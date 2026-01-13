// // // ignore_for_file: depend_on_referenced_packages, deprecated_member_use, avoid_print, use_build_context_synchronously, library_private_types_in_public_api

// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:intl/intl.dart';
// // import 'package:responsive_sizer/responsive_sizer.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:camera/camera.dart';
// // import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

// // class CreateNewItemScreeen extends StatefulWidget {
// //   const CreateNewItemScreeen({super.key});

// //   @override
// //   State<CreateNewItemScreeen> createState() => _CreateNewItemScreeenState();
// // }

// // class _CreateNewItemScreeenState extends State<CreateNewItemScreeen>
// //     with SingleTickerProviderStateMixin {
// //   bool isProduct = true;
// //   final List<String> _chartOptions = ['Without Tax', 'With Tax'];
// //   String _selectedChart = 'Without Tax';
// //   late TabController _tabController;

// //   final List<String> _productTabs = [
// //     'Pricing',
// //     'Stock',
// //     'Other',
// //     'Party Wise Prices',
// //   ];
// //   final List<String> _serviceTabs = ['Pricing', 'Other', 'Party Wise Prices'];

// //   // Form controllers
// //   final TextEditingController _itemNameController = TextEditingController();
// //   final TextEditingController _itemCodeController = TextEditingController();
// //   final TextEditingController _barcodeController = TextEditingController();
// //   final TextEditingController _salesPriceController = TextEditingController();
// //   final TextEditingController _purchasePriceController =
// //       TextEditingController();
// //   final TextEditingController _stockController = TextEditingController();
// //   final TextEditingController _hsnCodeController = TextEditingController();
// //   final TextEditingController _descriptionController = TextEditingController();
// //   final TextEditingController _packingController = TextEditingController();
// //   final TextEditingController _mrpController = TextEditingController();
// //   final TextEditingController _salesRate2Controller = TextEditingController();
// //   final TextEditingController _minimumQtyController = TextEditingController();
// //   final TextEditingController _maximumQtyController = TextEditingController();
// //   final TextEditingController _shelfLifeController = TextEditingController();
// //   final TextEditingController _maximumDiscountController =
// //       TextEditingController();
// //   final TextEditingController _conversionController = TextEditingController();

// //   HsnModel? _selectedHsn;
// //   List<Category> _categories = [];
// //   List<SubCategory> _subCategories = [];
// //   Category? _selectedCategory;
// //   SubCategory? _selectedSubCategory;
// //   Map<String, dynamic>? _selectedDivision;
// //   Map<String, dynamic>? _selectedCompany;
// //   bool _decimalAllowed = false;
// //   bool _isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(
// //       length: isProduct ? _productTabs.length : _serviceTabs.length,
// //       vsync: this,
// //     );
// //     _generateItemCode();
// //     _loadCategories();
// //   }

// //   void _generateItemCode() {
// //     final timestamp = DateTime.now().millisecondsSinceEpoch;
// //     _itemCodeController.text = 'ITEM${timestamp.toString().substring(9)}';
// //   }

// //   Future<void> _loadCategories() async {
// //     try {
// //       final categoryResponse = await http.get(
// //         Uri.parse('http://202.140.138.215:85/api/CategoryMasterApi'),
// //       );
// //       if (categoryResponse.statusCode == 200) {
// //         final Map<String, dynamic> categoryData = json.decode(
// //           categoryResponse.body,
// //         );
// //         if (categoryData['success'] == true) {
// //           final List<dynamic> categoryList = categoryData['data'];
// //           setState(() {
// //             _categories =
// //                 categoryList.map((json) => Category.fromJson(json)).toList();
// //           });
// //         }
// //       }

// //       final subCategoryResponse = await http.get(
// //         Uri.parse('http://202.140.138.215:85/api/SubCategoryApi/all'),
// //       );

// //       if (subCategoryResponse.statusCode == 200) {
// //         final List<dynamic> subCategoryData = json.decode(
// //           subCategoryResponse.body,
// //         );
// //         setState(() {
// //           _subCategories =
// //               subCategoryData
// //                   .map((json) => SubCategory.fromJson(json))
// //                   .toList();
// //         });
// //       }
// //     } catch (e) {
// //       print('Error loading categories: $e');
// //     }
// //   }

// //   @override
// //   void didUpdateWidget(covariant CreateNewItemScreeen oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if ((isProduct && _tabController.length != _productTabs.length) ||
// //         (!isProduct && _tabController.length != _serviceTabs.length)) {
// //       _tabController.dispose();
// //       _tabController = TabController(
// //         length: isProduct ? _productTabs.length : _serviceTabs.length,
// //         vsync: this,
// //       );
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     _itemNameController.dispose();
// //     _itemCodeController.dispose();
// //     _barcodeController.dispose();
// //     _salesPriceController.dispose();
// //     _purchasePriceController.dispose();
// //     _stockController.dispose();
// //     _hsnCodeController.dispose();
// //     _descriptionController.dispose();
// //     _packingController.dispose();
// //     _mrpController.dispose();
// //     _salesRate2Controller.dispose();
// //     _minimumQtyController.dispose();
// //     _maximumQtyController.dispose();
// //     _shelfLifeController.dispose();
// //     _maximumDiscountController.dispose();
// //     _conversionController.dispose();
// //     super.dispose();
// //   }

// //   void _toggleItemType(bool isProductSelected) {
// //     if (isProduct != isProductSelected) {
// //       setState(() {
// //         isProduct = isProductSelected;
// //       });
// //     }
// //   }

// //   Future<void> _openBarcodeScanner() async {
// //     final scannedBarcode = await Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => BarcodeScannerForItemScreen()),
// //     );
// //     if (scannedBarcode != null && scannedBarcode is String) {
// //       setState(() {
// //         _barcodeController.text = scannedBarcode;
// //       });
// //     }
// //   }

// //   final List<String> _units = [
// //     'kg',
// //     'g',
// //     'mg',
// //     'ltr',
// //     'ml',
// //     'pcs',
// //     'box',
// //     'carton',
// //     'dozen',
// //     'pair',
// //     'set',
// //     'pack',
// //     'bottle',
// //     'can',
// //     'jar',
// //     'bag',
// //     'roll',
// //     'meter',
// //     'cm',
// //     'mm',
// //     'inch',
// //     'feet',
// //     'yard',
// //     'sq. ft',
// //     'sq. m',
// //     'gram',
// //     'kilogram',
// //     'liter',
// //     'milliliter',
// //     'ton',
// //     'quintal',
// //     'ounce',
// //     'pound',
// //     'gallon',
// //     'unit',
// //     'piece',
// //     'each',
// //     'bundle',
// //     'packet',
// //     'ream',
// //     'sheet',
// //     'book',
// //     'tube',
// //     'capsule',
// //     'tablet',
// //     'vial',
// //     'ampoule',
// //     'syringe',
// //   ];

// //   String _selectedUnit = 'kg';

// //   Future<void> _submitItemData() async {
// //     if (_itemNameController.text.isEmpty) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Item Name is required')));
// //       return;
// //     }

// //     if (_selectedCategory == null) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Category is required')));
// //       return;
// //     }

// //     setState(() {
// //       _isLoading = true;
// //     });
// //     final Map<String, dynamic> requestData = {
// //       "Id": 0,
// //       "Name": _itemNameController.text.trim(),
// //       "Code": _itemCodeController.text.trim(),
// //       "Barcode":
// //           _barcodeController.text.trim().isNotEmpty
// //               ? _barcodeController.text.trim()
// //               : null,
// //       "Unit1": _selectedUnit.toUpperCase(),
// //       "Unit2": 1, 
// //       "Packing":
// //           _packingController.text.trim().isNotEmpty
// //               ? _packingController.text.trim()
// //               : null,
// //       "CategoryId": _selectedCategory?.id ?? 0,
// //       "Category": null,
// //       "SubCategoryId": _selectedSubCategory?.id,
// //       "SubCategory": _selectedSubCategory?.name,
// //       "DivisionId": _selectedDivision?['id'],
// //       "Division": _selectedDivision?['name'],
// //       "HsnId": _selectedHsn?.id,
// //       "Hsn": _selectedHsn?.hsnCode,
// //       "CompanyId": _selectedCompany?['id'],
// //       "Company": _selectedCompany?['name'],
// //       "Mrp": int.tryParse(_mrpController.text) ?? 0,
// //       "SalesRate1": int.tryParse(_salesPriceController.text) ?? 0,
// //       "SalesRate2": int.tryParse(_salesRate2Controller.text) ?? 0,
// //       "MinimumQty": int.tryParse(_minimumQtyController.text) ?? 0,
// //       "MaximumQty": int.tryParse(_maximumQtyController.text) ?? 0,
// //       "ShelfLife": int.tryParse(_shelfLifeController.text) ?? 0,
// //       "MaximumDiscount": int.tryParse(_maximumDiscountController.text) ?? 0,
// //       "DecemalAllowed": _decimalAllowed,
// //       "Conversion": int.tryParse(_conversionController.text) ?? 0,
// //       "photo": _selectedImage,
// //     };

// //     print('=== API REQUEST DATA ===');
// //     print('URL: http://202.140.138.215:85/api/ItemMasterApi');
// //     print('Request Body: ${json.encode(requestData)}');

// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final String? authToken = prefs.getString('authToken');

// //       final Map<String, String> headers = {
// //         'Content-Type': 'application/json; charset=UTF-8',
// //       };

// //       if (authToken != null && authToken.isNotEmpty) {
// //         headers['Authorization'] = 'Bearer $authToken';
// //         print('Using auth token');
// //       }

// //       final response = await http.post(
// //         Uri.parse('http://202.140.138.215:85/api/ItemMasterApi'),
// //         headers: headers,
// //         body: json.encode(requestData),
// //       );

// //       print('=== API RESPONSE ===');
// //       print('Status Code: ${response.statusCode}');
// //       print('Response Body: ${response.body}');
// //       print('Response Body image: ${_selectedImage}');

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final responseData = json.decode(response.body);
// //         if (responseData['success'] == true) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(
// //                 '✅ ${responseData['message'] ?? 'Item saved successfully!'}',
// //               ),
// //               backgroundColor: Colors.green,
// //               duration: Duration(seconds: 3),
// //             ),
// //           );
// //           Navigator.pop(context);
// //           _clearForm();
// //         } else {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(
// //                 '❌ ${responseData['message'] ?? 'Failed to save item'}',
// //               ),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //         }
// //       } else if (response.statusCode == 500) {
// //         // Try progressive testing
// //         await _testProgressiveRequests(authToken);
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(
// //               'Failed with status: ${response.statusCode}\n${response.body}',
// //             ),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       print('Error: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Network Error: $e'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   Future<void> _testProgressiveRequests(String? authToken) async {
// //     print('\n=== PROGRESSIVE TESTING ===');

// //     final Map<String, String> headers = {
// //       'Content-Type': 'application/json; charset=UTF-8',
// //     };

// //     if (authToken != null && authToken.isNotEmpty) {
// //       headers['Authorization'] = 'Bearer $authToken';
// //     }

// //     // Test 1: Minimal working request
// //     final Map<String, dynamic> test1 = {
// //       "Id": 0,
// //       "Name": "Test Item ${DateTime.now().millisecondsSinceEpoch}",
// //       "Code":
// //           "TEST${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}",
// //       "Unit1": "PCS",
// //       "CategoryId": _selectedCategory?.id ?? 12,
// //       "SalesRate1": 100,
// //       "Mrp": 120,
// //     };

// //     // Test 2: Add Unit2 and Packing
// //     final Map<String, dynamic> test2 = {
// //       ...test1,
// //       "Unit2": null,
// //       "Packing": "500",
// //     };

// //     // Test 3: Add Barcode
// //     final Map<String, dynamic> test3 = {...test2, "Barcode": "TESTBARCODE"};

// //     // Test 4: Add SubCategory
// //     final Map<String, dynamic> test4 = {
// //       ...test3,
// //       "SubCategoryId": _selectedSubCategory?.id,
// //       "SubCategory": _selectedSubCategory?.name,
// //     };

// //     // Test 5: Add Division
// //     final Map<String, dynamic> test5 = {
// //       ...test4,
// //       "DivisionId": null,
// //       "Division": "",
// //     };

// //     final Map<String, dynamic> test6 = {
// //       ...test5,
// //       "HsnId": _selectedHsn?.id,
// //       "Hsn": _selectedHsn?.hsnCode,
// //     };

// //     // Test 7: Add Company
// //     final Map<String, dynamic> test7 = {
// //       ...test6,
// //       "CompanyId": _selectedCompany?['id'],
// //       "Company": _selectedCompany?['name'],
// //     };

// //     // Test 8: Add quantity fields
// //     final Map<String, dynamic> test8 = {
// //       ...test7,
// //       "MinimumQty": 1,
// //       "MaximumQty": 100,
// //       "ShelfLife": 365,
// //       "MaximumDiscount": 5,
// //       "DecemalAllowed": true,
// //       "Conversion": 1,
// //     };

// //     final List<Map<String, dynamic>> tests = [
// //       test1,
// //       test2,
// //       test3,
// //       test4,
// //       test5,
// //       test6,
// //       test7,
// //       test8,
// //     ];

// //     for (int i = 0; i < tests.length; i++) {
// //       print('\n--- Test ${i + 1}: Adding ${_getTestDescription(i)} ---');
// //       print('Request: ${json.encode(tests[i])}');

// //       try {
// //         final response = await http.post(
// //           Uri.parse('http://202.140.138.215:85/api/ItemMasterApi'),
// //           headers: headers,
// //           body: json.encode(tests[i]),
// //         );

// //         print('Status: ${response.statusCode}');

// //         if (response.statusCode == 200 || response.statusCode == 201) {
// //           print('✅ Test ${i + 1} SUCCESS');
// //           if (i == tests.length - 1) {
// //             print('✅ All fields work!');
// //           }
// //         } else {
// //           print('❌ Test ${i + 1} FAILED at: ${_getTestDescription(i)}');
// //           print('Response: ${response.body}');
// //           break;
// //         }
// //       } catch (e) {
// //         print('❌ Test ${i + 1} ERROR: $e');
// //         break;
// //       }

// //       await Future.delayed(Duration(milliseconds: 200));
// //     }
// //   }

// //   String _getTestDescription(int index) {
// //     switch (index) {
// //       case 0:
// //         return "Minimal fields";
// //       case 1:
// //         return "Unit2 & Packing";
// //       case 2:
// //         return "Barcode";
// //       case 3:
// //         return "SubCategory";
// //       case 4:
// //         return "Division";
// //       case 5:
// //         return "HSN";
// //       case 6:
// //         return "Company";
// //       case 7:
// //         return "Quantity fields";
// //       default:
// //         return "Unknown";
// //     }
// //   }

// //   void _clearForm() {
// //     _itemNameController.clear();
// //     _barcodeController.clear();
// //     _salesPriceController.clear();
// //     _purchasePriceController.clear();
// //     _stockController.clear();
// //     _hsnCodeController.clear();
// //     _descriptionController.clear();
// //     _packingController.clear();
// //     _mrpController.clear();
// //     _salesRate2Controller.clear();
// //     _minimumQtyController.clear();
// //     _maximumQtyController.clear();
// //     _shelfLifeController.clear();
// //     _maximumDiscountController.clear();
// //     _conversionController.clear();

// //     setState(() {
// //       _selectedHsn = null;
// //       _selectedCategory = null;
// //       _selectedSubCategory = null;
// //       _selectedDivision = null;
// //       _selectedCompany = null;
// //       _decimalAllowed = false;
// //       _lowStockAlertEnabled = false;
// //       _selectedImage = null;
// //       _selectedUnit = 'kg';
// //     });

// //     _generateItemCode(); // Generate new code for next item
// //   }

// //   // Function to open HSN selection screen
// //   Future<void> _selectHsnCode(BuildContext context) async {
// //     final selectedHsn = await Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => HsnSelectionScreen()),
// //     );

// //     if (selectedHsn != null && selectedHsn is HsnModel) {
// //       setState(() {
// //         _selectedHsn = selectedHsn;
// //         _hsnCodeController.text = selectedHsn.hsnCode;
// //       });
// //     }
// //   }

// //   Widget _buildPricingTab() {
// //     return SingleChildScrollView(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Unit Dropdown
// //           Text(
// //             "  Unit",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: Padding(
// //               padding: EdgeInsets.symmetric(horizontal: 10),
// //               child: DropdownButtonHideUnderline(
// //                 child: DropdownButton<String>(
// //                   value: _selectedUnit,
// //                   isExpanded: true,
// //                   dropdownColor: Colors.white,
// //                   items:
// //                       _units.map((String value) {
// //                         return DropdownMenuItem<String>(
// //                           value: value,
// //                           child: Text(
// //                             value.toUpperCase(),
// //                             style: GoogleFonts.abel(
// //                               textStyle: TextStyle(
// //                                 color: Colors.black,
// //                                 fontSize: 14.sp,
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       }).toList(),
// //                   onChanged: (String? newValue) {
// //                     setState(() {
// //                       _selectedUnit = newValue!;
// //                     });
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Packing
// //           Text(
// //             "  Packing",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _packingController,
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "e.g., 500 ml bottle",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26, fontSize: 15.sp),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // HSN Code Field with Search Button
// //           Text(
// //             "  HSN Code",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _hsnCodeController,
// //               readOnly: true,
// //               style: TextStyle(fontSize: 16.sp),
// //               onTap: () => _selectHsnCode(context),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Select HSN code",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26, fontSize: 15.sp),
// //                 ),
// //                 suffixIcon: IconButton(
// //                   icon: Icon(Icons.search, color: Colors.blue),
// //                   onPressed: () => _selectHsnCode(context),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // GST Display
// //           if (_selectedHsn != null) ...[
// //             Text(
// //               "  GST Rates",
// //               style: GoogleFonts.abel(
// //                 textStyle: TextStyle(
// //                   color: Colors.black54,
// //                   fontSize: 15.sp,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //             Card(
// //               elevation: 0,
// //               color: Colors.white,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(6),
// //                 side: BorderSide(color: Colors.black26),
// //               ),
// //               child: Container(
// //                 padding: EdgeInsets.all(12),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     Chip(
// //                       label: Text(
// //                         'SGST: ${_selectedHsn!.sgst}%',
// //                         style: TextStyle(fontSize: 14.sp),
// //                       ),
// //                       backgroundColor: Colors.blue.shade100,
// //                     ),
// //                     Chip(
// //                       label: Text(
// //                         'CGST: ${_selectedHsn!.cgst}%',
// //                         style: TextStyle(fontSize: 14.sp),
// //                       ),
// //                       backgroundColor: Colors.green.shade100,
// //                     ),
// //                     Chip(
// //                       label: Text(
// //                         'IGST: ${_selectedHsn!.igst}%',
// //                         style: TextStyle(fontSize: 14.sp),
// //                       ),
// //                       backgroundColor: Colors.orange.shade100,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 1.h),
// //           ],

