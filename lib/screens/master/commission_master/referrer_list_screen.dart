// // ignore_for_file: avoid_print, deprecated_member_use, depend_on_referenced_packages

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:nanohospic/database/database_provider.dart';
// import 'package:nanohospic/database/entity/referrer_entity.dart';

// class ReferrerListScreen extends StatefulWidget {
//   const ReferrerListScreen({super.key});

//   @override
//   State<ReferrerListScreen> createState() => _ReferrerListScreenState();
// }

// class _ReferrerListScreenState extends State<ReferrerListScreen> {
//   List<ReferrerEntity> _referrers = [];
//   List<ReferrerEntity> _filteredReferrers = [];
//   bool _isLoading = false;
//   bool _isSyncing = false;
//   String? _error;
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   Timer? _syncTimer;
//   int _totalRecords = 0;
//   int _syncedRecords = 0;
//   int _pendingRecords = 0;
  
//   final Color _primaryColor = Color(0xff016B61);
//   final Color _backgroundColor = Colors.grey.shade50;
//   final Color _cardColor = Colors.white;

//   @override
//   void initState() {
//     super.initState();
//     _initializeScreen();
//     _searchController.addListener(() {
//       _filterReferrers(_searchController.text);
//     });

//     _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
//       _syncDataSilently();
//     });
//   }

//   Future<void> _initializeScreen() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });
      
//       await DatabaseProvider.ensureReferrerTableExists();
//       await _loadReferrers();
//       await _loadSyncStats();
      
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error initializing: $e');
//       setState(() {
//         _error = 'Failed to initialize: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadReferrers() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       final repository = await DatabaseProvider.referrerRepository;
//       final referrers = await repository.getAllReferrers();
      
//       setState(() {
//         _referrers = referrers;
//         _filteredReferrers = List.from(_referrers);
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading referrers: $e');
//       setState(() {
//         _error = 'Failed to load referrers: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadSyncStats() async {
//     try {
//       final repository = await DatabaseProvider.referrerRepository;
//       _totalRecords = await repository.getTotalCount();
//       _syncedRecords = await repository.getSyncedCount();
//       _pendingRecords = await repository.getPendingCount();
//       setState(() {});
//     } catch (e) {
//       print('Error loading sync stats: $e');
//     }
//   }

//   Future<void> _syncFromServer() async {
//     if (_isSyncing) return;
//     setState(() {
//       _isSyncing = true;
//     });
//     try {
//       // Add your server sync logic here
//       await _loadReferrers();
//       await _loadSyncStats();
//       await _syncPendingChanges();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('Sync completed successfully'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Sync failed: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Sync failed: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSyncing = false;
//         });
//       }
//     }
//   }

//   Future<void> _syncPendingChanges() async {
//     try {
//       final repository = await DatabaseProvider.referrerRepository;
//       final pendingReferrers = await repository.getPendingSync();

//       for (final referrer in pendingReferrers) {
//         if (referrer.isDeleted == 1) {
//           if (referrer.serverId != null) {
//             await repository.deleteFromServer(referrer.serverId!);
//             await repository.markAsSynced(referrer.id!);
//           } else {
//             await repository.markAsSynced(referrer.id!);
//           }
//         } else if (referrer.serverId == null) {
//           final serverId = await repository.addToServer(referrer);
//           if (serverId != null) {
//             await repository.updateServerId(referrer.id!, serverId);
//             await repository.markAsSynced(referrer.id!);
//           }
//         } else {
//           final success = await repository.updateOnServer(referrer);
//           if (success) {
//             await repository.markAsSynced(referrer.id!);
//           }
//         }
//       }

//       await _loadSyncStats();
//     } catch (e) {
//       print('Pending sync failed: $e');
//     }
//   }

//   Future<void> _syncDataSilently() async {
//     try {
//       await _syncPendingChanges();
//     } catch (e) {
//       print('Silent sync failed: $e');
//     }
//   }

