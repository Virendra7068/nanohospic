// lib/screens/master/test_method/test_method_screen.dart
// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/test_method_master_entity.dart';
import 'package:nanohospic/database/repository/test_method_master_repo.dart';
import 'package:nanohospic/screens/banner_widget.dart';
import 'dart:convert';
import 'package:responsive_sizer/responsive_sizer.dart';

class TestMethodScreen extends StatefulWidget {
  const TestMethodScreen({super.key});

  @override
  State<TestMethodScreen> createState() => _TestMethodScreenState();
}

class _TestMethodScreenState extends State<TestMethodScreen> {
  List<TestMethodEntity> _testMethods = [];
  List<TestMethodEntity> _filteredTestMethods = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late TestMethodRepository _testMethodRepository;
  Timer? _syncTimer;
  int _totalRecords = 0;
  int _syncedRecords = 0;
  int _pendingRecords = 0;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _searchController.addListener(() {
      _filterTestMethods(_searchController.text);
    });
    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _syncDataSilently();
    });
  }

  Future<void> _initializeDatabase() async {
    final db = await DatabaseProvider.database;
    _testMethodRepository = TestMethodRepository(db.testMethodDao);
    _loadLocalTestMethods();
    _loadSyncStats();
    _syncFromServer();
  }

  Future<void> _loadLocalTestMethods() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final testMethods = await _testMethodRepository.getAllTestMethods();
      print('Loaded ${testMethods.length} test methods from database');
      setState(() {
        _testMethods = testMethods;
        _filteredTestMethods = List.from(_testMethods);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load local data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSyncStats() async {
    _totalRecords = await _testMethodRepository.getTotalCount();
    _syncedRecords = await _testMethodRepository.getSyncedCount();
    _pendingRecords = await _testMethodRepository.getPendingCount();
    setState(() {});
  }

  Future<void> _syncFromServer() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
    });
    try {
      final response = await http
          .get(Uri.parse('http://202.140.138.215:85/api/TestMethodApi'))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> testMethodsData = data['data'];
          print('Received ${testMethodsData.length} test methods from server');
          final List<Map<String, dynamic>> testMethodList = testMethodsData
              .map<Map<String, dynamic>>((item) {
                if (item is Map<String, dynamic>) {
                  return item;
                } else if (item is Map) {
                  return Map<String, dynamic>.from(item);
                }
                return <String, dynamic>{};
              })
              .where((map) => map.isNotEmpty)
              .toList();
          await _testMethodRepository.syncFromServer(testMethodList);
          await _loadLocalTestMethods();
          await _loadSyncStats();
          await _syncPendingChanges();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Sync completed successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Sync failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _syncPendingChanges() async {
    try {
      final pendingTestMethods = await _testMethodRepository.getPendingSync();
      for (final testMethod in pendingTestMethods) {
        if (testMethod.isDeleted) {
          if (testMethod.serverId != null) {
            await _deleteFromServer(testMethod.serverId!);
            await _testMethodRepository.markAsSynced(testMethod.id!);
          } else {
            await _testMethodRepository.markAsSynced(testMethod.id!);
          }
        } else if (testMethod.serverId == null) {
          final serverId = await _addToServer(testMethod);
          if (serverId != null) {
            testMethod.serverId = serverId;
            await _testMethodRepository.updateTestMethod(testMethod);
            await _testMethodRepository.markAsSynced(testMethod.id!);
          }
        } else {
          final success = await _updateOnServer(testMethod);
          if (success) {
            await _testMethodRepository.markAsSynced(testMethod.id!);
          }
        }
      }

      await _loadSyncStats();
    } catch (e) {
      print('Pending sync failed: $e');
    }
  }

  Future<void> _syncDataSilently() async {
    try {
      await _syncPendingChanges();
    } catch (e) {
      print('Silent sync failed: $e');
    }
  }

  Future<int?> _addToServer(TestMethodEntity testMethod) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://202.140.138.215:85/api/TestMethodApi'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': 0,
              'methodName': testMethod.methodName,
              'description': testMethod.description,
            }),
          )
          .timeout(Duration(seconds: 5));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['id'] as int?;
      }
    } catch (e) {
      print('Add to server failed: $e');
    }
    return null;
  }

  Future<bool> _updateOnServer(TestMethodEntity testMethod) async {
    try {
      final response = await http
          .put(
            Uri.parse(
              'http://202.140.138.215:85/api/TestMethodApi/${testMethod.serverId}',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': testMethod.serverId,
              'methodName': testMethod.methodName,
              'description': testMethod.description,
            }),
          )
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('Update on server failed: $e');
      return false;
    }
  }

  final List<String> _bannerImages = [
    'assets/indflag.jpg',
    'assets/isrflag.jpg',
    'assets/russianflag.png',
  ];

  Future<bool> _deleteFromServer(int serverId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('http://202.140.138.215:85/api/TestMethodApi/$serverId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete from server failed: $e');
      return false;
    }
  }

  void _filterTestMethods(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTestMethods = List.from(_testMethods);
      } else {
        _filteredTestMethods = _testMethods
            .where(
              (testMethod) =>
                  testMethod.methodName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  testMethod.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  Future<void> _addTestMethod(String methodName, String description) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final testMethod = TestMethodEntity(
        methodName: methodName,
        description: description,
        createdAt: DateTime.now().toIso8601String(),
        isSynced: false,
      );

      await _testMethodRepository.insertTestMethod(testMethod);

      await _loadLocalTestMethods();
      await _loadSyncStats();

      await _syncPendingChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.save, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('$methodName saved locally'),
              ],
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to add test method: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Failed to save: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _deleteTestMethod(int testMethodId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _testMethodRepository.deleteTestMethod(testMethodId);
      await _loadLocalTestMethods();
      await _loadSyncStats();

      await _syncPendingChanges();

      return true;
    } catch (e) {
      setState(() {
        _error = 'Failed to delete test method: $e';
      });
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(TestMethodEntity testMethod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Delete Test Method?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${testMethod.methodName}"?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final success = await _deleteTestMethod(
                            testMethod.id!,
                          );

                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Test Method "${testMethod.methodName}" deleted',
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Failed to delete test method'),
                                  ],
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, size: 20),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddTestMethodDialog() {
    final methodNameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.science, color: Colors.white, size: 32),
                ),
                SizedBox(height: 20),
                Text(
                  'Add New Test Method',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade800,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: methodNameController,
                  decoration: InputDecoration(
                    labelText: 'Test Method Name',
                    labelStyle: TextStyle(
                      color: Colors.deepPurple.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.deepPurple.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    hintText: 'Enter test method name',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(
                        Icons.science,
                        color: Colors.deepPurple.shade600,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.deepPurple.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.deepPurple.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    hintText: 'Enter test method description',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(
                        Icons.description,
                        color: Colors.deepPurple.shade600,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                if (methodNameController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Please enter a test method name',
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.orange,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isSubmitting = true;
                                });

                                await _addTestMethod(
                                  methodNameController.text,
                                  descriptionController.text,
                                );

                                if (!context.mounted) return;

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '${methodNameController.text} added successfully!',
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 20),
                                  SizedBox(width: 8),
                                  Text('Add Method'),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSyncStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.purple.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.sync, color: Colors.white, size: 32),
                ),
                SizedBox(height: 20),
                Text(
                  'Sync Status',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildSyncStatItem(
                        'Total Test Methods',
                        '$_totalRecords',
                        Icons.science,
                        Colors.deepPurple,
                      ),
                      SizedBox(height: 12),
                      _buildSyncStatItem(
                        'Synced',
                        '$_syncedRecords',
                        Icons.cloud_done,
                        Colors.green,
                      ),
                      SizedBox(height: 12),
                      _buildSyncStatItem(
                        'Pending Sync',
                        '$_pendingRecords',
                        Icons.cloud_upload,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_isSyncing)
                  Column(
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.purple,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Syncing...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Close'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSyncing ? null : _syncFromServer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sync, size: 20),
                            SizedBox(width: 8),
                            Text('Sync Now'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyncStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _syncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 15.h,
              floating: false,
              pinned: true,
              backgroundColor: Color(0xff016B61),
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: Colors.teal.withOpacity(0.4),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff016B61),
                        Color(0xff016B61),
                        Color(0xff016B61).withOpacity(0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 70,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Test Methods',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Manage all laboratory test methods',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search test method...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _isSearching = false;
                              _searchController.clear();
                              _filteredTestMethods = List.from(_testMethods);
                            });
                          },
                        ),
                      ),
                    )
                  : null,
              actions: [
                if (!_isSearching)
                  IconButton(
                    icon: Icon(Icons.search, size: 22),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                IconButton(
                  icon: Icon(
                    Icons.sync,
                    color: _isSyncing ? Colors.amber : Colors.white,
                    size: 22,
                  ),
                  onPressed: _isSyncing ? null : _syncFromServer,
                  tooltip: 'Sync',
                ),
                IconButton(
                  icon: Icon(Icons.info_outline, size: 22),
                  onPressed: _showSyncStatusDialog,
                  tooltip: 'Sync Status',
                ),
                if (_isLoading)
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            BannerSlider(bannerImages: _bannerImages),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_pendingRecords > 0)
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child:
                  FloatingActionButton.extended(
                        onPressed: _syncFromServer,
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        icon: Icon(Icons.cloud_upload),
                        label: Text('$_pendingRecords pending'),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(duration: 2000.ms, curve: Curves.easeInOut)
                      .then(delay: 1000.ms),
            ),
          FloatingActionButton(
                onPressed: _showAddTestMethodDialog,
                backgroundColor: Colors.deepPurple.shade700,
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.add, size: 28),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then(delay: 200.ms)
              .shake(hz: 3, curve: Curves.easeInOut),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final displayTestMethods = _isSearching
        ? _filteredTestMethods
        : _testMethods;

    if (_isLoading && _testMethods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
                  'Loading test methods...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(delay: 1000.ms, duration: 1500.ms),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red.shade400,
                ),
              ).animate().shake(duration: 600.ms, hz: 4),
              SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadLocalTestMethods,
                icon: Icon(Icons.refresh, size: 20),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_testMethods.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade100,
                          Colors.deepPurple.shade200,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.science,
                      size: 60,
                      color: Colors.deepPurple.shade600,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(delay: 1000.ms, duration: 2000.ms)
                  .then(),
              SizedBox(height: 24),
              Text(
                'No Test Methods Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  'Get started by adding your first laboratory test method',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showAddTestMethodDialog,
                icon: Icon(Icons.add, size: 20),
                label: Text('Add First Test Method'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isSearching &&
        _filteredTestMethods.isEmpty &&
        _searchController.text.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off,
                  size: 50,
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'No Results Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'No test methods found for "${_searchController.text}"',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _syncFromServer,
      backgroundColor: Colors.white,
      color: Colors.deepPurple,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayTestMethods.length,
        itemBuilder: (context, index) {
          final testMethod = displayTestMethods[index];
          return _buildTestMethodItem(testMethod, index);
        },
      ),
    );
  }

  Widget _buildTestMethodItem(TestMethodEntity testMethod, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child:
          Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: 1,
                shadowColor: Colors.deepPurple.withOpacity(0.1),
                child: InkWell(
                  onTap: () {
                    // Can be used to navigate to test method details or edit
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(testMethod);
                  },
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.deepPurple.withOpacity(0.1),
                  highlightColor: Colors.deepPurple.withOpacity(0.05),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getColorFromIndex(index),
                                _getColorFromIndex(index).withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: _getColorFromIndex(
                                  index,
                                ).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.science,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      testMethod.methodName,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (!testMethod.isSynced)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.amber.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload,
                                            size: 12,
                                            color: Colors.amber.shade700,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Pending',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.amber.shade800,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              if (testMethod.description.isNotEmpty) ...[
                                SizedBox(height: 6),
                                Text(
                                  testMethod.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              if (testMethod.createdAt != null) ...[
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Created: ${_formatDate(testMethod.createdAt!)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red.shade600,
                            ),
                          ),
                          onPressed: () {
                            _showDeleteConfirmationDialog(testMethod);
                          },
                          tooltip: 'Delete Test Method',
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: (index * 100).ms)
              .slideX(begin: 0.5, curve: Curves.easeOutQuart)
              .scale(curve: Curves.easeOutBack),
    );
  }

  Color _getColorFromIndex(int index) {
    final colors = [
      Colors.deepPurple.shade600,
      Colors.purple.shade600,
      Colors.indigo.shade600,
      Colors.blue.shade600,
      Colors.cyan.shade600,
      Colors.teal.shade600,
      Colors.green.shade600,
      Colors.lightGreen.shade600,
      Colors.amber.shade600,
      Colors.orange.shade600,
    ];
    return colors[index % colors.length];
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