// //           // Sales Price
// //           Text(
// //             "  Sales Price",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _salesPriceController,
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter sales price",
// //                 prefixIcon: Icon(
// //                   Icons.currency_rupee,
// //                   size: 18,
// //                   color: Colors.black26,
// //                 ),
// //                 suffixIcon: Padding(
// //                   padding: EdgeInsets.symmetric(
// //                     horizontal: 1.w,
// //                     vertical: 0.5.h,
// //                   ),
// //                   child: SizedBox(
// //                     height: 45,
// //                     child: Card(
// //                       elevation: 0,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(30),
// //                       ),
// //                       color: Colors.grey.shade100,
// //                       child: Padding(
// //                         padding: EdgeInsets.all(8.0),
// //                         child: DropdownButtonHideUnderline(
// //                           child: DropdownButton<String>(
// //                             value: _selectedChart,
// //                             dropdownColor: Colors.white,
// //                             menuMaxHeight: 20.h,
// //                             items:
// //                                 _chartOptions.map((String value) {
// //                                   return DropdownMenuItem<String>(
// //                                     value: value,
// //                                     child: Padding(
// //                                       padding: EdgeInsets.only(left: 10),
// //                                       child: Text(
// //                                         value,
// //                                         style: GoogleFonts.abel(
// //                                           textStyle: TextStyle(
// //                                             color: Colors.black,
// //                                             fontSize: 15.sp,
// //                                             fontWeight: FontWeight.w500,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   );
// //                                 }).toList(),
// //                             onChanged: (String? newValue) {
// //                               setState(() {
// //                                 _selectedChart = newValue!;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Purchase Price
// //           Text(
// //             "  Purchase Price",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _purchasePriceController,
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter purchase price",
// //                 prefixIcon: Icon(
// //                   Icons.currency_rupee,
// //                   size: 18,
// //                   color: Colors.black26,
// //                 ),
// //                 suffixIcon: Padding(
// //                   padding: EdgeInsets.symmetric(
// //                     horizontal: 1.w,
// //                     vertical: 0.5.h,
// //                   ),
// //                   child: SizedBox(
// //                     height: 45,
// //                     child: Card(
// //                       elevation: 0,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(30),
// //                       ),
// //                       color: Colors.grey.shade100,
// //                       child: Padding(
// //                         padding: EdgeInsets.all(8.0),
// //                         child: DropdownButtonHideUnderline(
// //                           child: DropdownButton<String>(
// //                             value: _selectedChart,
// //                             dropdownColor: Colors.white,
// //                             menuMaxHeight: 20.h,
// //                             items:
// //                                 _chartOptions.map((String value) {
// //                                   return DropdownMenuItem<String>(
// //                                     value: value,
// //                                     child: Padding(
// //                                       padding: EdgeInsets.only(left: 10),
// //                                       child: Text(
// //                                         value,
// //                                         style: GoogleFonts.abel(
// //                                           textStyle: TextStyle(
// //                                             color: Colors.black,
// //                                             fontSize: 15.sp,
// //                                             fontWeight: FontWeight.w500,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   );
// //                                 }).toList(),
// //                             onChanged: (String? newValue) {
// //                               setState(() {
// //                                 _selectedChart = newValue!;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // MRP
// //           Text(
// //             "  MRP",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _mrpController,
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter MRP",
// //                 prefixIcon: Icon(
// //                   Icons.currency_rupee,
// //                   size: 18,
// //                   color: Colors.black26,
// //                 ),
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Sales Rate 2
// //           Text(
// //             "  Sales Rate 2 (Optional)",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _salesRate2Controller,
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter alternate sales price",
// //                 prefixIcon: Icon(
// //                   Icons.currency_rupee,
// //                   size: 18,
// //                   color: Colors.black26,
// //                 ),
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   bool _lowStockAlertEnabled = false;

// //   Widget _buildStockTab() {
// //     DateTime selectedDate = DateTime.now();
// //     final DateFormat dateFormat = DateFormat('dd MMM yyyy');

// //     return SingleChildScrollView(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Opening Stock
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.start,
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "  Opening Stock",
// //                       style: GoogleFonts.abel(
// //                         textStyle: TextStyle(
// //                           color: Colors.black54,
// //                           fontSize: 15.sp,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                     Card(
// //                       elevation: 0,
// //                       color: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(6),
// //                         side: BorderSide(color: Colors.black26),
// //                       ),
// //                       child: TextFormField(
// //                         controller: _stockController,
// //                         keyboardType: TextInputType.numberWithOptions(
// //                           decimal: true,
// //                         ),
// //                         decoration: InputDecoration(
// //                           contentPadding: EdgeInsets.all(10),
// //                           fillColor: Colors.white,
// //                           filled: true,
// //                           hintText: "Enter opening stock",
// //                           hintStyle: GoogleFonts.abel(
// //                             textStyle: TextStyle(color: Colors.black26),
// //                           ),
// //                           suffixIcon: Padding(
// //                             padding: EdgeInsets.symmetric(horizontal: 8),
// //                             child: DropdownButtonHideUnderline(
// //                               child: DropdownButton<String>(
// //                                 value: _selectedUnit,
// //                                 items:
// //                                     _units.map((String value) {
// //                                       return DropdownMenuItem<String>(
// //                                         value: value,
// //                                         child: Text(
// //                                           value.toUpperCase(),
// //                                           style: GoogleFonts.abel(
// //                                             textStyle: TextStyle(
// //                                               fontSize: 14.sp,
// //                                               fontWeight: FontWeight.bold,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       );
// //                                     }).toList(),
// //                                 onChanged: (String? newValue) {
// //                                   setState(() {
// //                                     _selectedUnit = newValue!;
// //                                   });
// //                                 },
// //                               ),
// //                             ),
// //                           ),
// //                           border: OutlineInputBorder(
// //                             borderSide: BorderSide.none,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "  As of Date",
// //                       style: GoogleFonts.abel(
// //                         textStyle: TextStyle(
// //                           color: Colors.black54,
// //                           fontSize: 15.sp,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                     Card(
// //                       elevation: 0,
// //                       color: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(6),
// //                         side: BorderSide(color: Colors.black26),
// //                       ),
// //                       child: InkWell(
// //                         onTap: () async {
// //                           final DateTime? picked = await showDatePicker(
// //                             context: context,
// //                             initialDate: selectedDate,
// //                             firstDate: DateTime(2000),
// //                             lastDate: DateTime(2100),
// //                           );
// //                           if (picked != null && picked != selectedDate) {
// //                             setState(() {
// //                               selectedDate = picked;
// //                             });
// //                           }
// //                         },
// //                         child: InputDecorator(
// //                           decoration: InputDecoration(
// //                             contentPadding: EdgeInsets.all(10),
// //                             fillColor: Colors.white,
// //                             filled: true,
// //                             hintText: "Select date",
// //                             hintStyle: GoogleFonts.abel(
// //                               textStyle: TextStyle(color: Colors.black26),
// //                             ),
// //                             suffixIcon: Icon(Icons.calendar_today, size: 20),
// //                             border: OutlineInputBorder(
// //                               borderSide: BorderSide.none,
// //                             ),
// //                           ),
// //                           child: Text(
// //                             dateFormat.format(selectedDate),
// //                             style: GoogleFonts.abel(
// //                               textStyle: TextStyle(fontSize: 16.sp),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 2.h),

// //           // Minimum Quantity
// //           Text(
// //             "  Minimum Quantity",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _minimumQtyController,
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter minimum order quantity",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Maximum Quantity
// //           Text(
// //             "  Maximum Quantity",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _maximumQtyController,
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter maximum order quantity",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Shelf Life
// //           Text(
// //             "  Shelf Life (Days)",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _shelfLifeController,
// //               keyboardType: TextInputType.number,
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter shelf life in days",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Conversion Factor
// //           Text(
// //             "  Conversion Factor",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _conversionController,
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "e.g., 1 kg = 1000 g (enter 1000)",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Low Stock Alert
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Text(
// //                   "  Low Stock Alert",
// //                   style: GoogleFonts.abel(
// //                     textStyle: TextStyle(
// //                       color: Colors.black54,
// //                       fontSize: 15.sp,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Switch(
// //                 value: _lowStockAlertEnabled,
// //                 onChanged: (bool value) {
// //                   setState(() {
// //                     _lowStockAlertEnabled = value;
// //                   });
// //                 },
// //                 activeColor: Colors.blue.shade800,
// //                 activeTrackColor: Colors.blue.shade200,
// //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //               ),
// //             ],
// //           ),
// //           if (_lowStockAlertEnabled) ...[
// //             SizedBox(height: 1.h),
// //             Text(
// //               "  Low Stock Quantity",
// //               style: GoogleFonts.abel(
// //                 textStyle: TextStyle(
// //                   color: Colors.black54,
// //                   fontSize: 15.sp,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //             Card(
// //               elevation: 0,
// //               color: Colors.white,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(6),
// //                 side: BorderSide(color: Colors.black26),
// //               ),
// //               child: TextFormField(
// //                 keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                 decoration: InputDecoration(
// //                   contentPadding: EdgeInsets.all(10),
// //                   fillColor: Colors.white,
// //                   filled: true,
// //                   hintText: "Enter low stock threshold",
// //                   hintStyle: GoogleFonts.abel(
// //                     textStyle: TextStyle(color: Colors.black26),
// //                   ),
// //                   suffixIcon: Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 8),
// //                     child: DropdownButtonHideUnderline(
// //                       child: DropdownButton<String>(
// //                         value: _selectedUnit,
// //                         items:
// //                             _units.map((String value) {
// //                               return DropdownMenuItem<String>(
// //                                 value: value,
// //                                 child: Text(
// //                                   value.toUpperCase(),
// //                                   style: GoogleFonts.abel(
// //                                     textStyle: TextStyle(
// //                                       fontSize: 14.sp,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               );
// //                             }).toList(),
// //                         onChanged: (String? newValue) {
// //                           setState(() {
// //                             _selectedUnit = newValue!;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                   border: OutlineInputBorder(borderSide: BorderSide.none),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   File? _selectedImage;

// //   Widget _buildOtherTab() {
// //     return SingleChildScrollView(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             "  Item Code",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.grey.shade100,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _itemCodeController,
// //               readOnly: true,
// //               style: GoogleFonts.abel(
// //                 textStyle: TextStyle(color: Colors.black45),
// //               ),
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.grey.shade100,
// //                 filled: true,
// //                 hintText: "Auto-generated code",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 suffixIcon: IconButton(
// //                   icon: Icon(Icons.refresh),
// //                   onPressed: _generateItemCode,
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Barcode with Scanner Icon
// //           Text(
// //             "  Barcode (Optional)",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Card(
// //                   elevation: 0,
// //                   color: Colors.white,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(6),
// //                     side: BorderSide(color: Colors.black26),
// //                   ),
// //                   child: TextFormField(
// //                     controller: _barcodeController,
// //                     style: GoogleFonts.abel(
// //                       textStyle: TextStyle(color: Colors.black45),
// //                     ),
// //                     decoration: InputDecoration(
// //                       contentPadding: EdgeInsets.all(10),
// //                       fillColor: Colors.white,
// //                       filled: true,
// //                       hintText: "Enter barcode number",
// //                       hintStyle: GoogleFonts.abel(
// //                         textStyle: TextStyle(color: Colors.black26),
// //                       ),
// //                       border: OutlineInputBorder(borderSide: BorderSide.none),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue.shade900,
// //                   borderRadius: BorderRadius.circular(6),
// //                 ),
// //                 child: IconButton(
// //                   icon: Icon(Icons.qr_code_scanner, color: Colors.white),
// //                   onPressed: _openBarcodeScanner,
// //                   tooltip: 'Scan Barcode',
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 1.h),
// //           Text(
// //             "  Category*",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: Padding(
// //               padding: EdgeInsets.symmetric(horizontal: 8),
// //               child: DropdownButtonHideUnderline(
// //                 child: DropdownButton<Category>(
// //                   value: _selectedCategory,
// //                   isExpanded: true,
// //                   hint: Text("Select category"),
// //                   items:
// //                       _categories.map((Category category) {
// //                         return DropdownMenuItem<Category>(
// //                           value: category,
// //                           child: Text(
// //                             category.categoryName,
// //                             style: GoogleFonts.abel(
// //                               textStyle: TextStyle(fontSize: 16.sp),
// //                             ),
// //                           ),
// //                         );
// //                       }).toList(),
// //                   onChanged: (Category? newValue) {
// //                     setState(() {
// //                       _selectedCategory = newValue;
// //                       _selectedSubCategory =
// //                           null; // Reset subcategory when category changes
// //                     });
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),

// //           // Subcategory Dropdown (only if category selected)
// //           if (_selectedCategory != null) ...[
// //             Text(
// //               "  Subcategory (Optional)",
// //               style: GoogleFonts.abel(
// //                 textStyle: TextStyle(
// //                   color: Colors.black54,
// //                   fontSize: 15.sp,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //             Card(
// //               elevation: 0,
// //               color: Colors.white,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(6),
// //                 side: BorderSide(color: Colors.black26),
// //               ),
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 8),
// //                 child: DropdownButtonHideUnderline(
// //                   child: DropdownButton<SubCategory>(
// //                     value: _selectedSubCategory,
// //                     isExpanded: true,
// //                     hint: Text("Select subcategory"),
// //                     items:
// //                         _subCategories
// //                             .where(
// //                               (sub) => sub.categoryId == _selectedCategory!.id,
// //                             )
// //                             .map((SubCategory subCategory) {
// //                               return DropdownMenuItem<SubCategory>(
// //                                 value: subCategory,
// //                                 child: Text(
// //                                   subCategory.name,
// //                                   style: GoogleFonts.abel(
// //                                     textStyle: TextStyle(fontSize: 16.sp),
// //                                   ),
// //                                 ),
// //                               );
// //                             })
// //                             .toList(),
// //                     onChanged: (SubCategory? newValue) {
// //                       setState(() {
// //                         _selectedSubCategory = newValue;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 1.h),
// //           ],

