// // lib/screens/master/division/division_screen.dart
// // ignore_for_file: avoid_print, depend_on_referenced_packages, use_super_parameters

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:http/http.dart' as http;
// import 'package:nanohospic/database/database_provider.dart';
// import 'package:nanohospic/database/entity/division_entity.dart';
// import 'package:nanohospic/database/repository/division_repo.dart';
// import 'package:nanohospic/screens/banner_widget.dart';
// import 'package:nanohospic/screens/master/item_master/division/add_division_screen.dart';
// import 'package:nanohospic/screens/master/item_master/division/division_update_screen.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class DivisionScreen extends StatefulWidget {
//   const DivisionScreen({super.key});

//   @override
//   State<DivisionScreen> createState() => _DivisionScreenState();
// }

// class _DivisionScreenState extends State<DivisionScreen> {
//   List<DivisionEntity> _divisions = [];
//   List<DivisionEntity> _filteredDivisions = [];
//   bool _isLoading = false;
//   bool _isSyncing = false;
//   String? _error;
//   final _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   late DivisionRepository _divisionRepository;
//   Timer? _syncTimer;
//   int _totalRecords = 0;
//   int _syncedRecords = 0;
//   int _pendingRecords = 0;
//   List<Map<String, dynamic>> _companies = [];
//   String? _selectedCompanyFilter;
//   Map<String, String> _companyNameCache = {};

//   @override
//   void initState() {
//     super.initState();
//     _initializeDatabase();
//     _searchController.addListener(() {
//       _filterDivisions(_searchController.text);
//     });

//     _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
//       _syncDataSilently();
//     });
//   }

//   Future<void> _initializeDatabase() async {
//     final db = await DatabaseProvider.database;
//     _divisionRepository = DivisionRepository(db.divisionDao);
//     await _loadCompanies();
//     _loadLocalDivisions();
//     _loadSyncStats();
//     _syncFromServer();
//   }

//   Future<void> _loadCompanies() async {
//     try {
//       final response = await http
//           .get(Uri.parse('http://202.140.138.215:85/api/CompanyApi'))
//           .timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['success'] == true) {
//           final List<dynamic> companiesData = data['data'];
//           _companies = companiesData.map<Map<String, dynamic>>((item) {
//             return {
//               'id': item['id'],
//               'name': item['name']?.toString() ?? 'Unknown Company',
//             };
//           }).toList();

//           // Create cache for company names
//           for (var company in _companies) {
//             _companyNameCache[company['id'].toString()] = company['name'];
//           }
//         }
//       }
//     } catch (e) {
//       print('Failed to load companies: $e');
//     }
//   }

//   String _getCompanyName(int? companyId) {
//     if (companyId == null) return 'Not Assigned';
//     return _companyNameCache[companyId.toString()] ?? 'Company $companyId';
//   }

//   Future<void> _loadLocalDivisions() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final divisions = await _divisionRepository.getAllDivisions();
//       print('Loaded ${divisions.length} divisions from database');

//       setState(() {
//         _divisions = divisions;
//         _filteredDivisions = List.from(_divisions);
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
//     _totalRecords = await _divisionRepository.getTotalCount();
//     _syncedRecords = await _divisionRepository.getSyncedCount();
//     _pendingRecords = await _divisionRepository.getPendingCount();
//     setState(() {});
//   }

//   Future<void> _syncFromServer() async {
//     if (_isSyncing) return;
//     setState(() {
//       _isSyncing = true;
//     });
//     try {
//       final response = await http
//           .get(Uri.parse('http://202.140.138.215:85/api/DivisionApi'))
//           .timeout(Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['success'] == true) {
//           final List<dynamic> divisionsData = data['data'];
//           print('Received ${divisionsData.length} divisions from server');
//           final List<Map<String, dynamic>> divisionList = divisionsData
//               .map<Map<String, dynamic>>((item) {
//                 if (item is Map<String, dynamic>) {
//                   return item;
//                 } else if (item is Map) {
//                   return Map<String, dynamic>.from(item);
//                 }
//                 return <String, dynamic>{};
//               })
//               .where((map) => map.isNotEmpty)
//               .toList();
//           await _divisionRepository.syncFromServer(divisionList);
//           await _loadLocalDivisions();
//           await _loadSyncStats();
//           await _syncPendingChanges();
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Row(
//                   children: [
//                     Icon(Icons.check_circle, color: Colors.white, size: 20),
//                     SizedBox(width: 8),
//                     Text('Sync completed successfully'),
//                   ],
//                 ),
//                 backgroundColor: Colors.green,
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             );
//           }
//         }
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
//       final pendingDivisions = await _divisionRepository.getPendingSync();
//       for (final division in pendingDivisions) {
//         if (division.isDeleted) {
//           if (division.serverId != null) {
//             await _deleteFromServer(division.serverId!);
//             await _divisionRepository.markAsSynced(division.id!);
//           } else {
//             await _divisionRepository.markAsSynced(division.id!);
//           }
//         } else if (division.serverId == null) {
//           final serverId = await _addToServer(division);
//           if (serverId != null) {
//             division.serverId = serverId;
//             await _divisionRepository.updateDivision(division);
//             await _divisionRepository.markAsSynced(division.id!);
//           }
//         } else {
//           final success = await _updateOnServer(division);
//           if (success) {
//             await _divisionRepository.markAsSynced(division.id!);
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

