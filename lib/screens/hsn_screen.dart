// // // ignore_for_file: deprecated_member_use

// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:flutter/animation.dart';
// // import 'package:responsive_sizer/responsive_sizer.dart';
// // import 'package:flutter_animate/flutter_animate.dart';

// // class HsnScreen extends StatefulWidget {
// //   @override
// //   _HsnScreenState createState() => _HsnScreenState();
// // }

// // class _HsnScreenState extends State<HsnScreen> with TickerProviderStateMixin {
// //   List<HsnModel> hsnList = [];
// //   List<HsnModel> filteredHsnList = [];
// //   bool isLoading = true;
// //   String errorMessage = '';
// //   final TextEditingController searchController = TextEditingController();
// //   String searchQuery = '';

// //   final TextEditingController hsnCodeController = TextEditingController();
// //   final TextEditingController sgstController = TextEditingController();
// //   final TextEditingController cgstController = TextEditingController();
// //   final TextEditingController igstController = TextEditingController();
// //   final TextEditingController cessController = TextEditingController();
// //   int? hsnTypeValue;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchHsnData();
// //     searchController.addListener(_onSearchChanged);
// //   }

// //   @override
// //   void dispose() {
// //     searchController.dispose();
// //     super.dispose();
// //   }

// //   void _onSearchChanged() {
// //     setState(() {
// //       searchQuery = searchController.text.toLowerCase();
// //       _filterHsnCodes();
// //     });
// //   }

// //   void _filterHsnCodes() {
// //     if (searchQuery.isEmpty) {
// //       filteredHsnList.clear();
// //       filteredHsnList.addAll(hsnList);
// //     } else {
// //       filteredHsnList.clear();
// //       filteredHsnList.addAll(
// //         hsnList.where((hsn) {
// //           return hsn.hsnCode.toLowerCase().contains(searchQuery);
// //         }),
// //       );
// //     }
// //   }

// //   Future<void> fetchHsnData() async {
// //     setState(() {
// //       isLoading = true;
// //       errorMessage = '';
// //     });

// //     try {
// //       final response = await http.get(
// //         Uri.parse('http://202.140.138.215:85/api/HSNApi'),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = json.decode(response.body);
// //         setState(() {
// //           hsnList = data.map((json) => HsnModel.fromJson(json)).toList();
// //           _filterHsnCodes();
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           errorMessage = 'Failed to load data: ${response.statusCode}';
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         errorMessage = 'Error: $e';
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   Future<void> deleteHsn(int id) async {
// //     try {
// //       final response = await http.delete(
// //         Uri.parse('http://202.140.138.215:85/api/HSNApi/$id'),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 200 || response.statusCode == 204) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //                 content: Text('HSN code deleted successfully'),
// //                 backgroundColor: Colors.green,
// //                 behavior: SnackBarBehavior.floating,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ).animate().fadeIn().slideY(begin: -0.5)
// //               as SnackBar,
// //         );

// //         // Refresh the list
// //         await fetchHsnData();
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //                 content: Text('Failed to delete HSN: ${response.statusCode}'),
// //                 backgroundColor: Colors.red,
// //                 behavior: SnackBarBehavior.floating,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ).animate().fadeIn().slideY(begin: -0.5)
// //               as SnackBar,
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //               content: Text('Error deleting HSN: $e'),
// //               backgroundColor: Colors.red,
// //               behavior: SnackBarBehavior.floating,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //             ).animate().fadeIn().slideY(begin: -0.5)
// //             as SnackBar,
// //       );
// //     }
// //   }

// //   Future<void> addHsn() async {
// //     if (hsnCodeController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //               content: Text('HSN Code is required'),
// //               backgroundColor: Colors.red,
// //               behavior: SnackBarBehavior.floating,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //             ).animate().fadeIn().slideY(begin: -0.5)
// //             as SnackBar,
// //       );
// //       return;
// //     }

// //     final newHsn = {
// //       "id": 0,
// //       "hsnCode": hsnCodeController.text,
// //       "sgst": double.tryParse(sgstController.text) ?? 0,
// //       "cgst": double.tryParse(cgstController.text) ?? 0,
// //       "igst": double.tryParse(igstController.text) ?? 0,
// //       "cess": double.tryParse(cessController.text) ?? 0,
// //       "hsnType": hsnTypeValue ?? 1,
// //     };

// //     try {
// //       final response = await http.post(
// //         Uri.parse('http://202.140.138.215:85/api/HSNApi'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: json.encode(newHsn),
// //       );

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //                 content: Text('HSN added successfully'),
// //                 backgroundColor: Colors.green,
// //                 behavior: SnackBarBehavior.floating,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ).animate().fadeIn().slideY(begin: -0.5)
// //               as SnackBar,
// //         );

// //         // Clear form
// //         hsnCodeController.clear();
// //         sgstController.clear();
// //         cgstController.clear();
// //         igstController.clear();
// //         cessController.clear();
// //         hsnTypeValue = null;

// //         // Refresh data
// //         fetchHsnData();

// //         // Close dialog
// //         Navigator.of(context).pop();
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //                 content: Text('Failed to add HSN: ${response.statusCode}'),
// //                 backgroundColor: Colors.red,
// //                 behavior: SnackBarBehavior.floating,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ).animate().fadeIn().slideY(begin: -0.5)
// //               as SnackBar,
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //               content: Text('Error: $e'),
// //               backgroundColor: Colors.red,
// //               behavior: SnackBarBehavior.floating,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //             ).animate().fadeIn().slideY(begin: -0.5)
// //             as SnackBar,
// //       );
// //     }
// //   }

// //   void _showAddHsnDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           backgroundColor: Colors.transparent,
// //           insetPadding: EdgeInsets.all(20),
// //           child: SingleChildScrollView(
// //             child: Container(
// //               padding: EdgeInsets.all(24),
// //               decoration: BoxDecoration(
// //                 color: Theme.of(context).scaffoldBackgroundColor,
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.2),
// //                     blurRadius: 10,
// //                     spreadRadius: 2,
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                 children: [
// //                   Text(
// //                     'Add New HSN',
// //                     style: TextStyle(
// //                       fontSize: 22,
// //                       fontWeight: FontWeight.bold,
// //                       color: Theme.of(context).primaryColor,
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),
// //                   SizedBox(height: 20),
// //                   TextField(
// //                     controller: hsnCodeController,
// //                     decoration: InputDecoration(
// //                       labelText: 'HSN Code*',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       filled: true,
// //                       prefixIcon: Icon(Icons.code),
// //                     ),
// //                   ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
// //                   SizedBox(height: 15),
// //                   TextField(
// //                     controller: sgstController,
// //                     decoration: InputDecoration(
// //                       labelText: 'SGST (%)',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       filled: true,
// //                       prefixIcon: Icon(Icons.percent),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                   ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
// //                   SizedBox(height: 15),
// //                   TextField(
// //                     controller: cgstController,
// //                     decoration: InputDecoration(
// //                       labelText: 'CGST (%)',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       filled: true,
// //                       prefixIcon: Icon(Icons.percent),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                   ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
// //                   SizedBox(height: 15),
// //                   TextField(
// //                     controller: igstController,
// //                     decoration: InputDecoration(
// //                       labelText: 'IGST (%)',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       filled: true,
// //                       prefixIcon: Icon(Icons.percent),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                   ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
// //                   SizedBox(height: 15),
// //                   TextField(
// //                     controller: cessController,
// //                     decoration: InputDecoration(
// //                       labelText: 'CESS (%)',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       filled: true,
// //                       prefixIcon: Icon(Icons.percent),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                   ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
// //                   SizedBox(height: 15),
// //                   DropdownButtonFormField<int>(
// //                     value: hsnTypeValue,
// //                     decoration: InputDecoration(
// //                       labelText: 'HSN Type',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       filled: true,
// //                       prefixIcon: Icon(Icons.category),
// //                     ),
// //                     items: [
// //                       DropdownMenuItem(value: 1, child: Text('Type 1')),
// //                       DropdownMenuItem(value: 2, child: Text('Type 2')),
// //                     ],
// //                     onChanged: (value) {
// //                       setState(() {
// //                         hsnTypeValue = value;
// //                       });
// //                     },
// //                   ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),
// //                   SizedBox(height: 20),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                     children: [
// //                       Expanded(
// //                         child: OutlinedButton(
// //                           onPressed: () => Navigator.of(context).pop(),
// //                           child: Text('Cancel'),
// //                           style: OutlinedButton.styleFrom(
// //                             padding: EdgeInsets.symmetric(vertical: 16),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                           ),
// //                         ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
// //                       ),
// //                       SizedBox(width: 15),
// //                       Expanded(
// //                         child: ElevatedButton(
// //                           onPressed: addHsn,
// //                           child: Text('Add'),
// //                           style: ElevatedButton.styleFrom(
// //                             padding: EdgeInsets.symmetric(vertical: 16),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                           ),
// //                         ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ).animate().scale(curve: Curves.easeOutBack);
// //       },
// //     );
// //   }