//   void _filterReferrers(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredReferrers = List.from(_referrers);
//       } else {
//         _filteredReferrers = _referrers
//             .where(
//               (referrer) =>
//                   referrer.name.toLowerCase().contains(query.toLowerCase()) ||
//                   referrer.contactNo.toLowerCase().contains(query.toLowerCase()) ||
//                   referrer.specialization.toLowerCase().contains(query.toLowerCase()) ||
//                   referrer.registrationNo.toLowerCase().contains(query.toLowerCase()),
//             )
//             .toList();
//       }
//     });
//   }

//   Future<bool> _deleteReferrer(int referrerId) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final repository = await DatabaseProvider.referrerRepository;
//       await repository.softDeleteReferrer(referrerId, 'user');
//       await _loadReferrers();
//       await _loadSyncStats();

//       await _syncPendingChanges();

//       return true;
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to delete referrer: $e';
//       });
//       return false;
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showDeleteConfirmationDialog(ReferrerEntity referrer) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           backgroundColor: Colors.white,
//           child: Container(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.red.shade50,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.delete_forever,
//                     color: Colors.red,
//                     size: 32,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Delete Referrer?',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Are you sure you want to delete "${referrer.name}"?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.of(context).pop(false),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.grey,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           side: BorderSide(color: Colors.grey.shade300),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text('Cancel'),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           Navigator.of(context).pop(true);
//                           final success = await _deleteReferrer(
//                             referrer.id!,
//                           );

//                           if (success && context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.check,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       'Referrer "${referrer.name}" deleted',
//                                     ),
//                                   ],
//                                 ),
//                                 backgroundColor: Colors.green,
//                                 behavior: SnackBarBehavior.floating,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.delete, size: 20),
//                             SizedBox(width: 8),
//                             Text('Delete'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showReferrerDetails(ReferrerEntity referrer) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.8,
//         minChildSize: 0.6,
//         maxChildSize: 0.95,
//         expand: false,
//         builder: (context, scrollController) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 topRight: Radius.circular(24),
//               ),
//             ),
//             child: SingleChildScrollView(
//               controller: scrollController,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         margin: EdgeInsets.symmetric(vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Center(
//                       child: Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               _primaryColor,
//                               _primaryColor.withOpacity(0.8),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: _primaryColor.withOpacity(0.3),
//                               blurRadius: 10,
//                               offset: Offset(2, 2),
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Iconsax.profile_circle,
//                             color: Colors.white,
//                             size: 36,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Center(
//                       child: Text(
//                         referrer.name,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: _primaryColor,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Center(
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: referrer.tagStatus == 'Tagged' 
//                               ? Colors.green.withOpacity(0.1)
//                               : Colors.orange.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: referrer.tagStatus == 'Tagged' 
//                                 ? Colors.green 
//                                 : Colors.orange,
//                           ),
//                         ),
//                         child: Text(
//                           referrer.tagStatus,
//                           style: TextStyle(
//                             color: referrer.tagStatus == 'Tagged' 
//                                 ? Colors.green 
//                                 : Colors.orange,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 24),
                    
//                     // Personal Information Card
//                     _buildDetailCard(
//                       icon: Iconsax.profile_circle,
//                       title: 'Personal Information',
//                       items: [
//                         _buildDetailItem('Name', referrer.name),
//                         _buildDetailItem('Date of Birth', referrer.dob),
//                         _buildDetailItem('Marriage Anniversary', referrer.marriageAnniversary),
//                         _buildDetailItem('Contact No', referrer.contactNo),
//                         _buildDetailItem('Email', referrer.email),
//                         _buildDetailItem('Degree', referrer.degree),
//                         _buildDetailItem('Specialization', referrer.specialization),
//                         _buildDetailItem('Registration No', referrer.registrationNo),
//                       ],
//                     ),
                    
//                     SizedBox(height: 16),
                    
//                     // Professional Information Card
//                     _buildDetailCard(
//                       icon: Iconsax.briefcase,
//                       title: 'Professional Information',
//                       items: [
//                         _buildDetailItem('Work Station', referrer.workStation),
//                         _buildDetailItem('Hospital Name', referrer.hospitalName),
//                         _buildDetailItem('Hospital Address', referrer.hospitalAddress),
//                         _buildDetailItem('Hospital Phone', referrer.hospitalPhone),
//                         _buildDetailItem('Clinic Address', referrer.clinicAddress),
//                         _buildDetailItem('Clinic Phone', referrer.clinicPhone),
//                       ],
//                     ),
                    
