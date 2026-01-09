// test_bom_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/repository/test_bom_repo.dart';
import 'package:nanohospic/database/entity/test_bom_entity.dart';

class TestBOMListScreen extends StatefulWidget {
  const TestBOMListScreen({super.key});

  @override
  State<TestBOMListScreen> createState() => _TestBOMListScreenState();
}

class _TestBOMListScreenState extends State<TestBOMListScreen> {
  List<TestBOM> _allTestBOMs = [];
  List<TestBOM> _filteredTestBOMs = [];
  List<String> _testGroups = [];
  String? _selectedGroup;
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _syncTimer;
  late TestBOMRepository _repository;

  final Color _primaryColor = Color(0xff016B61);
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _searchController.addListener(() {
      _filterTests(_searchController.text);
    });

    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _syncDataSilently();
    });
  }

  Future<void> _initializeScreen() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // await DatabaseProvider.ensureTestBOMTableExists();
      final database = await DatabaseProvider.database;
      _repository = TestBOMRepository(database);
      
      await _loadTestBOMs();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing: $e');
      setState(() {
        _error = 'Failed to initialize: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTestBOMs() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final tests = await _repository.getAllTestBOMs();
      final groups = await _repository.getAllTestGroups();
      
      setState(() {
        _allTestBOMs = tests;
        _filteredTestBOMs = List.from(_allTestBOMs);
        _testGroups = groups;
        _selectedGroup = null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading tests: $e');
      setState(() {
        _error = 'Failed to load tests: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _filterTests(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredTestBOMs = _selectedGroup == null
            ? List.from(_allTestBOMs)
            : _allTestBOMs
                .where((test) => test.testGroup == _selectedGroup)
                .toList();
      });
    } else {
      final results = _allTestBOMs.where(
        (test) =>
            test.name.toLowerCase().contains(query.toLowerCase()) ||
            test.code.toLowerCase().contains(query.toLowerCase()) ||
            test.testGroup.toLowerCase().contains(query.toLowerCase()),
      ).toList();
      
      setState(() {
        _filteredTestBOMs = results;
      });
    }
  }

  void _filterByGroup(String? group) {
    setState(() {
      _selectedGroup = group;
      if (group == null) {
        _filteredTestBOMs = List.from(_allTestBOMs);
      } else {
        _filteredTestBOMs = _allTestBOMs
            .where((test) => test.testGroup == group)
            .toList();
      }
    });
  }

  Future<void> _syncDataSilently() async {
    try {
      setState(() {
        _isSyncing = true;
      });
      
      // Add your silent sync logic here
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _isSyncing = false;
      });
    } catch (e) {
      print('Silent sync failed: $e');
      setState(() {
        _isSyncing = false;
      });
    }
  }

  Future<void> _deleteTestBOM(TestBOM test) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => Dialog(
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
                'Delete Test?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${test.name}"?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
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
                        Navigator.of(context).pop(true);
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
      ),
    );

    if (confirmed == true) {
      try {
        setState(() {
          _isLoading = true;
        });

        await _repository.deleteTestBOM(test.code, 'User', DateTime.now());
        await _loadTestBOMs();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('${test.name} deleted successfully'),
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
      } catch (e) {
        print('Error deleting: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Failed to delete: $e'),
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String _getGenderTypeText(String genderType) {
    switch (genderType.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'both':
        return 'Both';
      case 'na':
      case 'n/a':
        return 'N/A';
      default:
        return 'Both';
    }
  }

  void _showTestDetailsDialog(TestBOM test) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getGroupColor(test.testGroup),
                              _getGroupColor(test.testGroup).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _getGroupColor(test.testGroup).withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Iconsax.money_forbidden,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        test.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Code: ${test.code}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getGroupColor(test.testGroup).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getGroupColor(test.testGroup)),
                        ),
                        child: Text(
                          test.testGroup,
                          style: TextStyle(
                            color: _getGroupColor(test.testGroup),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildDetailCard(
                      icon: Iconsax.info_circle,
                      title: 'Test Information',
                      items: [
                        _buildDetailItem('Gender Type', _getGenderTypeText(test.genderType)),
                        _buildDetailItem('Rate', '₹${test.rate.toStringAsFixed(2)}'),
                        _buildDetailItem('GST', '${test.gst.toStringAsFixed(2)}%'),
                        _buildDetailItem('Turn Around Time', '${test.turnAroundTime} ${test.timeUnit}'),
                        if (test.description != null && test.description!.isNotEmpty)
                          _buildDetailItem('Description', test.description!),
                        if (test.method != null && test.method!.isNotEmpty)
                          _buildDetailItem('Method', test.method!),
                        if (test.referenceRange != null && test.referenceRange!.isNotEmpty)
                          _buildDetailItem('Reference Range', test.referenceRange!),
                        if (test.clinicalSignificance != null && test.clinicalSignificance!.isNotEmpty)
                          _buildDetailItem('Clinical Significance', test.clinicalSignificance!),
                        if (test.specimenRequirement != null && test.specimenRequirement!.isNotEmpty)
                          _buildDetailItem('Specimen Requirement', test.specimenRequirement!),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildDetailCard(
                      icon: Iconsax.activity,
                      title: 'Test Parameters (${test.parametersList.length})',
                      items: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 16,
                            dataRowHeight: 40,
                            headingRowHeight: 40,
                            columns: [
                              DataColumn(label: Text('Test')),
                              DataColumn(label: Text('Min Value')),
                              DataColumn(label: Text('Max Value')),
                              DataColumn(label: Text('Method')),
                              DataColumn(label: Text('Unit')),
                              DataColumn(label: Text('Description')),
                            ],
                            rows: test.parametersList.map((param) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(param.testName)),
                                  DataCell(Text(param.minValue ?? '-')),
                                  DataCell(Text(param.maxValue ?? '-')),
                                  DataCell(Text(param.testMethod ?? '-')),
                                  DataCell(Text(param.unit ?? '-')),
                                  DataCell(Text(param.description ?? '-')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TestBOMFormScreen(
                                    testBOM: test,
                                    onSaved: _loadTestBOMs,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Iconsax.edit, size: 20),
                            label: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteTestBOM(test);
                            },
                            icon: Icon(Iconsax.trash, size: 20),
                            label: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
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
      backgroundColor: _backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 15.h,
              floating: false,
              pinned: true,
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: _primaryColor.withOpacity(0.4),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _primaryColor,
                        _primaryColor,
                        _primaryColor.withOpacity(0.4),
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
                          'Test BOM Management',
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
                          'Manage all laboratory tests and parameters',
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
                        hintText: 'Search tests...',
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
                              _filterTests('');
                            });
                          },
                        ),
                      ),
                    )
                  : null,
              actions: [
                if (!_isSearching)
                  IconButton(
                    icon: Icon(Iconsax.search_normal, size: 22),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                IconButton(
                  icon: Icon(
                    Iconsax.refresh,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: _loadTestBOMs,
                  tooltip: 'Refresh',
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
        body: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestBOMFormScreen(
                onSaved: _loadTestBOMs,
              ),
            ),
          );
          
          if (result == true) {
            await _loadTestBOMs();
          }
        },
        icon: Icon(Iconsax.add, size: 24),
        label: Text('Add Test'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ).animate()
        .scale(duration: 600.ms, curve: Curves.elasticOut)
        .then(delay: 200.ms)
        .shake(hz: 3, curve: Curves.easeInOut),
    );
  }

  Widget _buildBody() {
    final displayTests = _isSearching
        ? _filteredTestBOMs
        : (_selectedGroup == null ? _allTestBOMs : _filteredTestBOMs);

    if (_isLoading && _allTestBOMs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Loading tests...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ).animate(onPlay: (controller) => controller.repeat())
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
                  Iconsax.close_circle,
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
                onPressed: _initializeScreen,
                icon: Icon(Iconsax.refresh, size: 20),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
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

    if (_allTestBOMs.isEmpty) {
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
                      _primaryColor.withOpacity(0.1),
                      _primaryColor.withOpacity(0.2)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.message_edit,
                  size: 60,
                  color: _primaryColor,
                ),
              ).animate(onPlay: (controller) => controller.repeat())
               .scale(delay: 1000.ms, duration: 2000.ms)
               .then(),
              SizedBox(height: 24),
              Text(
                'No Tests Found',
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
                  'Get started by adding your first laboratory test',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestBOMFormScreen(
                        onSaved: _loadTestBOMs,
                      ),
                    ),
                  );
                  
                  if (result == true) {
                    await _loadTestBOMs();
                  }
                },
                icon: Icon(Iconsax.add, size: 20),
                label: Text('Add First Test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
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
        _filteredTestBOMs.isEmpty &&
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
                  Iconsax.search_normal,
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
                'No tests found for "${_searchController.text}"',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
                child: Text('Clear Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (!_isSearching && _testGroups.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: DropdownButtonFormField<String>(
              value: _selectedGroup,
              decoration: InputDecoration(
                labelText: 'Filter by Group',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [
                DropdownMenuItem(value: null, child: Text('All Groups')),
                ..._testGroups.map((group) {
                  return DropdownMenuItem(value: group, child: Text(group));
                }).toList(),
              ],
              onChanged: _filterByGroup,
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadTestBOMs,
            backgroundColor: Colors.white,
            color: _primaryColor,
            displacement: 40,
            edgeOffset: 20,
            strokeWidth: 2.5,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              itemCount: displayTests.length,
              itemBuilder: (context, index) {
                final test = displayTests[index];
                return _buildTestItem(test, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestItem(TestBOM test, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: _getGroupColor(test.testGroup).withOpacity(0.1),
        child: InkWell(
          onTap: () => _showTestDetailsDialog(test),
          onLongPress: () {
            _deleteTestBOM(test);
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: _getGroupColor(test.testGroup).withOpacity(0.1),
          highlightColor: _getGroupColor(test.testGroup).withOpacity(0.05),
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
                        _getGroupColor(test.testGroup),
                        _getGroupColor(test.testGroup).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _getGroupColor(test.testGroup).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      test.isActiveBool ? Iconsax.medal : Iconsax.setting,
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
                              test.name,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getGroupColor(test.testGroup).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getGroupColor(test.testGroup),
                              ),
                            ),
                            child: Text(
                              test.testGroup,
                              style: TextStyle(
                                fontSize: 10,
                                color: _getGroupColor(test.testGroup),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Iconsax.tag,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Code: ${test.code}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${test.turnAroundTime} ${test.timeUnit} • ${_getGenderTypeText(test.genderType)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Iconsax.money,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '₹${test.rate.toStringAsFixed(2)} (${test.gst}% GST)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Spacer(),
                          if (!test.isActiveBool)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                'Inactive',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Iconsax.more,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onPressed: () => _showTestDetailsDialog(test),
                  tooltip: 'View Details',
                ),
              ],
            ),
          ),
        ),
      ).animate()
        .fadeIn(delay: (index * 100).ms)
        .slideX(begin: 0.5, curve: Curves.easeOutQuart)
        .scale(curve: Curves.easeOutBack),
    );
  }

  Color _getGroupColor(String group) {
    final groupLower = group.toLowerCase();
    if (groupLower.contains('blood') || groupLower.contains('hematology')) 
      return Colors.red.shade600;
    if (groupLower.contains('urine') || groupLower.contains('urinalysis')) 
      return Colors.yellow.shade700;
    if (groupLower.contains('biochemistry') || groupLower.contains('chemistry')) 
      return Colors.blue.shade600;
    if (groupLower.contains('hormone') || groupLower.contains('endocrinology')) 
      return Colors.purple.shade600;
    if (groupLower.contains('microbiology') || groupLower.contains('culture')) 
      return Colors.green.shade600;
    if (groupLower.contains('serology') || groupLower.contains('immunology')) 
      return Colors.orange.shade600;
    if (groupLower.contains('radiology') || groupLower.contains('imaging')) 
      return Colors.cyan.shade600;
    
    // Return a color based on hash code for consistent coloring
    final colors = [
      Colors.teal.shade600,
      Colors.indigo.shade600,
      Colors.pink.shade600,
      Colors.deepPurple.shade600,
      Colors.blueGrey.shade600,
      Colors.brown.shade600,
      Colors.deepOrange.shade600,
      Colors.lime.shade700,
    ];
    return colors[group.hashCode % colors.length];
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

class TestBOMFormScreen extends StatefulWidget {
  final TestBOM? testBOM;
  final Function()? onSaved;

  const TestBOMFormScreen({
    Key? key,
    this.testBOM,
    this.onSaved,
  }) : super(key: key);

  @override
  _TestBOMFormScreenState createState() => _TestBOMFormScreenState();
}

class _TestBOMFormScreenState extends State<TestBOMFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TestBOMRepository _repository;
  bool _isLoading = false;
  bool _isInitializing = true;
  bool _isEditing = false;

  // Basic Information Controllers
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rateController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _gstController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _turnAroundTimeController =
      TextEditingController();
  final TextEditingController _timeUnitController = TextEditingController(
    text: 'hours',
  );
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _referenceRangeController =
      TextEditingController();
  final TextEditingController _clinicalSignificanceController =
      TextEditingController();
  final TextEditingController _specimenRequirementController =
      TextEditingController();

  // Dropdown options
  String _genderType = 'Both';
  bool _isActive = true;
  List<String> _genderOptions = ['Male', 'Female', 'Both', 'N/A'];
  List<String> _timeUnitOptions = ['hours', 'days', 'weeks', 'immediate'];

  // Test Parameters Controllers
  List<TestParameter> _parameters = [];
  final TextEditingController _paramNameController = TextEditingController();
  final TextEditingController _paramMinValueController =
      TextEditingController();
  final TextEditingController _paramMaxValueController =
      TextEditingController();
  final TextEditingController _paramMethodController = TextEditingController();
  final TextEditingController _paramUnitController = TextEditingController();
  final TextEditingController _paramDescriptionController =
      TextEditingController();

  final Color _primaryColor = Color(0xff016B61);

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    try {
      final database = await DatabaseProvider.database;
      _repository = TestBOMRepository(database);
      
      _isEditing = widget.testBOM != null;
      if (_isEditing) {
        _populateForm();
      } else {
        _codeController.text = _generateTestCode();
      }
      
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      print('Error initializing: $e');
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _populateForm() {
    final bom = widget.testBOM!;
    _codeController.text = bom.code;
    _nameController.text = bom.name;
    _groupController.text = bom.testGroup;
    _descriptionController.text = bom.description ?? '';
    _rateController.text = bom.rate.toStringAsFixed(2);
    _gstController.text = bom.gst.toStringAsFixed(2);
    _turnAroundTimeController.text = bom.turnAroundTime;
    _timeUnitController.text = bom.timeUnit;
    _methodController.text = bom.method ?? '';
    _referenceRangeController.text = bom.referenceRange ?? '';
    _clinicalSignificanceController.text = bom.clinicalSignificance ?? '';
    _specimenRequirementController.text = bom.specimenRequirement ?? '';

    _genderType = bom.genderType;
    _isActive = bom.isActiveBool;
    _parameters = List.from(bom.parametersList);
  }

  String _generateTestCode() {
    return 'TEST-${DateTime.now().millisecondsSinceEpoch}';
  }

  void _addParameter() {
    if (_paramNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter test name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final parameter = TestParameter(
      testName: _paramNameController.text,
      minValue: _paramMinValueController.text.isEmpty
          ? null
          : _paramMinValueController.text,
      maxValue: _paramMaxValueController.text.isEmpty
          ? null
          : _paramMaxValueController.text,
      testMethod: _paramMethodController.text.isEmpty
          ? null
          : _paramMethodController.text,
      unit: _paramUnitController.text.isEmpty
          ? null
          : _paramUnitController.text,
      description: _paramDescriptionController.text.isEmpty
          ? null
          : _paramDescriptionController.text,
    );

    setState(() {
      _parameters.add(parameter);
      // Reset form
      _paramNameController.clear();
      _paramMinValueController.clear();
      _paramMaxValueController.clear();
      _paramMethodController.clear();
      _paramUnitController.clear();
      _paramDescriptionController.clear();
    });
  }

  void _removeParameter(int index) {
    setState(() {
      _parameters.removeAt(index);
    });
  }

  Future<void> _saveTestBOM() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      if (!_isEditing) {
        final testBOM = await _repository.createTestFromData(
          code: _codeController.text.trim(),
          name: _nameController.text.trim(),
          testGroup: _groupController.text.trim(),
          genderType: _genderType,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          rate: double.tryParse(_rateController.text) ?? 0.0,
          gst: double.tryParse(_gstController.text) ?? 0.0,
          turnAroundTime: _turnAroundTimeController.text.trim(),
          timeUnit: _timeUnitController.text.trim(),
          isActive: _isActive,
          method: _methodController.text.trim().isEmpty
              ? null
              : _methodController.text.trim(),
          referenceRange: _referenceRangeController.text.trim().isEmpty
              ? null
              : _referenceRangeController.text.trim(),
          clinicalSignificance:
              _clinicalSignificanceController.text.trim().isEmpty
                  ? null
                  : _clinicalSignificanceController.text.trim(),
          specimenRequirement:
              _specimenRequirementController.text.trim().isEmpty
                  ? null
                  : _specimenRequirementController.text.trim(),
          createdBy: 'user',
          parameters: _parameters,
        );

        await _repository.saveTestBOM(testBOM);
        
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${testBOM.name} saved successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        final updatedTestBOM = widget.testBOM!.copyWith(
          name: _nameController.text.trim(),
          testGroup: _groupController.text.trim(),
          genderType: _genderType,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          rate: double.tryParse(_rateController.text) ?? 0.0,
          gst: double.tryParse(_gstController.text) ?? 0.0,
          turnAroundTime: _turnAroundTimeController.text.trim(),
          timeUnit: _timeUnitController.text.trim(),
          isActive: _isActive,
          method: _methodController.text.trim().isEmpty
              ? null
              : _methodController.text.trim(),
          referenceRange: _referenceRangeController.text.trim().isEmpty
              ? null
              : _referenceRangeController.text.trim(),
          clinicalSignificance:
              _clinicalSignificanceController.text.trim().isEmpty
                  ? null
                  : _clinicalSignificanceController.text.trim(),
          specimenRequirement:
              _specimenRequirementController.text.trim().isEmpty
                  ? null
                  : _specimenRequirementController.text.trim(),
          lastModified: DateTime.now().toIso8601String(),
          lastModifiedBy: 'user',
          parameters: _parameters,
        );

        await _repository.updateTestBOM(updatedTestBOM);
        
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${updatedTestBOM.name} updated successfully'),
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
    } catch (e) {
      print('Error saving test: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Failed to save: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          labelStyle: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          hintText: 'Enter $label',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
    bool isRequired = true,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          labelStyle: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          prefixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
              style: TextStyle(color: Colors.grey.shade800)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        dropdownColor: Colors.white,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        icon: Icon(Iconsax.arrow_down_1, color: _primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Loading form...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Test' : 'Add New Test',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Iconsax.save_2),
            onPressed: _saveTestBOM,
            tooltip: 'Save',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Saving test...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.info_circle, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Basic Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildTextFormField(
                              label: 'Test Code',
                              controller: _codeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter test code';
                                }
                                return null;
                              },
                              icon: Iconsax.tag,
                              isRequired: false,
                            ),
                            _buildTextFormField(
                              label: 'Test Name',
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter test name';
                                }
                                return null;
                              },
                              icon: Iconsax.medal,
                            ),
                            _buildTextFormField(
                              label: 'Group',
                              controller: _groupController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter group name';
                                }
                                return null;
                              },
                              icon: Iconsax.category,
                            ),
                            _buildTextFormField(
                              label: 'Description',
                              controller: _descriptionController,
                              validator: null,
                              maxLines: 2,
                              isRequired: false,
                              icon: Iconsax.document,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Rate',
                                    controller: _rateController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter rate';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter valid number';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    icon: Iconsax.money,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'GST %',
                                    controller: _gstController,
                                    validator: (value) {
                                      if (value != null &&
                                          value.isNotEmpty &&
                                          double.tryParse(value) == null) {
                                        return 'Please enter valid number';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    icon: Iconsax.percentage_circle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Turn Around Time',
                                    controller: _turnAroundTimeController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter turn around time';
                                      }
                                      return null;
                                    },
                                    icon: Iconsax.clock,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildDropdownFormField(
                                    label: 'Time Unit',
                                    value: _timeUnitController.text,
                                    options: _timeUnitOptions,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _timeUnitController.text = value;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select time unit';
                                      }
                                      return null;
                                    },
                                    icon: Iconsax.timer,
                                  ),
                                ),
                              ],
                            ),
                            _buildDropdownFormField(
                              label: 'Gender Type',
                              value: _genderType,
                              options: _genderOptions,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _genderType = value;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select gender type';
                                }
                                return null;
                              },
                              icon: Iconsax.user,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Method',
                                    controller: _methodController,
                                    validator: null,
                                    isRequired: false,
                                    icon: Iconsax.check,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Switch(
                                  value: _isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      _isActive = value;
                                    });
                                  },
                                  activeColor: _primaryColor,
                                ),
                                Text(
                                  'Active',
                                  style: TextStyle(
                                    color: _isActive ? _primaryColor : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.document_text, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Additional Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildTextFormField(
                              label: 'Reference Range',
                              controller: _referenceRangeController,
                              validator: null,
                              maxLines: 2,
                              isRequired: false,
                              icon: Iconsax.chart,
                            ),
                            _buildTextFormField(
                              label: 'Clinical Significance',
                              controller: _clinicalSignificanceController,
                              validator: null,
                              maxLines: 3,
                              isRequired: false,
                              icon: Iconsax.health,
                            ),
                            _buildTextFormField(
                              label: 'Specimen Requirement',
                              controller: _specimenRequirementController,
                              validator: null,
                              maxLines: 3,
                              isRequired: false,
                              icon: Iconsax.box,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.activity, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Test Parameters',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildTextFormField(
                              label: 'Test Name',
                              controller: _paramNameController,
                              validator: null,
                              icon: Iconsax.text,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Min Value',
                                    controller: _paramMinValueController,
                                    validator: null,
                                    isRequired: false,
                                    icon: Iconsax.arrow_down,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Max Value',
                                    controller: _paramMaxValueController,
                                    validator: null,
                                    isRequired: false,
                                    icon: Iconsax.arrow_up,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Test Method',
                                    controller: _paramMethodController,
                                    validator: null,
                                    isRequired: false,
                                    icon: Iconsax.check,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextFormField(
                                    label: 'Unit',
                                    controller: _paramUnitController,
                                    validator: null,
                                    isRequired: false,
                                    icon: Iconsax.ruler,
                                  ),
                                ),
                              ],
                            ),
                            _buildTextFormField(
                              label: 'Description',
                              controller: _paramDescriptionController,
                              validator: null,
                              isRequired: false,
                              maxLines: 2,
                              icon: Iconsax.document,
                            ),
                            SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _addParameter,
                              icon: Icon(Iconsax.add, size: 20),
                              label: Text('Add Parameter'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_parameters.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.check, color: _primaryColor),
                                  SizedBox(width: 8),
                                  Text(
                                    'Added Parameters (${_parameters.length})',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 16,
                                  dataRowHeight: 40,
                                  headingRowHeight: 40,
                                  columns: [
                                    DataColumn(label: Text('Test')),
                                    DataColumn(label: Text('Min Value')),
                                    DataColumn(label: Text('Max Value')),
                                    DataColumn(label: Text('Method')),
                                    DataColumn(label: Text('Unit')),
                                    DataColumn(label: Text('Description')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows: _parameters.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final param = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(param.testName)),
                                        DataCell(Text(param.minValue ?? '-')),
                                        DataCell(Text(param.maxValue ?? '-')),
                                        DataCell(Text(param.testMethod ?? '-')),
                                        DataCell(Text(param.unit ?? '-')),
                                        DataCell(Text(param.description ?? '-')),
                                        DataCell(
                                          IconButton(
                                            icon: Icon(Iconsax.trash, size: 20, color: Colors.red),
                                            onPressed: () => _removeParameter(index),
                                            tooltip: 'Remove',
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveTestBOM,
                      icon: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Iconsax.save_2, size: 20),
                      label: Text(_isEditing ? 'Update Test' : 'Save Test'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                    SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Iconsax.close_circle, size: 20),
                      label: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _groupController.dispose();
    _descriptionController.dispose();
    _rateController.dispose();
    _gstController.dispose();
    _turnAroundTimeController.dispose();
    _timeUnitController.dispose();
    _methodController.dispose();
    _referenceRangeController.dispose();
    _clinicalSignificanceController.dispose();
    _specimenRequirementController.dispose();
    _paramNameController.dispose();
    _paramMinValueController.dispose();
    _paramMaxValueController.dispose();
    _paramMethodController.dispose();
    _paramUnitController.dispose();
    _paramDescriptionController.dispose();
    super.dispose();
  }
}