// //   Widget _buildLoadingIndicator() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(
// //                 strokeWidth: 2,
// //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
// //               )
// //               .animate(onPlay: (controller) => controller.repeat())
// //               .rotate(duration: 1500.ms),
// //           SizedBox(height: 16),
// //           Text(
// //                 'Loading HSN Codes...',
// //                 style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
// //               )
// //               .animate(onPlay: (controller) => controller.repeat())
// //               .shimmer(delay: 1000.ms, duration: 1500.ms),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildHsnList() {
// //     final displayList = searchQuery.isEmpty ? hsnList : filteredHsnList;

// //     return ListView.builder(
// //       itemCount: displayList.length,
// //       itemBuilder: (context, index) {
// //         final hsn = displayList[index];
// //         return Dismissible(
// //           key: Key(hsn.id.toString()),
// //           background: Container(
// //             color: Colors.red,
// //             alignment: Alignment.centerRight,
// //             padding: EdgeInsets.only(right: 20),
// //             child: Icon(Icons.delete, color: Colors.white),
// //           ),
// //           direction: DismissDirection.endToStart,
// //           confirmDismiss: (direction) async {
// //             return await showDialog(
// //               context: context,
// //               builder: (BuildContext context) {
// //                 return AlertDialog(
// //                   title: Text("Confirm Delete"),
// //                   content: Text(
// //                     "Are you sure you want to delete HSN code ${hsn.hsnCode}?",
// //                   ),
// //                   actions: [
// //                     TextButton(
// //                       onPressed: () => Navigator.of(context).pop(false),
// //                       child: Text("Cancel"),
// //                     ),
// //                     TextButton(
// //                       onPressed: () => Navigator.of(context).pop(true),
// //                       child: Text(
// //                         "Delete",
// //                         style: TextStyle(color: Colors.red),
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             );
// //           },
// //           onDismissed: (direction) async {
// //             await deleteHsn(hsn.id);
// //           },
// //           child:
// //               Card(
// //                     margin: EdgeInsets.symmetric(
// //                       horizontal: 3.w,
// //                       vertical: 0.5.h,
// //                     ),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(6),
// //                     ),
// //                     color: Colors.white,
// //                     elevation: 2,
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(6),
// //                         gradient: LinearGradient(
// //                           colors: [Colors.white, Colors.grey.shade50],
// //                           begin: Alignment.topLeft,
// //                           end: Alignment.bottomRight,
// //                         ),
// //                       ),
// //                       child: ListTile(
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         title: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               hsn.hsnCode,
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 16.sp,
// //                                 color: Theme.of(context).primaryColor,
// //                               ),
// //                             ),
// //                             SizedBox(height: 1.h),
// //                           ],
// //                         ),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 _buildTaxPill(
// //                                   'SGST: ${hsn.sgst}%',
// //                                   Colors.blue.shade700,
// //                                 ),
// //                                 _buildTaxPill(
// //                                   'CGST: ${hsn.cgst}%',
// //                                   Colors.green.shade700,
// //                                 ),
// //                                 _buildTaxPill(
// //                                   'IGST: ${hsn.igst}%',
// //                                   Colors.orange.shade700,
// //                                 ),
// //                                 _buildTaxPill(
// //                                   'CESS: ${hsn.cess}%',
// //                                   Colors.purple.shade700,
// //                                 ),
// //                               ],
// //                             ),
// //                             if (hsn.hsnType != null) SizedBox(height: 8),
// //                             if (hsn.hsnType != null)
// //                               Text(
// //                                 'Type: ${hsn.hsnType}',
// //                                 style: TextStyle(
// //                                   fontSize: 14.sp,
// //                                   fontStyle: FontStyle.italic,
// //                                   color: Colors.grey.shade600,
// //                                 ),
// //                               ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   )
// //                   .animate()
// //                   .fadeIn(delay: (index * 100).ms)
// //                   .slideX(begin: 0.5, curve: Curves.easeOutQuart)
// //                   .scale(curve: Curves.easeOutBack),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildTaxPill(String text, Color color) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //       decoration: BoxDecoration(
// //         color: color,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Text(
// //         text,
// //         style: TextStyle(
// //           color: Colors.white,
// //           fontSize: 14.sp,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'HSN Codes',
// //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.sp),
// //         ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
// //         backgroundColor: Colors.blue.shade900,
// //         foregroundColor: Colors.white,
// //         elevation: 0,
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.refresh),
// //             onPressed: fetchHsnData,
// //             tooltip: 'Refresh',
// //           ).animate().fadeIn(duration: 300.ms),
// //         ],
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Colors.blue.shade50, Colors.grey.shade100],
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             // Search Bar
// //             Padding(
// //               padding: EdgeInsets.all(2.w),
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(12),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.1),
// //                       blurRadius: 8,
// //                       offset: Offset(0, 2),
// //                     ),
// //                   ],
// //                 ),
// //                 child: TextField(
// //                   controller: searchController,
// //                   decoration: InputDecoration(
// //                     hintText: 'Search by HSN code...',
// //                     prefixIcon: Icon(Icons.search, color: Colors.blue),
// //                     suffixIcon: searchQuery.isNotEmpty
// //                         ? IconButton(
// //                             icon: Icon(Icons.clear, color: Colors.grey),
// //                             onPressed: () {
// //                               searchController.clear();
// //                             },
// //                           )
// //                         : null,
// //                     border: InputBorder.none,
// //                     contentPadding: EdgeInsets.symmetric(
// //                       horizontal: 4.w,
// //                       vertical: 2.h,
// //                     ),
// //                   ),
// //                 ),
// //               ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),
// //             ),
// //             if (searchQuery.isNotEmpty)
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 4.w),
// //                 child: Row(
// //                   children: [
// //                     Text(
// //                       '${filteredHsnList.length} result(s) found',
// //                       style: TextStyle(
// //                         color: Colors.grey.shade600,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             SizedBox(height: 1.h),
// //             Expanded(
// //               child: isLoading
// //                   ? _buildLoadingIndicator()
// //                   : errorMessage.isNotEmpty
// //                   ? Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                             Icons.error_outline,
// //                             size: 64,
// //                             color: Colors.red,
// //                           ).animate().shake(duration: 600.ms, hz: 4),
// //                           SizedBox(height: 16),
// //                           Text(
// //                             errorMessage,
// //                             style: TextStyle(fontSize: 18, color: Colors.red),
// //                             textAlign: TextAlign.center,
// //                           ),
// //                           SizedBox(height: 16),
// //                           ElevatedButton(
// //                                 onPressed: fetchHsnData,
// //                                 style: ElevatedButton.styleFrom(
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                   ),
// //                                 ),
// //                                 child: Text('Retry'),
// //                               )
// //                               .animate()
// //                               .fadeIn(delay: 200.ms)
// //                               .scale(curve: Curves.easeOutBack),
// //                         ],
// //                       ),
// //                     )
// //                   : (searchQuery.isEmpty ? hsnList : filteredHsnList).isEmpty
// //                   ? Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                                 Icons.inventory_2_outlined,
// //                                 size: 64,
// //                                 color: Colors.grey,
// //                               )
// //                               .animate(
// //                                 onPlay: (controller) => controller.repeat(),
// //                               )
// //                               .scale(delay: 1000.ms, duration: 2000.ms)
// //                               .then(),
// //                           SizedBox(height: 16),
// //                           Text(
// //                             searchQuery.isEmpty
// //                                 ? 'No HSN codes found'
// //                                 : 'No matching HSN codes',
// //                             style: TextStyle(fontSize: 18, color: Colors.grey),
// //                           ),
// //                           SizedBox(height: 16),
// //                           if (searchQuery.isEmpty)
// //                             ElevatedButton(
// //                                   onPressed: _showAddHsnDialog,
// //                                   style: ElevatedButton.styleFrom(
// //                                     shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(12),
// //                                     ),
// //                                   ),
// //                                   child: Text('Add HSN Code'),
// //                                 )
// //                                 .animate()
// //                                 .fadeIn(delay: 200.ms)
// //                                 .scale(curve: Curves.easeOutBack),
// //                         ],
// //                       ),
// //                     )
// //                   : _buildHsnList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton:
// //           FloatingActionButton(
// //                 onPressed: _showAddHsnDialog,
// //                 tooltip: 'Add HSN',
// //                 backgroundColor: Theme.of(context).primaryColor,
// //                 foregroundColor: Colors.white,
// //                 elevation: 4,
// //                 child: Icon(Icons.add),
// //               )
// //               .animate()
// //               .scale(duration: 600.ms, curve: Curves.elasticOut)
// //               .then(delay: 200.ms)
// //               .shake(hz: 3, curve: Curves.easeInOut),
// //     );
// //   }
// // }