//                     SizedBox(height: 16),
                    
//                     // Additional Information Card
//                     _buildDetailCard(
//                       icon: Iconsax.info_circle,
//                       title: 'Additional Information',
//                       items: [
//                         _buildDetailItem('Tag Status', referrer.tagStatus),
//                         _buildDetailItem('Center', referrer.centerName),
//                         _buildDetailItem('Remarks', referrer.remarks),
//                       ],
//                     ),
                    
//                     SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ReferrerEntryScreen(
//                                     referrer: referrer,
//                                     onSaved: _loadReferrers,
//                                   ),
//                                 ),
//                               );
//                             },
//                             icon: Icon(Iconsax.edit, size: 20),
//                             label: Text('Edit'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               _showDeleteConfirmationDialog(referrer);
//                             },
//                             icon: Icon(Iconsax.trash, size: 20),
//                             label: Text('Delete'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailCard({
//     required IconData icon,
//     required String title,
//     required List<Widget> items,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: _primaryColor, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: _primaryColor,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           ...items,
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 160,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade700,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value.isNotEmpty ? value : 'Not specified',
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.grey.shade800,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _syncTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 15.h,
//               floating: false,
//               pinned: true,
//               backgroundColor: _primaryColor,
//               foregroundColor: Colors.white,
//               elevation: 6,
//               shadowColor: _primaryColor.withOpacity(0.4),
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.pin,
//                 background: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         _primaryColor,
//                         _primaryColor,
//                         _primaryColor.withOpacity(0.4),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       left: 20,
//                       right: 20,
//                       top: 70,
//                       bottom: 20,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           'Referrers',
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 4,
//                                 offset: Offset(1, 1),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Manage all medical referrers',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               title: _isSearching
//                   ? TextField(
//                       controller: _searchController,
//                       autofocus: true,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: 'Search referrers...',
//                         hintStyle: TextStyle(
//                           color: Colors.white.withOpacity(0.7),
//                         ),
//                         border: InputBorder.none,
//                         suffixIcon: IconButton(
//                           icon: Icon(Icons.clear, size: 20),
//                           onPressed: () {
//                             setState(() {
//                               _isSearching = false;
//                               _searchController.clear();
//                               _filterReferrers('');
//                             });
//                           },
//                         ),
//                       ),
//                     )
//                   : null,
//               actions: [
//                 if (!_isSearching)
//                   IconButton(
//                     icon: Icon(Iconsax.search_normal, size: 22),
//                     onPressed: () {
//                       setState(() {
//                         _isSearching = true;
//                       });
//                     },
//                   ),
//                 IconButton(
//                   icon: Icon(
//                     Iconsax.refresh,
//                     color: Colors.white,
//                     size: 22,
//                   ),
//                   onPressed: _loadReferrers,
//                   tooltip: 'Refresh',
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Iconsax.cloud,
//                     color: _isSyncing ? Colors.amber : Colors.white,
//                     size: 22,
//                   ),
//                   onPressed: _isSyncing ? null : _syncFromServer,
//                   tooltip: 'Sync',
//                 ),
//                 if (_isLoading)
//                   Padding(
//                     padding: EdgeInsets.only(right: 16),
//                     child: Center(
//                       child: SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ];
//         },
//         body: _buildBody(),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ReferrerEntryScreen(
//                 onSaved: _loadReferrers,
//               ),
//             ),
//           );
          
//           if (result == true) {
//             await _loadReferrers();
//           }
//         },
//         icon: Icon(Iconsax.add, size: 24),
//         label: Text('Add Referrer'),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 6,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ).animate()
//         .scale(duration: 600.ms, curve: Curves.elasticOut)
//         .then(delay: 200.ms)
//         .shake(hz: 3, curve: Curves.easeInOut),
//     );
//   }

//   Widget _buildBody() {
//     final displayReferrers = _isSearching
//         ? _filteredReferrers
//         : _referrers;

//     if (_isLoading && _referrers.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: _primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Loading referrers...',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ).animate(onPlay: (controller) => controller.repeat())
//              .shimmer(delay: 1000.ms, duration: 1500.ms),
//           ],
//         ),
//       );
//     }

