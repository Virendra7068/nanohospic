// // ignore_for_file: avoid_print, deprecated_member_use, depend_on_referenced_packages

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:iconsax/iconsax.dart';
// import 'package:nanohospic/database/entity/group_entity.dart';
// import 'package:nanohospic/database/repository/group_repo.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:nanohospic/database/database_provider.dart';

// class GroupListScreen extends StatefulWidget {
//   const GroupListScreen({super.key});

//   @override
//   State<GroupListScreen> createState() => _GroupListScreenState();
// }

// class _GroupListScreenState extends State<GroupListScreen> {
//   List<GroupEntity> _paymentModes = [];
//   List<GroupEntity> _filteredPaymentModes = [];
//   bool _isLoading = false;
//   bool _isSyncing = false;
//   String? _error;
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   late GroupRepo _groupRepository;
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
//     _initializeDatabase();
//     _searchController.addListener(() {
//       _filterPaymentModes(_searchController.text);
//     });

//     _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
//       _syncDataSilently();
//     });
//   }

//   Future<void> _initializeDatabase() async {
//     try {
//       await DatabaseProvider.ensurePaymentModeTableExists();
//       final db = await DatabaseProvider.database;
//       _groupRepository = GroupRepo(db.groupDao);
//       await _loadLocalPaymentModes();
//       await _loadSyncStats();
//       _syncFromServer();
//     } catch (e) {
//       print('Error initializing database: $e');
//       setState(() {
//         _error = 'Failed to initialize database: $e';
//       });
//     }
//   }