// // class HsnModel {
// //   final int id;
// //   final String hsnCode;
// //   final double sgst;
// //   final double cgst;
// //   final double igst;
// //   final double cess;
// //   final int? hsnType;
// //   final String? tenant;
// //   final String? tenantId;
// //   final DateTime created;
// //   final String createdBy;
// //   final DateTime? lastModified;
// //   final String? lastModifiedBy;
// //   final DateTime? deleted;
// //   final String? deletedBy;

// //   HsnModel({
// //     required this.id,
// //     required this.hsnCode,
// //     required this.sgst,
// //     required this.cgst,
// //     required this.igst,
// //     required this.cess,
// //     this.hsnType,
// //     this.tenant,
// //     this.tenantId,
// //     required this.created,
// //     required this.createdBy,
// //     this.lastModified,
// //     this.lastModifiedBy,
// //     this.deleted,
// //     this.deletedBy,
// //   });

// //   factory HsnModel.fromJson(Map<String, dynamic> json) {
// //     return HsnModel(
// //       id: json['id'] ?? 0,
// //       hsnCode: json['hsnCode'] ?? '',
// //       sgst: (json['sgst'] ?? 0).toDouble(),
// //       cgst: (json['cgst'] ?? 0).toDouble(),
// //       igst: (json['igst'] ?? 0).toDouble(),
// //       cess: (json['cess'] ?? 0).toDouble(),
// //       hsnType: json['hsnType'],
// //       tenant: json['tenant'],
// //       tenantId: json['tenantId'],
// //       created: DateTime.parse(json['created']),
// //       createdBy: json['createdBy'] ?? '',
// //       lastModified: json['lastModified'] != null
// //           ? DateTime.parse(json['lastModified'])
// //           : null,
// //       lastModifiedBy: json['lastModifiedBy'],
// //       deleted: json['deleted'] != null ? DateTime.parse(json['deleted']) : null,
// //       deletedBy: json['deletedBy'],
// //     );
// //   }
// // }


// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class HsnScreen extends StatefulWidget {
//   @override
//   _HsnScreenState createState() => _HsnScreenState();
// }

// class _HsnScreenState extends State<HsnScreen> {
//   List<HsnModel> hsnList = [];
//   List<HsnModel> filteredHsnList = [];
//   bool _isLoading = true;
//   bool _isSyncing = false;
//   String? _error;
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;

//   // Form controllers
//   final TextEditingController _hsnCodeController = TextEditingController();
//   final TextEditingController _sgstController = TextEditingController();
//   final TextEditingController _cgstController = TextEditingController();
//   final TextEditingController _igstController = TextEditingController();
//   final TextEditingController _cessController = TextEditingController();
//   int? _hsnTypeValue;

//   @override
//   void initState() {
//     super.initState();
//     _fetchHsnData();
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _hsnCodeController.dispose();
//     _sgstController.dispose();
//     _cgstController.dispose();
//     _igstController.dispose();
//     _cessController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     setState(() {
//       _filterHsnCodes();
//     });
//   }

//   void _filterHsnCodes() {
//     final query = _searchController.text.toLowerCase();
//     if (query.isEmpty) {
//       filteredHsnList = List.from(hsnList);
//     } else {
//       filteredHsnList = hsnList
//           .where((hsn) => hsn.hsnCode.toLowerCase().contains(query))
//           .toList();
//     }
//   }

//   Future<void> _fetchHsnData() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final response = await http
//           .get(
//             Uri.parse('http://202.140.138.215:85/api/HSNApi'),
//             headers: {'Content-Type': 'application/json'},
//           )
//           .timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data is List) {
//           setState(() {
//             hsnList = data.map((json) => HsnModel.fromJson(json)).toList();
//             _filterHsnCodes();
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _error = 'Invalid data format received';
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _error = 'Failed to load data: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _deleteHsn(int id) async {
//     try {
//       final response = await http
//           .delete(
//             Uri.parse('http://202.140.138.215:85/api/HSNApi/$id'),
//             headers: {'Content-Type': 'application/json'},
//           )
//           .timeout(Duration(seconds: 5));

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white, size: 20),
//                   SizedBox(width: 8),
//                   Text('HSN code deleted successfully'),
//                 ],
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }

//         await _fetchHsnData();
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.error, color: Colors.white, size: 20),
//                   SizedBox(width: 8),
//                   Text('Failed to delete HSN: ${response.statusCode}'),
//                 ],
//               ),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.error, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('Error deleting HSN: $e'),
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
//     }
//   }

//   Future<void> _addHsn() async {
//     if (_hsnCodeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.warning, color: Colors.white, size: 20),
//               SizedBox(width: 8),
//               Text('HSN Code is required'),
//             ],
//           ),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//       return;
//     }

//     final newHsn = {
//       "id": 0,
//       "hsnCode": _hsnCodeController.text,
//       "sgst": double.tryParse(_sgstController.text) ?? 0,
//       "cgst": double.tryParse(_cgstController.text) ?? 0,
//       "igst": double.tryParse(_igstController.text) ?? 0,
//       "cess": double.tryParse(_cessController.text) ?? 0,
//       "hsnType": _hsnTypeValue ?? 1,
//     };

//     setState(() {
//       _isSyncing = true;
//     });

//     try {
//       final response = await http
//           .post(
//             Uri.parse('http://202.140.138.215:85/api/HSNApi'),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode(newHsn),
//           )
//           .timeout(Duration(seconds: 5));

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white, size: 20),
//                   SizedBox(width: 8),
//                   Text('HSN added successfully'),
//                 ],
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }

//         // Clear form
//         _hsnCodeController.clear();
//         _sgstController.clear();
//         _cgstController.clear();
//         _igstController.clear();
//         _cessController.clear();
//         _hsnTypeValue = null;

