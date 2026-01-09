// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanohospic/model/items_model.dart';
import 'package:nanohospic/screens/master/items/create_new_items_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsListScreen extends StatefulWidget {
  final String? title;
  const ItemsListScreen({super.key, this.title});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  ItemMasterResponse? _itemMasterResponse;
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  List<Item> _filteredItems = [];
  int _currentPage = 1;
  final int _pageSize = 1020;
  bool _hasMoreItems = true;
  bool _isLoadingMore = false;
  bool _isSelectionMode = false;
  List<int> _selectedItemIds = [];
  Map<int, SelectedItem> _selectedItemsMap = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterItems);
    _fetchItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final response = await http.get(
        Uri.parse(
          'http://202.140.138.215:85/api/ItemMasterApi?page=$_currentPage&pageSize=$_pageSize',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final ItemMasterResponse newResponse = ItemMasterResponse.fromJson(
          data,
        );

        setState(() {
          if (loadMore) {
            _itemMasterResponse = ItemMasterResponse(
              totalItems: newResponse.totalItems,
              currentPage: newResponse.currentPage,
              pageSize: newResponse.pageSize,
              data: [..._itemMasterResponse!.data, ...newResponse.data],
            );
          } else {
            _itemMasterResponse = newResponse;
          }

          _filteredItems = _itemMasterResponse!.data;
          final totalItems = _itemMasterResponse?.totalItems ?? 0;
          final currentItemsCount = _itemMasterResponse?.data.length ?? 0;
          _hasMoreItems = currentItemsCount < totalItems;
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _errorMessage = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _itemMasterResponse?.data ?? [];
      } else {
        _filteredItems =
            _itemMasterResponse?.data.where((item) {
              return item.name.toLowerCase().contains(query) ||
                  item.code.toLowerCase().contains(query) ||
                  item.barcode?.toLowerCase().contains(query) == true ||
                  item.category?.categoryName.toLowerCase().contains(query) ==
                      true;
            }).toList() ??
            [];
      }
    });
  }

  void _loadMoreItems() {
    if (!_isLoadingMore && _hasMoreItems) {
      setState(() {
        _currentPage++;
      });
      _fetchItems(loadMore: true);
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItemIds.clear();
      }
    });
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItemIds.contains(itemId)) {
        _selectedItemIds.remove(itemId);
        _selectedItemsMap.remove(itemId);
      } else {
        _selectedItemIds.add(itemId);
        final item = _itemMasterResponse!.data.firstWhere(
          (item) => item.id == itemId,
        );
        _selectedItemsMap[itemId] = SelectedItem(item: item);
      }

      if (_selectedItemIds.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _selectAllItems() {
    setState(() {
      if (_selectedItemIds.length == _filteredItems.length) {
        _selectedItemIds.clear();
        _selectedItemsMap.clear();
      } else {
        _selectedItemIds = _filteredItems.map((item) => item.id).toList();
        for (var item in _filteredItems) {
          _selectedItemsMap[item.id] = SelectedItem(item: item);
        }
      }
    });
  }

  void _saveAndReturn() {
    if (_selectedItemsMap.isNotEmpty) {
      final selectedItems = _selectedItemsMap.values.toList();
      Navigator.pop(context, selectedItems);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one item'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _updateItemQuantity(int itemId, int quantity) {
    setState(() {
      if (_selectedItemsMap.containsKey(itemId)) {
        _selectedItemsMap[itemId]!.quantity = quantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 8.h,
        title: Text(
          'Items List',
          style: GoogleFonts.abel(
            textStyle: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        backgroundColor: Color(0xff016B61),
        foregroundColor: Colors.white,
        elevation: 0,
        // actions: [
        //   if (_isSelectionMode) ...[
        //     IconButton(
        //       icon: Icon(
        //         _selectedItemIds.length == _filteredItems.length
        //             ? Icons.check_box_outline_blank
        //             : Icons.check_box,
        //       ),
        //       onPressed: _selectAllItems,
        //       tooltip: 'Select All',
        //     ),
        //     if (_selectedItemIds.isNotEmpty)
        //       IconButton(
        //         icon: Icon(Icons.save),
        //         onPressed: _saveAndReturn,
        //         tooltip: 'Save Items',
        //       ),
        //     IconButton(
        //       icon: Icon(Icons.close),
        //       onPressed: _toggleSelectionMode,
        //       tooltip: 'Cancel Selection',
        //     ),
        //   ] else ...[
        //     IconButton(
        //       icon: Icon(Icons.checklist),
        //       onPressed: _toggleSelectionMode,
        //       tooltip: 'Select Items',
        //     ),
        //   ],
        // ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewItemScreeen(),
                    ),
                  );
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
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Color(0xff016B61),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search items by name, code, or category...',
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),

          // Selection Info Bar
          if (_isSelectionMode)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: Colors.blue[50],
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '${_selectedItemIds.length} items selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _selectAllItems,
                    child: Text(
                      _selectedItemIds.length == _filteredItems.length
                          ? 'Deselect All'
                          : 'Select All',
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.teal))
                : _errorMessage.isNotEmpty
                ? _buildErrorWidget()
                : _filteredItems.isEmpty
                ? _buildEmptyWidget()
                : _buildItemsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            _errorMessage,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchItems,
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2, size: 60, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _currentPage = 1;
        });
        await _fetchItems();
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 0.h, top: 8),
          itemCount: _filteredItems.length + (_hasMoreItems ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _filteredItems.length) {
              return _buildLoadMoreIndicator();
            }

            final item = _filteredItems[index];
            final isSelected = _selectedItemIds.contains(item.id);
            final selectedItem = _selectedItemsMap[item.id];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildItemCard(item, isSelected, selectedItem, index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemCard(
    Item item,
    bool isSelected,
    SelectedItem? selectedItem,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 0.w),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? Colors.blue[300]!
                : index % 2 == 0
                ? Colors.teal[100]!
                : Colors.blue[100]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: _isSelectionMode
              ? () => _toggleItemSelection(item.id)
              : () => _showItemDetails(item),
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
              _toggleItemSelection(item.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    isSelected
                        ? Colors.blue[50]!
                        : index % 2 == 0
                        ? Colors.teal[50]!
                        : Colors.blue[50]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Colors.blueGrey[800],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Code: ${item.code}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: _isSelectionMode ? 8 : 0),
                      if (item.category?.categoryName != null)
                        _buildCategoryChip(item),
                      SizedBox(width: _isSelectionMode ? 8 : 0),
                      if (_isSelectionMode)
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.blue : Colors.grey,
                          size: 24,
                        ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Wrap(
                      spacing: 15.w,
                      runSpacing: 8,
                      children: [
                        _buildDetailItem(
                          'MRP',
                          '₹${(item.mrp).toStringAsFixed(2)}',
                        ),
                        _buildDetailItem(
                          'Rate',
                          '₹${(item.salesRate1).toStringAsFixed(2)}',
                        ),
                        _buildDetailItem(
                          'Unit',
                          item.unit1.isEmpty ? "NOS" : item.unit1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.company?.name != null)
                        _buildDetailItem('Company', item.company!.name),
                      SizedBox(width: 3.w),
                      if (item.barcode != null && item.barcode!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            'Barcode: ${item.barcode}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      Spacer(),
                      Text(
                        'Packing: ${item.packing}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  if (isSelected && selectedItem != null)
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue[100]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:'),
                          Text(
                            '₹${selectedItem.finalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                              fontSize: 16.sp,
                            ),
                          ),
                          if (isSelected && selectedItem != null)
                            _buildQuantityControls(item.id, selectedItem),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(int itemId, SelectedItem selectedItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 18),
                    onPressed: () =>
                        _updateItemQuantity(itemId, selectedItem.quantity - 1),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 10.w,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    child: Text(
                      selectedItem.quantity.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18),
                    onPressed: () =>
                        _updateItemQuantity(itemId, selectedItem.quantity + 1),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip(Item item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: item.mrp > 0 ? Colors.blue[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.mrp > 0 ? Colors.blue[100]! : Colors.orange[100]!,
        ),
      ),
      child: Text(
        item.category!.categoryName,
        style: TextStyle(
          fontSize: 12.sp,
          color: item.mrp > 0 ? Colors.blue[800] : Colors.orange[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: _isLoadingMore
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              )
            : ElevatedButton(
                onPressed: _loadMoreItems,
                child: Text('Load More Items'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
      ),
    );
  }

  void _showItemDetails(Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Item Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', item.name),
              _buildDetailRow('Code', item.code),
              if (item.barcode != null)
                _buildDetailRow('Barcode', item.barcode!),
              _buildDetailRow('MRP', '₹${item.mrp.toStringAsFixed(2)}'),
              _buildDetailRow(
                'Sales Rate 1',
                '₹${item.salesRate1.toStringAsFixed(2)}',
              ),
              _buildDetailRow('Unit', item.unit1),
              _buildDetailRow('Packing', item.packing),
              if (item.category != null)
                _buildDetailRow('Category', item.category!.categoryName),
              if (item.company != null)
                _buildDetailRow('Company', item.company!.name),
              if (item.division != null)
                _buildDetailRow('Division', item.division!.name),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class SelectedItem {
  final Item item;
  int quantity;
  double discount;
  double gstRate;

  SelectedItem({
    required this.item,
    this.quantity = 1,
    this.discount = 0.0,
    this.gstRate = 0.0,
  });

  double get totalAmount => (item.salesRate1) * quantity;
  double get discountAmount => totalAmount * (discount / 100);
  double get gstAmount => (totalAmount - discountAmount) * (gstRate / 100);
  double get finalAmount => totalAmount - discountAmount + gstAmount;
}
