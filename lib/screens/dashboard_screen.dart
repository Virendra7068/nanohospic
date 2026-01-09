// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:nanohospic/screens/banner_widget.dart';
import 'package:nanohospic/screens/dashboard_card_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _showAppBar = true;
  double _lastScrollPosition = 0;
  String _selectedMenu = 'Dashboard';

  // Sync statistics variables
  Map<String, dynamic> _syncStats = {
    'totalRecords': 0,
    'syncedRecords': 0,
    'pendingRecords': 0,
    'lastSyncTime': 'Never',
    'syncProgress': 0.0,
    'isSyncing': false,
  };

  bool _isLoading = false;

  final List<String> _bannerImages = [
    'assets/banner1.jpg',
    'assets/banner2.jpg',
    'assets/banner3.jpeg',
  ];

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadSyncStatistics();
    _pageController.addListener(() {
      setState(() {});
    });

    _scrollController.addListener(_handleScroll);
    _searchFocusNode.addListener(() {
      setState(() {});
    });

    // Auto-refresh sync stats every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadSyncStatisticsInBackground();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSyncStatistics() async {
    print('⚡ Loading sync statistics...');
    setState(() {
      _isLoading = true;
    });
    
    await Future.wait([
      _fetchSyncStatsFromApi(),
      _fetchRecordCountsFromDatabase(),
    ]);
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSyncStatisticsInBackground() async {
    try {
      await Future.wait([
        _fetchSyncStatsFromApi(),
        _fetchRecordCountsFromDatabase(),
      ]);
    } catch (e) {
      print('⚠️ Background sync stats load failed: $e');
    }
  }

  void _handleScroll() {
    final currentPosition = _scrollController.offset;
    if (currentPosition > _lastScrollPosition && currentPosition > 100) {
      if (_showAppBar) {
        setState(() => _showAppBar = false);
      }
    } else if (currentPosition < _lastScrollPosition) {
      if (!_showAppBar) {
        setState(() => _showAppBar = true);
      }
    }
    _lastScrollPosition = currentPosition;
  }

  // SYNC STATISTICS METHODS
  Future<void> _fetchSyncStatsFromApi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');

      if (authToken == null) return;

      final response = await http
          .get(
            Uri.parse('http://202.140.138.215:85/api/SyncApi/statistics'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _syncStats = {
              'totalRecords': data['totalRecords'] ?? 0,
              'syncedRecords': data['syncedRecords'] ?? 0,
              'pendingRecords': data['pendingRecords'] ?? 0,
              'lastSyncTime': data['lastSyncTime'] ?? 'Never',
              'syncProgress': data['syncProgress'] ?? 0.0,
              'isSyncing': data['isSyncing'] ?? false,
            };
          });
        }
      }
    } catch (e) {
      // If API fails, try to get from local database
      await _getLocalSyncStats();
    }
  }

  Future<void> _fetchRecordCountsFromDatabase() async {
    // This would normally query your local database
    // For now, we'll use mock data
    try {
      final prefs = await SharedPreferences.getInstance();
      final localStats = {
        'localTotal': prefs.getInt('local_total_records') ?? 0,
        'localSynced': prefs.getInt('local_synced_records') ?? 0,
        'localPending': prefs.getInt('local_pending_records') ?? 0,
      };

      if (mounted) {
        setState(() {
          // Update only if we have local data and no API data
          if (_syncStats['totalRecords'] == 0) {
            _syncStats['totalRecords'] = localStats['localTotal'];
            _syncStats['syncedRecords'] = localStats['localSynced'];
            _syncStats['pendingRecords'] = localStats['localPending'];
          }
        });
      }
    } catch (e) {
      print('⚠️ Local database query failed: $e');
    }
  }

  Future<void> _getLocalSyncStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (mounted) {
      setState(() {
        _syncStats = {
          'totalRecords': prefs.getInt('total_records') ?? 0,
          'syncedRecords': prefs.getInt('synced_records') ?? 0,
          'pendingRecords': prefs.getInt('pending_records') ?? 0,
          'lastSyncTime': prefs.getString('last_sync_time') ?? 'Never',
          'syncProgress': prefs.getDouble('sync_progress') ?? 0.0,
          'isSyncing': false,
        };
      });
    }
  }

  Future<void> _startManualSync() async {
    if (_syncStats['isSyncing']) return;
    
    setState(() {
      _syncStats['isSyncing'] = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');

      if (authToken == null) {
        throw Exception('Authentication required');
      }

      final response = await http
          .post(
            Uri.parse('http://202.140.138.215:85/api/SyncApi/start'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh statistics
        await _loadSyncStatistics();
      } else {
        throw Exception('Sync failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _syncStats['isSyncing'] = false;
        });
      }
    }
  }

  Future<void> _forceSyncAll() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Force Sync All Data'),
        content: Text('This will force sync all pending records. This may take several minutes. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _startManualSync();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Force Sync'),
          ),
        ],
      ),
    );
  }

  // UI HELPERS
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDateTime(String dateTime) {
    if (dateTime == 'Never') return dateTime;
    
    try {
      final dt = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(dt);
      
      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 30) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('dd MMM yyyy').format(dt);
      }
    } catch (e) {
      return dateTime;
    }
  }

  List<Map<String, dynamic>> get _dashboardItems {
    return [
      {
        'title': 'Total Records',
        'value': _formatNumber(_syncStats['totalRecords']),
        'count': _syncStats['totalRecords'],
        'icon': Icons.storage,
        'color': Colors.blue,
        'subtitle': 'All records in system',
        'isLoading': _isLoading,
      },
      {
        'title': 'Synced Records',
        'value': _formatNumber(_syncStats['syncedRecords']),
        'count': _syncStats['syncedRecords'],
        'icon': Icons.cloud_done,
        'color': Colors.green,
        'subtitle': 'Successfully synchronized',
        'isLoading': _isLoading,
      },
      {
        'title': 'Pending Sync',
        'value': _formatNumber(_syncStats['pendingRecords']),
        'count': _syncStats['pendingRecords'],
        'icon': Icons.cloud_upload,
        'color': Colors.orange,
        'subtitle': 'Waiting for sync',
        'isLoading': _isLoading,
      },
      {
        'title': 'Sync Progress',
        'value': '${(_syncStats['syncProgress'] * 100).toStringAsFixed(1)}%',
        'count': _syncStats['syncProgress'],
        'icon': Icons.trending_up,
        'color': Colors.purple,
        'subtitle': 'Overall completion',
        'isLoading': _isLoading,
      },
      {
        'title': 'Last Sync',
        'value': _formatDateTime(_syncStats['lastSyncTime']),
        'count': 0,
        'icon': Icons.access_time,
        'color': Colors.teal,
        'subtitle': 'Last synchronization time',
        'isLoading': _isLoading,
      },
      {
        'title': 'Sync Status',
        'value': _syncStats['isSyncing'] ? 'Syncing...' : 'Ready',
        'count': _syncStats['isSyncing'] ? 1 : 0,
        'icon': _syncStats['isSyncing'] ? Icons.sync : Icons.check_circle,
        'color': _syncStats['isSyncing'] ? Colors.amber : Colors.green,
        'subtitle': _syncStats['isSyncing'] ? 'Synchronizing data' : 'Ready to sync',
        'isLoading': _isLoading,
      },
    ];
  }

  Widget _buildDashboardCards() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 0.sp),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.sp,
          mainAxisSpacing: 12.sp,
          childAspectRatio: 2,
        ),
        itemCount: _dashboardItems.length,
        itemBuilder: (context, index) {
          final item = _dashboardItems[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: DashboardCard(
              title: item['title'],
              value: item['value'],
              icon: item['icon'],
              color: item['color'],
              // subtitle: item['subtitle'],
              // isLoading: item['isLoading'],
              onTap: () {
                _showCardDetails(context, item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSyncProgressSection() {
    final total = _syncStats['totalRecords'] as int;
    final synced = _syncStats['syncedRecords'] as int;
    final pending = _syncStats['pendingRecords'] as int;
    final progress = _syncStats['syncProgress'] as double;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 2.h, 16.sp, 8.sp),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8.sp,
              spreadRadius: 1.sp,
            ),
          ],
        ),
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sync Progress',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.sp),
            
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.blue,
              minHeight: 8.sp,
              borderRadius: BorderRadius.circular(4.sp),
            ),
            
            SizedBox(height: 16.sp),
            
            // Statistics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 8.sp,
              crossAxisSpacing: 8.sp,
              children: [
                _buildStatItem(
                  title: 'Total',
                  value: total.toString(),
                  color: Colors.blue,
                  icon: Icons.storage,
                ),
                _buildStatItem(
                  title: 'Synced',
                  value: synced.toString(),
                  color: Colors.green,
                  icon: Icons.cloud_done,
                ),
                _buildStatItem(
                  title: 'Pending',
                  value: pending.toString(),
                  color: Colors.orange,
                  icon: Icons.cloud_upload,
                ),
              ],
            ),
            
            SizedBox(height: 16.sp),
            
            // Sync Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _syncStats['isSyncing'] ? null : _startManualSync,
                    icon: _syncStats['isSyncing']
                        ? SizedBox(
                            width: 14.sp,
                            height: 14.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.sp,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.sync, size: 18.sp),
                    label: Text(
                      _syncStats['isSyncing'] ? 'Syncing...' : 'Sync Now',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 12.sp),
                
                if (pending > 0)
                  IconButton(
                    onPressed: _forceSyncAll,
                    icon: Icon(Icons.refresh, size: 22.sp),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.orange.shade700,
                      padding: EdgeInsets.all(12.sp),
                    ),
                    tooltip: 'Force sync all pending records',
                  ),
              ],
            ),
            
            SizedBox(height: 8.sp),
            
            // Last Sync Info
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 8.sp),
                Text(
                  'Last sync: ${_formatDateTime(_syncStats['lastSyncTime'])}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                Spacer(),
                if (_syncStats['isSyncing'])
                  Text(
                    'Processing...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: EdgeInsets.all(12.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.sp, color: color),
              SizedBox(width: 4.sp),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.sp),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncHistory() {
    // This would normally come from your database
    final mockSyncHistory = [
      {'time': DateTime.now().subtract(Duration(minutes: 5)), 'status': 'success', 'records': 15},
      {'time': DateTime.now().subtract(Duration(hours: 2)), 'status': 'success', 'records': 42},
      {'time': DateTime.now().subtract(Duration(days: 1)), 'status': 'partial', 'records': 28},
      {'time': DateTime.now().subtract(Duration(days: 3)), 'status': 'failed', 'records': 0},
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 2.h, 16.sp, 8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sync History',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                'Last ${mockSyncHistory.length} syncs',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
          
          SizedBox(height: 12.sp),
          
          ...mockSyncHistory.map((sync) {
            final time = sync['time'] as DateTime;
            final status = sync['status'] as String;
            final records = sync['records'] as int;
            
            Color statusColor;
            IconData statusIcon;
            String statusText;
            
            switch (status) {
              case 'success':
                statusColor = Colors.green;
                statusIcon = Icons.check_circle;
                statusText = 'Success';
                break;
              case 'partial':
                statusColor = Colors.orange;
                statusIcon = Icons.warning;
                statusText = 'Partial';
                break;
              default:
                statusColor = Colors.red;
                statusIcon = Icons.error;
                statusText = 'Failed';
            }
            
            return Container(
              margin: EdgeInsets.only(bottom: 8.sp),
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4.sp,
                    spreadRadius: 1.sp,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.sp),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, size: 18.sp, color: statusColor),
                  ),
                  
                  SizedBox(width: 12.sp),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: statusColor,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(time),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Text(
                    '$records records',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16.sp),
          Text(
            'Loading sync statistics...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCardDetails(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.sp,
                height: 4.sp,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.sp),
                ),
              ),
            ),
            
            SizedBox(height: 16.sp),
            
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                    size: 24.sp,
                  ),
                ),
                
                SizedBox(width: 12.sp),
                
                Expanded(
                  child: Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20.sp),
            
            Center(
              child: Text(
                item['value'],
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: item['color'],
                ),
              ),
            ),
            
            if (item.containsKey('count') && item['count'] > 0)
              Center(
                child: Text(
                  '${item['count']} records',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            
            SizedBox(height: 16.sp),
            
            if (item.containsKey('subtitle'))
              Center(
                child: Text(
                  item['subtitle'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            SizedBox(height: 24.sp),
            
            // Sync button if this is a sync-related card
            if (item['title'].contains('Sync'))
              SizedBox(
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _syncStats['isSyncing'] ? null : _startManualSync,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.sp),
                    backgroundColor: item['color'],
                  ),
                  child: _syncStats['isSyncing']
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16.sp,
                              height: 16.sp,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Text('Syncing...', style: TextStyle(color: Colors.white)),
                          ],
                        )
                      : Text('Sync Now', style: TextStyle(color: Colors.white)),
                ),
              ),
            
            SizedBox(height: 16.sp),
            
            SizedBox(
              height: 5.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.sp),
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.grey.shade700,
                ),
                child: Text('Close'),
              ),
            ),
            
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: _loadSyncStatistics,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 2,
              pinned: true,
              floating: true,
              expandedHeight: 9.h,
              title: PopupMenuButton<String>(
                child: Text(
                  _selectedMenu,
                  style: GoogleFonts.abel(
                    textStyle: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onSelected: (value) => setState(() => _selectedMenu = value),
                itemBuilder: (context) =>
                    ['Dashboard', 'Reports', 'Analytics', 'Settings']
                        .map(
                          (choice) => PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          ),
                        )
                        .toList(),
              ),
              actions: [
                IconButton(
                  icon: Image.asset("assets/gift.gif", height: 7.h),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.refresh, size: 20.sp),
                  onPressed: _loadSyncStatistics,
                ),
              ],
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                BannerSlider(bannerImages: _bannerImages),
                
                if (_isLoading)
                  _buildLoadingState()
                else ...[
                  _buildDashboardCards(),
                  _buildSyncProgressSection(),
                  _buildSyncHistory(),
                ],
                
                SizedBox(height: 8.h),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// Service class for sync operations
class SyncService {
  static const String baseUrl = "http://202.140.138.215:85/api/SyncApi";
  
  Future<Map<String, dynamic>> getSyncStatistics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      
      if (authToken == null) {
        throw Exception('Authentication required');
      }
      
      final response = await http
          .get(
            Uri.parse('$baseUrl/statistics'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          )
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch sync statistics');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<bool> startSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      
      if (authToken == null) {
        throw Exception('Authentication required');
      }
      
      final response = await http
          .post(
            Uri.parse('$baseUrl/start'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
          )
          .timeout(const Duration(minutes: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> saveLocalSyncStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt('total_records', stats['totalRecords'] ?? 0);
    await prefs.setInt('synced_records', stats['syncedRecords'] ?? 0);
    await prefs.setInt('pending_records', stats['pendingRecords'] ?? 0);
    await prefs.setString('last_sync_time', stats['lastSyncTime'] ?? 'Never');
    await prefs.setDouble('sync_progress', stats['syncProgress'] ?? 0.0);
  }
}