//     if (_error != null) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Iconsax.close_circle,
//                   size: 50,
//                   color: Colors.red.shade400,
//                 ),
//               ).animate().shake(duration: 600.ms, hz: 4),
//               SizedBox(height: 24),
//               Text(
//                 'Oops! Something went wrong',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey.shade800,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Container(
//                 padding: EdgeInsets.all(16),
//                 margin: EdgeInsets.symmetric(horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   _error!,
//                   style: TextStyle(color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _initializeScreen,
//                 icon: Icon(Iconsax.refresh, size: 20),
//                 label: Text('Try Again'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _primaryColor,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_referrers.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       _primaryColor.withOpacity(0.1),
//                       _primaryColor.withOpacity(0.2)
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Iconsax.profile_circle,
//                   size: 60,
//                   color: _primaryColor,
//                 ),
//               ).animate(onPlay: (controller) => controller.repeat())
//                .scale(delay: 1000.ms, duration: 2000.ms)
//                .then(),
//               SizedBox(height: 24),
//               Text(
//                 'No Referrers Found',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey.shade800,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Container(
//                 padding: EdgeInsets.all(16),
//                 margin: EdgeInsets.symmetric(horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Text(
//                   'Get started by adding your first medical referrer to the system',
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ReferrerEntryScreen(
//                         onSaved: _loadReferrers,
//                       ),
//                     ),
//                   );
                  
//                   if (result == true) {
//                     await _loadReferrers();
//                   }
//                 },
//                 icon: Icon(Iconsax.add, size: 20),
//                 label: Text('Add First Referrer'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _primaryColor,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_isSearching &&
//         _filteredReferrers.isEmpty &&
//         _searchController.text.isNotEmpty) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Iconsax.search_normal,
//                   size: 50,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//               SizedBox(height: 24),
//               Text(
//                 'No Results Found',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey.shade800,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Text(
//                 'No referrers found for "${_searchController.text}"',
//                 style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _isSearching = false;
//                     _searchController.clear();
//                   });
//                 },
//                 child: Text('Clear Search'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _primaryColor,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _loadReferrers,
//       backgroundColor: Colors.white,
//       color: _primaryColor,
//       displacement: 40,
//       edgeOffset: 20,
//       strokeWidth: 2.5,
//       child: ListView.builder(
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
//         itemCount: displayReferrers.length,
//         itemBuilder: (context, index) {
//           final referrer = displayReferrers[index];
//           return _buildReferrerItem(referrer, index);
//         },
//       ),
//     );
//   }

//   Widget _buildReferrerItem(ReferrerEntity referrer, int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       child: Material(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(16),
//         elevation: 1,
//         shadowColor: Colors.blue.withOpacity(0.1),
//         child: InkWell(
//           onTap: () => _showReferrerDetails(referrer),
//           onLongPress: () {
//             _showDeleteConfirmationDialog(referrer);
//           },
//           borderRadius: BorderRadius.circular(16),
//           splashColor: _primaryColor.withOpacity(0.1),
//           highlightColor: _primaryColor.withOpacity(0.05),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         _getColorFromIndex(index),
//                         _getColorFromIndex(index).withOpacity(0.8),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: _getColorFromIndex(index).withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Iconsax.profile_circle,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               referrer.name,
//                               style: TextStyle(
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey.shade800,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: referrer.tagStatus == 'Tagged'
//                                   ? Colors.green.withOpacity(0.1)
//                                   : Colors.orange.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: referrer.tagStatus == 'Tagged'
//                                     ? Colors.green
//                                     : Colors.orange,
//                               ),
//                             ),
//                             child: Text(
//                               referrer.tagStatus,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: referrer.tagStatus == 'Tagged'
//                                     ? Colors.green
//                                     : Colors.orange,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(
//                             Iconsax.medal,
//                             size: 14,
//                             color: Colors.grey.shade500,
//                           ),
//                           SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               referrer.specialization.isNotEmpty 
//                                   ? referrer.specialization 
//                                   : 'Not specified',
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Colors.grey.shade600,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(
//                             Iconsax.call,
//                             size: 14,
//                             color: Colors.grey.shade500,
//                           ),
//                           SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               referrer.contactNo,
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Colors.grey.shade600,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(
//                             Iconsax.briefcase,
//                             size: 14,
//                             color: Colors.grey.shade500,
//                           ),
//                           SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               referrer.workStation.isNotEmpty 
//                                   ? referrer.workStation 
//                                   : 'Not specified',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey.shade600,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (referrer.centerName.isNotEmpty) ...[
//                         SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(
//                               Iconsax.location,
//                               size: 12,
//                               color: Colors.grey.shade500,
//                             ),
//                             SizedBox(width: 6),
//                             Text(
//                               'Center: ${referrer.centerName}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                       if (referrer.createdAt != null) ...[
//                         SizedBox(height: 6),
//                         Row(
//                           children: [
//                             Icon(
//                               Iconsax.calendar,
//                               size: 12,
//                               color: Colors.grey.shade500,
//                             ),
//                             SizedBox(width: 6),
//                             Text(
//                               'Created: ${_formatDate(referrer.createdAt!)}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Iconsax.more,
//                       size: 20,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   onPressed: () => _showReferrerDetails(referrer),
//                   tooltip: 'View Details',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ).animate()
//         .fadeIn(delay: (index * 100).ms)
//         .slideX(begin: 0.5, curve: Curves.easeOutQuart)
//         .scale(curve: Curves.easeOutBack),
//     );
//   }

//   Color _getColorFromIndex(int index) {
//     final colors = [
//       Colors.blue.shade600,
//       Colors.green.shade600,
//       Colors.orange.shade600,
//       Colors.purple.shade600,
//       Colors.red.shade600,
//       Colors.teal.shade600,
//       Colors.pink.shade600,
//       Colors.indigo.shade600,
//       Colors.cyan.shade600,
//       Colors.deepOrange.shade600,
//     ];
//     return colors[index % colors.length];
//   }

//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       final now = DateTime.now();
//       final difference = now.difference(date);
//       if (difference.inDays == 0) {
//         return 'Today';
//       } else if (difference.inDays == 1) {
//         return 'Yesterday';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays} days ago';
//       } else {
//         return '${date.day}/${date.month}/${date.year}';
//       }
//     } catch (e) {
//       return dateString;
//     }
//   }
// }


// class ReferrerEntryScreen extends StatefulWidget {
//   final ReferrerEntity? referrer;
//   final Function()? onSaved;

//   const ReferrerEntryScreen({
//     Key? key,
//     this.referrer,
//     this.onSaved,
//   }) : super(key: key);

//   @override
//   _ReferrerEntryScreenState createState() => _ReferrerEntryScreenState();
// }

// class _ReferrerEntryScreenState extends State<ReferrerEntryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _isEditing = false;

//   // Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _marriageAnniversaryController = TextEditingController();
//   final TextEditingController _workStationController = TextEditingController();
//   final TextEditingController _clinicAddressController = TextEditingController();
//   final TextEditingController _clinicPhoneController = TextEditingController();
//   final TextEditingController _hospitalNameController = TextEditingController();
//   final TextEditingController _hospitalAddressController = TextEditingController();
//   final TextEditingController _hospitalPhoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _contactNoController = TextEditingController();
//   final TextEditingController _specializationController = TextEditingController();
//   final TextEditingController _remarksController = TextEditingController();
//   final TextEditingController _registrationNoController = TextEditingController();
//   final TextEditingController _degreeController = TextEditingController();
//   final TextEditingController _tagStatusController = TextEditingController();
//   final TextEditingController _centerController = TextEditingController();

//   // Dropdown options
//   List<String> specializationOptions = [
//     'Cardiology',
//     'Dermatology',
//     'Endocrinology',
//     'Gastroenterology',
//     'Neurology',
//     'Oncology',
//     'Orthopedics',
//     'Pediatrics',
//     'Psychiatry',
//     'Radiology',
//     'Surgery',
//     'Urology',
//     'General Medicine'
//   ];

//   List<String> degreeOptions = [
//     'MBBS',
//     'MD',
//     'MS',
//     'DM',
//     'MCh',
//     'DNB',
//     'BDS',
//     'MDS',
//     'BAMS',
//     'BHMS',
//     'BUMS',
//     'BPT',
//     'B.Pharm',
//     'M.Pharm'
//   ];

//   List<String> tagStatusOptions = ['Tagged', 'Untagged'];
  
//   List<String> centerOptions = [
//     'Main Center',
//     'Branch 1',
//     'Branch 2',
//     'Branch 3',
//     'Satellite Center'
//   ];

//   DateTime? _selectedDob;
//   DateTime? _selectedMarriageAnniversary;

//   final Color _primaryColor = Color(0xff016B61);

//   @override
//   void initState() {
//     super.initState();
//     _isEditing = widget.referrer != null;
    
//     if (_isEditing) {
//       _populateForm();
//     }
//   }

//   void _populateForm() {
//     final referrer = widget.referrer!;
//     _nameController.text = referrer.name;
//     _dobController.text = referrer.dob;
//     _marriageAnniversaryController.text = referrer.marriageAnniversary;
//     _workStationController.text = referrer.workStation;
//     _clinicAddressController.text = referrer.clinicAddress;
//     _clinicPhoneController.text = referrer.clinicPhone;
//     _hospitalNameController.text = referrer.hospitalName;
//     _hospitalAddressController.text = referrer.hospitalAddress;
//     _hospitalPhoneController.text = referrer.hospitalPhone;
//     _emailController.text = referrer.email;
//     _contactNoController.text = referrer.contactNo;
//     _specializationController.text = referrer.specialization;
//     _remarksController.text = referrer.remarks;
//     _registrationNoController.text = referrer.registrationNo;
//     _degreeController.text = referrer.degree;
//     _tagStatusController.text = referrer.tagStatus;
//     _centerController.text = referrer.centerName;
//   }

//   Future<void> _saveReferrer() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       final repository = await DatabaseProvider.referrerRepository;
//       final referrer = ReferrerEntity(
//         id: widget.referrer?.id,
//         serverId: widget.referrer?.serverId,
//         name: _nameController.text.trim(),
//         dob: _dobController.text.trim(),
//         marriageAnniversary: _marriageAnniversaryController.text.trim(),
//         workStation: _workStationController.text.trim(),
//         clinicAddress: _clinicAddressController.text.trim(),
//         clinicPhone: _clinicPhoneController.text.trim(),
//         hospitalName: _hospitalNameController.text.trim(),
//         hospitalAddress: _hospitalAddressController.text.trim(),
//         hospitalPhone: _hospitalPhoneController.text.trim(),
//         email: _emailController.text.trim(),
//         contactNo: _contactNoController.text.trim(),
//         specialization: _specializationController.text.trim(),
//         remarks: _remarksController.text.trim(),
//         registrationNo: _registrationNoController.text.trim(),
//         degree: _degreeController.text.trim(),
//         tagStatus: _tagStatusController.text.trim(),
//         centerId: 1, // You can get this from center dropdown
//         centerName: _centerController.text.trim(),
//         createdAt: widget.referrer?.createdAt ?? DateTime.now().toIso8601String(),
//         createdBy: widget.referrer?.createdBy ?? 'User',
//         lastModified: DateTime.now().toIso8601String(),
//         lastModifiedBy: 'User',
//       );

//       if (_isEditing) {
//         await repository.updateReferrer(referrer);
//         if (widget.onSaved != null) widget.onSaved!();
//         Navigator.pop(context, true);
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('${referrer.name} updated successfully'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       } else {
//         await repository.insertReferrer(referrer);
//         if (widget.onSaved != null) widget.onSaved!();
//         Navigator.pop(context, true);
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('${referrer.name} added successfully'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error saving referrer: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.error, color: Colors.white, size: 20),
//               SizedBox(width: 8),
//               Text('Failed to save: $e'),
//             ],
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context, bool isDob) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: _primaryColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
    
//     if (picked != null) {
//       final dateString = '${picked.day}/${picked.month}/${picked.year}';
//       setState(() {
//         if (isDob) {
//           _selectedDob = picked;
//           _dobController.text = dateString;
//         } else {
//           _selectedMarriageAnniversary = picked;
//           _marriageAnniversaryController.text = dateString;
//         }
//       });
//     }
//   }

//   Widget _buildTextFormField({
//     required String label,
//     required TextEditingController controller,
//     required String? Function(String?)? validator,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     bool isRequired = true,
//     IconData? icon,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: '$label${isRequired ? ' *' : ''}',
//           labelStyle: TextStyle(
//             color: _primaryColor,
//             fontWeight: FontWeight.w500,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: _primaryColor, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey.shade50,
//           hintText: 'Enter $label',
//           hintStyle: TextStyle(color: Colors.grey.shade500),
//           prefixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
//           suffixIcon: onTap != null
//               ? IconButton(
//                   icon: Icon(Iconsax.calendar, color: _primaryColor, size: 20),
//                   onPressed: onTap,
//                 )
//               : null,
//         ),
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         validator: validator,
//         readOnly: readOnly,
//         onTap: onTap,
//         style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
//       ),
//     );
//   }

//   Widget _buildDropdownFormField({
//     required String label,
//     required TextEditingController controller,
//     required List<String> options,
//     required String? Function(String?)? validator,
//     bool isRequired = true,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: DropdownButtonFormField<String>(
//         value: controller.text.isNotEmpty ? controller.text : null,
//         decoration: InputDecoration(
//           labelText: '$label${isRequired ? ' *' : ''}',
//           labelStyle: TextStyle(
//             color: _primaryColor,
//             fontWeight: FontWeight.w500,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: _primaryColor, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.grey.shade50,
//           prefixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
//         ),
//         items: options.map((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value,
//               style: TextStyle(color: Colors.grey.shade800)),
//           );
//         }).toList(),
//         onChanged: (String? newValue) {
//           setState(() {
//             controller.text = newValue ?? '';
//           });
//         },
//         validator: validator,
//         dropdownColor: Colors.white,
//         style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
//         icon: Icon(Iconsax.arrow_down_1, color: _primaryColor),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: Text(
//           _isEditing ? 'Edit Referrer' : 'Add New Referrer',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Iconsax.save_2),
//             onPressed: _saveReferrer,
//             tooltip: 'Save',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: _primaryColor.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3,
//                         valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Saving referrer...',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Personal Information Card
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Iconsax.profile_circle, color: _primaryColor),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Personal Information',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: _primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                             _buildTextFormField(
//                               label: 'Name',
//                               controller: _nameController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter name';
//                                 }
//                                 return null;
//                               },
//                               icon: Iconsax.user,
//                             ),
//                             _buildTextFormField(
//                               label: 'Date of Birth',
//                               controller: _dobController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select date of birth';
//                                 }
//                                 return null;
//                               },
//                               readOnly: true,
//                               onTap: () => _selectDate(context, true),
//                               icon: Iconsax.calendar,
//                             ),
//                             _buildTextFormField(
//                               label: 'Marriage Anniversary',
//                               controller: _marriageAnniversaryController,
//                               validator: null,
//                               isRequired: false,
//                               readOnly: true,
//                               onTap: () => _selectDate(context, false),
//                               icon: Iconsax.calendar_1,
//                             ),
//                             _buildTextFormField(
//                               label: 'Contact No',
//                               controller: _contactNoController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter contact number';
//                                 }
//                                 if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value)) {
//                                   return 'Please enter a valid contact number';
//                                 }
//                                 return null;
//                               },
//                               keyboardType: TextInputType.phone,
//                               icon: Iconsax.call,
//                             ),
//                             _buildTextFormField(
//                               label: 'Email',
//                               controller: _emailController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter email';
//                                 }
//                                 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                                   return 'Please enter a valid email';
//                                 }
//                                 return null;
//                               },
//                               keyboardType: TextInputType.emailAddress,
//                               icon: Iconsax.sms,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 16),
                    
//                     // Professional Information Card
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Iconsax.briefcase, color: _primaryColor),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Professional Information',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: _primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                             _buildDropdownFormField(
//                               label: 'Degree',
//                               controller: _degreeController,
//                               options: degreeOptions,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select degree';
//                                 }
//                                 return null;
//                               },
//                               icon: Iconsax.activity,
//                             ),
//                             _buildDropdownFormField(
//                               label: 'Specialization',
//                               controller: _specializationController,
//                               options: specializationOptions,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select specialization';
//                                 }
//                                 return null;
//                               },
//                               icon: Iconsax.medal,
//                             ),
//                             _buildTextFormField(
//                               label: 'Registration No',
//                               controller: _registrationNoController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter registration number';
//                                 }
//                                 return null;
//                               },
//                               icon: Iconsax.note_text,
//                             ),
//                             _buildTextFormField(
//                               label: 'Work Station',
//                               controller: _workStationController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter work station';
//                                 }
//                                 return null;
//                               },
//                               icon: Iconsax.building_4,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 16),
                    
//                     // Clinic Information Card
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Iconsax.hospital, color: _primaryColor),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Clinic Information',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: _primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                             _buildTextFormField(
//                               label: 'Clinic Address',
//                               controller: _clinicAddressController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter clinic address';
//                                 }
//                                 return null;
//                               },
//                               maxLines: 2,
//                               icon: Iconsax.location,
//                             ),
//                             _buildTextFormField(
//                               label: 'Clinic Phone',
//                               controller: _clinicPhoneController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter clinic phone';
//                                 }
//                                 return null;
//                               },
//                               keyboardType: TextInputType.phone,
//                               icon: Iconsax.call_calling,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 16),
                    