//         // Refresh data
//         await _fetchHsnData();

//         // Close dialog
//         if (mounted) {
//           Navigator.of(context).pop();
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.error, color: Colors.white, size: 20),
//                   SizedBox(width: 8),
//                   Text('Failed to add HSN: ${response.statusCode}'),
//                 ],
//               ),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.error, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text('Error: $e'),
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
//         _isSyncing = false;
//       });
//     }
//   }

//   void _showAddHsnDialog() {
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
//               crossAxisAlignment: CrossAxisAlignment.stretch,
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
//                   child: Icon(
//                     Icons.add_chart,
//                     color: Colors.white,
//                     size: 32,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Add New HSN Code',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade800,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: _hsnCodeController,
//                   decoration: InputDecoration(
//                     labelText: 'HSN Code*',
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
//                     hintText: 'Enter HSN code',
//                     hintStyle: TextStyle(color: Colors.grey.shade500),
//                     prefixIcon: Container(
//                       margin: EdgeInsets.only(right: 8, left: 12),
//                       child: Icon(Icons.code, color: Colors.blue.shade600),
//                     ),
//                     prefixIconConstraints: BoxConstraints(minWidth: 40),
//                   ),
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
//                 ),
//                 SizedBox(height: 15),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _sgstController,
//                         decoration: InputDecoration(
//                           labelText: 'SGST %',
//                           labelStyle: TextStyle(
//                             color: Colors.blue.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.blue.shade300),
//                           ),
//                           filled: true,
//                           fillColor: Colors.blue.shade50,
//                           prefixIcon: Container(
//                             margin: EdgeInsets.only(right: 8, left: 12),
//                             child: Icon(Icons.percent,
//                                 color: Colors.blue.shade600),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 40),
//                         ),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: _cgstController,
//                         decoration: InputDecoration(
//                           labelText: 'CGST %',
//                           labelStyle: TextStyle(
//                             color: Colors.blue.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.blue.shade300),
//                           ),
//                           filled: true,
//                           fillColor: Colors.blue.shade50,
//                           prefixIcon: Container(
//                             margin: EdgeInsets.only(right: 8, left: 12),
//                             child: Icon(Icons.percent,
//                                 color: Colors.blue.shade600),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 40),
//                         ),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _igstController,
//                         decoration: InputDecoration(
//                           labelText: 'IGST %',
//                           labelStyle: TextStyle(
//                             color: Colors.blue.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.blue.shade300),
//                           ),
//                           filled: true,
//                           fillColor: Colors.blue.shade50,
//                           prefixIcon: Container(
//                             margin: EdgeInsets.only(right: 8, left: 12),
//                             child: Icon(Icons.percent,
//                                 color: Colors.blue.shade600),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 40),
//                         ),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: _cessController,
//                         decoration: InputDecoration(
//                           labelText: 'CESS %',
//                           labelStyle: TextStyle(
//                             color: Colors.blue.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.blue.shade300),
//                           ),
//                           filled: true,
//                           fillColor: Colors.blue.shade50,
//                           prefixIcon: Container(
//                             margin: EdgeInsets.only(right: 8, left: 12),
//                             child: Icon(Icons.percent,
//                                 color: Colors.blue.shade600),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 40),
//                         ),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 DropdownButtonFormField<int>(
//                   value: _hsnTypeValue,
//                   decoration: InputDecoration(
//                     labelText: 'HSN Type',
//                     labelStyle: TextStyle(
//                       color: Colors.blue.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.blue.shade300),
//                     ),
//                     filled: true,
//                     fillColor: Colors.blue.shade50,
//                     prefixIcon: Container(
//                       margin: EdgeInsets.only(right: 8, left: 12),
//                       child: Icon(Icons.category, color: Colors.blue.shade600),
//                     ),
//                     prefixIconConstraints: BoxConstraints(minWidth: 40),
//                   ),
//                   items: [
//                     DropdownMenuItem(
//                       value: 1,
//                       child: Text('Type 1',
//                           style: TextStyle(color: Colors.grey.shade800)),
//                     ),
//                     DropdownMenuItem(
//                       value: 2,
//                       child: Text('Type 2',
//                           style: TextStyle(color: Colors.grey.shade800)),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _hsnTypeValue = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: _isSyncing
//                             ? null
//                             : () => Navigator.of(context).pop(),
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
//                         onPressed: _isSyncing ? null : _addHsn,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: _isSyncing
//                             ? SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 3,
//                                   valueColor:
//                                       AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               )
//                             : Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.add, size: 20),
//                                   SizedBox(width: 8),
//                                   Text('Add HSN'),
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

//   void _showDeleteConfirmationDialog(HsnModel hsn) {
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
//                   'Delete HSN Code?',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Are you sure you want to delete "${hsn.hsnCode}"?',
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
//                           await _deleteHsn(hsn.id);

//                           if (mounted) {
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
//                                     Text('HSN "${hsn.hsnCode}" deleted'),
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

//   Widget _buildTaxPill(String text, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
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
//               shadowColor: Color(0xff016B61).withOpacity(0.4),
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
//                           'HSN Codes',
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
//                           'Manage HSN codes with tax rates',
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
//                         hintText: 'Search HSN code...',
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
//                               filteredHsnList = List.from(hsnList);
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
//                   icon: Icon(Icons.refresh, size: 22),
//                   onPressed: _fetchHsnData,
//                   tooltip: 'Refresh',
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
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddHsnDialog,
//         backgroundColor: Color(0xff016B61),
//         foregroundColor: Colors.white,
//         elevation: 6,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Icon(Icons.add, size: 28),
//       ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
//     );
//   }

//   Widget _buildBody() {
//     final displayList = _isSearching ? filteredHsnList : hsnList;