// //           // Description
// //           Text(
// //             "  Description (Optional)",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 15.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           Card(
// //             elevation: 0,
// //             color: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //               side: BorderSide(color: Colors.black26),
// //             ),
// //             child: TextFormField(
// //               controller: _descriptionController,
// //               maxLines: 3,
// //               decoration: InputDecoration(
// //                 contentPadding: EdgeInsets.all(10),
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: "Enter item description",
// //                 hintStyle: GoogleFonts.abel(
// //                   textStyle: TextStyle(color: Colors.black26),
// //                 ),
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPartyWisePricesTab() {
// //     return SingleChildScrollView(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           SizedBox(height: 10.h),
// //           Icon(Icons.group, size: 60, color: Colors.grey.shade400),
// //           SizedBox(height: 2.h),
// //           Text(
// //             "Party Wise Pricing",
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(
// //                 color: Colors.black54,
// //                 fontSize: 18.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 1.h),
// //           Text(
// //             "This feature allows you to set different\nprices for different parties/customers",
// //             textAlign: TextAlign.center,
// //             style: GoogleFonts.abel(
// //               textStyle: TextStyle(color: Colors.grey, fontSize: 15.sp),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showImageSourceDialog() {
// //     showDialog(
// //       context: context,
// //       builder:
// //           (context) => AlertDialog(
// //             title: Text("Select Image Source"),
// //             content: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 ListTile(
// //                   leading: Icon(Icons.camera),
// //                   title: Text("Camera"),
// //                   onTap: () {
// //                     Navigator.pop(context);
// //                     _pickImage(ImageSource.camera);
// //                   },
// //                 ),
// //                 ListTile(
// //                   leading: Icon(Icons.photo_library),
// //                   title: Text("Gallery"),
// //                   onTap: () {
// //                     Navigator.pop(context);
// //                     _pickImage(ImageSource.gallery);
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //     );
// //   }

// //   // Pick Image Method
// //   Future<void> _pickImage(ImageSource source) async {
// //     final pickedFile = await ImagePicker().pickImage(source: source);
// //     if (pickedFile != null) {
// //       setState(() => _selectedImage = File(pickedFile.path));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         flexibleSpace: Container(color: Colors.teal),
// //         elevation: 4,
// //         shadowColor: Colors.black,
// //         backgroundColor: Colors.teal,
// //         foregroundColor: Colors.white,
// //         title: Text(
// //           "Create New Item",
// //           style: GoogleFonts.abel(
// //             textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
// //       ),
// //       body:
// //           _isLoading
// //               ? Center(child: CircularProgressIndicator())
// //               : SingleChildScrollView(
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Item Name Field
// //                       Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Expanded(
// //                             flex: 3,
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   "  Item Name*",
// //                                   style: GoogleFonts.abel(
// //                                     textStyle: TextStyle(
// //                                       color: Colors.black54,
// //                                       fontSize: 15.sp,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: 0.5.h),
// //                                 Card(
// //                                   elevation: 0,
// //                                   color: Colors.white,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(6),
// //                                     side: BorderSide(color: Colors.black12),
// //                                   ),
// //                                   child: TextFormField(
// //                                     controller: _itemNameController,
// //                                     decoration: InputDecoration(
// //                                       contentPadding: EdgeInsets.all(10),
// //                                       fillColor: Colors.white,
// //                                       filled: true,
// //                                       hintText:
// //                                           "Enter item name (e.g., Kisan Fruits Jam 500 gm)",
// //                                       hintStyle: GoogleFonts.abel(
// //                                         textStyle: TextStyle(
// //                                           color: Colors.black26,
// //                                         ),
// //                                       ),
// //                                       border: OutlineInputBorder(
// //                                         borderSide: BorderSide.none,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           SizedBox(width: 2.w),
// //                           Expanded(
// //                             flex: 1,
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   "  Product Image",
// //                                   style: GoogleFonts.abel(
// //                                     textStyle: TextStyle(
// //                                       color: Colors.black54,
// //                                       fontSize: 15.sp,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: 0.5.h),
// //                                 GestureDetector(
// //                                   onTap: _showImageSourceDialog,
// //                                   child: Card(
// //                                     elevation: 2,
// //                                     color: Colors.white,
// //                                     shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(8),
// //                                       side: BorderSide(
// //                                         color: Colors.blue.shade300,
// //                                         width: 1,
// //                                       ),
// //                                     ),
// //                                     child: SizedBox(
// //                                       height: 10.h,
// //                                       width: double.infinity,
// //                                       child:
// //                                           _selectedImage != null
// //                                               ? ClipRRect(
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(8),
// //                                                 child: Image.file(
// //                                                   _selectedImage!,
// //                                                   fit: BoxFit.cover,
// //                                                 ),
// //                                               )
// //                                               : Column(
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment.center,
// //                                                 children: [
// //                                                   Icon(
// //                                                     Icons.camera_alt,
// //                                                     size: 24,
// //                                                     color: Colors.blue.shade800,
// //                                                   ),
// //                                                   SizedBox(height: 0.5.h),
// //                                                   Text(
// //                                                     "Add",
// //                                                     style: GoogleFonts.abel(
// //                                                       textStyle: TextStyle(
// //                                                         color:
// //                                                             Colors
// //                                                                 .blue
// //                                                                 .shade800,
// //                                                         fontSize: 12.sp,
// //                                                       ),
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),

// //                       SizedBox(height: 1.h),

// //                       // Item Type Toggle
// //                       Text(
// //                         "  Item Type*",
// //                         style: GoogleFonts.abel(
// //                           textStyle: TextStyle(
// //                             color: Colors.black54,
// //                             fontSize: 15.sp,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(height: 1.h),
// //                       Row(
// //                         children: [
// //                           // Product Button
// //                           ChoiceChip(
// //                             label: Text("Product"),
// //                             selected: isProduct,
// //                             onSelected: (selected) => _toggleItemType(true),
// //                             selectedColor: Colors.blue.shade800,
// //                             showCheckmark: false,
// //                             labelStyle: GoogleFonts.abel(
// //                               textStyle: TextStyle(
// //                                 color: isProduct ? Colors.white : Colors.black,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             backgroundColor: Colors.white,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(30),
// //                               side: BorderSide(
// //                                 color:
// //                                     isProduct
// //                                         ? Colors.blue.shade800
// //                                         : Colors.grey,
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 2.w),
// //                           // Service Button
// //                           ChoiceChip(
// //                             label: Text("Service"),
// //                             selected: !isProduct,
// //                             showCheckmark: false,
// //                             onSelected: (selected) => _toggleItemType(false),
// //                             selectedColor: Colors.blue.shade800,
// //                             labelStyle: GoogleFonts.abel(
// //                               textStyle: TextStyle(
// //                                 color: !isProduct ? Colors.white : Colors.black,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             backgroundColor: Colors.white,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(30),
// //                               side: BorderSide(
// //                                 color:
// //                                     !isProduct
// //                                         ? Colors.blue.shade800
// //                                         : Colors.grey,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 2.h),

// //                       // Dynamic Tabs
// //                       Container(
// //                         decoration: BoxDecoration(
// //                           border: Border(
// //                             bottom: BorderSide(
// //                               color: Colors.grey.shade300,
// //                               width: 1.0,
// //                             ),
// //                           ),
// //                         ),
// //                         child: TabBar(
// //                           controller: _tabController,
// //                           isScrollable: false,
// //                           labelColor: Colors.blue.shade800,
// //                           unselectedLabelColor: Colors.black,
// //                           indicatorColor: Colors.blue.shade800,
// //                           labelPadding: EdgeInsets.zero,
// //                           tabAlignment: TabAlignment.fill,
// //                           tabs:
// //                               (isProduct ? _productTabs : _serviceTabs).map((
// //                                 tab,
// //                               ) {
// //                                 return Tab(
// //                                   child: Padding(
// //                                     padding: EdgeInsets.symmetric(
// //                                       horizontal: 2.0,
// //                                     ),
// //                                     child: Text(
// //                                       tab,
// //                                       style: GoogleFonts.abel(
// //                                         textStyle: TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 15.sp,
// //                                         ),
// //                                       ),
// //                                       maxLines: 1,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                   ),
// //                                 );
// //                               }).toList(),
// //                         ),
// //                       ),
// //                       SizedBox(height: 2.h),
// //                       SizedBox(
// //                         height: 50.h,
// //                         child: TabBarView(
// //                           controller: _tabController,
// //                           children:
// //                               isProduct
// //                                   ? [
// //                                     _buildPricingTab(),
// //                                     _buildStockTab(),
// //                                     _buildOtherTab(),
// //                                     _buildPartyWisePricesTab(),
// //                                   ]
// //                                   : [
// //                                     _buildPricingTab(),
// //                                     _buildOtherTab(),
// //                                     _buildPartyWisePricesTab(),
// //                                   ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //       bottomNavigationBar: Padding(
// //         padding: EdgeInsets.all(2.h),
// //         child: ElevatedButton(
// //           onPressed: _isLoading ? null : _submitItemData,
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.blue.shade900,
// //             minimumSize: Size(double.infinity, 6.h),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(6),
// //             ),
// //           ),
// //           child:
// //               _isLoading
// //                   ? SizedBox(
// //                     width: 20,
// //                     height: 20,
// //                     child: CircularProgressIndicator(
// //                       color: Colors.white,
// //                       strokeWidth: 2,
// //                     ),
// //                   )
// //                   : Text(
// //                     "Save Item",
// //                     style: GoogleFonts.abel(
// //                       textStyle: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 18.sp,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Barcode Scanner Screen for Item Creation
// // class BarcodeScannerForItemScreen extends StatefulWidget {
// //   @override
// //   State<BarcodeScannerForItemScreen> createState() =>
// //       _BarcodeScannerForItemScreenState();
// // }

// // class _BarcodeScannerForItemScreenState
// //     extends State<BarcodeScannerForItemScreen>
// //     with WidgetsBindingObserver {
// //   CameraController? _cameraController;
// //   List<CameraDescription>? _cameras;
// //   String? _scannedBarcode;
// //   bool _isLoading = false;
// //   bool _isScanning = true;
// //   bool _isCameraInitialized = false;
// //   bool _isTorchOn = false;
// //   final BarcodeScanner _barcodeScanner = BarcodeScanner();

