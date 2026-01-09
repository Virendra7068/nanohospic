// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class CreateNewItemScreeen extends StatefulWidget {
  const CreateNewItemScreeen({super.key});

  @override
  State<CreateNewItemScreeen> createState() => _CreateNewItemScreeenState();
}

class _CreateNewItemScreeenState extends State<CreateNewItemScreeen>
    with SingleTickerProviderStateMixin {
  bool isProduct = true;
  final List<String> _chartOptions = ['Without Tax', 'With Tax'];
  String _selectedChart = 'Without Tax';
  late TabController _tabController;

  final List<String> _productTabs = [
    'Pricing',
    'Stock',
    'Other',
    'Party Wise Prices',
  ];
  final List<String> _serviceTabs = ['Pricing', 'Other', 'Party Wise Prices'];

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
  Map<String, dynamic>? _selectedDivision;
  Map<String, dynamic>? _selectedCompany;
  bool _decimalAllowed = false;
  bool _isLoading = false;

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
              subCategoryData
                  .map((json) => SubCategory.fromJson(json))
                  .toList();
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  void didUpdateWidget(covariant CreateNewItemScreeen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((isProduct && _tabController.length != _productTabs.length) ||
        (!isProduct && _tabController.length != _serviceTabs.length)) {
      _tabController.dispose();
      _tabController = TabController(
        length: isProduct ? _productTabs.length : _serviceTabs.length,
        vsync: this,
      );
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
      });
    }
  }

  Future<void> _openBarcodeScanner() async {
    final scannedBarcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerForItemScreen()),
    );
    if (scannedBarcode != null && scannedBarcode is String) {
      setState(() {
        _barcodeController.text = scannedBarcode;
      });
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

  Future<void> _submitItemData() async {
    if (_itemNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Item Name is required')));
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Category is required')));
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final Map<String, dynamic> requestData = {
      "Id": 0,
      "Name": _itemNameController.text.trim(),
      "Code": _itemCodeController.text.trim(),
      "Barcode":
          _barcodeController.text.trim().isNotEmpty
              ? _barcodeController.text.trim()
              : null,
      "Unit1": _selectedUnit.toUpperCase(),
      "Unit2": 1, 
      "Packing":
          _packingController.text.trim().isNotEmpty
              ? _packingController.text.trim()
              : null,
      "CategoryId": _selectedCategory?.id ?? 0,
      "Category": null,
      "SubCategoryId": _selectedSubCategory?.id,
      "SubCategory": _selectedSubCategory?.name,
      "DivisionId": _selectedDivision?['id'],
      "Division": _selectedDivision?['name'],
      "HsnId": _selectedHsn?.id,
      "Hsn": _selectedHsn?.hsnCode,
      "CompanyId": _selectedCompany?['id'],
      "Company": _selectedCompany?['name'],
      "Mrp": int.tryParse(_mrpController.text) ?? 0,
      "SalesRate1": int.tryParse(_salesPriceController.text) ?? 0,
      "SalesRate2": int.tryParse(_salesRate2Controller.text) ?? 0,
      "MinimumQty": int.tryParse(_minimumQtyController.text) ?? 0,
      "MaximumQty": int.tryParse(_maximumQtyController.text) ?? 0,
      "ShelfLife": int.tryParse(_shelfLifeController.text) ?? 0,
      "MaximumDiscount": int.tryParse(_maximumDiscountController.text) ?? 0,
      "DecemalAllowed": _decimalAllowed,
      "Conversion": int.tryParse(_conversionController.text) ?? 0,
      "photo": _selectedImage,
    };

    print('=== API REQUEST DATA ===');
    print('URL: http://202.140.138.215:85/api/ItemMasterApi');
    print('Request Body: ${json.encode(requestData)}');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
        print('Using auth token');
      }

      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/ItemMasterApi'),
        headers: headers,
        body: json.encode(requestData),
      );

      print('=== API RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Body image: ${_selectedImage}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ ${responseData['message'] ?? 'Item saved successfully!'}',
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ ${responseData['message'] ?? 'Failed to save item'}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (response.statusCode == 500) {
        // Try progressive testing
        await _testProgressiveRequests(authToken);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed with status: ${response.statusCode}\n${response.body}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testProgressiveRequests(String? authToken) async {
    print('\n=== PROGRESSIVE TESTING ===');

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    // Test 1: Minimal working request
    final Map<String, dynamic> test1 = {
      "Id": 0,
      "Name": "Test Item ${DateTime.now().millisecondsSinceEpoch}",
      "Code":
          "TEST${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}",
      "Unit1": "PCS",
      "CategoryId": _selectedCategory?.id ?? 12,
      "SalesRate1": 100,
      "Mrp": 120,
    };

    // Test 2: Add Unit2 and Packing
    final Map<String, dynamic> test2 = {
      ...test1,
      "Unit2": null,
      "Packing": "500",
    };

    // Test 3: Add Barcode
    final Map<String, dynamic> test3 = {...test2, "Barcode": "TESTBARCODE"};

    // Test 4: Add SubCategory
    final Map<String, dynamic> test4 = {
      ...test3,
      "SubCategoryId": _selectedSubCategory?.id,
      "SubCategory": _selectedSubCategory?.name,
    };

    // Test 5: Add Division
    final Map<String, dynamic> test5 = {
      ...test4,
      "DivisionId": null,
      "Division": "",
    };

    final Map<String, dynamic> test6 = {
      ...test5,
      "HsnId": _selectedHsn?.id,
      "Hsn": _selectedHsn?.hsnCode,
    };

    // Test 7: Add Company
    final Map<String, dynamic> test7 = {
      ...test6,
      "CompanyId": _selectedCompany?['id'],
      "Company": _selectedCompany?['name'],
    };

    // Test 8: Add quantity fields
    final Map<String, dynamic> test8 = {
      ...test7,
      "MinimumQty": 1,
      "MaximumQty": 100,
      "ShelfLife": 365,
      "MaximumDiscount": 5,
      "DecemalAllowed": true,
      "Conversion": 1,
    };

    final List<Map<String, dynamic>> tests = [
      test1,
      test2,
      test3,
      test4,
      test5,
      test6,
      test7,
      test8,
    ];

    for (int i = 0; i < tests.length; i++) {
      print('\n--- Test ${i + 1}: Adding ${_getTestDescription(i)} ---');
      print('Request: ${json.encode(tests[i])}');

      try {
        final response = await http.post(
          Uri.parse('http://202.140.138.215:85/api/ItemMasterApi'),
          headers: headers,
          body: json.encode(tests[i]),
        );

        print('Status: ${response.statusCode}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('✅ Test ${i + 1} SUCCESS');
          if (i == tests.length - 1) {
            print('✅ All fields work!');
          }
        } else {
          print('❌ Test ${i + 1} FAILED at: ${_getTestDescription(i)}');
          print('Response: ${response.body}');
          break;
        }
      } catch (e) {
        print('❌ Test ${i + 1} ERROR: $e');
        break;
      }

      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  String _getTestDescription(int index) {
    switch (index) {
      case 0:
        return "Minimal fields";
      case 1:
        return "Unit2 & Packing";
      case 2:
        return "Barcode";
      case 3:
        return "SubCategory";
      case 4:
        return "Division";
      case 5:
        return "HSN";
      case 6:
        return "Company";
      case 7:
        return "Quantity fields";
      default:
        return "Unknown";
    }
  }

  void _clearForm() {
    _itemNameController.clear();
    _barcodeController.clear();
    _salesPriceController.clear();
    _purchasePriceController.clear();
    _stockController.clear();
    _hsnCodeController.clear();
    _descriptionController.clear();
    _packingController.clear();
    _mrpController.clear();
    _salesRate2Controller.clear();
    _minimumQtyController.clear();
    _maximumQtyController.clear();
    _shelfLifeController.clear();
    _maximumDiscountController.clear();
    _conversionController.clear();

    setState(() {
      _selectedHsn = null;
      _selectedCategory = null;
      _selectedSubCategory = null;
      _selectedDivision = null;
      _selectedCompany = null;
      _decimalAllowed = false;
      _lowStockAlertEnabled = false;
      _selectedImage = null;
      _selectedUnit = 'kg';
    });

    _generateItemCode(); // Generate new code for next item
  }

  // Function to open HSN selection screen
  Future<void> _selectHsnCode(BuildContext context) async {
    final selectedHsn = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HsnSelectionScreen()),
    );

    if (selectedHsn != null && selectedHsn is HsnModel) {
      setState(() {
        _selectedHsn = selectedHsn;
        _hsnCodeController.text = selectedHsn.hsnCode;
      });
    }
  }

  Widget _buildPricingTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unit Dropdown
          Text(
            "  Unit",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  items:
                      _units.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value.toUpperCase(),
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
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
          SizedBox(height: 1.h),

          // Packing
          Text(
            "  Packing",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _packingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "e.g., 500 ml bottle",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26, fontSize: 15.sp),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // HSN Code Field with Search Button
          Text(
            "  HSN Code",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _hsnCodeController,
              readOnly: true,
              style: TextStyle(fontSize: 16.sp),
              onTap: () => _selectHsnCode(context),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Select HSN code",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26, fontSize: 15.sp),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.blue),
                  onPressed: () => _selectHsnCode(context),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // GST Display
          if (_selectedHsn != null) ...[
            Text(
              "  GST Rates",
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.black26),
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Chip(
                      label: Text(
                        'SGST: ${_selectedHsn!.sgst}%',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      backgroundColor: Colors.blue.shade100,
                    ),
                    Chip(
                      label: Text(
                        'CGST: ${_selectedHsn!.cgst}%',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      backgroundColor: Colors.green.shade100,
                    ),
                    Chip(
                      label: Text(
                        'IGST: ${_selectedHsn!.igst}%',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      backgroundColor: Colors.orange.shade100,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],

          // Sales Price
          Text(
            "  Sales Price",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _salesPriceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter sales price",
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.black26,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.w,
                    vertical: 0.5.h,
                  ),
                  child: SizedBox(
                    height: 45,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedChart,
                            dropdownColor: Colors.white,
                            menuMaxHeight: 20.h,
                            items:
                                _chartOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        value,
                                        style: GoogleFonts.abel(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
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
                  ),
                ),
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Purchase Price
          Text(
            "  Purchase Price",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _purchasePriceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter purchase price",
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.black26,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.w,
                    vertical: 0.5.h,
                  ),
                  child: SizedBox(
                    height: 45,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedChart,
                            dropdownColor: Colors.white,
                            menuMaxHeight: 20.h,
                            items:
                                _chartOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        value,
                                        style: GoogleFonts.abel(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
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
                  ),
                ),
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // MRP
          Text(
            "  MRP",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _mrpController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter MRP",
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.black26,
                ),
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Sales Rate 2
          Text(
            "  Sales Rate 2 (Optional)",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _salesRate2Controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter alternate sales price",
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.black26,
                ),
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Opening Stock
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Opening Stock",
                      style: GoogleFonts.abel(
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: Colors.black26),
                      ),
                      child: TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter opening stock",
                          hintStyle: GoogleFonts.abel(
                            textStyle: TextStyle(color: Colors.black26),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedUnit,
                                items:
                                    _units.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value.toUpperCase(),
                                          style: GoogleFonts.abel(
                                            textStyle: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  As of Date",
                      style: GoogleFonts.abel(
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: Colors.black26),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Select date",
                            hintStyle: GoogleFonts.abel(
                              textStyle: TextStyle(color: Colors.black26),
                            ),
                            suffixIcon: Icon(Icons.calendar_today, size: 20),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          child: Text(
                            dateFormat.format(selectedDate),
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Minimum Quantity
          Text(
            "  Minimum Quantity",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _minimumQtyController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter minimum order quantity",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Maximum Quantity
          Text(
            "  Maximum Quantity",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _maximumQtyController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter maximum order quantity",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Shelf Life
          Text(
            "  Shelf Life (Days)",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _shelfLifeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter shelf life in days",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Conversion Factor
          Text(
            "  Conversion Factor",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _conversionController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "e.g., 1 kg = 1000 g (enter 1000)",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Low Stock Alert
          Row(
            children: [
              Expanded(
                child: Text(
                  "  Low Stock Alert",
                  style: GoogleFonts.abel(
                    textStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Switch(
                value: _lowStockAlertEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _lowStockAlertEnabled = value;
                  });
                },
                activeColor: Colors.blue.shade800,
                activeTrackColor: Colors.blue.shade200,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          if (_lowStockAlertEnabled) ...[
            SizedBox(height: 1.h),
            Text(
              "  Low Stock Quantity",
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.black26),
              ),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter low stock threshold",
                  hintStyle: GoogleFonts.abel(
                    textStyle: TextStyle(color: Colors.black26),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedUnit,
                        items:
                            _units.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toUpperCase(),
                                  style: GoogleFonts.abel(
                                    textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  File? _selectedImage;

  Widget _buildOtherTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "  Item Code",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _itemCodeController,
              readOnly: true,
              style: GoogleFonts.abel(
                textStyle: TextStyle(color: Colors.black45),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Auto-generated code",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _generateItemCode,
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Barcode with Scanner Icon
          Text(
            "  Barcode (Optional)",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: Colors.black26),
                  ),
                  child: TextFormField(
                    controller: _barcodeController,
                    style: GoogleFonts.abel(
                      textStyle: TextStyle(color: Colors.black45),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter barcode number",
                      hintStyle: GoogleFonts.abel(
                        textStyle: TextStyle(color: Colors.black26),
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                  onPressed: _openBarcodeScanner,
                  tooltip: 'Scan Barcode',
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            "  Category*",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Category>(
                  value: _selectedCategory,
                  isExpanded: true,
                  hint: Text("Select category"),
                  items:
                      _categories.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.categoryName,
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                      _selectedSubCategory =
                          null; // Reset subcategory when category changes
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Subcategory Dropdown (only if category selected)
          if (_selectedCategory != null) ...[
            Text(
              "  Subcategory (Optional)",
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.black26),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SubCategory>(
                    value: _selectedSubCategory,
                    isExpanded: true,
                    hint: Text("Select subcategory"),
                    items:
                        _subCategories
                            .where(
                              (sub) => sub.categoryId == _selectedCategory!.id,
                            )
                            .map((SubCategory subCategory) {
                              return DropdownMenuItem<SubCategory>(
                                value: subCategory,
                                child: Text(
                                  subCategory.name,
                                  style: GoogleFonts.abel(
                                    textStyle: TextStyle(fontSize: 16.sp),
                                  ),
                                ),
                              );
                            })
                            .toList(),
                    onChanged: (SubCategory? newValue) {
                      setState(() {
                        _selectedSubCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],

          // Description
          Text(
            "  Description (Optional)",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.black26),
            ),
            child: TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter item description",
                hintStyle: GoogleFonts.abel(
                  textStyle: TextStyle(color: Colors.black26),
                ),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyWisePricesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Icon(Icons.group, size: 60, color: Colors.grey.shade400),
          SizedBox(height: 2.h),
          Text(
            "Party Wise Pricing",
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                color: Colors.black54,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "This feature allows you to set different\nprices for different parties/customers",
            textAlign: TextAlign.center,
            style: GoogleFonts.abel(
              textStyle: TextStyle(color: Colors.grey, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Select Image Source"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Pick Image Method
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.teal),
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Text(
          "Create New Item",
          style: GoogleFonts.abel(
            textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Name Field
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "  Item Name*",
                                  style: GoogleFonts.abel(
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(color: Colors.black12),
                                  ),
                                  child: TextFormField(
                                    controller: _itemNameController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText:
                                          "Enter item name (e.g., Kisan Fruits Jam 500 gm)",
                                      hintStyle: GoogleFonts.abel(
                                        textStyle: TextStyle(
                                          color: Colors.black26,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "  Product Image",
                                  style: GoogleFonts.abel(
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                GestureDetector(
                                  onTap: _showImageSourceDialog,
                                  child: Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Colors.blue.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 10.h,
                                      width: double.infinity,
                                      child:
                                          _selectedImage != null
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                    Icons.camera_alt,
                                                    size: 24,
                                                    color: Colors.blue.shade800,
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  Text(
                                                    "Add",
                                                    style: GoogleFonts.abel(
                                                      textStyle: TextStyle(
                                                        color:
                                                            Colors
                                                                .blue
                                                                .shade800,
                                                        fontSize: 12.sp,
                                                      ),
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
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Item Type Toggle
                      Text(
                        "  Item Type*",
                        style: GoogleFonts.abel(
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          // Product Button
                          ChoiceChip(
                            label: Text("Product"),
                            selected: isProduct,
                            onSelected: (selected) => _toggleItemType(true),
                            selectedColor: Colors.blue.shade800,
                            showCheckmark: false,
                            labelStyle: GoogleFonts.abel(
                              textStyle: TextStyle(
                                color: isProduct ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color:
                                    isProduct
                                        ? Colors.blue.shade800
                                        : Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          // Service Button
                          ChoiceChip(
                            label: Text("Service"),
                            selected: !isProduct,
                            showCheckmark: false,
                            onSelected: (selected) => _toggleItemType(false),
                            selectedColor: Colors.blue.shade800,
                            labelStyle: GoogleFonts.abel(
                              textStyle: TextStyle(
                                color: !isProduct ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color:
                                    !isProduct
                                        ? Colors.blue.shade800
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Dynamic Tabs
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: false,
                          labelColor: Colors.blue.shade800,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Colors.blue.shade800,
                          labelPadding: EdgeInsets.zero,
                          tabAlignment: TabAlignment.fill,
                          tabs:
                              (isProduct ? _productTabs : _serviceTabs).map((
                                tab,
                              ) {
                                return Tab(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.0,
                                    ),
                                    child: Text(
                                      tab,
                                      style: GoogleFonts.abel(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        height: 50.h,
                        child: TabBarView(
                          controller: _tabController,
                          children:
                              isProduct
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
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(2.h),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitItemData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            minimumSize: Size(double.infinity, 6.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child:
              _isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    "Save Item",
                    style: GoogleFonts.abel(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}

// Barcode Scanner Screen for Item Creation
class BarcodeScannerForItemScreen extends StatefulWidget {
  @override
  State<BarcodeScannerForItemScreen> createState() =>
      _BarcodeScannerForItemScreenState();
}

class _BarcodeScannerForItemScreenState
    extends State<BarcodeScannerForItemScreen>
    with WidgetsBindingObserver {
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
      _scanResetTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
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
    if (!_isScanning || _isLoading) {
      return;
    }

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

          // Return the scanned value after delay
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
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.white,
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
            CircularProgressIndicator(color: Colors.blue[900]),
            SizedBox(height: 20),
            Text(
              'Initializing Camera...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Camera Preview
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_cameraController!),
        ),

        // Scanner Overlay
        if (_isScanning && _scannedBarcode == null) _buildScannerOverlay(),

        // Loading Indicator
        if (_isLoading)
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.blue[900]),
                  SizedBox(height: 16),
                  Text(
                    'Scanning...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Result Display
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
                    border: Border.all(color: Colors.blue.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 50,
                        color: Colors.blue.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Point camera at barcode',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Will auto-scan and return',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                        textAlign: TextAlign.center,
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '✅ Barcode Scanned!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                Icon(Icons.check_circle, color: Colors.green, size: 30),
              ],
            ),
            SizedBox(height: 16),

            // Scanned Value
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scanned Barcode:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SelectableText(
                      _scannedBarcode!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Returning to item form in a moment...',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

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
      filteredHsnList =
          hsnList.where((hsn) {
            return hsn.hsnCode.toLowerCase().contains(searchQuery);
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
    return ListView.builder(
      itemCount: filteredHsnList.length,
      itemBuilder: (context, index) {
        final hsn = filteredHsnList[index];
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          child: ListTile(
            onTap: () {
              Navigator.pop(context, hsn);
            },
            title: Text(
              hsn.hsnCode,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.blue.shade900,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        'SGST: ${hsn.sgst}%',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      backgroundColor: Colors.blue.shade100,
                    ),
                    SizedBox(width: 1.w),
                    Chip(
                      label: Text(
                        'CGST: ${hsn.cgst}%',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      backgroundColor: Colors.green.shade100,
                    ),
                    SizedBox(width: 1.w),
                    Chip(
                      label: Text(
                        'IGST: ${hsn.igst}%',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      backgroundColor: Colors.orange.shade100,
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

  @override
  Widget build(BuildContext context) {
     Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
                onPressed: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> ))
                },
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
      );
    return Scaffold(
      appBar: AppBar(
        title: Text('Select HSN Code', style: TextStyle(fontSize: 19.sp)),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(2.w),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search HSN code...',
                hintStyle: TextStyle(fontSize: 17.sp),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),

          if (searchQuery.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    '${filteredHsnList.length} result(s) found',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),

          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : filteredHsnList.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            searchQuery.isEmpty
                                ? 'No HSN codes available'
                                : 'No matching HSN codes',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : _buildHsnList(),
          ),
        ],
      ),
    );
  }
}

// HSN Model class
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