//   Future<void> _loadLocalPaymentModes() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final paymentModes = await _groupRepository.getAllGroups();
//       print('Loaded ${paymentModes.length} payment modes from database');
//       setState(() {
//         _paymentModes = paymentModes;
//         _filteredPaymentModes = List.from(_paymentModes);
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load local data: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadSyncStats() async {
//     _totalRecords = await _groupRepository.getTotalCount();
//     _syncedRecords = await _groupRepository.getSyncedCount();
//     _pendingRecords = await _groupRepository.getPendingCount();
//     setState(() {});
//   }

//   Future<void> _syncFromServer() async {
//     if (_isSyncing) return;
//     setState(() {
//       _isSyncing = true;
//     });
//     try {
//       // await _groupRepository.syncFromServer();
//       await _loadLocalPaymentModes();
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
//       final pendingPaymentModes = await _groupRepository.getPendingSync();

//       for (final paymentMode in pendingPaymentModes) {
//         if (paymentMode.isDeleted == 1) {
//           if (paymentMode.serverId != null) {
//             await _deleteFromServer(paymentMode.serverId!);
//             await _groupRepository.markAsSynced(paymentMode.id!);
//           } else {
//             await _groupRepository.markAsSynced(paymentMode.id!);
//           }
//         } else if (paymentMode.serverId == null) {
//           final serverId = await _addToServer(paymentMode);
//           if (serverId != null) {
//             await _groupRepository.updateServerId(paymentMode.id!, serverId);
//             await _groupRepository.markAsSynced(paymentMode.id!);
//           }
//         } else {
//           final success = await _updateOnServer(paymentMode);
//           if (success) {
//             await _groupRepository.markAsSynced(paymentMode.id!);
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

//   Future<int?> _addToServer(GroupEntity paymentMode) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse('http://202.140.138.215:85/api/PaymentModeApi/Create'),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode({
//               'id': 0,
//               'name': paymentMode.name,
//               'description': paymentMode.description ?? '',
//               'modeOfPayments': [
//                 {
//                   'id': 0,
//                   'name': paymentMode.name,
//                   'description': paymentMode.description ?? '',
//                   'tenantId': paymentMode.tenantId ?? 'default_tenant',
//                   'created': DateTime.now().toIso8601String(),
//                   'createdBy': paymentMode.createdBy ?? 'mobile_app',
//                   'lastModified': DateTime.now().toIso8601String(),
//                   'lastModifiedBy': paymentMode.createdBy ?? 'mobile_app',
//                   'deleted': null,
//                   'deletedBy': null,
//                 },
//               ],
//             }),
//           )
//           .timeout(Duration(seconds: 5));

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         return data['id'] as int?;
//       }
//     } catch (e) {
//       print('Add to server failed: $e');
//     }
//     return null;
//   }

//   Future<bool> _updateOnServer(GroupEntity paymentMode) async {
//     try {
//       final response = await http
//           .put(
//             Uri.parse(
//               'http://202.140.138.215:85/api/PaymentModeApi/${paymentMode.serverId}',
//             ),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode({
//               'id': paymentMode.serverId,
//               'name': paymentMode.name,
//               'description': paymentMode.description ?? '',
//               'modeOfPayments': [
//                 {
//                   'id': paymentMode.serverId,
//                   'name': paymentMode.name,
//                   'description': paymentMode.description ?? '',
//                   'tenantId': paymentMode.tenantId ?? 'default_tenant',
//                   'created':
//                       paymentMode.createdAt ?? DateTime.now().toIso8601String(),
//                   'createdBy': paymentMode.createdBy ?? 'mobile_app',
//                   'lastModified': DateTime.now().toIso8601String(),
//                   'lastModifiedBy': paymentMode.createdBy ?? 'mobile_app',
//                   'deleted': null,
//                   'deletedBy': null,
//                 },
//               ],
//             }),
//           )
//           .timeout(Duration(seconds: 5));

//       return response.statusCode == 200;
//     } catch (e) {
//       print('Update on server failed: $e');
//       return false;
//     }
//   }

//   Future<bool> _deleteFromServer(int serverId) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse(
//               'http://202.140.138.215:85/api/PaymentModeApi/Delete/$serverId',
//             ),
//             headers: {'Content-Type': 'application/json'},
//           )
//           .timeout(Duration(seconds: 5));

//       return response.statusCode == 200;
//     } catch (e) {
//       print('Delete from server failed: $e');
//       return false;
//     }
//   }

//   void _filterPaymentModes(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredPaymentModes = List.from(_paymentModes);
//       } else {
//         _filteredPaymentModes = _paymentModes
//             .where(
//               (paymentMode) =>
//                   paymentMode.name.toLowerCase().contains(query.toLowerCase()),
//             )
//             .toList();
//       }
//     });
//   }

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   Future<void> _addPaymentMode(String name, String description) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final paymentMode = GroupEntity(
//         name: name,
//         description: description.isNotEmpty ? description : null,
//         tenantId: 'default_tenant',
//         createdAt: DateTime.now().toIso8601String(),
//         createdBy: 'user',
//         isSynced: 0,
//       );

//       await _groupRepository.insertGroup(paymentMode);

//       await _loadLocalPaymentModes();
//       await _loadSyncStats();

//       await _syncPendingChanges();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.save, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('$name saved locally'),
//               ],
//             ),
//             backgroundColor: Colors.blue,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to add payment mode: $e';
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.error, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('Failed to save: ${e.toString()}'),
//               ],
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<bool> _deleteGroup(int paymentModeId) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _groupRepository.deleteGroup(paymentModeId);
//       await _loadLocalPaymentModes();
//       await _loadSyncStats();

//       await _syncPendingChanges();

//       return true;
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to delete payment mode: $e';
//       });
//       return false;
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showDeleteConfirmationDialog(GroupEntity paymentMode) {
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
//                   'Delete Payment Mode?',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Are you sure you want to delete "${paymentMode.name}"?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.of(context).pop(),
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
//                           Navigator.of(context).pop();
//                           final success = await _deleteGroup(paymentMode.id!);

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
//                                       'Payment mode "${paymentMode.name}" deleted',
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
//                           } else if (context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.error,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text('Failed to delete payment mode'),
//                                   ],
//                                 ),
//                                 backgroundColor: Colors.red,
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

//   void _showAddPaymentModeDialog() {
//     final nameController = TextEditingController();
//     final descriptionController = TextEditingController();
//     bool isSubmitting = false;

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
//                     gradient: LinearGradient(
//                       colors: [Colors.blue.shade400, Colors.blue.shade600],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.payment, color: Colors.white, size: 32),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Add New Payment Mode',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade800,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Payment Mode Name',
//                     labelStyle: TextStyle(
//                       color: Colors.blue.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.blue.shade300),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.blue, width: 2),
//                     ),
//                     filled: true,
//                     fillColor: Colors.blue.shade50,
//                     hintText: 'Enter payment mode name',
//                     hintStyle: TextStyle(color: Colors.grey.shade500),
//                     prefixIcon: Container(
//                       margin: EdgeInsets.only(right: 8, left: 12),
//                       child: Icon(Icons.label, color: Colors.blue.shade600),
//                     ),
//                     prefixIconConstraints: BoxConstraints(minWidth: 40),
//                   ),
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(
//                     labelText: 'Description (Optional)',
//                     labelStyle: TextStyle(
//                       color: Colors.blue.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.blue.shade300),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.blue, width: 2),
//                     ),
//                     filled: true,
//                     fillColor: Colors.blue.shade50,
//                     hintText: 'Enter description',
//                     hintStyle: TextStyle(color: Colors.grey.shade500),
//                     prefixIcon: Container(
//                       margin: EdgeInsets.only(right: 8, left: 12),
//                       child: Icon(
//                         Icons.description,
//                         color: Colors.blue.shade600,
//                       ),
//                     ),
//                     prefixIconConstraints: BoxConstraints(minWidth: 40),
//                   ),
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
//                   maxLines: 3,
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: isSubmitting
//                             ? null
//                             : () {
//                                 Navigator.pop(context);
//                               },
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.grey.shade700,
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
//                         onPressed: isSubmitting
//                             ? null
//                             : () async {
//                                 if (nameController.text.isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.warning,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                           SizedBox(width: 8),
//                                           Text(
//                                             'Please enter a payment mode name',
//                                           ),
//                                         ],
//                                       ),
//                                       backgroundColor: Colors.orange,
//                                       behavior: SnackBarBehavior.floating,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 setState(() {
//                                   isSubmitting = true;
//                                 });

//                                 await _addPaymentMode(
//                                   nameController.text,
//                                   descriptionController.text,
//                                 );

//                                 if (!context.mounted) return;

//                                 Navigator.pop(context);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           '${nameController.text} added successfully!',
//                                         ),
//                                       ],
//                                     ),
//                                     backgroundColor: Colors.green,
//                                     behavior: SnackBarBehavior.floating,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 );
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: isSubmitting
//                             ? SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 3,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               )
//                             : Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.add, size: 20),
//                                   SizedBox(width: 8),
//                                   Text('Add Payment Mode'),
//                                 ],
//                               ),
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

//   void _showSyncStatusDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
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
//                     gradient: LinearGradient(
//                       colors: [Colors.purple.shade400, Colors.purple.shade600],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.sync, color: Colors.white, size: 32),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Sync Status',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.purple.shade800,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildSyncStatItem(
//                         'Total Payment Modes',
//                         '$_totalRecords',
//                         Icons.payment,
//                         Colors.blue,
//                       ),
//                       SizedBox(height: 12),
//                       _buildSyncStatItem(
//                         'Synced',
//                         '$_syncedRecords',
//                         Icons.cloud_done,
//                         Colors.green,
//                       ),
//                       SizedBox(height: 12),
//                       _buildSyncStatItem(
//                         'Pending Sync',
//                         '$_pendingRecords',
//                         Icons.cloud_upload,
//                         Colors.orange,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 if (_isSyncing)
//                   Column(
//                     children: [
//                       CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.purple,
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         'Syncing...',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.grey.shade700,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           side: BorderSide(color: Colors.grey.shade300),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text('Close'),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _isSyncing ? null : _syncFromServer,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.purple,
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
//                             Icon(Icons.sync, size: 20),
//                             SizedBox(width: 8),
//                             Text('Sync Now'),
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

//   Widget _buildSyncStatItem(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, size: 20, color: color),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _nameController.dispose();
//     _descriptionController.dispose();
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
//               shadowColor: Colors.blue.withOpacity(0.4),
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
//                           'Group List',
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
//                           'Manage all payment methods in one place',
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
//                         hintText: 'Search payment mode...',
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
//                               _filteredPaymentModes = List.from(_paymentModes);
//                             });
//                           },
//                         ),
//                       ),
//                     )
//                   : null,
//               actions: [
//                 if (!_isSearching)
//                   IconButton(
//                     icon: Icon(Icons.search, size: 22),
//                     onPressed: () {
//                       setState(() {
//                         _isSearching = true;
//                       });
//                     },
//                   ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.sync,
//                     color: _isSyncing ? Colors.amber : Colors.white,
//                     size: 22,
//                   ),
//                   onPressed: _isSyncing ? null : _syncFromServer,
//                   tooltip: 'Sync',
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.info_outline, size: 22),
//                   onPressed: _showSyncStatusDialog,
//                   tooltip: 'Sync Status',
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
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//                 onPressed: _showAddPaymentModeDialog,
//                 backgroundColor: Colors.teal.shade700,
//                 foregroundColor: Colors.white,
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(Icons.add, size: 28),
//               )
//               .animate()
//               .scale(duration: 600.ms, curve: Curves.elasticOut)
//               .then(delay: 200.ms)
//               .shake(hz: 3, curve: Curves.easeInOut),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     final displayPaymentModes = _isSearching
//         ? _filteredPaymentModes
//         : _paymentModes;

//     if (_isLoading && _paymentModes.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//                   'Loading payment modes...',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//                 .animate(onPlay: (controller) => controller.repeat())
//                 .shimmer(delay: 1000.ms, duration: 1500.ms),
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
//                   Icons.error_outline,
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
//                 onPressed: _loadLocalPaymentModes,
//                 icon: Icon(Icons.refresh, size: 20),
//                 label: Text('Try Again'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
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

//     if (_paymentModes.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.blue.shade100, Colors.blue.shade200],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Iconsax.wallet_remove,
//                       size: 60,
//                       color: Colors.blue.shade600,
//                     ),
//                   )
//                   .animate(onPlay: (controller) => controller.repeat())
//                   .scale(delay: 1000.ms, duration: 2000.ms)
//                   .then(),
//               SizedBox(height: 24),
//               Text(
//                 'No Payment Modes Found',
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
//                   'Get started by adding your first payment method to the system',
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _showAddPaymentModeDialog,
//                 icon: Icon(Icons.add, size: 20),
//                 label: Text('Add Payment Method'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
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
//         _filteredPaymentModes.isEmpty &&
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
//                   Icons.search_off,
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
//                 'No payment modes found for "${_searchController.text}"',
//                 style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _syncFromServer,
//       backgroundColor: Colors.white,
//       color: Colors.blue,
//       displacement: 40,
//       edgeOffset: 20,
//       strokeWidth: 2.5,
//       child: ListView.builder(
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
//         itemCount: displayPaymentModes.length,
//         itemBuilder: (context, index) {
//           final paymentMode = displayPaymentModes[index];
//           return _buildPaymentModeItem(paymentMode, index);
//         },
//       ),
//     );
//   }

//   Widget _buildPaymentModeItem(GroupEntity paymentMode, int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       child:
//           Material(
//                 color: _cardColor,
//                 borderRadius: BorderRadius.circular(16),
//                 elevation: 1,
//                 shadowColor: Colors.blue.withOpacity(0.1),
//                 child: InkWell(
//                   onLongPress: () {
//                     _showDeleteConfirmationDialog(paymentMode);
//                   },
//                   borderRadius: BorderRadius.circular(16),
//                   splashColor: Colors.blue.withOpacity(0.1),
//                   highlightColor: Colors.blue.withOpacity(0.05),
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 _getColorFromIndex(index),
//                                 _getColorFromIndex(index).withOpacity(0.8),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: _getColorFromIndex(
//                                   index,
//                                 ).withOpacity(0.3),
//                                 blurRadius: 8,
//                                 offset: Offset(2, 2),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Icon(
//                               _getModeIcon(paymentMode.name),
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       paymentMode.name,
//                                       style: TextStyle(
//                                         fontSize: 17.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey.shade800,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   if (paymentMode.isSynced == 0)
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.amber.shade50,
//                                         borderRadius: BorderRadius.circular(20),
//                                         border: Border.all(
//                                           color: Colors.amber.shade200,
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             Icons.cloud_upload,
//                                             size: 12,
//                                             color: Colors.amber.shade700,
//                                           ),
//                                           SizedBox(width: 4),
//                                           Text(
//                                             'Pending',
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               color: Colors.amber.shade800,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               if (paymentMode.description != null &&
//                                   paymentMode.description!.isNotEmpty) ...[
//                                 SizedBox(height: 4),
//                                 Text(
//                                   paymentMode.description!,
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                               if (paymentMode.createdAt != null) ...[
//                                 SizedBox(height: 6),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.calendar_today,
//                                       size: 12,
//                                       color: Colors.grey.shade500,
//                                     ),
//                                     SizedBox(width: 6),
//                                     Text(
//                                       'Created: ${_formatDate(paymentMode.createdAt!)}',
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: Container(
//                             width: 36,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               color: Colors.red.shade50,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(
//                               Icons.delete_outline,
//                               size: 18,
//                               color: Colors.red.shade600,
//                             ),
//                           ),
//                           onPressed: () {
//                             _showDeleteConfirmationDialog(paymentMode);
//                           },
//                           tooltip: 'Delete Payment Mode',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//               .animate()
//               .fadeIn(delay: (index * 100).ms)
//               .slideX(begin: 0.5, curve: Curves.easeOutQuart)
//               .scale(curve: Curves.easeOutBack),
//     );
//   }

//   IconData _getModeIcon(String modeName) {
//     final name = modeName.toLowerCase();
//     if (name.contains('cash')) return Iconsax.money;
//     if (name.contains('card')) return Iconsax.card;
//     if (name.contains('upi')) return Iconsax.mobile;
//     if (name.contains('wallet')) return Iconsax.wallet;
//     if (name.contains('bank')) return Iconsax.bank;
//     if (name.contains('cheque')) return Iconsax.receipt_text;
//     if (name.contains('net')) return Iconsax.global;
//     return Iconsax.wallet;
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


// ignore_for_file: avoid_print, deprecated_member_use, depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:nanohospic/database/entity/group_entity.dart';
import 'package:nanohospic/database/repository/group_repo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:nanohospic/database/database_provider.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  List<GroupEntity> _groups = [];  // Changed from _paymentModes
  List<GroupEntity> _filteredGroups = [];  // Changed from _filteredPaymentModes
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late GroupRepo _groupRepository;
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
    _initializeDatabase();
    _searchController.addListener(() {
      _filterGroups(_searchController.text);  // Changed from _filterPaymentModes
    });

    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _syncDataSilently();
    });
  }

  Future<void> _initializeDatabase() async {
    try {
      // await DatabaseProvider.ensureGroupTableExists();  // Changed from ensurePaymentModeTableExists
      final db = await DatabaseProvider.database;
      _groupRepository = GroupRepo(db.groupDao);  // Changed dao reference
      await _loadLocalGroups();  // Changed from _loadLocalPaymentModes
      await _loadSyncStats();
      _syncFromServer();
    } catch (e) {
      print('Error initializing database: $e');
      setState(() {
        _error = 'Failed to initialize database: $e';
      });
    }
  }

  Future<void> _loadLocalGroups() async {  // Changed from _loadLocalPaymentModes
    setState(() {
      _isLoading = true;
    });
    try {
      final groups = await _groupRepository.getAllGroups();  // Changed method call
      print('Loaded ${groups.length} groups from database');
      setState(() {
        _groups = groups;
        _filteredGroups = List.from(_groups);
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
    _totalRecords = await _groupRepository.getTotalCount();
    _syncedRecords = await _groupRepository.getSyncedCount();
    _pendingRecords = await _groupRepository.getPendingCount();
    setState(() {});
  }

  Future<void> _syncFromServer() async {
    try {
      final response = await http
          .get(Uri.parse('http://202.140.138.215:85/api/GroupApi/GetAllGroups'))
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          await _groupRepository.syncFromServer(data.cast<Map<String, dynamic>>());
          await _loadLocalGroups();
          await _loadSyncStats();
          
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
    }
  }

  Future<void> _syncPendingChanges() async {
    try {
      final pendingGroups = await _groupRepository.getPendingSync();

      for (final group in pendingGroups) {
        if (group.isDeleted == 1) {
          if (group.serverId != null) {
            await _groupRepository.deleteFromServer(group.serverId!);
            await _groupRepository.markAsSynced(group.id!);
          } else {
            await _groupRepository.markAsSynced(group.id!);
          }
        } else if (group.serverId == null) {
          final serverId = await _groupRepository.addToServer(group);
          if (serverId != null) {
            await _groupRepository.updateServerId(group.id!, serverId);
            await _groupRepository.markAsSynced(group.id!);
          }
        } else {
          final success = await _groupRepository.updateOnServer(group);
          if (success) {
            await _groupRepository.markAsSynced(group.id!);
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

  void _filterGroups(String query) {  // Changed from _filterPaymentModes
    setState(() {
      if (query.isEmpty) {
        _filteredGroups = List.from(_groups);
      } else {
        _filteredGroups = _groups
            .where(
              (group) =>
                  group.name.toLowerCase().contains(query.toLowerCase()) ||
                  (group.code?.toLowerCase() ?? '').contains(query.toLowerCase()) ||
                  (group.type?.toLowerCase() ?? '').contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  Future<void> _addGroup(String name, String description, String code, String type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final group = GroupEntity(
        name: name,
        description: description.isNotEmpty ? description : null,
        code: code.isNotEmpty ? code : null,
        type: type.isNotEmpty ? type : 'general',
        status: 'active',
        tenantId: 'default_tenant',
        createdAt: DateTime.now().toIso8601String(),
        createdBy: 'user',
        isSynced: 0,
      );

      await _groupRepository.insertGroup(group);

      await _loadLocalGroups();
      await _loadSyncStats();

      await _syncPendingChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.save, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('$name saved locally'),
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
        _error = 'Failed to add group: $e';
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

  Future<bool> _deleteGroup(int groupId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _groupRepository.deleteGroup(groupId);
      await _loadLocalGroups();
      await _loadSyncStats();

      await _syncPendingChanges();

      return true;
    } catch (e) {
      setState(() {
        _error = 'Failed to delete group: $e';
      });
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(GroupEntity group) {
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
                  'Delete Group?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${group.name}"?',
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
                          final success = await _deleteGroup(group.id!);

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
                                      'Group "${group.name}" deleted',
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
                                    Text('Failed to delete group'),
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

  void _showAddGroupDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final codeController = TextEditingController();
    final typeController = TextEditingController();
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
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.category, color: Colors.white, size: 32),
                ),
                SizedBox(height: 20),
                Text(
                  'Add New Group',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                    labelStyle: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    hintText: 'Enter group name',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(Icons.label, color: Colors.blue.shade600),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Code (Optional)',
                    labelStyle: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    hintText: 'Enter group code',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(
                        Icons.code,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: 'Type (Optional)',
                    labelStyle: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    hintText: 'Enter group type',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(
                        Icons.category,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    labelStyle: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    hintText: 'Enter description',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(
                        Icons.description,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                  maxLines: 3,
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
                                if (nameController.text.isEmpty) {
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
                                            'Please enter a group name',
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

                                await _addGroup(
                                  nameController.text,
                                  descriptionController.text,
                                  codeController.text,
                                  typeController.text,
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
                                          '${nameController.text} added successfully!',
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
                          backgroundColor: Colors.blue,
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
                                  Text('Add Group'),
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
                        'Total Groups',
                        '$_totalRecords',
                        Icons.category,
                        Colors.blue,
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
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _typeController.dispose();
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
              shadowColor: Colors.blue.withOpacity(0.4),
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
                          'Groups',
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
                          'Manage all groups in one place',
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
                        hintText: 'Search groups...',
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
                              _filteredGroups = List.from(_groups);
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
        body: _buildBody(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
                onPressed: _showAddGroupDialog,
                backgroundColor: Colors.teal.shade700,
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
    final displayGroups = _isSearching
        ? _filteredGroups
        : _groups;

    if (_isLoading && _groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
                  'Loading groups...',
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
                onPressed: _loadLocalGroups,
                icon: Icon(Icons.refresh, size: 20),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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

    if (_groups.isEmpty) {
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
                        colors: [Colors.blue.shade100, Colors.blue.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.category,
                      size: 60,
                      color: Colors.blue.shade600,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(delay: 1000.ms, duration: 2000.ms)
                  .then(),
              SizedBox(height: 24),
              Text(
                'No Groups Found',
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
                  'Get started by adding your first group to the system',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showAddGroupDialog,
                icon: Icon(Icons.add, size: 20),
                label: Text('Add Group'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
        _filteredGroups.isEmpty &&
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
                'No groups found for "${_searchController.text}"',
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
      color: Colors.blue,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayGroups.length,
        itemBuilder: (context, index) {
          final group = displayGroups[index];
          return _buildGroupItem(group, index);
        },
      ),
    );
  }

  Widget _buildGroupItem(GroupEntity group, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: Colors.blue.withOpacity(0.1),
        child: InkWell(
          onLongPress: () {
            _showDeleteConfirmationDialog(group);
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.blue.withOpacity(0.1),
          highlightColor: Colors.blue.withOpacity(0.05),
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
                      _getGroupIcon(group.type),
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
                              group.name,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (group.isSynced == 0)
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
                      if (group.code != null && group.code!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          'Code: ${group.code!}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      if (group.type != null && group.type!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          'Type: ${group.type!}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      if (group.description != null &&
                          group.description!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          group.description!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (group.createdAt != null) ...[
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
                              'Created: ${_formatDate(group.createdAt!)}',
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
                    _showDeleteConfirmationDialog(group);
                  },
                  tooltip: 'Delete Group',
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

  IconData _getGroupIcon(String? type) {
    final name = type?.toLowerCase() ?? '';
    if (name.contains('general')) return Icons.category;
    if (name.contains('test')) return Icons.medical_services;
    if (name.contains('patient')) return Icons.person;
    if (name.contains('staff')) return Icons.group;
    if (name.contains('lab')) return Icons.science;
    return Icons.category;
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