//   Future<int?> _addToServer(DivisionEntity division) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse('http://202.140.138.215:85/api/DivisionApi'),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode({
//               'id': 0,
//               'name': division.name,
//               'companyId': division.companyId,
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

//   Future<bool> _updateOnServer(DivisionEntity division) async {
//     try {
//       final response = await http
//           .put(
//             Uri.parse(
//               'http://202.140.138.215:85/api/DivisionApi/${division.serverId}',
//             ),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode({
//               'id': division.serverId,
//               'name': division.name,
//               'companyId': division.companyId,
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
//           .delete(
//             Uri.parse('http://202.140.138.215:85/api/DivisionApi/$serverId'),
//             headers: {'Content-Type': 'application/json'},
//           )
//           .timeout(Duration(seconds: 5));

//       return response.statusCode == 200 || response.statusCode == 204;
//     } catch (e) {
//       print('Delete from server failed: $e');
//       return false;
//     }
//   }

//   void _filterDivisions(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredDivisions = _applyCompanyFilter(_divisions);
//       } else {
//         _filteredDivisions = _divisions
//             .where(
//               (division) => division.name.toLowerCase().contains(query.toLowerCase()) ||
//                           _getCompanyName(division.companyId).toLowerCase().contains(query.toLowerCase()),
//             )
//             .toList();
//         _filteredDivisions = _applyCompanyFilter(_filteredDivisions);
//       }
//     });
//   }

//   List<DivisionEntity> _applyCompanyFilter(List<DivisionEntity> divisions) {
//     if (_selectedCompanyFilter == null || _selectedCompanyFilter == 'all') {
//       return divisions;
//     }
//     final companyId = int.tryParse(_selectedCompanyFilter!);
//     if (companyId == null) return divisions;

//     return divisions.where((division) => division.companyId == companyId).toList();
//   }

//   void _applyCompanyFilterSelection(String? companyId) {
//     setState(() {
//       _selectedCompanyFilter = companyId;
//       _filteredDivisions = _applyCompanyFilter(_divisions);
//     });
//   }

//   Future<void> _addDivision(String divisionName, int? companyId, String? companyName) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final division = DivisionEntity(
//         name: divisionName,
//         companyId: companyId,
//         companyName: companyName,
//         createdAt: DateTime.now().toIso8601String(),
//         isSynced: false,
//       );

//       await _divisionRepository.insertDivision(division);

//       await _loadLocalDivisions();
//       await _loadSyncStats();

//       await _syncPendingChanges();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.save, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('$divisionName saved locally'),
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
//         _error = 'Failed to add division: $e';
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

//   Future<bool> _deleteDivision(int divisionId) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _divisionRepository.softDeleteDivision(divisionId);
//       await _loadLocalDivisions();
//       await _loadSyncStats();

//       await _syncPendingChanges();