//     if (_isLoading && hsnList.isEmpty) {
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
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xff016B61)),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Loading HSN codes...',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ).animate(onPlay: (controller) => controller.repeat()).shimmer(
//                   delay: 1000.ms,
//                   duration: 1500.ms,
//                 ),
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
//                 onPressed: _fetchHsnData,
//                 icon: Icon(Icons.refresh, size: 20),
//                 label: Text('Try Again'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xff016B61),
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

//     if (hsnList.isEmpty) {
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
//                       Color(0xff016B61).withOpacity(0.1),
//                       Color(0xff016B61).withOpacity(0.2),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.inventory_2,
//                   size: 60,
//                   color: Color(0xff016B61),
//                 ),
//               ).animate(onPlay: (controller) => controller.repeat()).scale(
//                     delay: 1000.ms,
//                     duration: 2000.ms,
//                   ),
//               SizedBox(height: 24),
//               Text(
//                 'No HSN Codes Found',
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
//                   'Get started by adding your first HSN code with tax rates',
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _showAddHsnDialog,
//                 icon: Icon(Icons.add, size: 20),
//                 label: Text('Add First HSN'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xff016B61),
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
//         filteredHsnList.isEmpty &&
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
//                 'No HSN codes found for "${_searchController.text}"',
//                 style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchHsnData,
//       backgroundColor: Colors.white,
//       color: Color(0xff016B61),
//       displacement: 40,
//       edgeOffset: 20,
//       strokeWidth: 2.5,
//       child: ListView.builder(
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
//         itemCount: displayList.length,
//         itemBuilder: (context, index) {
//           final hsn = displayList[index];
//           return _buildHsnItem(hsn, index);
//         },
//       ),
//     );
//   }

