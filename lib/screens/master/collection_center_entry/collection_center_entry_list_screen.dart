// ignore_for_file: avoid_print, deprecated_member_use, depend_on_referenced_packages

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/collection_center_entity.dart';

class CollectionCenterListScreen extends StatefulWidget {
  const CollectionCenterListScreen({super.key});

  @override
  State<CollectionCenterListScreen> createState() => _CollectionCenterListScreenState();
}

class _CollectionCenterListScreenState extends State<CollectionCenterListScreen> {
  List<CollectionCenterEntity> _collectionCenters = [];
  List<CollectionCenterEntity> _filteredCollectionCenters = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _syncTimer;
  int _totalRecords = 0;
  int _syncedRecords = 0;
  int _pendingRecords = 0;
  
  final Color _primaryColor = Color(0xff016B61);
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _searchController.addListener(() {
      _filterCollectionCenters(_searchController.text);
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
      
      // await DatabaseProvider.ensureCollectionCenterTableExists();
      await _loadCollectionCenters();
      await _loadSyncStats();
      
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

  Future<void> _loadCollectionCenters() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final repository = await DatabaseProvider.collectionCenterRepository;
      final centers = await repository.getAllCollectionCenters();
      
      setState(() {
        _collectionCenters = centers;
        _filteredCollectionCenters = List.from(_collectionCenters);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading collection centers: $e');
      setState(() {
        _error = 'Failed to load collection centers: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSyncStats() async {
    try {
      final repository = await DatabaseProvider.collectionCenterRepository;
      _totalRecords = await repository.getTotalCount();
      _syncedRecords = await repository.getSyncedCount();
      _pendingRecords = await repository.getPendingCount();
      setState(() {});
    } catch (e) {
      print('Error loading sync stats: $e');
    }
  }

  Future<void> _syncFromServer() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
    });
    try {
      // Add your server sync logic here
      await _loadCollectionCenters();
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
      final repository = await DatabaseProvider.collectionCenterRepository;
      final pendingCenters = await repository.getPendingSync();

      for (final center in pendingCenters) {
        if (center.isDeleted == 1) {
          if (center.serverId != null) {
            await repository.deleteFromServer(center.serverId!);
            await repository.markAsSynced(center.id!);
          } else {
            await repository.markAsSynced(center.id!);
          }
        } else if (center.serverId == null) {
          final serverId = await repository.addToServer(center);
          if (serverId != null) {
            await repository.updateServerId(center.id!, serverId);
            await repository.markAsSynced(center.id!);
          }
        } else {
          final success = await repository.updateOnServer(center);
          if (success) {
            await repository.markAsSynced(center.id!);
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

  void _filterCollectionCenters(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCollectionCenters = List.from(_collectionCenters);
      } else {
        _filteredCollectionCenters = _collectionCenters
            .where(
              (center) =>
                  center.centerName.toLowerCase().contains(query.toLowerCase()) ||
                  center.centerCode.toLowerCase().contains(query.toLowerCase()) ||
                  center.contactPersonName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Future<bool> _deleteCollectionCenter(int centerId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repository = await DatabaseProvider.collectionCenterRepository;
      await repository.softDeleteCollectionCenter(centerId, 'user');
      await _loadCollectionCenters();
      await _loadSyncStats();

      await _syncPendingChanges();

      return true;
    } catch (e) {
      setState(() {
        _error = 'Failed to delete collection center: $e';
      });
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(CollectionCenterEntity center) {
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
                  'Delete Collection Center?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${center.centerName}"?',
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
                          final success = await _deleteCollectionCenter(
                            center.id!,
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
                                      'Collection center "${center.centerName}" deleted',
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

  void _showCollectionCenterDetails(CollectionCenterEntity center) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
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
                              _primaryColor,
                              _primaryColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Iconsax.location,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        center.centerName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                        textAlign: TextAlign.center,
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
                          color: center.centreStatus == 'Active' 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: center.centreStatus == 'Active' 
                                ? Colors.green 
                                : Colors.orange,
                          ),
                        ),
                        child: Text(
                          center.centreStatus,
                          style: TextStyle(
                            color: center.centreStatus == 'Active' 
                                ? Colors.green 
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Basic Information Card
                    _buildDetailCard(
                      icon: Iconsax.info_circle,
                      title: 'Basic Information',
                      items: [
                        _buildDetailItem('Center Code', center.centerCode),
                        _buildDetailItem('Contact Person', center.contactPersonName),
                        _buildDetailItem('Phone', center.phoneNo),
                        _buildDetailItem('Email', center.email),
                        _buildDetailItem('GST Number', center.gstNumber),
                        _buildDetailItem('PAN Number', center.panNumber),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Location Information Card
                    _buildDetailCard(
                      icon: Iconsax.location,
                      title: 'Location Information',
                      items: [
                        _buildDetailItem('Address 1', center.address1),
                        _buildDetailItem('Address 2', center.address2),
                        _buildDetailItem('Location', center.location),
                        _buildDetailItem('City', center.city),
                        _buildDetailItem('State', center.state),
                        _buildDetailItem('Country', center.country),
                        _buildDetailItem('Postal Code', center.postalCode),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Operational Information Card
                    _buildDetailCard(
                      icon: Iconsax.clock,
                      title: 'Operational Information',
                      items: [
                        _buildDetailItem('Operational Hours', '${center.operationalHoursFrom} - ${center.operationalHoursTo}'),
                        _buildDetailItem('Collection Days', center.collectionDays),
                        _buildDetailItem('Sample Pickup Timing', '${center.samplePickupTimingFrom} - ${center.samplePickupTimingTo}'),
                        _buildDetailItem('Transport Mode', center.transportMode),
                        _buildDetailItem('Courier/Agency', center.courierAgencyName),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Commission Information Card
                    _buildDetailCard(
                      icon: Iconsax.money,
                      title: 'Commission Information',
                      items: [
                        _buildDetailItem('Commission Type', center.commissionType),
                        _buildDetailItem('Commission Value', center.commissionValue.toString()),
                        _buildDetailItem('Account Holder', center.accountHolderName),
                        _buildDetailItem('Account No', center.accountNo),
                        _buildDetailItem('IFSC Code', center.ifscCode),
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
                                  builder: (context) => CollectionCenterEntryScreen(
                                    collectionCenter: center,
                                    onSaved: _loadCollectionCenters,
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
                              _showDeleteConfirmationDialog(center);
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
            width: 140,
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
              value.isNotEmpty ? value : 'Not specified',
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
                          'Collection Centers',
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
                          'Manage all collection centers',
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
                        hintText: 'Search collection centers...',
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
                              _filterCollectionCenters('');
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
                  onPressed: _loadCollectionCenters,
                  tooltip: 'Refresh',
                ),
                IconButton(
                  icon: Icon(
                    Iconsax.cloud,
                    color: _isSyncing ? Colors.amber : Colors.white,
                    size: 22,
                  ),
                  onPressed: _isSyncing ? null : _syncFromServer,
                  tooltip: 'Sync',
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
              builder: (context) => CollectionCenterEntryScreen(
                onSaved: _loadCollectionCenters,
              ),
            ),
          );
          
          if (result == true) {
            await _loadCollectionCenters();
          }
        },
        icon: Icon(Iconsax.add, size: 24),
        label: Text('Add Center'),
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
    final displayCenters = _isSearching
        ? _filteredCollectionCenters
        : _collectionCenters;

    if (_isLoading && _collectionCenters.isEmpty) {
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
              'Loading collection centers...',
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

    if (_collectionCenters.isEmpty) {
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
                  Iconsax.location,
                  size: 60,
                  color: _primaryColor,
                ),
              ).animate(onPlay: (controller) => controller.repeat())
               .scale(delay: 1000.ms, duration: 2000.ms)
               .then(),
              SizedBox(height: 24),
              Text(
                'No Collection Centers Found',
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
                  'Get started by adding your first collection center to the system',
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
                      builder: (context) => CollectionCenterEntryScreen(
                        onSaved: _loadCollectionCenters,
                      ),
                    ),
                  );
                  
                  if (result == true) {
                    await _loadCollectionCenters();
                  }
                },
                icon: Icon(Iconsax.add, size: 20),
                label: Text('Add First Center'),
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
        _filteredCollectionCenters.isEmpty &&
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
                'No collection centers found for "${_searchController.text}"',
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

    return RefreshIndicator(
      onRefresh: _loadCollectionCenters,
      backgroundColor: Colors.white,
      color: _primaryColor,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayCenters.length,
        itemBuilder: (context, index) {
          final center = displayCenters[index];
          return _buildCollectionCenterItem(center, index);
        },
      ),
    );
  }

  Widget _buildCollectionCenterItem(CollectionCenterEntity center, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: Colors.blue.withOpacity(0.1),
        child: InkWell(
          onTap: () => _showCollectionCenterDetails(center),
          onLongPress: () {
            _showDeleteConfirmationDialog(center);
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: _primaryColor.withOpacity(0.1),
          highlightColor: _primaryColor.withOpacity(0.05),
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
                        color: _getColorFromIndex(index).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.location,
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
                              center.centerName,
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
                              color: center.centreStatus == 'Active'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: center.centreStatus == 'Active'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            child: Text(
                              center.centreStatus,
                              style: TextStyle(
                                fontSize: 10,
                                color: center.centreStatus == 'Active'
                                    ? Colors.green
                                    : Colors.orange,
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
                            Iconsax.hashtag,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Code: ${center.centerCode}',
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
                            Iconsax.profile_circle,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              center.contactPersonName,
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
                            Iconsax.call,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${center.phoneNo} • ${center.city}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (center.createdAt != null) ...[
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Iconsax.calendar,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Created: ${_formatDate(center.createdAt!)}',
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
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Iconsax.more,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onPressed: () => _showCollectionCenterDetails(center),
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

  Color _getColorFromIndex(int index) {
    final colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.red.shade600,
      Colors.teal.shade600,
      Colors.pink.shade600,
      Colors.indigo.shade600,
      Colors.cyan.shade600,
      Colors.deepOrange.shade600,
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

class CollectionCenterEntryScreen extends StatefulWidget {
  final CollectionCenterEntity? collectionCenter;
  final Function()? onSaved;

  const CollectionCenterEntryScreen({
    Key? key,
    this.collectionCenter,
    this.onSaved,
  }) : super(key: key);

  @override
  _CollectionCenterEntryScreenState createState() => _CollectionCenterEntryScreenState();
}

class _CollectionCenterEntryScreenState extends State<CollectionCenterEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditing = false;

  // Controllers
  final TextEditingController _centerCodeController = TextEditingController();
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _centreStatusController = TextEditingController();
  final TextEditingController _branchTypeController = TextEditingController();
  final TextEditingController _labAffiliationController = TextEditingController();
  final TextEditingController _operationalHoursFromController = TextEditingController();
  final TextEditingController _operationalHoursToController = TextEditingController();
  final TextEditingController _collectionDaysController = TextEditingController();
  final TextEditingController _samplePickupFromController = TextEditingController();
  final TextEditingController _samplePickupToController = TextEditingController();
  final TextEditingController _transportModeController = TextEditingController();
  final TextEditingController _courierAgencyController = TextEditingController();
  final TextEditingController _commissionTypeController = TextEditingController();
  final TextEditingController _commissionValueController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();

  // File paths
  String? _agreementFile1Path;
  String? _agreementFile2Path;

 final List<String> _countryOptions = ['India', 'USA', 'UK', 'Canada', 'Australia'];
 final List<String> _stateOptions = ['Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Gujarat'];
 final List<String> _cityOptions = ['Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Ahmedabad'];
 final List<String> _centreStatusOptions = ['Active', 'Inactive', 'Pending Approval'];
 final List<String> _labAffiliationOptions = ['Lab A', 'Lab B', 'Lab C'];
 final List<String> _transportModeOptions = ['Courier', 'Self', 'Third Party'];
 final List<String> _commissionTypeOptions = ['Percentage', 'Fixed Amount'];
 final List<String> _collectionDaysOptions = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  // Time controllers
  TimeOfDay? _operationalHoursFromTime;
  TimeOfDay? _operationalHoursToTime;
  TimeOfDay? _samplePickupFromTime;
  TimeOfDay? _samplePickupToTime;

  // Multi-select for collection days
  List<String> _selectedCollectionDays = [];

  final Color _primaryColor = Color(0xff016B61);

  @override
  void initState() {
    super.initState();
    _isEditing = widget.collectionCenter != null;
    
    if (_isEditing) {
      _populateForm();
    }
  }

  void _populateForm() {
    final center = widget.collectionCenter!;
    _centerCodeController.text = center.centerCode;
    _centerNameController.text = center.centerName;
    _countryController.text = center.country;
    _stateController.text = center.state;
    _cityController.text = center.city;
    _address1Controller.text = center.address1;
    _address2Controller.text = center.address2;
    _locationController.text = center.location;
    _postalCodeController.text = center.postalCode;
    _latitudeController.text = center.latitude.toString();
    _longitudeController.text = center.longitude.toString();
    _gstNumberController.text = center.gstNumber;
    _panNumberController.text = center.panNumber;
    _contactPersonController.text = center.contactPersonName;
    _phoneNoController.text = center.phoneNo;
    _emailController.text = center.email;
    _centreStatusController.text = center.centreStatus;
    _labAffiliationController.text = center.labAffiliationCompany;
    _operationalHoursFromController.text = center.operationalHoursFrom;
    _operationalHoursToController.text = center.operationalHoursTo;
    _collectionDaysController.text = center.collectionDays;
    _selectedCollectionDays = center.collectionDays.split(',').map((e) => e.trim()).toList();
    _samplePickupFromController.text = center.samplePickupTimingFrom;
    _samplePickupToController.text = center.samplePickupTimingTo;
    _transportModeController.text = center.transportMode;
    _courierAgencyController.text = center.courierAgencyName;
    _commissionTypeController.text = center.commissionType;
    _commissionValueController.text = center.commissionValue.toString();
    _accountHolderController.text = center.accountHolderName;
    _accountNoController.text = center.accountNo;
    _ifscCodeController.text = center.ifscCode;
    _agreementFile1Path = center.agreementFile1Path;
    _agreementFile2Path = center.agreementFile2Path;
  }

  Future<void> _saveCollectionCenter() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final repository = await DatabaseProvider.collectionCenterRepository;
      final collectionCenter = CollectionCenterEntity(
        id: widget.collectionCenter?.id,
        serverId: widget.collectionCenter?.serverId,
        centerCode: _centerCodeController.text.trim(),
        centerName: _centerNameController.text.trim(),
        country: _countryController.text.trim(),
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        address1: _address1Controller.text.trim(),
        address2: _address2Controller.text.trim(),
        location: _locationController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        latitude: double.tryParse(_latitudeController.text) ?? 0.0,
        longitude: double.tryParse(_longitudeController.text) ?? 0.0,
        gstNumber: _gstNumberController.text.trim(),
        panNumber: _panNumberController.text.trim(),
        contactPersonName: _contactPersonController.text.trim(),
        phoneNo: _phoneNoController.text.trim(),
        email: _emailController.text.trim(),
        centreStatus: _centreStatusController.text.trim(),
        branchTypeId: 1, // You can get this from branch type dropdown
        labAffiliationCompany: _labAffiliationController.text.trim(),
        operationalHoursFrom: _operationalHoursFromController.text.trim(),
        operationalHoursTo: _operationalHoursToController.text.trim(),
        collectionDays: _selectedCollectionDays.join(', '),
        samplePickupTimingFrom: _samplePickupFromController.text.trim(),
        samplePickupTimingTo: _samplePickupToController.text.trim(),
        transportMode: _transportModeController.text.trim(),
        courierAgencyName: _courierAgencyController.text.trim(),
        commissionType: _commissionTypeController.text.trim(),
        commissionValue: double.tryParse(_commissionValueController.text) ?? 0.0,
        accountHolderName: _accountHolderController.text.trim(),
        accountNo: _accountNoController.text.trim(),
        ifscCode: _ifscCodeController.text.trim(),
        agreementFile1Path: _agreementFile1Path,
        agreementFile2Path: _agreementFile2Path,
        createdAt: widget.collectionCenter?.createdAt ?? DateTime.now().toIso8601String(),
        createdBy: widget.collectionCenter?.createdBy ?? 'User',
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'User',
      );

      if (_isEditing) {
        await repository.updateCollectionCenter(collectionCenter);
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${collectionCenter.centerName} updated successfully'),
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
        await repository.insertCollectionCenter(collectionCenter);
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${collectionCenter.centerName} added successfully'),
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
      print('Error saving collection center: $e');
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

  Future<void> _pickFile(int fileNumber) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          if (fileNumber == 1) {
            _agreementFile1Path = result.files.single.path;
          } else {
            _agreementFile2Path = result.files.single.path;
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFrom, bool isOperational) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isOperational) {
          if (isFrom) {
            _operationalHoursFromTime = picked;
            _operationalHoursFromController.text = timeString;
          } else {
            _operationalHoursToTime = picked;
            _operationalHoursToController.text = timeString;
          }
        } else {
          if (isFrom) {
            _samplePickupFromTime = picked;
            _samplePickupFromController.text = timeString;
          } else {
            _samplePickupToTime = picked;
            _samplePickupToController.text = timeString;
          }
        }
      });
    }
  }

  void _showCollectionDaysDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Collection Days'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _collectionDaysOptions.map((day) {
                    return CheckboxListTile(
                      title: Text(day),
                      value: _selectedCollectionDays.contains(day),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedCollectionDays.add(day);
                          } else {
                            _selectedCollectionDays.remove(day);
                          }
                        });
                      },
                      activeColor: _primaryColor,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _collectionDaysController.text = _selectedCollectionDays.join(', ');
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                  ),
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
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
          suffixIcon: onTap != null
              ? IconButton(
                  icon: Icon(Iconsax.calendar, color: _primaryColor, size: 20),
                  onPressed: onTap,
                )
              : null,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
    required String? Function(String?)? validator,
    bool isRequired = true,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
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
        onChanged: (String? newValue) {
          setState(() {
            controller.text = newValue ?? '';
          });
        },
        validator: validator,
        dropdownColor: Colors.white,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        icon: Icon(Iconsax.arrow_down_1, color: _primaryColor),
      ),
    );
  }

  Widget _buildFilePicker({
    required String label,
    required String? filePath,
    required VoidCallback onPick,
    int fileNumber = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.document_upload, color: _primaryColor),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      filePath != null
                          ? filePath.split('/').last
                          : 'No file chosen',
                      style: TextStyle(
                        color: filePath != null 
                            ? Colors.grey.shade800 
                            : Colors.grey.shade500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (filePath != null)
                    IconButton(
                      icon: Icon(Iconsax.eye, size: 20, color: _primaryColor),
                      onPressed: () {
                        // View file logic here
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Collection Center' : 'Add New Collection Center',
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
            onPressed: _saveCollectionCenter,
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
                    'Saving collection center...',
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
                    // Basic Information Card
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
                              label: 'Center Code',
                              controller: _centerCodeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter center code';
                                }
                                return null;
                              },
                              icon: Iconsax.hashtag,
                            ),
                            _buildTextFormField(
                              label: 'Center Name',
                              controller: _centerNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter center name';
                                }
                                return null;
                              },
                              icon: Iconsax.building,
                            ),
                            _buildDropdownFormField(
                              label: 'Centre Status',
                              controller: _centreStatusController,
                              options: _centreStatusOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select centre status';
                                }
                                return null;
                              },
                              icon: Iconsax.activity,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Location Information Card
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
                                Icon(Iconsax.location, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Location Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildDropdownFormField(
                              label: 'Country',
                              controller: _countryController,
                              options: _countryOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select country';
                                }
                                return null;
                              },
                              icon: Iconsax.global,
                            ),
                            _buildDropdownFormField(
                              label: 'State',
                              controller: _stateController,
                              options: _stateOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select state';
                                }
                                return null;
                              },
                              icon: Iconsax.map,
                            ),
                            _buildDropdownFormField(
                              label: 'City',
                              controller: _cityController,
                              options: _cityOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select city';
                                }
                                return null;
                              },
                              icon: Iconsax.buildings,
                            ),
                            _buildTextFormField(
                              label: 'Address 1',
                              controller: _address1Controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter address';
                                }
                                return null;
                              },
                              maxLines: 2,
                              icon: Iconsax.home,
                            ),
                            _buildTextFormField(
                              label: 'Address 2',
                              controller: _address2Controller,
                              validator: null,
                              isRequired: false,
                              maxLines: 2,
                              icon: Iconsax.home_2,
                            ),
                            _buildTextFormField(
                              label: 'Location',
                              controller: _locationController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter location';
                                }
                                return null;
                              },
                              icon: Iconsax.map_1,
                            ),
                            _buildTextFormField(
                              label: 'Postal Code',
                              controller: _postalCodeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter postal code';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              icon: Iconsax.note,
                            ),
                            _buildTextFormField(
                              label: 'Latitude',
                              controller: _latitudeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter latitude';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              icon: Iconsax.location,
                            ),
                            _buildTextFormField(
                              label: 'Longitude',
                              controller: _longitudeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter longitude';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              icon: Iconsax.location,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Contact Information Card
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
                                Icon(Iconsax.profile_circle, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Contact Information',
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
                              label: 'Contact Person Name',
                              controller: _contactPersonController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter contact person name';
                                }
                                return null;
                              },
                              icon: Iconsax.user,
                            ),
                            _buildTextFormField(
                              label: 'Phone No',
                              controller: _phoneNoController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              icon: Iconsax.call,
                            ),
                            _buildTextFormField(
                              label: 'Email',
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              icon: Iconsax.sms,
                            ),
                            _buildTextFormField(
                              label: 'GST Number',
                              controller: _gstNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter GST number';
                                }
                                return null;
                              },
                              icon: Iconsax.receipt,
                            ),
                            _buildTextFormField(
                              label: 'PAN Number',
                              controller: _panNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter PAN number';
                                }
                                return null;
                              },
                              icon: Iconsax.receipt_edit,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Operational Information Card
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
                                Icon(Iconsax.clock, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Operational Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildDropdownFormField(
                              label: 'Lab Affiliation Company',
                              controller: _labAffiliationController,
                              options: _labAffiliationOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select lab affiliation';
                                }
                                return null;
                              },
                              icon: Iconsax.building,
                            ),
                            _buildTextFormField(
                              label: 'Operational Hours From',
                              controller: _operationalHoursFromController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select operational hours from';
                                }
                                return null;
                              },
                              readOnly: true,
                              onTap: () => _selectTime(context, true, true),
                              icon: Iconsax.clock,
                            ),
                            _buildTextFormField(
                              label: 'Operational Hours To',
                              controller: _operationalHoursToController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select operational hours to';
                                }
                                return null;
                              },
                              readOnly: true,
                              onTap: () => _selectTime(context, false, true),
                              icon: Iconsax.clock,
                            ),
                            _buildTextFormField(
                              label: 'Collection Days',
                              controller: _collectionDaysController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select collection days';
                                }
                                return null;
                              },
                              readOnly: true,
                              onTap: _showCollectionDaysDialog,
                              icon: Iconsax.calendar,
                            ),
                            _buildTextFormField(
                              label: 'Sample Pickup Timing From',
                              controller: _samplePickupFromController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select sample pickup timing from';
                                }
                                return null;
                              },
                              readOnly: true,
                              onTap: () => _selectTime(context, true, false),
                              icon: Iconsax.timer,
                            ),
                            _buildTextFormField(
                              label: 'Sample Pickup Timing To',
                              controller: _samplePickupToController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select sample pickup timing to';
                                }
                                return null;
                              },
                              readOnly: true,
                              onTap: () => _selectTime(context, false, false),
                              icon: Iconsax.timer,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Transport & Commission Card
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
                                Icon(Iconsax.truck, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Transport & Commission',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildDropdownFormField(
                              label: 'Transport Mode',
                              controller: _transportModeController,
                              options: _transportModeOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select transport mode';
                                }
                                return null;
                              },
                              icon: Iconsax.truck,
                            ),
                            _buildTextFormField(
                              label: 'Courier / Agency Name',
                              controller: _courierAgencyController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter courier/agency name';
                                }
                                return null;
                              },
                              icon: Iconsax.building_4,
                            ),
                            _buildDropdownFormField(
                              label: 'Commission Type',
                              controller: _commissionTypeController,
                              options: _commissionTypeOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select commission type';
                                }
                                return null;
                              },
                              icon: Iconsax.money,
                            ),
                            _buildTextFormField(
                              label: 'Commission Value',
                              controller: _commissionValueController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter commission value';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              icon: Iconsax.money_2,
                            ),
                            _buildTextFormField(
                              label: 'Account Holder Name',
                              controller: _accountHolderController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter account holder name';
                                }
                                return null;
                              },
                              icon: Iconsax.user,
                            ),
                            _buildTextFormField(
                              label: 'Account No',
                              controller: _accountNoController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter account number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              icon: Iconsax.card,
                            ),
                            _buildTextFormField(
                              label: 'IFSC Code',
                              controller: _ifscCodeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter IFSC code';
                                }
                                return null;
                              },
                              icon: Iconsax.bank,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Agreement Files Card
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
                                Icon(Iconsax.document, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Agreement Files',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildFilePicker(
                              label: 'Agreement File 1',
                              filePath: _agreementFile1Path,
                              onPick: () => _pickFile(1),
                              fileNumber: 1,
                            ),
                            SizedBox(height: 12),
                            _buildFilePicker(
                              label: 'Agreement File 2',
                              filePath: _agreementFile2Path,
                              onPick: () => _pickFile(2),
                              fileNumber: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveCollectionCenter,
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
                      label: Text(_isEditing ? 'Update Collection Center' : 'Save Collection Center'),
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
    _centerCodeController.dispose();
    _centerNameController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _locationController.dispose();
    _postalCodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _gstNumberController.dispose();
    _panNumberController.dispose();
    _contactPersonController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _centreStatusController.dispose();
    _branchTypeController.dispose();
    _labAffiliationController.dispose();
    _operationalHoursFromController.dispose();
    _operationalHoursToController.dispose();
    _collectionDaysController.dispose();
    _samplePickupFromController.dispose();
    _samplePickupToController.dispose();
    _transportModeController.dispose();
    _courierAgencyController.dispose();
    _commissionTypeController.dispose();
    _commissionValueController.dispose();
    _accountHolderController.dispose();
    _accountNoController.dispose();
    _ifscCodeController.dispose();
    super.dispose();
  }
}