//       return true;
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to delete division: $e';
//       });
//       return false;
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showDeleteConfirmationDialog(DivisionEntity division) {
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
//                   'Delete Division?',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Are you sure you want to delete "${division.name}"?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                 ),
//                 if (division.companyName != null) ...[
//                   SizedBox(height: 8),
//                   Text(
//                     'Company: ${division.companyName}',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                   ),
//                 ],
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
//                           final success = await _deleteDivision(division.id!);

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
//                                     Text('Division "${division.name}" deleted'),
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
//                                     Text('Failed to delete division'),
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

//   void _showAddDivisionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AddDivisionDialog(
//           companies: _companies,
//           onSave: (name, companyId, companyName) {
//             _addDivision(name, companyId, companyName);
//           },
//         );
//       },
//     );
//   }

//   void _showEditDivisionDialog(DivisionEntity division) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return EditDivisionDialog(
//           division: division,
//           companies: _companies,
//           onSave: (name, companyId, companyName) async {
//             setState(() {
//               _isLoading = true;
//             });

//             try {
//               final updatedDivision = division.copyWith(
//                 name: name,
//                 companyId: companyId,
//                 companyName: companyName,
//                 lastModified: DateTime.now().toIso8601String(),
//                 isSynced: false,
//                 syncStatus: 'pending',
//               );

//               await _divisionRepository.updateDivision(updatedDivision);
//               await _loadLocalDivisions();
//               await _loadSyncStats();
//               await _syncPendingChanges();

//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Row(
//                       children: [
//                         Icon(Icons.check, color: Colors.white, size: 20),
//                         SizedBox(width: 8),
//                         Text('Division updated successfully'),
//                       ],
//                     ),
//                     backgroundColor: Colors.green,
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 );
//               }
//             } catch (e) {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Row(
//                       children: [
//                         Icon(Icons.error, color: Colors.white, size: 20),
//                         SizedBox(width: 8),
//                         Text('Failed to update division: $e'),
//                       ],
//                     ),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 );
//               }
//             } finally {
//               setState(() {
//                 _isLoading = false;
//               });
//             }
//           },
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
//                         'Total Divisions',
//                         '$_totalRecords',
//                         Icons.business,
//                         Colors.teal,
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
//     _syncTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 15.h,
//               floating: false,
//               pinned: true,
//               backgroundColor: Color(0xff016B61),
//               foregroundColor: Colors.white,
//               elevation: 6,
//               shadowColor: Colors.teal.withOpacity(0.4),
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.pin,
//                 background: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xff016B61),
//                         Color(0xff016B61),
//                         Color(0xff016B61).withOpacity(0.4),
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
//                           'Divisions',
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
//                           'Manage all your departments/divisions',
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
//                         hintText: 'Search division...',
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
//                               _filteredDivisions = List.from(_divisions);
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
//         body: Column(
//           children: [
//             BannerSlider(bannerImages: _bannerImages),
//             _buildFilterRow(),
//             Expanded(child: _buildBody()),
//           ],
//         ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           if (_pendingRecords > 0)
//             Container(
//               margin: EdgeInsets.only(bottom: 10),
//               child:
//                   FloatingActionButton.extended(
//                         onPressed: _syncFromServer,
//                         backgroundColor: Colors.orange,
//                         foregroundColor: Colors.white,
//                         icon: Icon(Icons.cloud_upload),
//                         label: Text('$_pendingRecords pending'),
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       )
//                       .animate(onPlay: (controller) => controller.repeat())
//                       .scale(duration: 2000.ms, curve: Curves.easeInOut)
//                       .then(delay: 1000.ms),
//             ),
//           FloatingActionButton(
//                 onPressed: _showAddDivisionDialog,
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

//   Widget _buildFilterRow() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       color: Colors.white,
//       child: Row(
//         children: [
//           Icon(Icons.filter_alt, size: 20, color: Colors.teal.shade700),
//           SizedBox(width: 8),
//           Text(
//             'Company:',
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: _selectedCompanyFilter ?? 'all',
//                   isExpanded: true,
//                   icon: Icon(Icons.arrow_drop_down, color: Colors.teal.shade700),
//                   items: [
//                     DropdownMenuItem(
//                       value: 'all',
//                       child: Text(
//                         'All Companies',
//                         style: TextStyle(color: Colors.grey.shade700),
//                       ),
//                     ),
//                     ..._companies.map((company) {
//                       return DropdownMenuItem(
//                         value: company['id'].toString(),
//                         child: Text(
//                           company['name'],
//                           style: TextStyle(color: Colors.grey.shade800),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                   onChanged: _applyCompanyFilterSelection,
//                 ),
//               ),
//             ),
//           ),
//           if (_selectedCompanyFilter != null && _selectedCompanyFilter != 'all')
//             IconButton(
//               icon: Icon(Icons.clear, size: 20),
//               onPressed: () => _applyCompanyFilterSelection('all'),
//               tooltip: 'Clear filter',
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     final displayDivisions = _isSearching ? _filteredDivisions : _divisions;

//     if (_isLoading && _divisions.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.teal.shade50,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//                   'Loading divisions...',
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
//                 onPressed: _loadLocalDivisions,
//                 icon: Icon(Icons.refresh, size: 20),
//                 label: Text('Try Again'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
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

//     if (_divisions.isEmpty) {
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
//                         colors: [Colors.teal.shade100, Colors.teal.shade200],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.business,
//                       size: 60,
//                       color: Colors.teal.shade600,
//                     ),
//                   )
//                   .animate(onPlay: (controller) => controller.repeat())
//                   .scale(delay: 1000.ms, duration: 2000.ms)
//                   .then(),
//               SizedBox(height: 24),
//               Text(
//                 'No Divisions Found',
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
//                   'Get started by adding your first division/department',
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _showAddDivisionDialog,
//                 icon: Icon(Icons.add, size: 20),
//                 label: Text('Add First Division'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
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
//         _filteredDivisions.isEmpty &&
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
//                 'No divisions found for "${_searchController.text}"',
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
//       color: Colors.teal,
//       displacement: 40,
//       edgeOffset: 20,
//       strokeWidth: 2.5,
//       child: ListView.builder(
//         controller: _scrollController,
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
//         itemCount: displayDivisions.length,
//         itemBuilder: (context, index) {
//           final division = displayDivisions[index];
//           return _buildDivisionItem(division, index);
//         },
//       ),
//     );
//   }

