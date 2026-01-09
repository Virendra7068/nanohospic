// ignore_for_file: avoid_print, deprecated_member_use, depend_on_referenced_packages, use_super_parameters, sort_child_properties_last

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nanohospic/database/entity/doctor_commision_entity.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/referrer_entity.dart';

class DoctorCommissionListScreen extends StatefulWidget {
  const DoctorCommissionListScreen({super.key});

  @override
  State<DoctorCommissionListScreen> createState() =>
      _DoctorCommissionListScreenState();
}

class _DoctorCommissionListScreenState
    extends State<DoctorCommissionListScreen> {
  List<DoctorCommissionEntity> _commissions = [];
  List<DoctorCommissionEntity> _filteredCommissions = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _syncTimer;

  final Color _primaryColor = Color(0xff016B61);
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _searchController.addListener(() {
      _filterCommissions(_searchController.text);
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

      await _loadCommissions();
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

  Future<void> _loadCommissions() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final repository = await DatabaseProvider.doctorCommissionRepository;
      final commissions = await repository.getAllCommissions();
      setState(() {
        _commissions = commissions;
        _filteredCommissions = List.from(_commissions);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading commissions: $e');
      setState(() {
        _error = 'Failed to load commissions: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSyncStats() async {
    try {
      await DatabaseProvider.doctorCommissionRepository;
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
      await _loadCommissions();
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
      final repository = await DatabaseProvider.doctorCommissionRepository;
      final pendingCommissions = await repository.getPendingSync();

      for (final commission in pendingCommissions) {
        if (commission.isDeleted == 1) {
          if (commission.serverId != null) {
            await repository.deleteFromServer(commission.serverId!);
            await repository.markAsSynced(commission.id!);
          } else {
            await repository.markAsSynced(commission.id!);
          }
        } else if (commission.serverId == null) {
          final serverId = await repository.addToServer(commission);
          if (serverId != null) {
            await repository.updateServerId(commission.id!, serverId);
            await repository.markAsSynced(commission.id!);
          }
        } else {
          final success = await repository.updateOnServer(commission);
          if (success) {
            await repository.markAsSynced(commission.id!);
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

  void _filterCommissions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCommissions = List.from(_commissions);
      } else {
        _filteredCommissions = _commissions
            .where(
              (commission) =>
                  commission.doctorName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  commission.referrerName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  commission.commissionFor.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  commission.contactNo.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  Future<bool> _deleteCommission(int commissionId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repository = await DatabaseProvider.doctorCommissionRepository;
      await repository.softDeleteCommission(commissionId, 'user');
      await _loadCommissions();
      await _loadSyncStats();

      await _syncPendingChanges();

      return true;
    } catch (e) {
      setState(() {
        _error = 'Failed to delete commission: $e';
      });
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(DoctorCommissionEntity commission) {
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
                  'Delete Commission?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete commission for "${commission.doctorName}"?',
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
                          final success = await _deleteCommission(
                            commission.id!,
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
                                      'Commission for "${commission.doctorName}" deleted',
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

  void _showCommissionDetails(DoctorCommissionEntity commission) {
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
                            Iconsax.money_send,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        commission.doctorName,
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
                          color: commission.status == 'Active'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: commission.status == 'Active'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        child: Text(
                          commission.status,
                          style: TextStyle(
                            color: commission.status == 'Active'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Doctor Information Card
                    _buildDetailCard(
                      icon: Iconsax.profile_circle,
                      title: 'Doctor Information',
                      items: [
                        _buildDetailItem('Doctor Name', commission.doctorName),
                        _buildDetailItem('Initials', commission.initials),
                        _buildDetailItem('Contact', commission.contactNo),
                        _buildDetailItem('Email', commission.email),
                        _buildDetailItem(
                          'Work Station',
                          commission.workStation,
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Commission Information Card
                    _buildDetailCard(
                      icon: Iconsax.money,
                      title: 'Commission Details',
                      items: [
                        _buildDetailItem('Referrer', commission.referrerName),
                        _buildDetailItem(
                          'Commission For',
                          commission.commissionFor,
                        ),
                        _buildDetailItem('Type', commission.commissionType),
                        _buildDetailItem(
                          'Percentage',
                          '${commission.percentage}%',
                        ),
                        _buildDetailItem(
                          'Value',
                          '₹${commission.value.toStringAsFixed(2)}',
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Additional Information Card
                    _buildDetailCard(
                      icon: Iconsax.info_circle,
                      title: 'Additional Information',
                      items: [
                        _buildDetailItem('Status', commission.status),
                        _buildDetailItem('Center', commission.centerName),
                        _buildDetailItem('Remarks', commission.remarks),
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
                                  builder: (context) =>
                                      DoctorCommissionEntryScreen(
                                        commission: commission,
                                        onSaved: _loadCommissions,
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
                              _showDeleteConfirmationDialog(commission);
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
            width: 160,
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
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
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
                          'Doctor Commissions',
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
                          'Manage doctor commission settings',
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
                        hintText: 'Search commissions...',
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
                              _filterCommissions('');
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
                  icon: Icon(Iconsax.refresh, color: Colors.white, size: 22),
                  onPressed: _loadCommissions,
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
      floatingActionButton:
          FloatingActionButton.extended(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorCommissionEntryScreen(
                        onSaved: _loadCommissions,
                      ),
                    ),
                  );

                  if (result == true) {
                    await _loadCommissions();
                  }
                },
                icon: Icon(Iconsax.add, size: 24),
                label: Text('Add Commission'),
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then(delay: 200.ms)
              .shake(hz: 3, curve: Curves.easeInOut),
    );
  }

  Widget _buildBody() {
    final displayCommissions = _isSearching
        ? _filteredCommissions
        : _commissions;

    if (_isLoading && _commissions.isEmpty) {
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
                  'Loading commissions...',
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

    if (_commissions.isEmpty) {
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
                          _primaryColor.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.money_send,
                      size: 60,
                      color: _primaryColor,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(delay: 1000.ms, duration: 2000.ms)
                  .then(),
              SizedBox(height: 24),
              Text(
                'No Commissions Found',
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
                  'Get started by adding your first doctor commission to the system',
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
                      builder: (context) => DoctorCommissionEntryScreen(
                        onSaved: _loadCommissions,
                      ),
                    ),
                  );

                  if (result == true) {
                    await _loadCommissions();
                  }
                },
                icon: Icon(Iconsax.add, size: 20),
                label: Text('Add First Commission'),
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
        _filteredCommissions.isEmpty &&
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
                'No commissions found for "${_searchController.text}"',
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
      onRefresh: _loadCommissions,
      backgroundColor: Colors.white,
      color: _primaryColor,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayCommissions.length,
        itemBuilder: (context, index) {
          final commission = displayCommissions[index];
          return _buildCommissionItem(commission, index);
        },
      ),
    );
  }

  Widget _buildCommissionItem(DoctorCommissionEntity commission, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child:
          Material(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                elevation: 1,
                shadowColor: Colors.blue.withOpacity(0.1),
                child: InkWell(
                  onTap: () => _showCommissionDetails(commission),
                  onLongPress: () {
                    _showDeleteConfirmationDialog(commission);
                  },
                  borderRadius: BorderRadius.circular(16),
                  splashColor: _primaryColor.withOpacity(0.1),
                  highlightColor: _primaryColor.withOpacity(0.05),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26.sp,
                          height: 26.sp,
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
                              Iconsax.money_send,
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
                                      commission.doctorName,
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
                                      color: commission.status == 'Active'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: commission.status == 'Active'
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                    child: Text(
                                      commission.status,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: commission.status == 'Active'
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
                                    Iconsax.profile_circle,
                                    size: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      commission.referrerName.isNotEmpty
                                          ? 'Referrer: ${commission.referrerName}'
                                          : 'Direct Commission',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 4),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Iconsax.money,
                              //       size: 14,
                              //       color: Colors.grey.shade500,
                              //     ),
                              //     SizedBox(width: 6),
                              //     Expanded(
                              //       child: Text(
                              //         '${commission.commissionType}: ${commission.percentage}%',
                              //         style: TextStyle(
                              //           fontSize: 14.sp,
                              //           color: Colors.grey.shade600,
                              //         ),
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 4),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Iconsax.medal,
                              //       size: 14,
                              //       color: Colors.grey.shade500,
                              //     ),
                              //     SizedBox(width: 6),
                              //     Expanded(
                              //       child: Text(
                              //         'For: ${commission.commissionFor}',
                              //         style: TextStyle(
                              //           fontSize: 12,
                              //           color: Colors.grey.shade600,
                              //         ),
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 4),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Iconsax.dollar_circle,
                              //       size: 14,
                              //       color: Colors.green,
                              //     ),
                              //     SizedBox(width: 6),
                              //     Text(
                              //       'Value: ₹${commission.value.toStringAsFixed(2)}',
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         color: Colors.green.shade700,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // if (commission.workStation.isNotEmpty) ...[
                              //   SizedBox(height: 4),
                              //   Row(
                              //     children: [
                              //       Icon(
                              //         Iconsax.building,
                              //         size: 12,
                              //         color: Colors.grey.shade500,
                              //       ),
                              //       SizedBox(width: 6),
                              //       Text(
                              //         'Work Station: ${commission.workStation}',
                              //         style: TextStyle(
                              //           fontSize: 11,
                              //           color: Colors.grey.shade600,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ],
                              // if (commission.createdAt != null) ...[
                              //   SizedBox(height: 6),
                              //   Row(
                              //     children: [
                              //       Icon(
                              //         Iconsax.calendar,
                              //         size: 12,
                              //         color: Colors.grey.shade500,
                              //       ),
                              //       SizedBox(width: 6),
                              //       Text(
                              //         'Created: ${_formatDate(commission.createdAt!)}',
                              //         style: TextStyle(
                              //           fontSize: 11,
                              //           color: Colors.grey.shade600,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ],
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
                          onPressed: () => _showCommissionDetails(commission),
                          tooltip: 'View Details',
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

class DoctorCommissionEntryScreen extends StatefulWidget {
  final DoctorCommissionEntity? commission;
  final Function()? onSaved;

  const DoctorCommissionEntryScreen({Key? key, this.commission, this.onSaved})
    : super(key: key);

  @override
  _DoctorCommissionEntryScreenState createState() =>
      _DoctorCommissionEntryScreenState();
}

class _DoctorCommissionEntryScreenState
    extends State<DoctorCommissionEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditing = false;

  // Controllers
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _initialsController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _workStationController = TextEditingController();
  final TextEditingController _commissionForController =
      TextEditingController();
  final TextEditingController _commissionTypeController =
      TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _centerController = TextEditingController();

  // Referrer related
  final TextEditingController _referrerController = TextEditingController();
  ReferrerEntity? _selectedReferrer;
  List<ReferrerEntity> _referrers = [];

  // Doctor dropdown data
  List<Map<String, String>> _doctors = [
    {'name': 'Dr. John Smith', 'initials': 'JS'},
    {'name': 'Dr. Sarah Johnson', 'initials': 'SJ'},
    {'name': 'Dr. Michael Brown', 'initials': 'MB'},
    {'name': 'Dr. Emily Davis', 'initials': 'ED'},
    {'name': 'Dr. Robert Wilson', 'initials': 'RW'},
    {'name': 'Dr. Lisa Miller', 'initials': 'LM'},
    {'name': 'Dr. David Taylor', 'initials': 'DT'},
    {'name': 'Dr. Jennifer Anderson', 'initials': 'JA'},
  ];

  // Dropdown options
  List<String> commissionForOptions = [
    'OPD',
    'IPD',
    'Surgery',
    'Lab Tests',
    'Scans',
    'Procedures',
    'All Services',
  ];

  List<String> commissionTypeOptions = ['Percentage', 'Fixed Amount'];

  List<String> statusOptions = ['Active', 'Inactive'];

  List<String> centerOptions = [
    'Main Center',
    'Branch 1',
    'Branch 2',
    'Branch 3',
    'Satellite Center',
  ];

  final Color _primaryColor = Color(0xff016B61);
  final Color _secondaryColor = Color(0xff2E7D32);
  final Color _accentColor = Color(0xffFF6B6B);

  @override
  void initState() {
    super.initState();
    _isEditing = widget.commission != null;

    _loadReferrers();
    if (_isEditing) {
      _populateForm();
    } else {
      _commissionTypeController.text = 'Percentage';
      _statusController.text = 'Active';
    }
  }

  Future<void> _loadReferrers() async {
    try {
      final repository = await DatabaseProvider.refrerrerRepository;
      final referrers = await repository.getAllReferrers();
      setState(() {
        _referrers = referrers;
      });
    } catch (e) {
      print('Error loading referrers: $e');
    }
  }

  void _populateForm() {
    final commission = widget.commission!;
    _doctorNameController.text = commission.doctorName;
    _initialsController.text = commission.initials;
    _contactNoController.text = commission.contactNo;
    _emailController.text = commission.email;
    _workStationController.text = commission.workStation;
    _commissionForController.text = commission.commissionFor;
    _commissionTypeController.text = commission.commissionType;
    _percentageController.text = commission.percentage.toString();
    _valueController.text = commission.value.toString();
    _remarksController.text = commission.remarks;
    _statusController.text = commission.status;
    _centerController.text = commission.centerName;

    // Set referrer if exists
    if (commission.referrerId != null && _referrers.isNotEmpty) {
      final referrer = _referrers.firstWhere(
        (r) => r.id == commission.referrerId,
        orElse: () => _referrers.first,
      );
      _selectedReferrer = referrer;
      _referrerController.text = referrer.name;
    }
  }

  Future<void> _saveCommission() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final repository = await DatabaseProvider.doctorCommissionRepository;
      final commission = DoctorCommissionEntity(
        id: widget.commission?.id,
        serverId: widget.commission?.serverId,
        doctorName: _doctorNameController.text.trim(),
        initials: _initialsController.text.trim(),
        contactNo: _contactNoController.text.trim(),
        email: _emailController.text.trim(),
        workStation: _workStationController.text.trim(),
        referrerId: _selectedReferrer?.id,
        referrerName: _selectedReferrer?.name ?? '',
        commissionFor: _commissionForController.text.trim(),
        commissionType: _commissionTypeController.text.trim(),
        percentage: double.tryParse(_percentageController.text) ?? 0.0,
        value: double.tryParse(_valueController.text) ?? 0.0,
        remarks: _remarksController.text.trim(),
        status: _statusController.text.trim(),
        centerId: 1, // You can get this from center dropdown
        centerName: _centerController.text.trim(),
        createdAt:
            widget.commission?.createdAt ?? DateTime.now().toIso8601String(),
        createdBy: widget.commission?.createdBy ?? 'User',
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'User',
      );

      if (_isEditing) {
        await repository.updateCommission(commission);
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);

        _showSuccessSnackbar(
          'Commission for ${commission.doctorName} updated successfully',
        );
      } else {
        await repository.insertCommission(commission);
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);

        _showSuccessSnackbar(
          'Commission for ${commission.doctorName} added successfully',
        );
      }
    } catch (e) {
      print('Error saving commission: $e');
      _showErrorSnackbar('Failed to save: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.tick_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.close_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showReferrerSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.profile_add, color: _primaryColor, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Select Referrer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: _referrers.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final referrer = _referrers[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: _selectedReferrer?.id == referrer.id
                              ? _primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: _selectedReferrer?.id == referrer.id
                              ? Border.all(color: _primaryColor, width: 1)
                              : null,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Iconsax.profile_circle,
                                color: _primaryColor,
                                size: 22,
                              ),
                            ),
                          ),
                          title: Text(
                            referrer.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (referrer.specialization.isNotEmpty)
                                Text(
                                  referrer.specialization,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              if (referrer.contactNo.isNotEmpty)
                                Text(
                                  referrer.contactNo,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                            ],
                          ),
                          trailing: _selectedReferrer?.id == referrer.id
                              ? Icon(
                                  Iconsax.tick_circle,
                                  color: _secondaryColor,
                                  size: 24,
                                )
                              : Icon(
                                  Iconsax.arrow_right_3,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                          onTap: () {
                            setState(() {
                              _selectedReferrer = referrer;
                              _referrerController.text = referrer.name;
                            });
                            Navigator.pop(context);
                          },
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedReferrer = null;
                          _referrerController.text = '';
                        });
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.close_circle, size: 18),
                          SizedBox(width: 6),
                          Text('Clear'),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.arrow_left, size: 18),
                          SizedBox(width: 6),
                          Text('Back'),
                        ],
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
    Widget? suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRequired)
            Row(
              children: [
                Text('*', style: TextStyle(color: _accentColor, fontSize: 16)),
                SizedBox(width: 2),
              ],
            ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accentColor, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accentColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: icon != null
                  ? Container(
                      padding: EdgeInsets.all(12),
                      child: Icon(icon, color: _primaryColor, size: 22),
                    )
                  : null,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            readOnly: readOnly,
            onTap: onTap,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
    String? hintText,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRequired)
            Row(
              children: [
                Text('*', style: TextStyle(color: _accentColor, fontSize: 16)),
                SizedBox(width: 2),
              ],
            ),
          DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accentColor, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accentColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hintText ?? 'Select $label',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: icon != null
                  ? Container(
                      padding: EdgeInsets.all(12),
                      child: Icon(icon, color: _primaryColor, size: 22),
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue ?? '';
                if (label == 'Commission Type' && newValue == 'Fixed Amount') {
                  _percentageController.text = '0';
                }
              });
            },
            validator: validator,
            dropdownColor: Colors.white,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            icon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Iconsax.arrow_down_1, color: _primaryColor, size: 20),
            ),
            borderRadius: BorderRadius.circular(12),
            isExpanded: true,
            menuMaxHeight: 300,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('*', style: TextStyle(color: _accentColor, fontSize: 16)),
              SizedBox(width: 2),
            ],
          ),
          DropdownButtonFormField<String>(
            value: _doctorNameController.text.isNotEmpty
                ? _doctorNameController.text
                : null,
            decoration: InputDecoration(
              labelText: 'Doctor Name',
              labelStyle: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Select Doctor',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Iconsax.profile_circle,
                  color: _primaryColor,
                  size: 22,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            items: _doctors.map((doctor) {
              return DropdownMenuItem<String>(
                value: doctor['name'],
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name']!,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Initials: ${doctor['initials']}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                final selectedDoctor = _doctors.firstWhere(
                  (doctor) => doctor['name'] == newValue,
                  orElse: () => {'name': '', 'initials': ''},
                );
                setState(() {
                  _doctorNameController.text = selectedDoctor['name']!;
                  _initialsController.text = selectedDoctor['initials']!;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select doctor';
              }
              return null;
            },
            dropdownColor: Colors.white,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            icon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Iconsax.arrow_down_1, color: _primaryColor, size: 20),
            ),
            borderRadius: BorderRadius.circular(12),
            isExpanded: true,
            menuMaxHeight: 300,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primaryColor.withOpacity(0.1),
                    _primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: _primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: iconColor ?? _primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: iconColor ?? _primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionValueIndicator() {
    final percentage = double.tryParse(_percentageController.text) ?? 0;
    final value = double.tryParse(_valueController.text) ?? 0;
    final type = _commissionTypeController.text;

    if (type.isEmpty) return SizedBox();

    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: type == 'Percentage'
            ? Colors.blue.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: type == 'Percentage'
              ? Colors.blue.withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.info_circle,
            color: type == 'Percentage' ? Colors.blue : Colors.green,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              type == 'Percentage'
                  ? 'Commission: $percentage% of total amount'
                  : 'Fixed Commission: ₹${value.toStringAsFixed(2)} per service',
              style: TextStyle(
                color: type == 'Percentage' ? Colors.blue : Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 14,
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
          _isEditing ? 'Edit Commission' : 'Add New Commission',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(Iconsax.save_2, size: 24),
              onPressed: _saveCommission,
              tooltip: 'Save',
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primaryColor, _secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Saving Commission...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please wait while we save your details',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
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
                    // Header decoration
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _primaryColor.withOpacity(0.1),
                            _secondaryColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.money_send,
                            color: _primaryColor,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isEditing
                                      ? 'Update Commission Details'
                                      : 'Create New Commission',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fill in the details below to ${_isEditing ? 'update' : 'create'} a doctor commission',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Doctor Information Card
                    _buildSectionCard(
                      title: 'Doctor Information',
                      icon: Iconsax.profile_circle,
                      children: [
                        _buildDoctorDropdown(),
                        _buildTextFormField(
                          label: 'Initials',
                          controller: _initialsController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter initials';
                            }
                            return null;
                          },
                          icon: Iconsax.text,
                          readOnly: true,
                        ),
                        _buildTextFormField(
                          label: 'Contact No',
                          controller: _contactNoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact number';
                            }
                            if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value)) {
                              return 'Please enter a valid contact number';
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
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          icon: Iconsax.sms,
                        ),
                        _buildTextFormField(
                          label: 'Work Station',
                          controller: _workStationController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter work station';
                            }
                            return null;
                          },
                          icon: Iconsax.building_4,
                        ),
                      ],
                    ),

                    // Referrer Information Card
                    _buildSectionCard(
                      title: 'Referrer Information',
                      icon: Iconsax.profile_add,
                      iconColor: Colors.purple,
                      children: [
                        _buildTextFormField(
                          label: 'Doctor Referrer',
                          controller: _referrerController,
                          validator: null,
                          isRequired: false,
                          icon: Iconsax.profile_add,
                          readOnly: true,
                          onTap: _showReferrerSelectionDialog,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Iconsax.search_normal,
                              color: _primaryColor,
                              size: 20,
                            ),
                            onPressed: _showReferrerSelectionDialog,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.info_circle,
                                color: Colors.purple,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Referrer selection is optional for direct doctor commissions',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.purple.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Commission Details Card
                    _buildSectionCard(
                      title: 'Commission Details',
                      icon: Iconsax.money,
                      iconColor: Colors.orange,
                      children: [
                        _buildDropdownFormField(
                          label: 'Commission For',
                          controller: _commissionForController,
                          options: commissionForOptions,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select commission for';
                            }
                            return null;
                          },
                          icon: Iconsax.activity,
                          hintText: 'Select service type',
                        ),
                        _buildDropdownFormField(
                          label: 'Type',
                          controller: _commissionTypeController,
                          options: commissionTypeOptions,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select commission type';
                            }
                            return null;
                          },
                          icon: Iconsax.dollar_circle,
                          hintText: 'Select commission type',
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextFormField(
                                label: 'Percentage (%)',
                                controller: _percentageController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter percentage';
                                  }
                                  final percentage = double.tryParse(value);
                                  if (percentage == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (percentage < 0 || percentage > 100) {
                                    return 'Percentage must be between 0 and 100';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                icon: Iconsax.percentage_circle,
                                readOnly:
                                    _commissionTypeController.text ==
                                    'Fixed Amount',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextFormField(
                                label: 'Value (₹)',
                                controller: _valueController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter value';
                                  }
                                  final val = double.tryParse(value);
                                  if (val == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (val < 0) {
                                    return 'Value cannot be negative';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                icon: Iconsax.dollar_circle,
                              ),
                            ),
                          ],
                        ),
                        _buildCommissionValueIndicator(),
                      ],
                    ),

                    // Additional Information Card
                    _buildSectionCard(
                      title: 'Additional Information',
                      icon: Iconsax.info_circle,
                      iconColor: Colors.teal,
                      children: [
                        _buildDropdownFormField(
                          label: 'Status',
                          controller: _statusController,
                          options: statusOptions,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select status';
                            }
                            return null;
                          },
                          icon: Iconsax.activity,
                          hintText: 'Select commission status',
                        ),
                        _buildDropdownFormField(
                          label: 'Center',
                          controller: _centerController,
                          options: centerOptions,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select center';
                            }
                            return null;
                          },
                          icon: Iconsax.location,
                          hintText: 'Select center',
                        ),
                        _buildTextFormField(
                          label: 'Remarks',
                          controller: _remarksController,
                          validator: null,
                          isRequired: false,
                          maxLines: 3,
                          icon: Iconsax.note,
                        ),
                      ],
                    ),

                    // Action Buttons
                    Container(
                      margin: EdgeInsets.only(top: 24, bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _saveCommission,
                              icon: _isLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(Iconsax.save_2, size: 24),
                              label: Text(
                                _isEditing
                                    ? 'Update Commission'
                                    : 'Save Commission',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                shadowColor: _primaryColor.withOpacity(0.3),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Iconsax.close_circle, size: 24),
                              label: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _initialsController.dispose();
    _contactNoController.dispose();
    _emailController.dispose();
    _workStationController.dispose();
    _referrerController.dispose();
    _commissionForController.dispose();
    _commissionTypeController.dispose();
    _percentageController.dispose();
    _valueController.dispose();
    _remarksController.dispose();
    _statusController.dispose();
    _centerController.dispose();
    super.dispose();
  }
}