// //   String _lastScannedValue = '';
// //   Timer? _scanResetTimer;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addObserver(this);
// //     _initializeCamera();
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     _scanResetTimer?.cancel();
// //     _cameraController?.dispose();
// //     _barcodeScanner.close();
// //     super.dispose();
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (_cameraController == null || !_cameraController!.value.isInitialized) {
// //       return;
// //     }
// //     if (state == AppLifecycleState.inactive) {
// //       _cameraController?.dispose();
// //       _scanResetTimer?.cancel();
// //     } else if (state == AppLifecycleState.resumed) {
// //       _initializeCamera();
// //     }
// //   }

// //   Future<void> _initializeCamera() async {
// //     try {
// //       _cameras = await availableCameras();
// //       if (_cameras!.isEmpty) return;

// //       final backCamera = _cameras!.firstWhere(
// //         (camera) => camera.lensDirection == CameraLensDirection.back,
// //         orElse: () => _cameras!.first,
// //       );

// //       _cameraController = CameraController(
// //         backCamera,
// //         ResolutionPreset.high,
// //         enableAudio: false,
// //       );

// //       await _cameraController!.initialize();

// //       if (mounted) {
// //         setState(() {
// //           _isCameraInitialized = true;
// //         });
// //       }

// //       _cameraController!.startImageStream(_processCameraImage);
// //     } catch (e) {
// //       print('Error initializing camera: $e');
// //       if (mounted) {
// //         setState(() {
// //           _isCameraInitialized = false;
// //         });
// //       }
// //     }
// //   }

// //   void _processCameraImage(CameraImage image) async {
// //     if (!_isScanning || _isLoading) {
// //       return;
// //     }

// //     try {
// //       final inputImage = _createInputImage(image);
// //       if (inputImage == null) return;

// //       final List<Barcode> barcodes = await _barcodeScanner.processImage(
// //         inputImage,
// //       );

// //       if (barcodes.isNotEmpty) {
// //         final Barcode barcode = barcodes.first;
// //         final String barcodeValue =
// //             barcode.rawValue ?? barcode.displayValue ?? '';

// //         if (barcodeValue.isNotEmpty && barcodeValue != _lastScannedValue) {
// //           _lastScannedValue = barcodeValue;

// //           if (mounted) {
// //             setState(() {
// //               _scannedBarcode = barcodeValue;
// //               _isLoading = true;
// //               _isScanning = false;
// //             });
// //           }

// //           // Return the scanned value after delay
// //           _scanResetTimer?.cancel();
// //           _scanResetTimer = Timer(Duration(milliseconds: 1500), () {
// //             if (mounted) {
// //               Navigator.pop(context, _scannedBarcode);
// //             }
// //           });
// //         }
// //       }
// //     } catch (e) {
// //       print('Error scanning barcode: $e');
// //     }
// //   }

// //   InputImage? _createInputImage(CameraImage image) {
// //     try {
// //       final WriteBuffer allBytes = WriteBuffer();
// //       for (final Plane plane in image.planes) {
// //         allBytes.putUint8List(plane.bytes);
// //       }
// //       final bytes = allBytes.done().buffer.asUint8List();

// //       final imageRotation = _getImageRotation();

// //       final inputImageMetadata = InputImageMetadata(
// //         size: Size(image.width.toDouble(), image.height.toDouble()),
// //         rotation: imageRotation,
// //         format: InputImageFormat.nv21,
// //         bytesPerRow: image.planes.first.bytesPerRow,
// //       );

// //       return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
// //     } catch (e) {
// //       print('Error creating InputImage: $e');
// //       return null;
// //     }
// //   }

// //   InputImageRotation _getImageRotation() {
// //     if (_cameraController == null) return InputImageRotation.rotation0deg;

// //     final camera = _cameraController!.description;
// //     switch (camera.sensorOrientation) {
// //       case 90:
// //         return InputImageRotation.rotation90deg;
// //       case 180:
// //         return InputImageRotation.rotation180deg;
// //       case 270:
// //         return InputImageRotation.rotation270deg;
// //       default:
// //         return InputImageRotation.rotation0deg;
// //     }
// //   }

// //   void _toggleTorch() async {
// //     if (_cameraController != null && _cameraController!.value.isInitialized) {
// //       try {
// //         await _cameraController!.setFlashMode(
// //           _isTorchOn ? FlashMode.off : FlashMode.torch,
// //         );
// //         if (mounted) {
// //           setState(() {
// //             _isTorchOn = !_isTorchOn;
// //           });
// //         }
// //       } catch (e) {
// //         print('Error toggling torch: $e');
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         title: Text(
// //           'Scan Barcode',
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.w700,
// //             color: Colors.white,
// //           ),
// //         ),
// //         backgroundColor: Colors.blue[900],
// //         foregroundColor: Colors.white,
// //         elevation: 0,
// //         centerTitle: true,
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(
// //               _isTorchOn ? Icons.flash_on : Icons.flash_off,
// //               color: _isTorchOn ? Colors.yellow : Colors.white,
// //             ),
// //             onPressed: _toggleTorch,
// //           ),
// //         ],
// //       ),
// //       body: _buildBody(),
// //     );
// //   }

// //   Widget _buildBody() {
// //     if (!_isCameraInitialized || _cameraController == null) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             CircularProgressIndicator(color: Colors.blue[900]),
// //             SizedBox(height: 20),
// //             Text(
// //               'Initializing Camera...',
// //               style: TextStyle(color: Colors.white, fontSize: 16),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return Stack(
// //       children: [
// //         // Camera Preview
// //         SizedBox(
// //           width: double.infinity,
// //           height: double.infinity,
// //           child: CameraPreview(_cameraController!),
// //         ),

// //         // Scanner Overlay
// //         if (_isScanning && _scannedBarcode == null) _buildScannerOverlay(),

// //         // Loading Indicator
// //         if (_isLoading)
// //           Center(
// //             child: Container(
// //               padding: EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 color: Colors.black54,
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   CircularProgressIndicator(color: Colors.blue[900]),
// //                   SizedBox(height: 16),
// //                   Text(
// //                     'Scanning...',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),

// //         // Result Display
// //         if (_scannedBarcode != null && !_isLoading) _buildResultCard(),
// //       ],
// //     );
// //   }

// //   Widget _buildScannerOverlay() {
// //     return Column(
// //       children: [
// //         Expanded(flex: 2, child: Container(color: Colors.black54)),
// //         Expanded(
// //           flex: 3,
// //           child: Row(
// //             children: [
// //               Expanded(flex: 1, child: Container(color: Colors.black54)),
// //               Expanded(
// //                 flex: 8,
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: Colors.blue.shade400, width: 2),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(
// //                         Icons.qr_code_scanner,
// //                         size: 50,
// //                         color: Colors.blue.shade400,
// //                       ),
// //                       SizedBox(height: 16),
// //                       Text(
// //                         'Point camera at barcode',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                       SizedBox(height: 8),
// //                       Text(
// //                         'Will auto-scan and return',
// //                         style: TextStyle(fontSize: 12, color: Colors.grey[400]),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               Expanded(flex: 1, child: Container(color: Colors.black54)),
// //             ],
// //           ),
// //         ),
// //         Expanded(flex: 2, child: Container(color: Colors.black54)),
// //       ],
// //     );
// //   }

// //   Widget _buildResultCard() {
// //     return Positioned(
// //       bottom: 2.h,
// //       left: 3.w,
// //       right: 3.w,
// //       child: Container(
// //         padding: EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black54,
// //               blurRadius: 15,
// //               offset: Offset(0, 5),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Header
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(
// //                   '✅ Barcode Scanned!',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.green[700],
// //                   ),
// //                 ),
// //                 Icon(Icons.check_circle, color: Colors.green, size: 30),
// //               ],
// //             ),
// //             SizedBox(height: 16),

// //             // Scanned Value
// //             Container(
// //               width: double.infinity,
// //               padding: EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.blue[50],
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(color: Colors.blue[200]!),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'Scanned Barcode:',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       color: Colors.blue[900],
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   SizedBox(height: 10),
// //                   Container(
// //                     width: double.infinity,
// //                     padding: EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: Colors.grey[300]!),
// //                     ),
// //                     child: SelectableText(
// //                       _scannedBarcode!,
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.black87,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             SizedBox(height: 20),
// //             Text(
// //               'Returning to item form in a moment...',
// //               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class HsnSelectionScreen extends StatefulWidget {
// //   const HsnSelectionScreen({super.key});

// //   @override
// //   _HsnSelectionScreenState createState() => _HsnSelectionScreenState();
// // }

// // class _HsnSelectionScreenState extends State<HsnSelectionScreen> {
// //   List<HsnModel> hsnList = [];
// //   List<HsnModel> filteredHsnList = [];
// //   bool isLoading = true;
// //   String errorMessage = '';
// //   final TextEditingController searchController = TextEditingController();
// //   String searchQuery = '';

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
// //       filteredHsnList = List.from(hsnList);
// //     } else {
// //       filteredHsnList =
// //           hsnList.where((hsn) {
// //             return hsn.hsnCode.toLowerCase().contains(searchQuery);
// //           }).toList();
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
// //           filteredHsnList = List.from(hsnList);
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

// //   Widget _buildHsnList() {
// //     return ListView.builder(
// //       itemCount: filteredHsnList.length,
// //       itemBuilder: (context, index) {
// //         final hsn = filteredHsnList[index];
// //         return Card(
// //           color: Colors.white,
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //           margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
// //           child: ListTile(
// //             onTap: () {
// //               Navigator.pop(context, hsn);
// //             },
// //             title: Text(
// //               hsn.hsnCode,
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 15.sp,
// //                 color: Colors.blue.shade900,
// //               ),
// //             ),
// //             subtitle: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(height: 0.5.h),
// //                 Row(
// //                   children: [
// //                     Chip(
// //                       label: Text(
// //                         'SGST: ${hsn.sgst}%',
// //                         style: TextStyle(fontSize: 14.sp),
// //                       ),
// //                       backgroundColor: Colors.blue.shade100,
// //                     ),
// //                     SizedBox(width: 1.w),
// //                     Chip(
// //                       label: Text(
// //                         'CGST: ${hsn.cgst}%',
// //                         style: TextStyle(fontSize: 14.sp),
// //                       ),
// //                       backgroundColor: Colors.green.shade100,
// //                     ),
// //                     SizedBox(width: 1.w),
// //                     Chip(
// //                       label: Text(
// //                         'IGST: ${hsn.igst}%',
// //                         style: TextStyle(fontSize: 14.sp),
// //                       ),
// //                       backgroundColor: Colors.orange.shade100,
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //      Row(
// //         mainAxisAlignment: MainAxisAlignment.end,
// //         children: [
// //           FloatingActionButton(
// //                 onPressed: (){
// //                   // Navigator.push(context, MaterialPageRoute(builder: (context)=> ))
// //                 },
// //                 backgroundColor: Colors.teal.shade700,
// //                 foregroundColor: Colors.white,
// //                 elevation: 6,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(16),
// //                 ),
// //                 child: Icon(Icons.add, size: 28),
// //               )
// //               .animate()
// //               .scale(duration: 600.ms, curve: Curves.elasticOut)
// //               .then(delay: 200.ms)
// //               .shake(hz: 3, curve: Curves.easeInOut),
// //         ],
// //       );
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Select HSN Code', style: TextStyle(fontSize: 19.sp)),
// //         backgroundColor: Colors.blue.shade900,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Column(
// //         children: [
// //           // Search Bar
// //           Padding(
// //             padding: EdgeInsets.all(2.w),
// //             child: TextField(
// //               controller: searchController,
// //               decoration: InputDecoration(
// //                 hintText: 'Search HSN code...',
// //                 hintStyle: TextStyle(fontSize: 17.sp),
// //                 prefixIcon: Icon(Icons.search),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 contentPadding: EdgeInsets.all(10),
// //               ),
// //             ),
// //           ),

// //           if (searchQuery.isNotEmpty)
// //             Padding(
// //               padding: EdgeInsets.symmetric(horizontal: 4.w),
// //               child: Row(
// //                 children: [
// //                   Text(
// //                     '${filteredHsnList.length} result(s) found',
// //                     style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //           Expanded(
// //             child:
// //                 isLoading
// //                     ? Center(child: CircularProgressIndicator())
// //                     : errorMessage.isNotEmpty
// //                     ? Center(child: Text(errorMessage))
// //                     : filteredHsnList.isEmpty
// //                     ? Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(Icons.search_off, size: 64, color: Colors.grey),
// //                           SizedBox(height: 16),
// //                           Text(
// //                             searchQuery.isEmpty
// //                                 ? 'No HSN codes available'
// //                                 : 'No matching HSN codes',
// //                             style: TextStyle(fontSize: 18, color: Colors.grey),
// //                           ),
// //                         ],
// //                       ),
// //                     )
// //                     : _buildHsnList(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // HSN Model class
// // class HsnModel {
// //   final int id;
// //   final String hsnCode;
// //   final double sgst;
// //   final double cgst;
// //   final double igst;
// //   final double cess;
// //   final int? hsnType;

// //   HsnModel({
// //     required this.id,
// //     required this.hsnCode,
// //     required this.sgst,
// //     required this.cgst,
// //     required this.igst,
// //     required this.cess,
// //     this.hsnType,
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
// //     );
// //   }
// // }

// // class Category {
// //   final int id;
// //   final String categoryName;
// //   final DateTime created;

// //   Category({
// //     required this.id,
// //     required this.categoryName,
// //     required this.created,
// //   });

// //   factory Category.fromJson(Map<String, dynamic> json) {
// //     return Category(
// //       id: json['id'] ?? 0,
// //       categoryName: json['categoryName'] ?? '',
// //       created: DateTime.parse(json['created'] ?? DateTime.now().toString()),
// //     );
// //   }
// // }

// // class SubCategory {
// //   final int id;
// //   final String name;
// //   final int categoryId;
// //   final Category category;
// //   final DateTime created;

// //   SubCategory({
// //     required this.id,
// //     required this.name,
// //     required this.categoryId,
// //     required this.category,
// //     required this.created,
// //   });

// //   factory SubCategory.fromJson(Map<String, dynamic> json) {
// //     return SubCategory(
// //       id: json['id'] ?? 0,
// //       name: json['name'] ?? '',
// //       categoryId: json['categoryId'] ?? 0,
// //       category: Category.fromJson(json['category'] ?? {}),
// //       created: DateTime.parse(json['created'] ?? DateTime.now().toString()),
// //     );
// //   }
// // }


// // ignore_for_file: depend_on_referenced_packages, deprecated_member_use, avoid_print, use_build_context_synchronously, library_private_types_in_public_api

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

// class CreateNewItemScreen extends StatefulWidget {
//   const CreateNewItemScreen({super.key});

//   @override
//   State<CreateNewItemScreen> createState() => _CreateNewItemScreenState();
// }

// class _CreateNewItemScreenState extends State<CreateNewItemScreen>
//     with SingleTickerProviderStateMixin {
//   bool isProduct = true;
//   final List<String> _chartOptions = ['Without Tax', 'With Tax'];
//   String _selectedChart = 'Without Tax';
//   late TabController _tabController;

//   final List<String> _productTabs = [
//     '💰 Pricing',
//     '📦 Stock',
//     '📝 Other',
//     '👥 Party Wise',
//   ];
//   final List<String> _serviceTabs = ['💰 Pricing', '📝 Other', '👥 Party Wise'];

//   // Form controllers
//   final TextEditingController _itemNameController = TextEditingController();
//   final TextEditingController _itemCodeController = TextEditingController();
//   final TextEditingController _barcodeController = TextEditingController();
//   final TextEditingController _salesPriceController = TextEditingController();
//   final TextEditingController _purchasePriceController = TextEditingController();
//   final TextEditingController _stockController = TextEditingController();
//   final TextEditingController _hsnCodeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _packingController = TextEditingController();
//   final TextEditingController _mrpController = TextEditingController();
//   final TextEditingController _salesRate2Controller = TextEditingController();
//   final TextEditingController _minimumQtyController = TextEditingController();
//   final TextEditingController _maximumQtyController = TextEditingController();
//   final TextEditingController _shelfLifeController = TextEditingController();
//   final TextEditingController _maximumDiscountController = TextEditingController();
//   final TextEditingController _conversionController = TextEditingController();

//   HsnModel? _selectedHsn;
//   List<Category> _categories = [];
//   List<SubCategory> _subCategories = [];
//   Category? _selectedCategory;
//   SubCategory? _selectedSubCategory;
//   Map<String, dynamic>? _selectedDivision;
//   Map<String, dynamic>? _selectedCompany;
//   bool _decimalAllowed = false;
//   bool _isLoading = false;

//   // Decorative colors
//   final Color _primaryColor = Color(0xFF2E7D32); // Teal green
//   final Color _secondaryColor = Color(0xFF43A047);
//   final Color _accentColor = Color(0xFFF57C00); // Orange
//   final Color _backgroundColor = Color(0xFFF5F7FA);
//   final Color _cardColor = Colors.white;
//   final Color _textColor = Color(0xFF37474F);
//   final Color _hintColor = Color(0xFF90A4AE);
//   final Color _successColor = Color(0xFF4CAF50);
//   final Color _warningColor = Color(0xFFFF9800);
//   final Color _errorColor = Color(0xFFF44336);

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//       length: isProduct ? _productTabs.length : _serviceTabs.length,
//       vsync: this,
//     );
//     _generateItemCode();
//     _loadCategories();
//   }

//   void _generateItemCode() {
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     _itemCodeController.text = 'ITEM${timestamp.toString().substring(9)}';
//   }

//   Future<void> _loadCategories() async {
//     try {
//       final categoryResponse = await http.get(
//         Uri.parse('http://202.140.138.215:85/api/CategoryMasterApi'),
//       );
//       if (categoryResponse.statusCode == 200) {
//         final Map<String, dynamic> categoryData = json.decode(
//           categoryResponse.body,
//         );
//         if (categoryData['success'] == true) {
//           final List<dynamic> categoryList = categoryData['data'];
//           setState(() {
//             _categories =
//                 categoryList.map((json) => Category.fromJson(json)).toList();
//           });
//         }
//       }

//       final subCategoryResponse = await http.get(
//         Uri.parse('http://202.140.138.215:85/api/SubCategoryApi/all'),
//       );

//       if (subCategoryResponse.statusCode == 200) {
//         final List<dynamic> subCategoryData = json.decode(
//           subCategoryResponse.body,
//         );
//         setState(() {
//           _subCategories =
//               subCategoryData
//                   .map((json) => SubCategory.fromJson(json))
//                   .toList();
//         });
//       }
//     } catch (e) {
//       print('Error loading categories: $e');
//     }
//   }

//   @override
//   void didUpdateWidget(covariant CreateNewItemScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if ((isProduct && _tabController.length != _productTabs.length) ||
//         (!isProduct && _tabController.length != _serviceTabs.length)) {
//       _tabController.dispose();
//       _tabController = TabController(
//         length: isProduct ? _productTabs.length : _serviceTabs.length,
//         vsync: this,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _itemNameController.dispose();
//     _itemCodeController.dispose();
//     _barcodeController.dispose();
//     _salesPriceController.dispose();
//     _purchasePriceController.dispose();
//     _stockController.dispose();
//     _hsnCodeController.dispose();
//     _descriptionController.dispose();
//     _packingController.dispose();
//     _mrpController.dispose();
//     _salesRate2Controller.dispose();
//     _minimumQtyController.dispose();
//     _maximumQtyController.dispose();
//     _shelfLifeController.dispose();
//     _maximumDiscountController.dispose();
//     _conversionController.dispose();
//     super.dispose();
//   }

//   void _toggleItemType(bool isProductSelected) {
//     if (isProduct != isProductSelected) {
//       setState(() {
//         isProduct = isProductSelected;
//         _tabController.dispose();
//         _tabController = TabController(
//           length: isProduct ? _productTabs.length : _serviceTabs.length,
//           vsync: this,
//         );
//       });
//     }
//   }

//   Future<void> _openBarcodeScanner() async {
//     final scannedBarcode = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const BarcodeScannerForItemScreen(),
//         fullscreenDialog: true,
//       ),
//     );
//     if (scannedBarcode != null && scannedBarcode is String) {
//       setState(() {
//         _barcodeController.text = scannedBarcode;
//       });
//       _showSuccessToast('Barcode scanned successfully!');
//     }
//   }

//   final List<String> _units = [
//     'kg', 'g', 'mg', 'ltr', 'ml', 'pcs', 'box', 'carton', 'dozen', 'pair',
//     'set', 'pack', 'bottle', 'can', 'jar', 'bag', 'roll', 'meter', 'cm', 'mm',
//     'inch', 'feet', 'yard', 'sq. ft', 'sq. m', 'gram', 'kilogram', 'liter',
//     'milliliter', 'ton', 'quintal', 'ounce', 'pound', 'gallon', 'unit',
//     'piece', 'each', 'bundle', 'packet', 'ream', 'sheet', 'book', 'tube',
//     'capsule', 'tablet', 'vial', 'ampoule', 'syringe',
//   ];

//   String _selectedUnit = 'kg';

//   void _showSuccessToast(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.white, size: 20),
//             SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: _successColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _showErrorToast(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error, color: Colors.white, size: 20),
//             SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: _errorColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> _submitItemData() async {
//     if (_itemNameController.text.isEmpty) {
//       _showErrorToast('Item Name is required');
//       return;
//     }

//     if (_selectedCategory == null) {
//       _showErrorToast('Category is required');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final Map<String, dynamic> requestData = {
//       "Id": 0,
//       "Name": _itemNameController.text.trim(),
//       "Code": _itemCodeController.text.trim(),
//       "Barcode": _barcodeController.text.trim().isNotEmpty
//           ? _barcodeController.text.trim()
//           : null,
//       "Unit1": _selectedUnit.toUpperCase(),
//       "Unit2": 1,
//       "Packing": _packingController.text.trim().isNotEmpty
//           ? _packingController.text.trim()
//           : null,
//       "CategoryId": _selectedCategory?.id ?? 0,
//       "Category": null,
//       "SubCategoryId": _selectedSubCategory?.id,
//       "SubCategory": _selectedSubCategory?.name,
//       "DivisionId": _selectedDivision?['id'],
//       "Division": _selectedDivision?['name'],
//       "HsnId": _selectedHsn?.id,
//       "Hsn": _selectedHsn?.hsnCode,
//       "CompanyId": _selectedCompany?['id'],
//       "Company": _selectedCompany?['name'],
//       "Mrp": int.tryParse(_mrpController.text) ?? 0,
//       "SalesRate1": int.tryParse(_salesPriceController.text) ?? 0,
//       "SalesRate2": int.tryParse(_salesRate2Controller.text) ?? 0,
//       "MinimumQty": int.tryParse(_minimumQtyController.text) ?? 0,
//       "MaximumQty": int.tryParse(_maximumQtyController.text) ?? 0,
//       "ShelfLife": int.tryParse(_shelfLifeController.text) ?? 0,
//       "MaximumDiscount": int.tryParse(_maximumDiscountController.text) ?? 0,
//       "DecemalAllowed": _decimalAllowed,
//       "Conversion": int.tryParse(_conversionController.text) ?? 0,
//       "photo": _selectedImage != null ? base64Encode(_selectedImage!.readAsBytesSync()) : null,
//     };

//     print('=== API REQUEST DATA ===');
//     print('URL: http://202.140.138.215:85/api/ItemMasterApi');
//     print('Request Body: ${json.encode(requestData)}');

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? authToken = prefs.getString('authToken');

//       final Map<String, String> headers = {
//         'Content-Type': 'application/json; charset=UTF-8',
//       };

//       if (authToken != null && authToken.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $authToken';
//       }

//       final response = await http.post(
//         Uri.parse('http://202.140.138.215:85/api/ItemMasterApi'),
//         headers: headers,
//         body: json.encode(requestData),
//       );

//       print('=== API RESPONSE ===');
//       print('Status Code: ${response.statusCode}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = json.decode(response.body);
//         if (responseData['success'] == true) {
//           _showSuccessToast('✅ ${responseData['message'] ?? 'Item saved successfully!'}');
//           Future.delayed(Duration(milliseconds: 1500), () {
//             Navigator.pop(context, true);
//           });
//         } else {
//           _showErrorToast('❌ ${responseData['message'] ?? 'Failed to save item'}');
//         }
//       } else {
//         _showErrorToast('Failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//       _showErrorToast('Network Error: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _clearForm() {
//     _itemNameController.clear();
//     _barcodeController.clear();
//     _salesPriceController.clear();
//     _purchasePriceController.clear();
//     _stockController.clear();
//     _hsnCodeController.clear();
//     _descriptionController.clear();
//     _packingController.clear();
//     _mrpController.clear();
//     _salesRate2Controller.clear();
//     _minimumQtyController.clear();
//     _maximumQtyController.clear();
//     _shelfLifeController.clear();
//     _maximumDiscountController.clear();
//     _conversionController.clear();

//     setState(() {
//       _selectedHsn = null;
//       _selectedCategory = null;
//       _selectedSubCategory = null;
//       _selectedDivision = null;
//       _selectedCompany = null;
//       _decimalAllowed = false;
//       _lowStockAlertEnabled = false;
//       _selectedImage = null;
//       _selectedUnit = 'kg';
//     });

//     _generateItemCode();
//   }

//   Future<void> _selectHsnCode(BuildContext context) async {
//     final selectedHsn = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const HsnSelectionScreen(),
//         fullscreenDialog: true,
//       ),
//     );

//     if (selectedHsn != null && selectedHsn is HsnModel) {
//       setState(() {
//         _selectedHsn = selectedHsn;
//         _hsnCodeController.text = selectedHsn.hsnCode;
//       });
//       _showSuccessToast('HSN code selected');
//     }
//   }

//   Widget _buildDecoratedField({
//     required String label,
//     required Widget child,
//     String? helperText,
//     IconData? prefixIcon,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             if (prefixIcon != null)
//               Icon(prefixIcon, size: 18, color: _primaryColor.withOpacity(0.7)),
//             SizedBox(width: prefixIcon != null ? 8 : 0),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: _textColor.withOpacity(0.8),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 0.8.h),
//         Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: BorderSide(color: Colors.grey.shade200, width: 1),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.white,
//                   Colors.grey.shade50,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: child,
//           ),
//         ),
//         if (helperText != null) ...[
//           SizedBox(height: 0.5.h),
//           Padding(
//             padding: EdgeInsets.only(left: 4),
//             child: Text(
//               helperText,
//               style: GoogleFonts.poppins(
//                 fontSize: 11.sp,
//                 color: _hintColor,
//               ),
//             ),
//           ),
//         ],
//         SizedBox(height: 1.5.h),
//       ],
//     );
//   }

//   Widget _buildPricingTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(vertical: 2.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Unit Dropdown
//           _buildDecoratedField(
//             label: "Unit",
//             prefixIcon: Icons.scale,
//             helperText: "Select measurement unit",
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: _selectedUnit,
//                   isExpanded: true,
//                   dropdownColor: Colors.white,
//                   icon: Icon(Icons.arrow_drop_down_circle, color: _primaryColor),
//                   items: _units.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 8),
//                         child: Text(
//                           value.toUpperCase(),
//                           style: GoogleFonts.poppins(
//                             fontSize: 15.sp,
//                             color: _textColor,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedUnit = newValue!;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),

//           // Packing
//           _buildDecoratedField(
//             label: "Packing",
//             prefixIcon: Icons.inventory,
//             helperText: "e.g., 500 ml bottle, 1 kg pouch",
//             child: TextFormField(
//               controller: _packingController,
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "Enter packing details...",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ),
//           ),

//           // HSN Code
//           _buildDecoratedField(
//             label: "HSN Code",
//             prefixIcon: Icons.code,
//             helperText: "Select HSN for tax calculation",
//             child: InkWell(
//               onTap: () => _selectHsnCode(context),
//               child: AbsorbPointer(
//                 child: TextFormField(
//                   controller: _hsnCodeController,
//                   style: GoogleFonts.poppins(
//                     fontSize: 15.sp,
//                     color: _textColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.all(16),
//                     border: InputBorder.none,
//                     hintText: "Tap to select HSN code...",
//                     hintStyle: GoogleFonts.poppins(
//                       color: _hintColor,
//                       fontSize: 14.sp,
//                     ),
//                     suffixIcon: Icon(
//                       Icons.search,
//                       color: _primaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // GST Display
//           if (_selectedHsn != null)
//             Container(
//               margin: EdgeInsets.only(bottom: 2.h),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.shade50,
//                     Colors.green.shade50,
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.blue.shade100, width: 1),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.verified, color: _successColor, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         "Selected HSN: ${_selectedHsn!.hsnCode}",
//                         style: GoogleFonts.poppins(
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.w600,
//                           color: _textColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildGstChip('SGST', '${_selectedHsn!.sgst}%', Colors.blue),
//                       _buildGstChip('CGST', '${_selectedHsn!.cgst}%', Colors.green),
//                       _buildGstChip('IGST', '${_selectedHsn!.igst}%', Colors.orange),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//           // Sales Price
//           _buildDecoratedField(
//             label: "Sales Price",
//             prefixIcon: Icons.sell,
//             helperText: "Price for selling this item",
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _salesPriceController,
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       color: _textColor,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(16),
//                       border: InputBorder.none,
//                       hintText: "0.00",
//                       hintStyle: GoogleFonts.poppins(
//                         color: _hintColor,
//                         fontSize: 14.sp,
//                       ),
//                       prefixIcon: Icon(
//                         Icons.currency_rupee,
//                         size: 20,
//                         color: _primaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 40.w,
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   child: Card(
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: _selectedChart,
//                         dropdownColor: Colors.white,
//                         items: _chartOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8),
//                               child: Text(
//                                 value,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 13.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedChart = newValue!;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Purchase Price
//           _buildDecoratedField(
//             label: "Purchase Price",
//             prefixIcon: Icons.shopping_cart,
//             helperText: "Cost to purchase this item",
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _purchasePriceController,
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       color: _textColor,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(16),
//                       border: InputBorder.none,
//                       hintText: "0.00",
//                       hintStyle: GoogleFonts.poppins(
//                         color: _hintColor,
//                         fontSize: 14.sp,
//                       ),
//                       prefixIcon: Icon(
//                         Icons.currency_rupee,
//                         size: 20,
//                         color: _primaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 40.w,
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   child: Card(
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: _selectedChart,
//                         dropdownColor: Colors.white,
//                         items: _chartOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8),
//                               child: Text(
//                                 value,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 13.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedChart = newValue!;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // MRP
//           _buildDecoratedField(
//             label: "MRP (Maximum Retail Price)",
//             prefixIcon: Icons.price_change,
//             helperText: "Maximum retail price as per packaging",
//             child: TextFormField(
//               controller: _mrpController,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "0.00",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.currency_rupee,
//                   size: 20,
//                   color: _primaryColor,
//                 ),
//               ),
//             ),
//           ),

//           // Sales Rate 2
//           _buildDecoratedField(
//             label: "Alternate Sales Price (Optional)",
//             prefixIcon: Icons.price_check,
//             helperText: "Secondary price for special customers",
//             child: TextFormField(
//               controller: _salesRate2Controller,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "0.00",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.currency_rupee,
//                   size: 20,
//                   color: _primaryColor,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGstChip(String label, String value, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 11.sp,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 2),
//           Text(
//             value,
//             style: GoogleFonts.poppins(
//               fontSize: 12.sp,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _lowStockAlertEnabled = false;

//   Widget _buildStockTab() {
//     DateTime selectedDate = DateTime.now();
//     final DateFormat dateFormat = DateFormat('dd MMM yyyy');

//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(vertical: 2.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Opening Stock and Date
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDecoratedField(
//                   label: "Opening Stock",
//                   prefixIcon: Icons.inventory_2,
//                   helperText: "Initial stock quantity",
//                   child: TextFormField(
//                     controller: _stockController,
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       color: _textColor,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(16),
//                       border: InputBorder.none,
//                       hintText: "0",
//                       hintStyle: GoogleFonts.poppins(
//                         color: _hintColor,
//                         fontSize: 14.sp,
//                       ),
//                       suffixIcon: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: _selectedUnit,
//                             items: _units.map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(
//                                   value.toUpperCase(),
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 13.sp,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 _selectedUnit = newValue!;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 2.w),
//               Expanded(
//                 child: _buildDecoratedField(
//                   label: "As of Date",
//                   prefixIcon: Icons.calendar_today,
//                   helperText: "Stock date reference",
//                   child: InkWell(
//                     onTap: () async {
//                       final DateTime? picked = await showDatePicker(
//                         context: context,
//                         initialDate: selectedDate,
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                         builder: (context, child) {
//                           return Theme(
//                             data: ThemeData.light().copyWith(
//                               primaryColor: _primaryColor,
//                               colorScheme: ColorScheme.light(
//                                 primary: _primaryColor,
//                               ),
//                               buttonTheme: ButtonThemeData(
//                                 textTheme: ButtonTextTheme.primary,
//                               ),
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//                       if (picked != null && picked != selectedDate) {
//                         setState(() {
//                           selectedDate = picked;
//                         });
//                       }
//                     },
//                     child: InputDecorator(
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.all(16),
//                         border: InputBorder.none,
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.date_range, size: 20, color: _primaryColor),
//                           SizedBox(width: 12),
//                           Text(
//                             dateFormat.format(selectedDate),
//                             style: GoogleFonts.poppins(
//                               fontSize: 15.sp,
//                               color: _textColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Minimum Quantity
//           _buildDecoratedField(
//             label: "Minimum Order Quantity",
//             prefixIcon: Icons.arrow_downward,
//             helperText: "Minimum quantity for orders",
//             child: TextFormField(
//               controller: _minimumQtyController,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "1",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ),
//           ),

//           // Maximum Quantity
//           _buildDecoratedField(
//             label: "Maximum Order Quantity",
//             prefixIcon: Icons.arrow_upward,
//             helperText: "Maximum quantity per order",
//             child: TextFormField(
//               controller: _maximumQtyController,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "100",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ),
//           ),

//           // Shelf Life
//           _buildDecoratedField(
//             label: "Shelf Life (Days)",
//             prefixIcon: Icons.timer,
//             helperText: "Product expiry duration in days",
//             child: TextFormField(
//               controller: _shelfLifeController,
//               keyboardType: TextInputType.number,
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "365",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ),
//           ),

//           // Conversion Factor
//           _buildDecoratedField(
//             label: "Conversion Factor",
//             prefixIcon: Icons.compare_arrows,
//             helperText: "e.g., 1 kg = 1000 g (enter 1000)",
//             child: TextFormField(
//               controller: _conversionController,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "1",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ),
//           ),

//           // Low Stock Alert
//           Container(
//             margin: EdgeInsets.only(bottom: 2.h),
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.orange.shade50,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.orange.shade100, width: 1),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.notifications_active, color: Colors.orange),
//                         SizedBox(width: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Low Stock Alert",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 15.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: _textColor,
//                               ),
//                             ),
//                             Text(
//                               "Get notified when stock is low",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 11.sp,
//                                 color: _hintColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Transform.scale(
//                       scale: 1.2,
//                       child: Switch(
//                         value: _lowStockAlertEnabled,
//                         onChanged: (bool value) {
//                           setState(() {
//                             _lowStockAlertEnabled = value;
//                           });
//                         },
//                         activeColor: Colors.orange,
//                         activeTrackColor: Colors.orange.shade200,
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (_lowStockAlertEnabled) ...[
//                   SizedBox(height: 16),
//                   _buildDecoratedField(
//                     label: "Alert Threshold Quantity",
//                     prefixIcon: Icons.warning,
//                     helperText: "Trigger alert when stock reaches this level",
//                     child: TextFormField(
//                       keyboardType: TextInputType.numberWithOptions(decimal: true),
//                       style: GoogleFonts.poppins(
//                         fontSize: 15.sp,
//                         color: _textColor,
//                       ),
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.all(16),
//                         border: InputBorder.none,
//                         hintText: "10",
//                         hintStyle: GoogleFonts.poppins(
//                           color: _hintColor,
//                           fontSize: 14.sp,
//                         ),
//                         suffixIcon: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 12),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<String>(
//                               value: _selectedUnit,
//                               items: _units.map((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(
//                                     value.toUpperCase(),
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 13.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _selectedUnit = newValue!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   File? _selectedImage;

//   Widget _buildOtherTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(vertical: 2.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Item Code
//           _buildDecoratedField(
//             label: "Item Code",
//             prefixIcon: Icons.tag,
//             helperText: "Auto-generated unique identifier",
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _itemCodeController,
//                     readOnly: true,
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       color: Colors.blueGrey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(16),
//                       border: InputBorder.none,
//                       hintStyle: GoogleFonts.poppins(
//                         color: _hintColor,
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: _primaryColor.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.autorenew, color: _primaryColor, size: 20),
//                   ),
//                   onPressed: _generateItemCode,
//                   tooltip: 'Generate New Code',
//                 ),
//               ],
//             ),
//           ),

//           // Barcode
//           _buildDecoratedField(
//             label: "Barcode (Optional)",
//             prefixIcon: Icons.qr_code,
//             helperText: "Scan or enter barcode manually",
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _barcodeController,
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       color: _textColor,
//                     ),
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(16),
//                       border: InputBorder.none,
//                       hintText: "Enter barcode number...",
//                       hintStyle: GoogleFonts.poppins(
//                         color: _hintColor,
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 12.w,
//                   margin: EdgeInsets.only(right: 8),
//                   child: ElevatedButton(
//                     onPressed: _openBarcodeScanner,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _primaryColor,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.all(12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: Icon(Icons.qr_code_scanner, size: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Category
//           _buildDecoratedField(
//             label: "Category*",
//             prefixIcon: Icons.category,
//             helperText: "Required - Select item category",
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<Category>(
//                 value: _selectedCategory,
//                 isExpanded: true,
//                 hint: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     "Select category",
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       color: _hintColor,
//                     ),
//                   ),
//                 ),
//                 items: _categories.map((Category category) {
//                   return DropdownMenuItem<Category>(
//                     value: category,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       child: Text(
//                         category.categoryName,
//                         style: GoogleFonts.poppins(
//                           fontSize: 15.sp,
//                           color: _textColor,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (Category? newValue) {
//                   setState(() {
//                     _selectedCategory = newValue;
//                     _selectedSubCategory = null;
//                   });
//                 },
//               ),
//             ),
//           ),

//           // Subcategory
//           if (_selectedCategory != null)
//             _buildDecoratedField(
//               label: "Subcategory (Optional)",
//               prefixIcon: Icons.subdirectory_arrow_right,
//               helperText: "Optional - Select subcategory",
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<SubCategory>(
//                   value: _selectedSubCategory,
//                   isExpanded: true,
//                   hint: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       "Select subcategory",
//                       style: GoogleFonts.poppins(
//                         fontSize: 15.sp,
//                         color: _hintColor,
//                       ),
//                     ),
//                   ),
//                   items: _subCategories
//                       .where((sub) => sub.categoryId == _selectedCategory!.id)
//                       .map((SubCategory subCategory) {
//                         return DropdownMenuItem<SubCategory>(
//                           value: subCategory,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                             child: Text(
//                               subCategory.name,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 15.sp,
//                                 color: _textColor,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                   onChanged: (SubCategory? newValue) {
//                     setState(() {
//                       _selectedSubCategory = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ),

//           // Description
//           _buildDecoratedField(
//             label: "Description (Optional)",
//             prefixIcon: Icons.description,
//             helperText: "Additional details about the item",
//             child: TextFormField(
//               controller: _descriptionController,
//               maxLines: 4,
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _textColor,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(16),
//                 border: InputBorder.none,
//                 hintText: "Enter detailed description...",
//                 hintStyle: GoogleFonts.poppins(
//                   color: _hintColor,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPartyWisePricesTab() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(4.h),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: _primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.group,
//                 size: 60,
//                 color: _primaryColor,
//               ),
//             ).animate().scale(delay: 200.ms).fadeIn(),
//             SizedBox(height: 3.h),
//             Text(
//               "Party Wise Pricing",
//               style: GoogleFonts.poppins(
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.bold,
//                 color: _textColor,
//               ),
//             ),
//             SizedBox(height: 1.h),
//             Text(
//               "Set different prices for different customers",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 color: _hintColor,
//               ),
//             ),
//             SizedBox(height: 2.h),
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.shade50,
//                     Colors.purple.shade50,
//                   ],
//                 ),
//                   borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.business, color: Colors.blue),
//                     ),
//                     title: Text(
//                       "Corporate Discounts",
//                       style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text("Special rates for corporate clients"),
//                   ),
//                   ListTile(
//                     leading: Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade100,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.loyalty, color: Colors.green),
//                     ),
//                     title: Text(
//                       "Loyalty Pricing",
//                       style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text("Discounted rates for loyal customers"),
//                   ),
//                   ListTile(
//                     leading: Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade100,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.local_offer, color: Colors.orange),
//                     ),
//                     title: Text(
//                       "Bulk Order Pricing",
//                       style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text("Special rates for bulk purchases"),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 2.h),
//             Text(
//               "This feature will be available soon!",
//               style: GoogleFonts.poppins(
//                 fontSize: 13.sp,
//                 color: _warningColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(height: 16),
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Select Image Source",
//               style: GoogleFonts.poppins(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 color: _textColor,
//               ),
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildImageSourceButton(
//                   icon: Icons.camera_alt,
//                   label: "Camera",
//                   color: Colors.blue,
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImage(ImageSource.camera);
//                   },
//                 ),
//                 _buildImageSourceButton(
//                   icon: Icons.photo_library,
//                   label: "Gallery",
//                   color: Colors.green,
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImage(ImageSource.gallery);
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImageSourceButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         width: 40.w,
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 32, color: color),
//             ),
//             SizedBox(height: 12),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 15.sp,
//                 fontWeight: FontWeight.w600,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() => _selectedImage = File(pickedFile.path));
//       _showSuccessToast('Image selected successfully!');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [_primaryColor, _secondaryColor],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         elevation: 4,
//         shadowColor: Colors.black26,
//         title: Row(
//           children: [
//             Icon(Icons.add_circle_outline, size: 24),
//             SizedBox(width: 12),
//             Text(
//               "Create New Item",
//               style: GoogleFonts.poppins(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: Text("Help"),
//                   content: Text("This form allows you to create new inventory items. Fill in all required fields and save."),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text("OK"),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             icon: Icon(Icons.help_outline),
//             tooltip: 'Help',
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
//                     child: CircularProgressIndicator(
//                       strokeWidth: 3,
//                       valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "Saving Item...",
//                     style: GoogleFonts.poppins(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       color: _textColor,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "Please wait",
//                     style: GoogleFonts.poppins(
//                       fontSize: 13.sp,
//                       color: _hintColor,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Item Name and Image
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 10,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Basic Information",
//                             style: GoogleFonts.poppins(
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.bold,
//                               color: _textColor,
//                             ),
//                           ),
//                           SizedBox(height: 2.h),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 3,
//                                 child: _buildDecoratedField(
//                                   label: "Item Name*",
//                                   prefixIcon: Icons.shopping_bag,
//                                   helperText: "Enter clear and descriptive name",
//                                   child: TextFormField(
//                                     controller: _itemNameController,
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 15.sp,
//                                       color: _textColor,
//                                     ),
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.all(16),
//                                       border: InputBorder.none,
//                                       hintText: "e.g., Kisan Fruits Jam 500 gm",
//                                       hintStyle: GoogleFonts.poppins(
//                                         color: _hintColor,
//                                         fontSize: 14.sp,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 2.w),
//                               Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Product Image",
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: _textColor.withOpacity(0.8),
//                                       ),
//                                     ),
//                                     SizedBox(height: 0.8.h),
//                                     GestureDetector(
//                                       onTap: _showImageSourceDialog,
//                                       child: Container(
//                                         height: 12.h,
//                                         decoration: BoxDecoration(
//                                           color: _selectedImage != null
//                                               ? Colors.transparent
//                                               : _primaryColor.withOpacity(0.05),
//                                           borderRadius: BorderRadius.circular(16),
//                                           border: Border.all(
//                                             color: _selectedImage != null
//                                                 ? Colors.transparent
//                                                 : _primaryColor.withOpacity(0.3),
//                                             width: 2,
//                                           ),
//                                           boxShadow: _selectedImage != null
//                                               ? [
//                                                   BoxShadow(
//                                                     color: Colors.black12,
//                                                     blurRadius: 8,
//                                                     offset: Offset(0, 2),
//                                                   ),
//                                                 ]
//                                               : null,
//                                         ),
//                                         child: _selectedImage != null
//                                             ? ClipRRect(
//                                                 borderRadius: BorderRadius.circular(16),
//                                                 child: Image.file(
//                                                   _selectedImage!,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               )
//                                             : Column(
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.add_a_photo,
//                                                     size: 32,
//                                                     color: _primaryColor,
//                                                   ),
//                                                   SizedBox(height: 0.5.h),
//                                                   Text(
//                                                     "Add Photo",
//                                                     style: GoogleFonts.poppins(
//                                                       fontSize: 12.sp,
//                                                       color: _primaryColor,
//                                                       fontWeight: FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 2.h),

//                     // Item Type Toggle
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 10,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Item Type",
//                             style: GoogleFonts.poppins(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w600,
//                               color: _textColor.withOpacity(0.8),
//                             ),
//                           ),
//                           SizedBox(height: 1.h),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: _buildItemTypeButton(
//                                   label: "Product",
//                                   icon: Icons.shopping_bag,
//                                   isSelected: isProduct,
//                                   onTap: () => _toggleItemType(true),
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               SizedBox(width: 2.w),
//                               Expanded(
//                                 child: _buildItemTypeButton(
//                                   label: "Service",
//                                   icon: Icons.handyman,
//                                   isSelected: !isProduct,
//                                   onTap: () => _toggleItemType(false),
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 2.h),

//                     // Dynamic Tabs
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 10,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                             child: TabBar(
//                               controller: _tabController,
//                               isScrollable: false,
//                               labelColor: _primaryColor,
//                               unselectedLabelColor: _hintColor,
//                               indicatorColor: _primaryColor,
//                               indicatorSize: TabBarIndicatorSize.tab,
//                               indicatorWeight: 3,
//                               labelPadding: EdgeInsets.zero,
//                               tabAlignment: TabAlignment.fill,
//                               tabs: (isProduct ? _productTabs : _serviceTabs).map((tab) {
//                                 return Tab(
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 12),
//                                     child: Text(
//                                       tab,
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14.sp,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                           Container(
//                             height: 55.h,
//                             child: TabBarView(
//                               controller: _tabController,
//                               children: isProduct
//                                   ? [
//                                       _buildPricingTab(),
//                                       _buildStockTab(),
//                                       _buildOtherTab(),
//                                       _buildPartyWisePricesTab(),
//                                     ]
//                                   : [
//                                       _buildPricingTab(),
//                                       _buildOtherTab(),
//                                       _buildPartyWisePricesTab(),
//                                     ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 20,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: _isLoading ? null : () => Navigator.pop(context),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: _primaryColor,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   side: BorderSide(color: _primaryColor),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.arrow_back, size: 20),
//                     SizedBox(width: 8),
//                     Text(
//                       "Cancel",
//                       style: GoogleFonts.poppins(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _submitItemData,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _primaryColor,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 4,
//                   shadowColor: _primaryColor.withOpacity(0.3),
//                 ),
//                 child: _isLoading
//                     ? SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 3,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.save, size: 22),
//                           SizedBox(width: 8),
//                           Text(
//                             "Save Item",
//                             style: GoogleFonts.poppins(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//               ).animate().scale(delay: 300.ms),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildItemTypeButton({
//     required String label,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? color : Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? color : color.withOpacity(0.3),
//             width: 2,
//           ),
//           gradient: isSelected
//               ? LinearGradient(
//                   colors: [color, color.withOpacity(0.8)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 )
//               : null,
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: color.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               size: 32,
//               color: isSelected ? Colors.white : color,
//             ),
//             SizedBox(height: 8),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? Colors.white : color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Barcode Scanner Screen for Item Creation
// class BarcodeScannerForItemScreen extends StatefulWidget {
//   const BarcodeScannerForItemScreen({super.key});

//   @override
//   State<BarcodeScannerForItemScreen> createState() =>
//       _BarcodeScannerForItemScreenState();
// }

// class _BarcodeScannerForItemScreenState
//     extends State<BarcodeScannerForItemScreen>
//     with WidgetsBindingObserver {
//   CameraController? _cameraController;
//   List<CameraDescription>? _cameras;
//   String? _scannedBarcode;
//   bool _isLoading = false;
//   bool _isScanning = true;
//   bool _isCameraInitialized = false;
//   bool _isTorchOn = false;
//   final BarcodeScanner _barcodeScanner = BarcodeScanner();

//   String _lastScannedValue = '';
//   Timer? _scanResetTimer;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _scanResetTimer?.cancel();
//     _cameraController?.dispose();
//     _barcodeScanner.close();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }
//     if (state == AppLifecycleState.inactive) {
//       _cameraController?.dispose();
//       _scanResetTimer?.cancel();
//     } else if (state == AppLifecycleState.resumed) {
//       _initializeCamera();
//     }
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _cameras = await availableCameras();
//       if (_cameras!.isEmpty) return;

//       final backCamera = _cameras!.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.back,
//         orElse: () => _cameras!.first,
//       );

//       _cameraController = CameraController(
//         backCamera,
//         ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await _cameraController!.initialize();

//       if (mounted) {
//         setState(() {
//           _isCameraInitialized = true;
//         });
//       }

//       _cameraController!.startImageStream(_processCameraImage);
//     } catch (e) {
//       print('Error initializing camera: $e');
//       if (mounted) {
//         setState(() {
//           _isCameraInitialized = false;
//         });
//       }
//     }
//   }

//   void _processCameraImage(CameraImage image) async {
//     if (!_isScanning || _isLoading) {
//       return;
//     }

//     try {
//       final inputImage = _createInputImage(image);
//       if (inputImage == null) return;

//       final List<Barcode> barcodes = await _barcodeScanner.processImage(
//         inputImage,
//       );

//       if (barcodes.isNotEmpty) {
//         final Barcode barcode = barcodes.first;
//         final String barcodeValue =
//             barcode.rawValue ?? barcode.displayValue ?? '';

//         if (barcodeValue.isNotEmpty && barcodeValue != _lastScannedValue) {
//           _lastScannedValue = barcodeValue;

//           if (mounted) {
//             setState(() {
//               _scannedBarcode = barcodeValue;
//               _isLoading = true;
//               _isScanning = false;
//             });
//           }

//           // Return the scanned value after delay
//           _scanResetTimer?.cancel();
//           _scanResetTimer = Timer(Duration(milliseconds: 1500), () {
//             if (mounted) {
//               Navigator.pop(context, _scannedBarcode);
//             }
//           });
//         }
//       }
//     } catch (e) {
//       print('Error scanning barcode: $e');
//     }
//   }

//   InputImage? _createInputImage(CameraImage image) {
//     try {
//       final WriteBuffer allBytes = WriteBuffer();
//       for (final Plane plane in image.planes) {
//         allBytes.putUint8List(plane.bytes);
//       }
//       final bytes = allBytes.done().buffer.asUint8List();

//       final imageRotation = _getImageRotation();

//       final inputImageMetadata = InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: imageRotation,
//         format: InputImageFormat.nv21,
//         bytesPerRow: image.planes.first.bytesPerRow,
//       );

//       return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
//     } catch (e) {
//       print('Error creating InputImage: $e');
//       return null;
//     }
//   }

//   InputImageRotation _getImageRotation() {
//     if (_cameraController == null) return InputImageRotation.rotation0deg;

//     final camera = _cameraController!.description;
//     switch (camera.sensorOrientation) {
//       case 90:
//         return InputImageRotation.rotation90deg;
//       case 180:
//         return InputImageRotation.rotation180deg;
//       case 270:
//         return InputImageRotation.rotation270deg;
//       default:
//         return InputImageRotation.rotation0deg;
//     }
//   }

//   void _toggleTorch() async {
//     if (_cameraController != null && _cameraController!.value.isInitialized) {
//       try {
//         await _cameraController!.setFlashMode(
//           _isTorchOn ? FlashMode.off : FlashMode.torch,
//         );
//         if (mounted) {
//           setState(() {
//             _isTorchOn = !_isTorchOn;
//           });
//         }
//       } catch (e) {
//         print('Error toggling torch: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text(
//           'Scan Barcode',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.5,
//           ),
//         ),
//         backgroundColor: Color(0xFF2E7D32),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, size: 24),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               _isTorchOn ? Icons.flash_on : Icons.flash_off,
//               color: _isTorchOn ? Colors.yellow : Colors.white,
//               size: 24,
//             ),
//             onPressed: _toggleTorch,
//           ),
//         ],
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (!_isCameraInitialized || _cameraController == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Initializing Camera...',
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         // Camera Preview
//         SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: CameraPreview(_cameraController!),
//         ),

//         // Scanner Overlay
//         if (_isScanning && _scannedBarcode == null) _buildScannerOverlay(),

//         // Loading Indicator
//         if (_isLoading)
//           Center(
//             child: Container(
//               padding: EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF2E7D32),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Scanning...',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Please hold steady',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//         // Result Display
//         if (_scannedBarcode != null && !_isLoading) _buildResultCard(),
//       ],
//     );
//   }

//   Widget _buildScannerOverlay() {
//     return Column(
//       children: [
//         Expanded(flex: 2, child: Container(color: Colors.black54)),
//         Expanded(
//           flex: 3,
//           child: Row(
//             children: [
//               Expanded(flex: 1, child: Container(color: Colors.black54)),
//               Expanded(
//                 flex: 8,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFF2E7D32), width: 3),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.qr_code_scanner,
//                         size: 60,
//                         color: Color(0xFF2E7D32),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Align Barcode',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         'Position within the frame',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: Colors.white70,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 20),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Color(0xFF2E7D32),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'Auto-scan enabled',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(flex: 1, child: Container(color: Colors.black54)),
//             ],
//           ),
//         ),
//         Expanded(flex: 2, child: Container(color: Colors.black54)),
//       ],
//     );
//   }

//   Widget _buildResultCard() {
//     return Positioned(
//       bottom: 2.h,
//       left: 3.w,
//       right: 3.w,
//       child: Container(
//         padding: EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black54,
//               blurRadius: 20,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade100,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.check, color: Colors.green, size: 24),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       'Barcode Scanned!',
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green[800],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(Icons.verified, color: Colors.green, size: 30),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Scanned Value
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blue.shade50, Colors.green.shade50],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.blue.shade200, width: 2),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Scanned Value:',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: Colors.blue[900],
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: SelectableText(
//                       _scannedBarcode!,
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.timer, color: Colors.grey.shade600, size: 16),
//                 SizedBox(width: 8),
//                 Text(
//                   'Returning to form in a moment...',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Enhanced HSN Selection Screen
// class HsnSelectionScreen extends StatefulWidget {
//   const HsnSelectionScreen({super.key});

//   @override
//   _HsnSelectionScreenState createState() => _HsnSelectionScreenState();
// }

// class _HsnSelectionScreenState extends State<HsnSelectionScreen> {
//   List<HsnModel> hsnList = [];
//   List<HsnModel> filteredHsnList = [];
//   bool isLoading = true;
//   String errorMessage = '';
//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = '';

//   final Color _primaryColor = Color(0xFF2E7D32);
//   final Color _backgroundColor = Color(0xFFF5F7FA);

//   @override
//   void initState() {
//     super.initState();
//     fetchHsnData();
//     searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     setState(() {
//       searchQuery = searchController.text.toLowerCase();
//       _filterHsnCodes();
//     });
//   }

//   void _filterHsnCodes() {
//     if (searchQuery.isEmpty) {
//       filteredHsnList = List.from(hsnList);
//     } else {
//       filteredHsnList = hsnList.where((hsn) {
//         return hsn.hsnCode.toLowerCase().contains(searchQuery) ||
//             hsn.hsnCode.contains(searchQuery);
//       }).toList();
//     }
//   }

//   Future<void> fetchHsnData() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       final response = await http.get(
//         Uri.parse('http://202.140.138.215:85/api/HSNApi'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           hsnList = data.map((json) => HsnModel.fromJson(json)).toList();
//           filteredHsnList = List.from(hsnList);
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load data: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Widget _buildHsnList() {
//     return ListView.separated(
//       padding: EdgeInsets.symmetric(vertical: 1.h),
//       itemCount: filteredHsnList.length,
//       separatorBuilder: (context, index) => SizedBox(height: 0.5.h),
//       itemBuilder: (context, index) {
//         final hsn = filteredHsnList[index];
//         return Card(
//           margin: EdgeInsets.symmetric(horizontal: 2.w),
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.white,
//                   Colors.blueGrey.shade50,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: ListTile(
//               onTap: () {
//                 Navigator.pop(context, hsn);
//               },
//               leading: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: _primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: _primaryColor.withOpacity(0.3)),
//                 ),
//                 child: Center(
//                   child: Text(
//                     hsn.hsnCode.substring(0, 2),
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: _primaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//               title: Text(
//                 hsn.hsnCode,
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.sp,
//                   color: Colors.blueGrey.shade900,
//                 ),
//               ),
//               subtitle: Padding(
//                 padding: EdgeInsets.only(top: 8),
//                 child: Row(
//                   children: [
//                     _buildTaxChip('SGST', '${hsn.sgst}%', Colors.blue),
//                     SizedBox(width: 1.w),
//                     _buildTaxChip('CGST', '${hsn.cgst}%', Colors.green),
//                     SizedBox(width: 1.w),
//                     _buildTaxChip('IGST', '${hsn.igst}%', Colors.orange),
//                   ],
//                 ),
//               ),
//               trailing: Icon(
//                 Icons.chevron_right,
//                 color: _primaryColor,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTaxChip(String label, String value, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 10.sp,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(width: 4),
//           Text(
//             value,
//             style: GoogleFonts.poppins(
//               fontSize: 10.sp,
//               color: color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'Select HSN Code',
//           style: GoogleFonts.poppins(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 4,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: fetchHsnData,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Container(
//             padding: EdgeInsets.all(2.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search HSN code...',
//                 hintStyle: GoogleFonts.poppins(fontSize: 15.sp),
//                 prefixIcon: Icon(Icons.search, color: _primaryColor),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//                 contentPadding: EdgeInsets.all(16),
//                 suffixIcon: searchQuery.isNotEmpty
//                     ? IconButton(
//                         icon: Icon(Icons.clear, size: 20),
//                         onPressed: () {
//                           searchController.clear();
//                         },
//                       )
//                     : null,
//               ),
//             ),
//           ),

//           // Results Count
//           if (searchQuery.isNotEmpty)
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//               color: Colors.white,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${filteredHsnList.length} result(s) found',
//                     style: GoogleFonts.poppins(
//                       color: Colors.grey.shade600,
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   if (filteredHsnList.isNotEmpty)
//                     Text(
//                       'Tap to select',
//                       style: GoogleFonts.poppins(
//                         color: _primaryColor,
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//           Expanded(
//             child: isLoading
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           decoration: BoxDecoration(
//                             color: _primaryColor.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               strokeWidth: 3,
//                               valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'Loading HSN Codes...',
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             color: Colors.grey.shade700,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : errorMessage.isNotEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.error_outline,
//                               size: 64,
//                               color: Colors.red.shade400,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               errorMessage,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 color: Colors.grey.shade700,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: fetchHsnData,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: _primaryColor,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 24,
//                                   vertical: 12,
//                                 ),
//                               ),
//                               child: Text('Retry'),
//                             ),
//                           ],
//                         ),
//                       )
//                     : filteredHsnList.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: 120,
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     Icons.search_off,
//                                     size: 60,
//                                     color: Colors.grey.shade400,
//                                   ),
//                                 ),
//                                 SizedBox(height: 24),
//                                 Text(
//                                   searchQuery.isEmpty
//                                       ? 'No HSN codes available'
//                                       : 'No matching HSN codes',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 18,
//                                     color: Colors.grey.shade700,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   searchQuery.isEmpty
//                                       ? 'Check back later'
//                                       : 'Try a different search term',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 14,
//                                     color: Colors.grey.shade500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : _buildHsnList(),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Add new HSN functionality
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text("Add New HSN"),
//               content: Text("This feature will be available soon!"),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("OK"),
//                 ),
//               ],
//             ),
//           );
//         },
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         icon: Icon(Icons.add),
//         label: Text("Add New"),
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ).animate().scale(delay: 300.ms),
//     );
//   }
// }

// // HSN Model class
// class HsnModel {
//   final int id;
//   final String hsnCode;
//   final double sgst;
//   final double cgst;
//   final double igst;
//   final double cess;
//   final int? hsnType;

//   HsnModel({
//     required this.id,
//     required this.hsnCode,
//     required this.sgst,
//     required this.cgst,
//     required this.igst,
//     required this.cess,
//     this.hsnType,
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
//     );
//   }
// }

// class Category {
//   final int id;
//   final String categoryName;
//   final DateTime created;

//   Category({
//     required this.id,
//     required this.categoryName,
//     required this.created,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'] ?? 0,
//       categoryName: json['categoryName'] ?? '',
//       created: DateTime.parse(json['created'] ?? DateTime.now().toString()),
//     );
//   }
// }

// class SubCategory {
//   final int id;
//   final String name;
//   final int categoryId;
//   final Category category;
//   final DateTime created;

//   SubCategory({
//     required this.id,
//     required this.name,
//     required this.categoryId,
//     required this.category,
//     required this.created,
//   });

//   factory SubCategory.fromJson(Map<String, dynamic> json) {
//     return SubCategory(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       categoryId: json['categoryId'] ?? 0,
//       category: Category.fromJson(json['category'] ?? {}),
//       created: DateTime.parse(json['created'] ?? DateTime.now().toString()),
//     );
//   }
// }


// ignore_for_file: depend_on_referenced_packages, avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class CreateNewItemScreen extends StatefulWidget {
  const CreateNewItemScreen({super.key});

  @override
  State<CreateNewItemScreen> createState() => _CreateNewItemScreenState();
}

class _CreateNewItemScreenState extends State<CreateNewItemScreen>
    with SingleTickerProviderStateMixin {
  bool isProduct = true;
  final List<String> _chartOptions = ['Without Tax', 'With Tax'];
  String _selectedChart = 'Without Tax';
  late TabController _tabController;

  final List<String> _productTabs = [
    '💰 Pricing',
    '📦 Stock',
    '📝 Other',
    '👥 Party Wise',
  ];
  final List<String> _serviceTabs = [
    '💰 Pricing',
    '📝 Other',
    '👥 Party Wise',
  ];

  // Form controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _salesPriceController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _packingController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _salesRate2Controller = TextEditingController();
  final TextEditingController _minimumQtyController = TextEditingController();
  final TextEditingController _maximumQtyController = TextEditingController();
  final TextEditingController _shelfLifeController = TextEditingController();
  final TextEditingController _maximumDiscountController =
      TextEditingController();
  final TextEditingController _conversionController = TextEditingController();

  HsnModel? _selectedHsn;
  List<Category> _categories = [];
  List<SubCategory> _subCategories = [];
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  bool _decimalAllowed = false;
  bool _isLoading = false;

  // Teal Color Scheme - Modern aur professional
  final Color _primaryTeal = Color(0xFF009688); // Bright teal
  final Color _darkTeal = Color(0xFF00695C); // Dark teal
  final Color _lightTeal = Color(0xFF80CBC4); // Light teal
  final Color _accentOrange = Color(0xFFFF9800); // Orange accent
  final Color _accentPurple = Color(0xFF9C27B0); // Purple accent
  final Color _bgColor = Color(0xFFFAFAFA); // Light background
  final Color _cardColor = Colors.white;
  final Color _textDark = Color(0xFF263238); // Dark text
  final Color _textLight = Color(0xFF78909C); // Light text
  final Color _borderColor = Color(0xFFE0E0E0); // Border color
  final Color _successGreen = Color(0xFF4CAF50);
  final Color _errorRed = Color(0xFFF44336);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: isProduct ? _productTabs.length : _serviceTabs.length,
      vsync: this,
    );
    _generateItemCode();
    _loadCategories();
  }

  void _generateItemCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _itemCodeController.text = 'ITEM${timestamp.toString().substring(9)}';
  }

  Future<void> _loadCategories() async {
    try {
      final categoryResponse = await http.get(
        Uri.parse('http://202.140.138.215:85/api/CategoryMasterApi'),
      );
      if (categoryResponse.statusCode == 200) {
        final Map<String, dynamic> categoryData = json.decode(
          categoryResponse.body,
        );
        if (categoryData['success'] == true) {
          final List<dynamic> categoryList = categoryData['data'];
          setState(() {
            _categories =
                categoryList.map((json) => Category.fromJson(json)).toList();
          });
        }
      }

      final subCategoryResponse = await http.get(
        Uri.parse('http://202.140.138.215:85/api/SubCategoryApi/all'),
      );

      if (subCategoryResponse.statusCode == 200) {
        final List<dynamic> subCategoryData = json.decode(
          subCategoryResponse.body,
        );
        setState(() {
          _subCategories =
              subCategoryData.map((json) => SubCategory.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _itemNameController.dispose();
    _itemCodeController.dispose();
    _barcodeController.dispose();
    _salesPriceController.dispose();
    _purchasePriceController.dispose();
    _stockController.dispose();
    _hsnCodeController.dispose();
    _descriptionController.dispose();
    _packingController.dispose();
    _mrpController.dispose();
    _salesRate2Controller.dispose();
    _minimumQtyController.dispose();
    _maximumQtyController.dispose();
    _shelfLifeController.dispose();
    _maximumDiscountController.dispose();
    _conversionController.dispose();
    super.dispose();
  }

  void _toggleItemType(bool isProductSelected) {
    if (isProduct != isProductSelected) {
      setState(() {
        isProduct = isProductSelected;
        _tabController.dispose();
        _tabController = TabController(
          length: isProduct ? _productTabs.length : _serviceTabs.length,
          vsync: this,
        );
      });
    }
  }

  Future<void> _openBarcodeScanner() async {
    final scannedBarcode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerForItemScreen(),
        fullscreenDialog: true,
      ),
    );
    if (scannedBarcode != null && scannedBarcode is String) {
      setState(() {
        _barcodeController.text = scannedBarcode;
      });
      _showToast('Barcode scanned successfully!', _successGreen);
    }
  }

  final List<String> _units = [
    'kg',
    'g',
    'mg',
    'ltr',
    'ml',
    'pcs',
    'box',
    'carton',
    'dozen',
    'pair',
    'set',
    'pack',
    'bottle',
    'can',
    'jar',
    'bag',
    'roll',
    'meter',
    'cm',
    'mm',
    'inch',
    'feet',
    'yard',
    'sq. ft',
    'sq. m',
    'gram',
    'kilogram',
    'liter',
    'milliliter',
    'ton',
    'quintal',
    'ounce',
    'pound',
    'gallon',
    'unit',
    'piece',
    'each',
    'bundle',
    'packet',
    'ream',
    'sheet',
    'book',
    'tube',
    'capsule',
    'tablet',
    'vial',
    'ampoule',
    'syringe',
  ];

  String _selectedUnit = 'kg';

  void _showToast(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                color == _successGreen ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitItemData() async {
    if (_itemNameController.text.isEmpty) {
      _showToast('Item Name is required', _errorRed);
      return;
    }

    if (_selectedCategory == null) {
      _showToast('Category is required', _errorRed);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> requestData = {
      "Id": 0,
      "Name": _itemNameController.text.trim(),
      "Code": _itemCodeController.text.trim(),
      "Barcode": _barcodeController.text.trim().isNotEmpty
          ? _barcodeController.text.trim()
          : null,
      "Unit1": _selectedUnit.toUpperCase(),
      "Unit2": 1,
      "Packing": _packingController.text.trim().isNotEmpty
          ? _packingController.text.trim()
          : null,
      "CategoryId": _selectedCategory?.id ?? 0,
      "Category": null,
      "SubCategoryId": _selectedSubCategory?.id,
      "SubCategory": _selectedSubCategory?.name,
      "HsnId": _selectedHsn?.id,
      "Hsn": _selectedHsn?.hsnCode,
      "Mrp": int.tryParse(_mrpController.text) ?? 0,
      "SalesRate1": int.tryParse(_salesPriceController.text) ?? 0,
      "SalesRate2": int.tryParse(_salesRate2Controller.text) ?? 0,
      "MinimumQty": int.tryParse(_minimumQtyController.text) ?? 0,
      "MaximumQty": int.tryParse(_maximumQtyController.text) ?? 0,
      "ShelfLife": int.tryParse(_shelfLifeController.text) ?? 0,
      "MaximumDiscount": int.tryParse(_maximumDiscountController.text) ?? 0,
      "DecemalAllowed": _decimalAllowed,
      "Conversion": int.tryParse(_conversionController.text) ?? 0,
      "photo": _selectedImage != null
          ? base64Encode(_selectedImage!.readAsBytesSync())
          : null,
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/ItemMasterApi'),
        headers: headers,
        body: json.encode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          _showToast(
            '✅ ${responseData['message'] ?? 'Item saved successfully!'}',
            _successGreen,
          );
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.pop(context, true);
          });
        } else {
          _showToast(
            '❌ ${responseData['message'] ?? 'Failed to save item'}',
            _errorRed,
          );
        }
      } else {
        _showToast('Failed with status: ${response.statusCode}', _errorRed);
      }
    } catch (e) {
      print('Error: $e');
      _showToast('Network Error: $e', _errorRed);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectHsnCode(BuildContext context) async {
    final selectedHsn = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HsnSelectionScreen(),
        fullscreenDialog: true,
      ),
    );

    if (selectedHsn != null && selectedHsn is HsnModel) {
      setState(() {
        _selectedHsn = selectedHsn;
        _hsnCodeController.text = selectedHsn.hsnCode;
      });
      _showToast('HSN code selected', _successGreen);
    }
  }

  Widget _buildModernField({
    required String label,
    required Widget child,
    String? helperText,
    bool isRequired = false,
    IconData? prefixIcon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (prefixIcon != null)
                Container(
                  width: 36,
                  height: 36,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: _primaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    prefixIcon,
                    size: 20,
                    color: _primaryTeal,
                  ),
                ),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              if (isRequired)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Required',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: _errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.white,
                child: child,
              ),
            ),
          ),
          if (helperText != null) ...[
            SizedBox(height: 0.5.h),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                helperText,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: _textLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unit Selection
          _buildModernField(
            label: "Measurement Unit",
            prefixIcon: Icons.straighten,
            helperText: "Select the primary unit for this item",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  isExpanded: true,
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primaryTeal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.arrow_drop_down, color: Colors.white),
                  ),
                  dropdownColor: Colors.white,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _textDark,
                    fontWeight: FontWeight.w500,
                  ),
                  items: _units.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _lightTeal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  value.substring(0, 2).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryTeal,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              value.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: _textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUnit = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),

          // Packing Details
          _buildModernField(
            label: "Packing Details",
            prefixIcon: Icons.inventory_2,
            helperText: "e.g., 500 ml bottle, 1 kg pouch",
            child: TextFormField(
              controller: _packingController,
              style: TextStyle(
                fontSize: 15.sp,
                color: _textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "Enter packaging information...",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),

          // HSN Code
          _buildModernField(
            label: "HSN Code & Tax",
            prefixIcon: Icons.receipt,
            helperText: "Select HSN code for tax calculation",
            child: InkWell(
              onTap: () => _selectHsnCode(context),
              borderRadius: BorderRadius.circular(16),
              child: AbsorbPointer(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _hsnCodeController.text.isNotEmpty
                              ? _hsnCodeController.text
                              : "Tap to select HSN code",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: _hsnCodeController.text.isNotEmpty
                                ? _textDark
                                : _textLight,
                            fontWeight: _hsnCodeController.text.isNotEmpty
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _primaryTeal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // GST Display
          if (_selectedHsn != null)
            Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primaryTeal.withOpacity(0.08),
                    _lightTeal.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _primaryTeal.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: _successGreen, size: 22),
                      SizedBox(width: 10),
                      Text(
                        "Tax Rates Applied",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTaxBadge(
                        "SGST",
                        "${_selectedHsn!.sgst}%",
                        Colors.blue.shade400,
                      ),
                      _buildTaxBadge(
                        "CGST",
                        "${_selectedHsn!.cgst}%",
                        Colors.green.shade400,
                      ),
                      _buildTaxBadge(
                        "IGST",
                        "${_selectedHsn!.igst}%",
                        Colors.orange.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Pricing Section Title
          Container(
            margin: EdgeInsets.only(bottom: 2.h, top: 1.h),
            child: Row(
              children: [
                Icon(Icons.monetization_on, color: _accentOrange, size: 22),
                SizedBox(width: 10),
                Text(
                  "Pricing Details",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Sales Price
          _buildModernField(
            label: "Sales Price",
            prefixIcon: Icons.sell,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _salesPriceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                      hintText: "0.00",
                      hintStyle: TextStyle(
                        color: _textLight,
                        fontSize: 16.sp,
                      ),
                      prefixIcon: Container(
                        width: 50,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "₹",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: _primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 35.w,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _darkTeal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedChart,
                        dropdownColor: Colors.white,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: _darkTeal,
                          fontWeight: FontWeight.w600,
                        ),
                        items: _chartOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedChart = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Purchase Price
          _buildModernField(
            label: "Purchase Price",
            prefixIcon: Icons.shopping_cart,
            child: TextFormField(
              controller: _purchasePriceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 16.sp,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "0.00",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 16.sp,
                ),
                prefixIcon: Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "₹",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: _primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // MRP
          _buildModernField(
            label: "Maximum Retail Price (MRP)",
            prefixIcon: Icons.price_change,
            helperText: "Printed maximum selling price",
            child: TextFormField(
              controller: _mrpController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 16.sp,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "0.00",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 16.sp,
                ),
                prefixIcon: Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "₹",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: _primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Alternate Price
          _buildModernField(
            label: "Alternate Sales Price",
            prefixIcon: Icons.price_check,
            helperText: "Special price for selected customers",
            child: TextFormField(
              controller: _salesRate2Controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 16.sp,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "0.00",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 16.sp,
                ),
                prefixIcon: Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "₹",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: _primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxBadge(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  bool _lowStockAlertEnabled = false;

  Widget _buildStockTab() {
    DateTime selectedDate = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Opening Stock Section
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              children: [
                Icon(Icons.inventory, color: _primaryTeal, size: 24),
                SizedBox(width: 10),
                Text(
                  "Stock Management",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Opening Stock Row
          Row(
            children: [
              Expanded(
                child: _buildModernField(
                  label: "Opening Stock",
                  prefixIcon: Icons.start,
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                      hintText: "0",
                      hintStyle: TextStyle(
                        color: _textLight,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildModernField(
                  label: "Stock Date",
                  prefixIcon: Icons.calendar_today,
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: _primaryTeal,
                              colorScheme: ColorScheme.light(
                                primary: _primaryTeal,
                                secondary: _primaryTeal,
                              ),
                              buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.date_range, color: _primaryTeal, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              dateFormat.format(selectedDate),
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: _textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Stock Unit
          _buildModernField(
            label: "Stock Unit",
            prefixIcon: Icons.scale,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: _primaryTeal),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _textDark,
                    fontWeight: FontWeight.w500,
                  ),
                  items: _units.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUnit = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),

          // Quantity Limits Section
          Container(
            margin: EdgeInsets.only(bottom: 2.h, top: 1.h),
            child: Row(
              children: [
                Icon(Icons.search, color: _accentPurple, size: 24),
                SizedBox(width: 10),
                Text(
                  "Quantity Limits",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Minimum Quantity
          _buildModernField(
            label: "Minimum Order Quantity",
            prefixIcon: Icons.arrow_circle_down,
            helperText: "Lowest quantity that can be ordered",
            child: TextFormField(
              controller: _minimumQtyController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 16.sp,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "1",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),

          // Maximum Quantity
          _buildModernField(
            label: "Maximum Order Quantity",
            prefixIcon: Icons.arrow_circle_up,
            helperText: "Highest quantity per single order",
            child: TextFormField(
              controller: _maximumQtyController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 16.sp,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "100",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),

          // Product Life Section
          Container(
            margin: EdgeInsets.only(bottom: 2.h, top: 1.h),
            child: Row(
              children: [
                Icon(Icons.timelapse, color: Colors.amber, size: 24),
                SizedBox(width: 10),
                Text(
                  "Product Life & Conversion",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Shelf Life
          _buildModernField(
            label: "Shelf Life (Days)",
            prefixIcon: Icons.timer,
            helperText: "Product expiry duration in days",
            child: TextFormField(
              controller: _shelfLifeController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 16.sp,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "365",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),

          // Conversion Factor
          _buildModernField(
            label: "Conversion Factor",
            prefixIcon: Icons.compare_arrows,
            helperText: "e.g., 1 kg = 1000 g (enter 1000)",
            child: TextFormField(
              controller: _conversionController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 16.sp,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "1",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),

          // Low Stock Alert
          Container(
            margin: EdgeInsets.only(top: 2.h),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.08),
                  Colors.amber.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.notifications_active,
                            color: Colors.orange,
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Low Stock Alert",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: _textDark,
                              ),
                            ),
                            Text(
                              "Get notified when stock is low",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: _textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 1.3,
                      child: Switch(
                        value: _lowStockAlertEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _lowStockAlertEnabled = value;
                          });
                        },
                        activeColor: Colors.orange,
                        activeTrackColor: Colors.orange.shade200,
                        inactiveThumbColor: _textLight,
                        inactiveTrackColor: _borderColor,
                      ),
                    ),
                  ],
                ),
                if (_lowStockAlertEnabled) ...[
                  SizedBox(height: 20),
                  _buildModernField(
                    label: "Alert Threshold",
                    prefixIcon: Icons.warning,
                    helperText: "Trigger alert when stock reaches this level",
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: _textDark,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                        hintText: "10",
                        hintStyle: TextStyle(
                          color: _textLight,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  File? _selectedImage;

  Widget _buildOtherTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information Section
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              children: [
                Icon(Icons.info, color: _primaryTeal, size: 24),
                SizedBox(width: 10),
                Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Item Code
          _buildModernField(
            label: "Item Code",
            prefixIcon: Icons.qr_code,
            helperText: "Auto-generated unique identifier",
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _itemCodeController,
                    readOnly: true,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: _darkTeal,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: _textLight,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: _primaryTeal,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryTeal.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.autorenew, size: 20, color: Colors.white),
                    onPressed: _generateItemCode,
                    tooltip: 'Generate New Code',
                  ),
                ),
              ],
            ),
          ),

          // Barcode
          _buildModernField(
            label: "Barcode",
            prefixIcon: Icons.barcode_reader,
            helperText: "Scan or enter barcode manually",
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _barcodeController,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: _textDark,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                      hintText: "Enter barcode number...",
                      hintStyle: TextStyle(
                        color: _textLight,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 45,
                  height: 45,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryTeal, _darkTeal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryTeal.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.qr_code_scanner, size: 22, color: Colors.white),
                    onPressed: _openBarcodeScanner,
                    tooltip: 'Scan Barcode',
                  ),
                ),
              ],
            ),
          ),

          // Category Section
          Container(
            margin: EdgeInsets.only(bottom: 2.h, top: 1.h),
            child: Row(
              children: [
                Icon(Icons.category, color: _accentPurple, size: 24),
                SizedBox(width: 10),
                Text(
                  "Category Details",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Category
          _buildModernField(
            label: "Category",
            prefixIcon: Icons.category,
            isRequired: true,
            helperText: "Select the main category for this item",
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Category>(
                value: _selectedCategory,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: _primaryTeal),
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Select category",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: _textLight,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: _textDark,
                  fontWeight: FontWeight.w500,
                ),
                items: _categories.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text(
                        category.categoryName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: _textDark,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                    _selectedSubCategory = null;
                  });
                },
              ),
            ),
          ),

          // Subcategory
          if (_selectedCategory != null)
            _buildModernField(
              label: "Subcategory",
              prefixIcon: Icons.subdirectory_arrow_right,
              helperText: "Optional - Select subcategory for better organization",
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SubCategory>(
                  value: _selectedSubCategory,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: _primaryTeal),
                  hint: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Select subcategory",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: _textLight,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _textDark,
                    fontWeight: FontWeight.w500,
                  ),
                  items: _subCategories
                      .where((sub) => sub.categoryId == _selectedCategory!.id)
                      .map((SubCategory subCategory) {
                    return DropdownMenuItem<SubCategory>(
                      value: subCategory,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          subCategory.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: _textDark,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (SubCategory? newValue) {
                    setState(() {
                      _selectedSubCategory = newValue;
                    });
                  },
                ),
              ),
            ),

          // Description
          _buildModernField(
            label: "Description",
            prefixIcon: Icons.description,
            helperText: "Add detailed description about the item",
            child: TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              style: TextStyle(
                fontSize: 15.sp,
                color: _textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: "Enter detailed description...",
                hintStyle: TextStyle(
                  color: _textLight,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyWisePricesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryTeal.withOpacity(0.1), _lightTeal.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(75),
            ),
            child: Center(
              child: Icon(
                Icons.group_work,
                size: 70,
                color: _primaryTeal,
              ),
            ),
          ).animate().scale(delay: 200.ms).fadeIn(),

          SizedBox(height: 4.h),

          // Title
          Text(
            "Party Wise Pricing",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: _textDark,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: 1.h),

          // Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              "Set custom prices for different customers or groups",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: _textLight,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Features Grid
          Wrap(
            spacing: 3.w,
            runSpacing: 3.h,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureCard(
                icon: Icons.business,
                title: "Corporate Pricing",
                description: "Special rates for corporate clients",
                color: Colors.blue,
              ),
              _buildFeatureCard(
                icon: Icons.loyalty,
                title: "Loyalty Discounts",
                description: "Reward loyal customers",
                color: Colors.green,
              ),
              _buildFeatureCard(
                icon: Icons.local_offer,
                title: "Bulk Pricing",
                description: "Discounted rates for bulk orders",
                color: Colors.orange,
              ),
              _buildFeatureCard(
                icon: Icons.star,
                title: "VIP Pricing",
                description: "Exclusive rates for VIP customers",
                color: Colors.purple,
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Coming Soon Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryTeal, _darkTeal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: _primaryTeal.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  "Coming Soon",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 42.w,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, size: 28, color: color),
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 11.sp,
              color: _textLight,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Add Product Image",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: _textDark,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: "Gallery",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40.w,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
      _showToast('Image selected successfully!', _successGreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 16.h,
              floating: false,
              pinned: true,
              backgroundColor: _primaryTeal,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: _primaryTeal.withOpacity(0.4),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _primaryTeal,
                        _darkTeal,
                        _primaryTeal.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 4.w,
                      right: 4.w,
                      top: 8.h,
                      bottom: 3.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Create New Item',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          'Add product details and pricing information',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.help_outline, size: 20),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Item Creation Guide",
                          style: TextStyle(color: _primaryTeal),
                        ),
                        content: Text(
                          "Fill all required fields marked with *. Use clear names and accurate pricing for better inventory management.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Got It"),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Help',
                ),
              ],
            ),
          ];
        },
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _primaryTeal.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(_primaryTeal),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Saving Item...",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please wait while we save your item",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: _textLight,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Item Card
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Name Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.shopping_bag,
                                              size: 22, color: _primaryTeal),
                                          SizedBox(width: 10),
                                          Text(
                                            "Item Name*",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: _textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border:
                                              Border.all(color: _borderColor, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.03),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: TextFormField(
                                            controller: _itemNameController,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: _textDark,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(20),
                                              border: InputBorder.none,
                                              hintText: "e.g., Kisan Fruits Jam 500 gm",
                                              hintStyle: TextStyle(
                                                color: _textLight,
                                                fontSize: 14.sp,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Product Image",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: _textDark,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      GestureDetector(
                                        onTap: _showImageSourceDialog,
                                        child: Container(
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            color: _selectedImage != null
                                                ? Colors.transparent
                                                : _primaryTeal.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: _selectedImage != null
                                                  ? Colors.transparent
                                                  : _primaryTeal.withOpacity(0.3),
                                              width: 2,
                                            ),
                                            boxShadow: _selectedImage != null
                                                ? [
                                                    BoxShadow(
                                                      color:
                                                          Colors.black.withOpacity(0.1),
                                                      blurRadius: 12,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: _selectedImage != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.file(
                                                    _selectedImage!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add_a_photo,
                                                      size: 36,
                                                      color: _primaryTeal,
                                                    ),
                                                    SizedBox(height: 0.5.h),
                                                    Text(
                                                      "Add Photo",
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: _primaryTeal,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),

                            // Item Type Toggle
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Item Type*",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _textDark,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTypeToggleButton(
                                        label: "Product",
                                        icon: Icons.shopping_bag,
                                        isSelected: isProduct,
                                        onTap: () => _toggleItemType(true),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: _buildTypeToggleButton(
                                        label: "Service",
                                        icon: Icons.handyman,
                                        isSelected: !isProduct,
                                        onTap: () => _toggleItemType(false),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Tabs Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Custom Tab Bar
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: false,
                                labelColor: _primaryTeal,
                                unselectedLabelColor: _textLight,
                                indicatorColor: _primaryTeal,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorWeight: 3,
                                labelPadding: EdgeInsets.zero,
                                tabAlignment: TabAlignment.fill,
                                indicatorPadding: EdgeInsets.zero,
                                overlayColor:
                                    MaterialStateProperty.all(Colors.transparent),
                                tabs: (isProduct ? _productTabs : _serviceTabs)
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final tab = entry.value;
                                  return Tab(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            tab.split(' ')[0],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            tab.split(' ').sublist(1).join(' '),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Divider(height: 0, color: _borderColor, thickness: 1),
                            Container(
                              height: 55.h,
                              child: TabBarView(
                                controller: _tabController,
                                children: isProduct
                                    ? [
                                        _buildPricingTab(),
                                        _buildStockTab(),
                                        _buildOtherTab(),
                                        _buildPartyWisePricesTab(),
                                      ]
                                    : [
                                        _buildPricingTab(),
                                        _buildOtherTab(),
                                        _buildPartyWisePricesTab(),
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: Offset(0, -5),
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade100,
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: _borderColor, width: 2),
                ),
                child: TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close, size: 20, color: _textLight),
                      SizedBox(width: 8),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: _textLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [_primaryTeal, _darkTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryTeal.withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitItemData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, size: 22),
                            SizedBox(width: 10),
                            Text(
                              "Save Item",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ).animate().scale(delay: 300.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? _primaryTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryTeal : _borderColor,
            width: 2,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [_primaryTeal, _darkTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primaryTeal.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : _textLight,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : _textLight,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Barcode Scanner Screen
class BarcodeScannerForItemScreen extends StatefulWidget {
  const BarcodeScannerForItemScreen({super.key});

  @override
  State<BarcodeScannerForItemScreen> createState() =>
      _BarcodeScannerForItemScreenState();
}

class _BarcodeScannerForItemScreenState
    extends State<BarcodeScannerForItemScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String? _scannedBarcode;
  bool _isLoading = false;
  bool _isScanning = true;
  bool _isCameraInitialized = false;
  bool _isTorchOn = false;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  String _lastScannedValue = '';
  Timer? _scanResetTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanResetTimer?.cancel();
    _cameraController?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) return;

      final backCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }

      _cameraController!.startImageStream(_processCameraImage);
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (!_isScanning || _isLoading) return;

    try {
      final inputImage = _createInputImage(image);
      if (inputImage == null) return;

      final List<Barcode> barcodes = await _barcodeScanner.processImage(
        inputImage,
      );

      if (barcodes.isNotEmpty) {
        final Barcode barcode = barcodes.first;
        final String barcodeValue =
            barcode.rawValue ?? barcode.displayValue ?? '';

        if (barcodeValue.isNotEmpty && barcodeValue != _lastScannedValue) {
          _lastScannedValue = barcodeValue;

          if (mounted) {
            setState(() {
              _scannedBarcode = barcodeValue;
              _isLoading = true;
              _isScanning = false;
            });
          }

          _scanResetTimer?.cancel();
          _scanResetTimer = Timer(Duration(milliseconds: 1500), () {
            if (mounted) {
              Navigator.pop(context, _scannedBarcode);
            }
          });
        }
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  InputImage? _createInputImage(CameraImage image) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final imageRotation = _getImageRotation();

      final inputImageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
    } catch (e) {
      print('Error creating InputImage: $e');
      return null;
    }
  }

  InputImageRotation _getImageRotation() {
    if (_cameraController == null) return InputImageRotation.rotation0deg;

    final camera = _cameraController!.description;
    switch (camera.sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  void _toggleTorch() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.setFlashMode(
          _isTorchOn ? FlashMode.off : FlashMode.torch,
        );
        if (mounted) {
          setState(() {
            _isTorchOn = !_isTorchOn;
          });
        }
      } catch (e) {
        print('Error toggling torch: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Scan Barcode',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Color(0xFF009688),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.white,
              size: 24,
            ),
            onPressed: _toggleTorch,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Initializing Camera...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_cameraController!),
        ),
        if (_isScanning && _scannedBarcode == null) _buildScannerOverlay(),
        if (_isLoading)
          Center(
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF009688),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Scanning...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please hold steady',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_scannedBarcode != null && !_isLoading) _buildResultCard(),
      ],
    );
  }

  Widget _buildScannerOverlay() {
    return Column(
      children: [
        Expanded(flex: 2, child: Container(color: Colors.black54)),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(flex: 1, child: Container(color: Colors.black54)),
              Expanded(
                flex: 8,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF009688), width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 60,
                        color: Color(0xFF009688),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Align Barcode',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Position within the frame',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF009688),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Auto-scan enabled',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container(color: Colors.black54)),
            ],
          ),
        ),
        Expanded(flex: 2, child: Container(color: Colors.black54)),
      ],
    );
  }

  Widget _buildResultCard() {
    return Positioned(
      bottom: 2.h,
      left: 3.w,
      right: 3.w,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.green, size: 24),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Barcode Scanned!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
                Icon(Icons.verified, color: Colors.green, size: 30),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.green.shade50],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scanned Value:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: SelectableText(
                      _scannedBarcode!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: Colors.grey.shade600, size: 16),
                SizedBox(width: 8),
                Text(
                  'Returning to form in a moment...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
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

// HSN Selection Screen
class HsnSelectionScreen extends StatefulWidget {
  const HsnSelectionScreen({super.key});

  @override
  _HsnSelectionScreenState createState() => _HsnSelectionScreenState();
}

class _HsnSelectionScreenState extends State<HsnSelectionScreen> {
  List<HsnModel> hsnList = [];
  List<HsnModel> filteredHsnList = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final Color _primaryTeal = Color(0xFF009688);
  final Color _bgColor = Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    fetchHsnData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
      _filterHsnCodes();
    });
  }

  void _filterHsnCodes() {
    if (searchQuery.isEmpty) {
      filteredHsnList = List.from(hsnList);
    } else {
      filteredHsnList = hsnList.where((hsn) {
        return hsn.hsnCode.toLowerCase().contains(searchQuery) ||
            hsn.hsnCode.contains(searchQuery);
      }).toList();
    }
  }

  Future<void> fetchHsnData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://202.140.138.215:85/api/HSNApi'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          hsnList = data.map((json) => HsnModel.fromJson(json)).toList();
          filteredHsnList = List.from(hsnList);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildHsnList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: filteredHsnList.length,
      separatorBuilder: (context, index) => SizedBox(height: 0.5.h),
      itemBuilder: (context, index) {
        final hsn = filteredHsnList[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE0E0E0), width: 1),
            ),
            child: ListTile(
              onTap: () {
                Navigator.pop(context, hsn);
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryTeal.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    hsn.hsnCode.substring(0, 2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _primaryTeal,
                    ),
                  ),
                ),
              ),
              title: Text(
                hsn.hsnCode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Color(0xFF263238),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _buildTaxChip('SGST', '${hsn.sgst}%', Colors.blue),
                    SizedBox(width: 1.w),
                    _buildTaxChip('CGST', '${hsn.cgst}%', Colors.green),
                    SizedBox(width: 1.w),
                    _buildTaxChip('IGST', '${hsn.igst}%', Colors.orange),
                  ],
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: _primaryTeal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaxChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text(
          'Select HSN Code',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _primaryTeal,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchHsnData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search HSN code...',
                hintStyle: TextStyle(fontSize: 15.sp),
                prefixIcon: Icon(Icons.search, color: _primaryTeal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                contentPadding: EdgeInsets.all(16),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 20),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredHsnList.length} result(s) found',
                    style: TextStyle(
                      color: Color(0xFF78909C),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (filteredHsnList.isNotEmpty)
                    Text(
                      'Tap to select',
                      style: TextStyle(
                        color: _primaryTeal,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _primaryTeal.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(_primaryTeal),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading HSN Codes...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF78909C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade400,
                            ),
                            SizedBox(height: 16),
                            Text(
                              errorMessage,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF78909C),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: fetchHsnData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryTeal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : filteredHsnList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search_off,
                                    size: 60,
                                    color: Color(0xFFB0BEC5),
                                  ),
                                ),
                                SizedBox(height: 24),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'No HSN codes available'
                                      : 'No matching HSN codes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF546E7A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'Check back later'
                                      : 'Try a different search term',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFB0BEC5),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _buildHsnList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Add New HSN"),
              content: Text("This feature will be available soon!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        },
        backgroundColor: _primaryTeal,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("Add New"),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ).animate().scale(delay: 300.ms),
    );
  }
}

class HsnModel {
  final int id;
  final String hsnCode;
  final double sgst;
  final double cgst;
  final double igst;
  final double cess;
  final int? hsnType;

  HsnModel({
    required this.id,
    required this.hsnCode,
    required this.sgst,
    required this.cgst,
    required this.igst,
    required this.cess,
    this.hsnType,
  });

  factory HsnModel.fromJson(Map<String, dynamic> json) {
    return HsnModel(
      id: json['id'] ?? 0,
      hsnCode: json['hsnCode'] ?? '',
      sgst: (json['sgst'] ?? 0).toDouble(),
      cgst: (json['cgst'] ?? 0).toDouble(),
      igst: (json['igst'] ?? 0).toDouble(),
      cess: (json['cess'] ?? 0).toDouble(),
      hsnType: json['hsnType'],
    );
  }
}

class Category {
  final int id;
  final String categoryName;
  final DateTime created;

  Category({
    required this.id,
    required this.categoryName,
    required this.created,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      created: DateTime.parse(json['created'] ?? DateTime.now().toString()),
    );
  }
}

class SubCategory {
  final int id;
  final String name;
  final int categoryId;
  final Category category;
  final DateTime created;

  SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.category,
    required this.created,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      category: Category.fromJson(json['category'] ?? {}),
      created: DateTime.parse(json['created'] ?? DateTime.now().toString()),
    );
  }
}