//   Widget _buildDivisionItem(DivisionEntity division, int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       child:
//           Material(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 elevation: 1,
//                 shadowColor: Colors.teal.withOpacity(0.1),
//                 child: InkWell(
//                   onTap: () {
//                     _showEditDivisionDialog(division);
//                   },
//                   onLongPress: () {
//                     _showDeleteConfirmationDialog(division);
//                   },
//                   borderRadius: BorderRadius.circular(16),
//                   splashColor: Colors.teal.withOpacity(0.1),
//                   highlightColor: Colors.teal.withOpacity(0.05),
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
//                               Icons.business,
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
//                                       division.name,
//                                       style: TextStyle(
//                                         fontSize: 17.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey.shade800,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   if (!division.isSynced)
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
//                               SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.business_center,
//                                     size: 12,
//                                     color: Colors.grey.shade500,
//                                   ),
//                                   SizedBox(width: 6),
//                                   Text(
//                                     _getCompanyName(division.companyId),
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade600,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (division.createdAt != null) ...[
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
//                                       'Created: ${_formatDate(division.createdAt!)}',
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
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Container(
//                                 width: 36,
//                                 height: 36,
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade50,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.edit,
//                                   size: 18,
//                                   color: Colors.blue.shade600,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 _showEditDivisionDialog(division);
//                               },
//                               tooltip: 'Edit Division',
//                             ),
//                             SizedBox(height: 4),
//                             IconButton(
//                               icon: Container(
//                                 width: 36,
//                                 height: 36,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.shade50,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.delete_outline,
//                                   size: 18,
//                                   color: Colors.red.shade600,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 _showDeleteConfirmationDialog(division);
//                               },
//                               tooltip: 'Delete Division',
//                             ),
//                           ],
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

//   Color _getColorFromIndex(int index) {
//     final colors = [
//       Colors.teal.shade600,
//       Colors.cyan.shade600,
//       Colors.blue.shade600,
//       Colors.indigo.shade600,
//       Colors.purple.shade600,
//       Colors.deepPurple.shade600,
//       Colors.green.shade600,
//       Colors.lightGreen.shade600,
//       Colors.orange.shade600,
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

//   final List<String> _bannerImages = [
//     'assets/indflag.jpg',
//     'assets/isrflag.jpg',
//     'assets/russianflag.png',
//   ];
// }

// lib/screens/master/division/division_screen.dart
// ignore_for_file: avoid_print, depend_on_referenced_packages, use_super_parameters

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/division_entity.dart';
import 'package:nanohospic/database/repository/division_repo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Additional check by trying to reach a known server
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Stream<bool> get connectivityStream {
    return Connectivity().onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }
}

class DivisionScreen extends StatefulWidget {
  const DivisionScreen({super.key});

  @override
  State<DivisionScreen> createState() => _DivisionScreenState();
}

class _DivisionScreenState extends State<DivisionScreen> {
  List<DivisionEntity> _divisions = [];
  List<DivisionEntity> _filteredDivisions = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late DivisionRepository _divisionRepository;
  Timer? _syncTimer;
  Timer? _connectionCheckTimer;
  int _totalRecords = 0;
  int _syncedRecords = 0;
  int _pendingRecords = 0;
  List<Map<String, dynamic>> _companies = [];
  String? _selectedCompanyFilter;
  Map<String, String> _companyNameCache = {};
  bool _isOnline = false;
  StreamSubscription<bool>? _connectionSubscription;
  bool _showOfflineBanner = false;
  List<Map<String, dynamic>> _syncQueue = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _checkConnection();
    _setupConnectionListener();

    _searchController.addListener(() {
      _filterDivisions(_searchController.text);
    });

    // Sync every 30 seconds when online
    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_isOnline && _pendingRecords > 0) {
        _syncPendingChanges();
      }
    });

    // Check connection every 10 seconds
    _connectionCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _checkConnection();
    });
  }

  Future<void> _initializeDatabase() async {
    final db = await DatabaseProvider.database;
    _divisionRepository = DivisionRepository(db.divisionDao);
    await _loadLocalDivisions();
    await _loadSyncStats();

    // Try to load companies if online
    if (_isOnline) {
      await _loadCompanies();
      await _syncFromServer();
    } else {
      // Load companies from cache or show empty
      _companies = [];
      _showOfflineBanner = true;
    }
  }

  Future<void> _checkConnection() async {
    final isConnected = await NetworkUtils.hasInternetConnection();
    if (isConnected != _isOnline) {
      setState(() {
        _isOnline = isConnected;
        _showOfflineBanner = !isConnected;
      });

      if (isConnected) {
        // Just came online, sync immediately
        _syncFromServer();
        _syncPendingChanges();
        _loadCompanies();
      }
    }
  }

  void _setupConnectionListener() {
    _connectionSubscription = NetworkUtils.connectivityStream.listen((
      isConnected,
    ) {
      if (isConnected != _isOnline) {
        setState(() {
          _isOnline = isConnected;
          _showOfflineBanner = !isConnected;
        });

        if (isConnected) {
          // Just came online, sync immediately
          _syncFromServer();
          _syncPendingChanges();
          _loadCompanies();
        }
      }
    });
  }

  Future<void> _loadCompanies() async {
    if (!_isOnline) return;

    try {
      final response = await http
          .get(Uri.parse('http://202.140.138.215:85/api/CompanyApi'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> companiesData = data['data'];
          setState(() {
            _companies = companiesData.map<Map<String, dynamic>>((item) {
              return {
                'id': item['id'],
                'name': item['name']?.toString() ?? 'Unknown Company',
              };
            }).toList();

            // Create cache for company names
            for (var company in _companies) {
              _companyNameCache[company['id'].toString()] = company['name'];
            }
          });
        }
      }
    } catch (e) {
      print('Failed to load companies: $e');
    }
  }

  String _getCompanyName(int? companyId) {
    if (companyId == null) return 'Not Assigned';
    return _companyNameCache[companyId.toString()] ?? 'Company $companyId';
  }

  Future<void> _loadLocalDivisions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final divisions = await _divisionRepository.getAllDivisions();
      print('Loaded ${divisions.length} divisions from database');

      setState(() {
        _divisions = divisions;
        _filteredDivisions = List.from(_divisions);
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
    _totalRecords = await _divisionRepository.getTotalCount();
    _syncedRecords = await _divisionRepository.getSyncedCount();
    _pendingRecords = await _divisionRepository.getPendingCount();
    setState(() {});
  }

  Future<void> _syncFromServer() async {
    if (_isSyncing || !_isOnline) return;

    setState(() {
      _isSyncing = true;
    });
    try {
      final response = await http
          .get(Uri.parse('http://202.140.138.215:85/api/DivisionApi'))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> divisionsData = data['data'];
          print('Received ${divisionsData.length} divisions from server');

          final List<Map<String, dynamic>> divisionList = divisionsData
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

          await _divisionRepository.syncFromServer(divisionList);
          await _loadLocalDivisions();
          await _loadSyncStats();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.cloud_download, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Data synced from server'),
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
      print('Sync from server failed: $e');
      if (mounted && _isOnline) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Failed to sync from server'),
              ],
            ),
            backgroundColor: Colors.orange,
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
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _syncPendingChanges() async {
    if (!_isOnline) return;
    try {
      final pendingDivisions = await _divisionRepository.getPendingSync();
      int syncedCount = 0;
      int totalCount = pendingDivisions.length;
      for (final division in pendingDivisions) {
        try {
          if (division.isDeleted) {
            if (division.serverId != null) {
              final success = await _deleteFromServer(division.serverId!);
              if (success) {
                await _divisionRepository.markAsSynced(division.id!);
                syncedCount++;
              }
            } else {
              await _divisionRepository.markAsSynced(division.id!);
              syncedCount++;
            }
          } else if (division.serverId == null) {
            final serverId = await _addToServer(division);
            if (serverId != null) {
              division.serverId = serverId;
              await _divisionRepository.updateDivision(division);
              await _divisionRepository.markAsSynced(division.id!);
              syncedCount++;
            }
          } else {
            final success = await _updateOnServer(division);
            if (success) {
              await _divisionRepository.markAsSynced(division.id!);
              syncedCount++;
            }
          }
        } catch (e) {
          print('Failed to sync division ${division.id}: $e');
        }
      }
      await _loadSyncStats();

      if (syncedCount > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cloud_upload, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  '$syncedCount/$totalCount pending changes synced successfully',
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

      if (syncedCount < totalCount && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${totalCount - syncedCount} items failed to sync'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print('Pending sync failed: $e');
    }
  }

  Future<int?> _addToServer(DivisionEntity division) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://202.140.138.215:85/api/DivisionApi'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': 0,
              'name': division.name,
              'companyId': division.companyId,
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

  Future<bool> _updateOnServer(DivisionEntity division) async {
    try {
      final response = await http
          .put(
            Uri.parse(
              'http://202.140.138.215:85/api/DivisionApi/${division.serverId}',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': division.serverId,
              'name': division.name,
              'companyId': division.companyId,
            }),
          )
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('Update on server failed: $e');
      return false;
    }
  }

  Future<bool> _deleteFromServer(int serverId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('http://202.140.138.215:85/api/DivisionApi/$serverId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete from server failed: $e');
      return false;
    }
  }

  void _filterDivisions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDivisions = _applyCompanyFilter(_divisions);
      } else {
        _filteredDivisions = _divisions
            .where(
              (division) =>
                  division.name.toLowerCase().contains(query.toLowerCase()) ||
                  _getCompanyName(
                    division.companyId,
                  ).toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        _filteredDivisions = _applyCompanyFilter(_filteredDivisions);
      }
    });
  }

  List<DivisionEntity> _applyCompanyFilter(List<DivisionEntity> divisions) {
    if (_selectedCompanyFilter == null || _selectedCompanyFilter == 'all') {
      return divisions;
    }
    final companyId = int.tryParse(_selectedCompanyFilter!);
    if (companyId == null) return divisions;

    return divisions
        .where((division) => division.companyId == companyId)
        .toList();
  }

  void _applyCompanyFilterSelection(String? companyId) {
    setState(() {
      _selectedCompanyFilter = companyId;
      _filteredDivisions = _applyCompanyFilter(_divisions);
    });
  }

  Future<void> _addDivision(
    String divisionName,
    int? companyId,
    String? companyName,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final division = await _divisionRepository.addDivisionWithSync(
        name: divisionName,
        companyId: companyId,
        companyName: companyName,
      );
      await _loadLocalDivisions();
      await _loadSyncStats();

      if (mounted) {
        if (_isOnline) {
          final serverId = await _addToServer(division);
          if (serverId != null) {
            division.serverId = serverId;
            await _divisionRepository.updateDivision(division);
            await _divisionRepository.markAsSynced(division.id!);
            await _loadSyncStats();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.cloud_done, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('$divisionName added and synced to server'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.save, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('$divisionName saved locally (sync pending)'),
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
        } else {
          // Offline mode - saved locally only
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.signal_wifi_off, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('$divisionName saved locally (offline mode)'),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to add division: $e';
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

  Future<bool> _deleteDivision(int divisionId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _divisionRepository.softDeleteDivision(divisionId);
      await _loadLocalDivisions();
      await _loadSyncStats();

      if (_isOnline) {
        // Try to sync delete immediately
        await _syncPendingChanges();
      }

      return true;
    } catch (e) {
      setState(() {
        _error = 'Failed to delete division: $e';
      });
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(DivisionEntity division) {
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
                  'Delete Division?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${division.name}"?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                if (division.companyName != null) ...[
                  SizedBox(height: 8),
                  Text(
                    'Company: ${division.companyName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
                if (!_isOnline) ...[
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.signal_wifi_off,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You are offline. Deletion will sync when back online.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                          final success = await _deleteDivision(division.id!);

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
                                      'Division "${division.name}" ${_isOnline ? 'deleted' : 'marked for deletion'}',
                                    ),
                                  ],
                                ),
                                backgroundColor: _isOnline
                                    ? Colors.green
                                    : Colors.orange,
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
                                    Text('Failed to delete division'),
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

  void _showAddDivisionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDivisionDialog(
          companies: _companies,
          isOnline: _isOnline,
          onSave: (name, companyId, companyName) {
            _addDivision(name, companyId, companyName);
          },
        );
      },
    );
  }

  void _showEditDivisionDialog(DivisionEntity division) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDivisionDialog(
          division: division,
          companies: _companies,
          isOnline: _isOnline,
          onSave: (name, companyId, companyName) async {
            setState(() {
              _isLoading = true;
            });

            try {
              final updatedDivision = division.copyWith(
                name: name,
                companyId: companyId,
                companyName: companyName,
                lastModified: DateTime.now().toIso8601String(),
                isSynced: false,
                syncStatus: 'pending',
              );

              await _divisionRepository.updateDivision(updatedDivision);
              await _loadLocalDivisions();
              await _loadSyncStats();

              if (_isOnline) {
                await _syncPendingChanges();
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Division updated ${_isOnline ? 'and synced' : 'locally'}',
                        ),
                      ],
                    ),
                    backgroundColor: _isOnline ? Colors.green : Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Failed to update division: $e'),
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
          },
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
                  child: Icon(
                    _isOnline ? Icons.sync : Icons.signal_wifi_off,
                    color: Colors.white,
                    size: 32,
                  ),
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
                        'Connection',
                        _isOnline ? 'Online' : 'Offline',
                        _isOnline ? Icons.wifi : Icons.wifi_off,
                        _isOnline ? Colors.green : Colors.orange,
                      ),
                      SizedBox(height: 12),
                      _buildSyncStatItem(
                        'Total Divisions',
                        '$_totalRecords',
                        Icons.business,
                        Colors.teal,
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
                if (!_isOnline)
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You are offline. Changes will sync when connection is restored.',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 14,
                            ),
                          ),
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
                        onPressed: _isSyncing || !_isOnline
                            ? null
                            : _syncFromServer,
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
    _connectionCheckTimer?.cancel();
    _connectionSubscription?.cancel();
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
              expandedHeight: _showOfflineBanner ? 18.h : 15.h,
              floating: false,
              pinned: true,
              backgroundColor: Color(0xff016B61),
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: Colors.teal.withOpacity(0.4),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [
                    // Offline banner
                    if (_showOfflineBanner)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: Colors.orange,
                        child: Row(
                          children: [
                            Icon(
                              Icons.signal_wifi_off,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'You are offline. Working in offline mode.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (_pendingRecords > 0)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$_pendingRecords pending',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Divisions',
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
                                'Manage all your departments/divisions',
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
                  ],
                ),
              ),
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search division...',
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
                              _filteredDivisions = List.from(_divisions);
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
                    color: _isSyncing
                        ? Colors.amber
                        : _isOnline
                        ? Colors.white
                        : Colors.grey,
                    size: 22,
                  ),
                  onPressed: _isSyncing || !_isOnline ? null : _syncFromServer,
                  tooltip: _isOnline ? 'Sync' : 'Offline',
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
            // BannerSlider(bannerImages: _bannerImages),
            // _buildFilterRow(),
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
                        onPressed: _isOnline ? _syncPendingChanges : null,
                        backgroundColor: _isOnline
                            ? Colors.orange
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        icon: Icon(
                          _isOnline
                              ? Icons.cloud_upload
                              : Icons.signal_wifi_off,
                        ),
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
                onPressed: _showAddDivisionDialog,
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

  Widget _buildFilterRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.filter_alt, size: 20, color: Colors.teal.shade700),
          SizedBox(width: 8),
          Text(
            'Company:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCompanyFilter ?? 'all',
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.teal.shade700,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text(
                        'All Companies',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    ..._companies.map((company) {
                      return DropdownMenuItem(
                        value: company['id'].toString(),
                        child: Text(
                          company['name'],
                          style: TextStyle(color: Colors.grey.shade800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: _applyCompanyFilterSelection,
                ),
              ),
            ),
          ),
          if (_selectedCompanyFilter != null && _selectedCompanyFilter != 'all')
            IconButton(
              icon: Icon(Icons.clear, size: 20),
              onPressed: () => _applyCompanyFilterSelection('all'),
              tooltip: 'Clear filter',
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final displayDivisions = _isSearching ? _filteredDivisions : _divisions;

    if (_isLoading && _divisions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
                  'Loading divisions...',
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
                onPressed: _loadLocalDivisions,
                icon: Icon(Icons.refresh, size: 20),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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

    if (_divisions.isEmpty) {
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
                        colors: [Colors.teal.shade100, Colors.teal.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.business,
                      size: 60,
                      color: Colors.teal.shade600,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(delay: 1000.ms, duration: 2000.ms)
                  .then(),
              SizedBox(height: 24),
              Text(
                'No Divisions Found',
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
                  'Get started by adding your first division/department',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showAddDivisionDialog,
                icon: Icon(Icons.add, size: 20),
                label: Text('Add First Division'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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
        _filteredDivisions.isEmpty &&
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
                'No divisions found for "${_searchController.text}"',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _isOnline
          ? _syncFromServer
          : () async {
              // Offline refresh - just reload local data
              await _loadLocalDivisions();
              await _loadSyncStats();
            },
      backgroundColor: Colors.white,
      color: _isOnline ? Colors.teal : Colors.grey,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayDivisions.length,
        itemBuilder: (context, index) {
          final division = displayDivisions[index];
          return _buildDivisionItem(division, index);
        },
      ),
    );
  }

  Widget _buildDivisionItem(DivisionEntity division, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child:
          Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: 1,
                shadowColor: Colors.teal.withOpacity(0.1),
                child: InkWell(
                  onTap: () {
                    _showEditDivisionDialog(division);
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(division);
                  },
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.teal.withOpacity(0.1),
                  highlightColor: Colors.teal.withOpacity(0.05),
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
                              Icons.business,
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
                                      division.name,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (!division.isSynced)
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
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.business_center,
                                    size: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    _getCompanyName(division.companyId),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              if (division.createdAt != null) ...[
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
                                      'Created: ${_formatDate(division.createdAt!)}',
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                              onPressed: () {
                                _showEditDivisionDialog(division);
                              },
                              tooltip: 'Edit Division',
                            ),
                            SizedBox(height: 4),
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
                                _showDeleteConfirmationDialog(division);
                              },
                              tooltip: 'Delete Division',
                            ),
                          ],
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
      Colors.teal.shade600,
      Colors.cyan.shade600,
      Colors.blue.shade600,
      Colors.indigo.shade600,
      Colors.purple.shade600,
      Colors.deepPurple.shade600,
      Colors.green.shade600,
      Colors.lightGreen.shade600,
      Colors.orange.shade600,
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

  final List<String> _bannerImages = [
    'assets/indflag.jpg',
    'assets/isrflag.jpg',
    'assets/russianflag.png',
  ];
}

// AddDivisionDialog with offline support
class AddDivisionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> companies;
  final bool isOnline;
  final Function(String name, int? companyId, String? companyName) onSave;

  const AddDivisionDialog({
    Key? key,
    required this.companies,
    required this.isOnline,
    required this.onSave,
  }) : super(key: key);

  @override
  _AddDivisionDialogState createState() => _AddDivisionDialogState();
}

class _AddDivisionDialogState extends State<AddDivisionDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCompanyId;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  colors: [Colors.teal.shade400, Colors.teal.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.business, color: Colors.white, size: 32),
            ),
            SizedBox(height: 20),
            Text(
              'Add New Division',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            if (!widget.isOnline) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.signal_wifi_off, size: 16, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You are offline. Division will sync when back online.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Division Name *',
                labelStyle: TextStyle(
                  color: Colors.teal.shade600,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
                filled: true,
                fillColor: Colors.teal.shade50,
                hintText: 'Enter division name',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Container(
                  margin: EdgeInsets.only(right: 8, left: 12),
                  child: Icon(Icons.business, color: Colors.teal.shade600),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 40),
              ),
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
            SizedBox(height: 16),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade300),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCompanyId,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.teal.shade700,
                  ),
                  hint: Text(
                    widget.companies.isEmpty
                        ? 'No companies loaded (offline)'
                        : 'Select Company *',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  items: widget.companies.isEmpty
                      ? []
                      : widget.companies.map((company) {
                          return DropdownMenuItem(
                            value: company['id'].toString(),
                            child: Text(
                              company['name'],
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          );
                        }).toList(),
                  onChanged: widget.companies.isEmpty
                      ? null
                      : (value) {
                          setState(() {
                            _selectedCompanyId = value;
                          });
                        },
                ),
              ),
            ),
            if (widget.companies.isEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Companies not available offline',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting
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
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            if (_nameController.text.isEmpty) {
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
                                      Text('Please enter division name'),
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

                            if (widget.companies.isNotEmpty &&
                                _selectedCompanyId == null) {
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
                                      Text('Please select a company'),
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
                              _isSubmitting = true;
                            });

                            final companyId = _selectedCompanyId != null
                                ? int.tryParse(_selectedCompanyId!)
                                : null;

                            final company =
                                widget.companies.isNotEmpty && companyId != null
                                ? widget.companies.firstWhere(
                                    (c) => c['id'] == companyId,
                                    orElse: () => {'name': ''},
                                  )
                                : {'name': ''};
                            final companyName = company['name'] as String?;

                            widget.onSave(
                              _nameController.text,
                              companyId,
                              companyName,
                            );

                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
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
                              Text(
                                widget.isOnline ? 'Add & Sync' : 'Add Locally',
                              ),
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
  }
}