//                     // Hospital Information Card
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Iconsax.hospital, color: _primaryColor),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Hospital Information',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: _primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                             _buildTextFormField(
//                               label: 'Hospital Name',
//                               controller: _hospitalNameController,
//                               validator: null,
//                               isRequired: false,
//                               icon: Iconsax.building,
//                             ),
//                             _buildTextFormField(
//                               label: 'Hospital Address',
//                               controller: _hospitalAddressController,
//                               validator: null,
//                               isRequired: false,
//                               maxLines: 2,
//                               icon: Iconsax.location,
//                             ),
//                             _buildTextFormField(
//                               label: 'Hospital Phone',
//                               controller: _hospitalPhoneController,
//                               validator: null,
//                               isRequired: false,
//                               keyboardType: TextInputType.phone,
//                               icon: Iconsax.call_calling,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 16),
                    
//                     // Additional Information Card
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Iconsax.info_circle, color: _primaryColor),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Additional Information',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: _primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                             _buildDropdownFormField(
//                               label: 'Tag Status',
//                               controller: _tagStatusController,
//                               options: tagStatusOptions,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select tag status';
//                                 }
//                                 return null;
//                               },
//                               icon: Iconsax.tag,
//                             ),
//                             _buildDropdownFormField(
//                               label: 'Center',
//                               controller: _centerController,
//                               options: centerOptions,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select center';
//                                 }
//                                 return null;
//                               },
//                               icon: Iconsax.location,
//                             ),
//                             _buildTextFormField(
//                               label: 'Remarks',
//                               controller: _remarksController,
//                               validator: null,
//                               isRequired: false,
//                               maxLines: 3,
//                               icon: Iconsax.note,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 24),
//                     ElevatedButton.icon(
//                       onPressed: _saveReferrer,
//                       icon: _isLoading
//                           ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Icon(Iconsax.save_2, size: 20),
//                       label: Text(_isEditing ? 'Update Referrer' : 'Save Referrer'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         backgroundColor: _primaryColor,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     OutlinedButton.icon(
//                       onPressed: () => Navigator.pop(context),
//                       icon: Icon(Iconsax.close_circle, size: 20),
//                       label: Text('Cancel'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.grey,
//                         padding: EdgeInsets.symmetric(vertical: 18),
//                         side: BorderSide(color: Colors.grey.shade300),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _dobController.dispose();
//     _marriageAnniversaryController.dispose();
//     _workStationController.dispose();
//     _clinicAddressController.dispose();
//     _clinicPhoneController.dispose();
//     _hospitalNameController.dispose();
//     _hospitalAddressController.dispose();
//     _hospitalPhoneController.dispose();
//     _emailController.dispose();
//     _contactNoController.dispose();
//     _specializationController.dispose();
//     _remarksController.dispose();
//     _registrationNoController.dispose();
//     _degreeController.dispose();
//     _tagStatusController.dispose();
//     _centerController.dispose();
//     super.dispose();
//   }
// }