//   Widget _buildHsnItem(HsnModel hsn, int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         elevation: 1,
//         shadowColor: Colors.grey.withOpacity(0.1),
//         child: InkWell(
//           onLongPress: () {
//             _showDeleteConfirmationDialog(hsn);
//           },
//           borderRadius: BorderRadius.circular(16),
//           splashColor: Color(0xff016B61).withOpacity(0.1),
//           highlightColor: Color(0xff016B61).withOpacity(0.05),
//           child: Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             _getColorFromIndex(index),
//                             _getColorFromIndex(index).withOpacity(0.8),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: _getColorFromIndex(index).withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: Offset(2, 2),
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: Text(
//                           hsn.hsnCode.isNotEmpty
//                               ? hsn.hsnCode[0].toUpperCase()
//                               : 'H',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             hsn.hsnCode,
//                             style: TextStyle(
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey.shade800,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           if (hsn.hsnType != null) ...[
//                             SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.category,
//                                   size: 12,
//                                   color: Colors.grey.shade500,
//                                 ),
//                                 SizedBox(width: 6),
//                                 Text(
//                                   'Type: ${hsn.hsnType}',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       icon: Container(
//                         width: 36,
//                         height: 36,
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           Icons.delete_outline,
//                           size: 18,
//                           color: Colors.red.shade600,
//                         ),
//                       ),
//                       onPressed: () {
//                         _showDeleteConfirmationDialog(hsn);
//                       },
//                       tooltip: 'Delete HSN',
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _buildTaxPill(
//                       'SGST: ${hsn.sgst}%',
//                       Colors.blue.shade600,
//                     ),
//                     _buildTaxPill(
//                       'CGST: ${hsn.cgst}%',
//                       Colors.green.shade600,
//                     ),
//                     _buildTaxPill(
//                       'IGST: ${hsn.igst}%',
//                       Colors.orange.shade600,
//                     ),
//                     _buildTaxPill(
//                       'CESS: ${hsn.cess}%',
//                       Colors.purple.shade600,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ).animate().fadeIn(delay: (index * 100).ms).slideX(
//             begin: 0.5,
//             curve: Curves.easeOutQuart,
//           ),
//     );
//   }

//   Color _getColorFromIndex(int index) {
//     final colors = [
//       Color(0xff016B61),
//       Colors.blue.shade600,
//       Colors.green.shade600,
//       Colors.orange.shade600,
//       Colors.purple.shade600,
//       Colors.red.shade600,
//       Colors.teal.shade600,
//       Colors.pink.shade600,
//       Colors.indigo.shade600,
//       Colors.cyan.shade600,
//     ];
//     return colors[index % colors.length];
//   }
// }

// class HsnModel {
//   final int id;
//   final String hsnCode;
//   final double sgst;
//   final double cgst;
//   final double igst;
//   final double cess;
//   final int? hsnType;
//   final String? tenant;
//   final String? tenantId;
//   final DateTime created;
//   final String createdBy;
//   final DateTime? lastModified;
//   final String? lastModifiedBy;
//   final DateTime? deleted;
//   final String? deletedBy;

//   HsnModel({
//     required this.id,
//     required this.hsnCode,
//     required this.sgst,
//     required this.cgst,
//     required this.igst,
//     required this.cess,
//     this.hsnType,
//     this.tenant,
//     this.tenantId,
//     required this.created,
//     required this.createdBy,
//     this.lastModified,
//     this.lastModifiedBy,
//     this.deleted,
//     this.deletedBy,
//   });

//   factory HsnModel.fromJson(Map<String, dynamic> json) {
//     return HsnModel(
//       id: json['id'] ?? 0,
//       hsnCode: json['hsnCode'] ?? '',
//       sgst: (json['sgst'] ?? 0).toDouble(),
//       cgst: (json['cgst'] ?? 0).toDouble(),
//       igst: (json['igst'] ?? 0).toDouble(),
//       cess: (json['cess'] ?? 0).toDouble(),
//       hsnType: json['hsnType'],
//       tenant: json['tenant'],
//       tenantId: json['tenantId'],
//       created: DateTime.parse(json['created']),
//       createdBy: json['createdBy'] ?? '',
//       lastModified: json['lastModified'] != null
//           ? DateTime.parse(json['lastModified'])
//           : null,
//       lastModifiedBy: json['lastModifiedBy'],
//       deleted:
//           json['deleted'] != null ? DateTime.parse(json['deleted']) : null,
//       deletedBy: json['deletedBy'],
//     );
//   }
// }


// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/repository/hsn_repo.dart';
import 'dart:convert';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/hsn_entity.dart';

class HsnScreen extends StatefulWidget {
  const HsnScreen({super.key});

  @override
  _HsnScreenState createState() => _HsnScreenState();
}

class _HsnScreenState extends State<HsnScreen> {
  List<HsnEntity> _hsnList = [];
  List<HsnEntity> _filteredHsnList = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late HsnRepository _hsnRepository;
  Timer? _syncTimer;

  // Sync statistics
  int _totalRecords = 0;
  int _syncedRecords = 0;
  int _pendingRecords = 0;

  // Form controllers
  final TextEditingController _hsnCodeController = TextEditingController();
  final TextEditingController _sgstController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  final TextEditingController _igstController = TextEditingController();
  final TextEditingController _cessController = TextEditingController();
  int? _hsnTypeValue;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _searchController.addListener(() {
      _filterHsnCodes(_searchController.text);
    });

    // Auto sync every 30 seconds
    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _syncDataSilently();
    });
  }

  Future<void> _initializeDatabase() async {
    final db = await DatabaseProvider.database;
    _hsnRepository = HsnRepository(db.hsnDao);
    _loadLocalHsnCodes();
    _loadSyncStats();
    _syncFromServer();
  }

  Future<void> _loadLocalHsnCodes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final hsnCodes = await _hsnRepository.getAllHsnCodes();
      print('Loaded ${hsnCodes.length} HSN codes from database');
      
      setState(() {
        _hsnList = hsnCodes;
        _filteredHsnList = List.from(_hsnList);
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
    final stats = await _hsnRepository.getSyncStats();
    setState(() {
      _totalRecords = stats['total'] ?? 0;
      _syncedRecords = stats['synced'] ?? 0;
      _pendingRecords = stats['pending'] ?? 0;
    });
  }

  Future<void> _syncFromServer() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final response = await http
          .get(
            Uri.parse('http://202.140.138.215:85/api/HSNApi'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data is List) {
          final List<Map<String, dynamic>> hsnList = data
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

          await _hsnRepository.syncFromServer(hsnList);

          await _loadLocalHsnCodes();
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
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
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
      final pendingHsn = await _hsnRepository.getPendingSync();

      for (final hsn in pendingHsn) {
        if (hsn.isDeleted) {
          if (hsn.serverId != null) {
            await _deleteFromServer(hsn.serverId!);
            await _hsnRepository.markAsSynced(hsn.id!);
          } else {
            await _hsnRepository.markAsSynced(hsn.id!);
          }
        } else if (hsn.serverId == null) {
          final serverId = await _addToServer(hsn);
          if (serverId != null) {
            // hsn.serverId = serverId;
            await _hsnRepository.updateHsn(hsn);
            await _hsnRepository.markAsSynced(hsn.id!);
          }
        } else {
          final success = await _updateOnServer(hsn);
          if (success) {
            await _hsnRepository.markAsSynced(hsn.id!);
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

  Future<int?> _addToServer(HsnEntity hsn) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://202.140.138.215:85/api/HSNApi'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(hsn.toServerJson()),
          )
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['id'] as int?;
      }
    } catch (e) {
      print('Add to server failed: $e');
      await _hsnRepository.markAsFailed(hsn.id!, e.toString());
    }
    return null;
  }

  Future<bool> _updateOnServer(HsnEntity hsn) async {
    try {
      final response = await http
          .put(
            Uri.parse('http://202.140.138.215:85/api/HSNApi/${hsn.serverId}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(hsn.toServerJson()),
          )
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        return true;
      } else {
        await _hsnRepository.markAsFailed(hsn.id!, 'Update failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Update on server failed: $e');
      await _hsnRepository.markAsFailed(hsn.id!, e.toString());
    }
    return false;
  }

  Future<bool> _deleteFromServer(int serverId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('http://202.140.138.215:85/api/HSNApi/$serverId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete from server failed: $e');
      return false;
    }
  }

  void _filterHsnCodes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHsnList = List.from(_hsnList);
      } else {
        _filteredHsnList = _hsnList
            .where((hsn) =>
                hsn.hsnCode.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _addHsn() async {
    if (_hsnCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('HSN Code is required'),
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
      _isSyncing = true;
    });

    try {
      final hsn = HsnEntity(
        hsnCode: _hsnCodeController.text,
        sgst: double.tryParse(_sgstController.text) ?? 0,
        cgst: double.tryParse(_cgstController.text) ?? 0,
        igst: double.tryParse(_igstController.text) ?? 0,
        cess: double.tryParse(_cessController.text) ?? 0,
        hsnType: _hsnTypeValue,
        createdAt: DateTime.now().toIso8601String(),
        createdBy: 'User',
        isSynced: false,
      );

      await _hsnRepository.insertHsn(hsn);

      await _loadLocalHsnCodes();
      await _loadSyncStats();

      await _syncPendingChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.save, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${_hsnCodeController.text} saved locally'),
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
        _isSyncing = false;
        // Clear form and close dialog
        _hsnCodeController.clear();
        _sgstController.clear();
        _cgstController.clear();
        _igstController.clear();
        _cessController.clear();
        _hsnTypeValue = null;
        
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  Future<bool> _deleteHsn(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _hsnRepository.deleteHsn(id);
      await _loadLocalHsnCodes();
      await _loadSyncStats();

      await _syncPendingChanges();

      return true;
    } catch (e) {
      setState(() {
        _error = 'Failed to delete HSN: $e';
      });
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddHsnDialog() {
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  child: Icon(
                    Icons.add_chart,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Add New HSN Code',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _hsnCodeController,
                  decoration: InputDecoration(
                    labelText: 'HSN Code*',
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
                    hintText: 'Enter HSN code',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(Icons.code, color: Colors.blue.shade600),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _sgstController,
                        decoration: InputDecoration(
                          labelText: 'SGST %',
                          labelStyle: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          prefixIcon: Container(
                            margin: EdgeInsets.only(right: 8, left: 12),
                            child: Icon(Icons.percent,
                                color: Colors.blue.shade600),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _cgstController,
                        decoration: InputDecoration(
                          labelText: 'CGST %',
                          labelStyle: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          prefixIcon: Container(
                            margin: EdgeInsets.only(right: 8, left: 12),
                            child: Icon(Icons.percent,
                                color: Colors.blue.shade600),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _igstController,
                        decoration: InputDecoration(
                          labelText: 'IGST %',
                          labelStyle: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          prefixIcon: Container(
                            margin: EdgeInsets.only(right: 8, left: 12),
                            child: Icon(Icons.percent,
                                color: Colors.blue.shade600),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _cessController,
                        decoration: InputDecoration(
                          labelText: 'CESS %',
                          labelStyle: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                          prefixIcon: Container(
                            margin: EdgeInsets.only(right: 8, left: 12),
                            child: Icon(Icons.percent,
                                color: Colors.blue.shade600),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<int>(
                  value: _hsnTypeValue,
                  decoration: InputDecoration(
                    labelText: 'HSN Type',
                    labelStyle: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(Icons.category, color: Colors.blue.shade600),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Type 1',
                          style: TextStyle(color: Colors.grey.shade800)),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('Type 2',
                          style: TextStyle(color: Colors.grey.shade800)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _hsnTypeValue = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSyncing
                            ? null
                            : () => Navigator.of(context).pop(),
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
                        onPressed: _isSyncing ? null : _addHsn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSyncing
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 20),
                                  SizedBox(width: 8),
                                  Text('Add HSN'),
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

  void _showDeleteConfirmationDialog(HsnEntity hsn) {
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
                  'Delete HSN Code?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${hsn.hsnCode}"?',
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
                          final success = await _deleteHsn(hsn.id!);

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
                                    Text('HSN "${hsn.hsnCode}" deleted'),
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
                                    Text('Failed to delete HSN'),
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
                        'Total HSN Codes',
                        '$_totalRecords',
                        Icons.list_alt,
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

  Widget _buildTaxPill(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hsnCodeController.dispose();
    _sgstController.dispose();
    _cgstController.dispose();
    _igstController.dispose();
    _cessController.dispose();
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
              shadowColor: Color(0xff016B61).withOpacity(0.4),
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
                          'HSN Codes',
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
                          'Manage HSN codes with tax rates',
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
                        hintText: 'Search HSN code...',
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
                              _filteredHsnList = List.from(_hsnList);
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
          if (_pendingRecords > 0)
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: FloatingActionButton.extended(
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
            onPressed: _showAddHsnDialog,
            backgroundColor: Color(0xff016B61),
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
    final displayList = _isSearching ? _filteredHsnList : _hsnList;

    if (_isLoading && _hsnList.isEmpty) {
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff016B61)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Loading HSN codes...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                  delay: 1000.ms,
                  duration: 1500.ms,
                ),
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
                onPressed: _loadLocalHsnCodes,
                icon: Icon(Icons.refresh, size: 20),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff016B61),
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

    if (_hsnList.isEmpty) {
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
                      Color(0xff016B61).withOpacity(0.1),
                      Color(0xff016B61).withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2,
                  size: 60,
                  color: Color(0xff016B61),
                ),
              ).animate(onPlay: (controller) => controller.repeat()).scale(
                    delay: 1000.ms,
                    duration: 2000.ms,
                  ),
              SizedBox(height: 24),
              Text(
                'No HSN Codes Found',
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
                  'Get started by adding your first HSN code with tax rates',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showAddHsnDialog,
                icon: Icon(Icons.add, size: 20),
                label: Text('Add First HSN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff016B61),
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
        _filteredHsnList.isEmpty &&
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
                'No HSN codes found for "${_searchController.text}"',
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
      color: Color(0xff016B61),
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final hsn = displayList[index];
          return _buildHsnItem(hsn, index);
        },
      ),
    );
  }

  Widget _buildHsnItem(HsnEntity hsn, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.1),
        child: InkWell(
          onLongPress: () {
            _showDeleteConfirmationDialog(hsn);
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Color(0xff016B61).withOpacity(0.1),
          highlightColor: Color(0xff016B61).withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        child: Text(
                          hsn.hsnCode.isNotEmpty
                              ? hsn.hsnCode[0].toUpperCase()
                              : 'H',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
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
                                  hsn.hsnCode,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!hsn.isSynced)
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
                          if (hsn.hsnType != null) ...[
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  size: 12,
                                  color: Colors.grey.shade500,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Type: ${hsn.hsnType}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (hsn.createdAt != null) ...[
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.grey.shade500,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Added: ${_formatDate(hsn.createdAt!)}',
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
                        _showDeleteConfirmationDialog(hsn);
                      },
                      tooltip: 'Delete HSN',
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTaxPill(
                      'SGST: ${hsn.sgst}%',
                      Colors.blue.shade600,
                    ),
                    _buildTaxPill(
                      'CGST: ${hsn.cgst}%',
                      Colors.green.shade600,
                    ),
                    _buildTaxPill(
                      'IGST: ${hsn.igst}%',
                      Colors.orange.shade600,
                    ),
                    _buildTaxPill(
                      'CESS: ${hsn.cess}%',
                      Colors.purple.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: (index * 100).ms).slideX(
            begin: 0.5,
            curve: Curves.easeOutQuart,
          ),
    );
  }

  Color _getColorFromIndex(int index) {
    final colors = [
      Color(0xff016B61),
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.red.shade600,
      Colors.teal.shade600,
      Colors.pink.shade600,
      Colors.indigo.shade600,
      Colors.cyan.shade600,
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