// EditDivisionDialog with offline support
class EditDivisionDialog extends StatefulWidget {
  final DivisionEntity division;
  final List<Map<String, dynamic>> companies;
  final bool isOnline;
  final Function(String name, int? companyId, String? companyName) onSave;

  const EditDivisionDialog({
    Key? key,
    required this.division,
    required this.companies,
    required this.isOnline,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditDivisionDialogState createState() => _EditDivisionDialogState();
}

class _EditDivisionDialogState extends State<EditDivisionDialog> {
  late TextEditingController _nameController;
  late String? _selectedCompanyId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.division.name);
    _selectedCompanyId = widget.division.companyId?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              child: Icon(Icons.edit, color: Colors.white, size: 32),
            ),
            SizedBox(height: 20),
            Text(
              'Edit Division',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            if (!widget.isOnline) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.signal_wifi_off, size: 16, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You are offline. Changes will sync when back online.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Division Name *',
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
                hintText: 'Enter division name',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Container(
                  margin: EdgeInsets.only(right: 8, left: 12),
                  child: Icon(Icons.business, color: Colors.blue.shade600),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 40),
              ),
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
            SizedBox(height: 16),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade300),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCompanyId,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue.shade700,
                  ),
                  hint: Text(
                    widget.companies.isEmpty
                        ? 'No companies loaded (offline)'
                        : 'Select Company *',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  items: widget.companies.isEmpty
                      ? []
                      : widget.companies.map((company) {
                          return DropdownMenuItem(
                            value: company['id'].toString(),
                            child: Text(
                              company['name'],
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          );
                        }).toList(),
                  onChanged: widget.companies.isEmpty
                      ? null
                      : (value) {
                          setState(() {
                            _selectedCompanyId = value;
                          });
                        },
                ),
              ),
            ),
            if (widget.companies.isEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Companies not available offline',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting
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
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            if (_nameController.text.isEmpty) {
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
                                      Text('Please enter division name'),
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

                            if (widget.companies.isNotEmpty &&
                                _selectedCompanyId == null) {
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
                                      Text('Please select a company'),
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
                              _isSubmitting = true;
                            });

                            final companyId = _selectedCompanyId != null
                                ? int.tryParse(_selectedCompanyId!)
                                : widget.division.companyId;

                            final company =
                                widget.companies.isNotEmpty && companyId != null
                                ? widget.companies.firstWhere(
                                    (c) => c['id'] == companyId,
                                    orElse: () => {'name': ''},
                                  )
                                : {'name': widget.division.companyName ?? ''};
                            final companyName = company['name'] as String?;

                            widget.onSave(
                              _nameController.text,
                              companyId,
                              companyName,
                            );

                            Navigator.pop(context);
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
                    child: _isSubmitting
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
                              Icon(Icons.save, size: 20),
                              SizedBox(width: 8),
                              Text(
                                widget.isOnline
                                    ? 'Save & Sync'
                                    : 'Save Locally',
                              ),
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
  }
}
