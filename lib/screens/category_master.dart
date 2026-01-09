// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:responsive_sizer/responsive_sizer.dart';

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
//       id: json['id'],
//       categoryName: json['categoryName'],
//       created: DateTime.parse(json['created']),
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
//       id: json['id'],
//       name: json['name'],
//       categoryId: json['categoryId'],
//       category: Category.fromJson(json['category']),
//       created: DateTime.parse(json['created']),
//     );
//   }
// }

// class ApiService {
//   static const String baseUrl =
//       'http://202.140.138.215:85/api/CategoryMasterApi';
//   static const String subCategoryBaseUrl =
//       'http://202.140.138.215:85/api/SubCategoryApi/all';
//   static const String createSubCategoryUrl =
//       'http://202.140.138.215:85/api/SubCategoryApi/create';

//   static Future<List<Category>> fetchCategories() async {
//     try {
//       final response = await http.get(Uri.parse(baseUrl));

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);

//         if (data['success'] == true) {
//           final List<dynamic> categoryData = data['data'];
//           return categoryData.map((json) => Category.fromJson(json)).toList();
//         } else {
//           throw Exception('API returned success: false');
//         }
//       } else {
//         throw Exception('Failed to load categories: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }

//   static Future<List<SubCategory>> fetchSubCategories() async {
//     try {
//       final response = await http.get(Uri.parse(subCategoryBaseUrl));

//       if (response.statusCode == 200) {
//         final List<dynamic> subCategoryData = json.decode(response.body);
//         return subCategoryData
//             .map((json) => SubCategory.fromJson(json))
//             .toList();
//       } else {
//         throw Exception('Failed to load subcategories: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load subcategories: $e');
//     }
//   }

//   static Future<bool> createSubCategory(
//     String name,
//     int categoryId,
//     String categoryName,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse(createSubCategoryUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'id': 0,
//           'name': name,
//           'categoryId': categoryId,
//           'categoryName': categoryName,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         throw Exception('Failed to create subcategory: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to create subcategory: $e');
//     }
//   }
// }

// class CategoriesScreen extends StatefulWidget {
//   const CategoriesScreen({super.key});

//   @override
//   State<CategoriesScreen> createState() => _CategoriesScreenState();
// }

// class _CategoriesScreenState extends State<CategoriesScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   List<Category> categories = [];
//   bool isLoading = true;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();

//     // Set up animations
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
//       ),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     // Fetch data from API
//     fetchCategoriesData();
//   }

//   Future<void> fetchCategoriesData() async {
//     try {
//       final List<Category> fetchedCategories =
//           await ApiService.fetchCategories();

//       setState(() {
//         categories = fetchedCategories;
//         isLoading = false;
//       });

//       // Start animations after data is loaded
//       _controller.forward();
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = e.toString();
//       });
//     }
//   }

//   Future<void> refreshData() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     await fetchCategoriesData();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.blue.shade900,
//         foregroundColor: Colors.white,
//         title: Text(
//           'Categories',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 19.sp,
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blue.shade900,
//         onPressed: () {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder:
//           //         (context) => AddCategoryBottomSheet(
//           //           onCategoryAdded: (p0) {
//           //             setState(() async {
//           //               Navigator.pop(context);
//           //               await fetchCategoriesData();
//           //             });
//           //           },
//           //         ),
//           //   ),
//           // );
//         },
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error: $errorMessage',
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: refreshData,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//           : RefreshIndicator(
//               onRefresh: refreshData,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: AnimatedBuilder(
//                         animation: _fadeAnimation,
//                         builder: (context, child) {
//                           return Opacity(
//                             opacity: _fadeAnimation.value,
//                             child: const Text(
//                               'Explore our product categories',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate((context, index) {
//                       final category = categories[index];
//                       return AnimatedCategoryItem(
//                         category: category,
//                         index: index,
//                         animationController: _controller,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) =>
//                                       SubCategoriesScreen(category: category),
//                               transitionsBuilder:
//                                   (
//                                     context,
//                                     animation,
//                                     secondaryAnimation,
//                                     child,
//                                   ) {
//                                     const begin = Offset(1.0, 0.0);
//                                     const end = Offset.zero;
//                                     const curve = Curves.easeInOut;

//                                     var tween = Tween(
//                                       begin: begin,
//                                       end: end,
//                                     ).chain(CurveTween(curve: curve));
//                                     var offsetAnimation = animation.drive(
//                                       tween,
//                                     );

//                                     return SlideTransition(
//                                       position: offsetAnimation,
//                                       child: child,
//                                     );
//                                   },
//                               transitionDuration: const Duration(
//                                 milliseconds: 300,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }, childCount: categories.length),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// class AnimatedCategoryItem extends StatelessWidget {
//   final Category category;
//   final int index;
//   final AnimationController animationController;
//   final VoidCallback onTap;

//   const AnimatedCategoryItem({
//     super.key,
//     required this.category,
//     required this.index,
//     required this.animationController,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
//         .animate(
//           CurvedAnimation(
//             parent: animationController,
//             curve: Interval(
//               (0.5 + index * 0.05).clamp(0.0, 1.0),
//               1.0,
//               curve: Curves.easeInOut,
//             ),
//           ),
//         );

//     return AnimatedBuilder(
//       animation: animationController,
//       builder: (context, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: Transform(
//             transform: Matrix4.translationValues(
//               0.0,
//               50 * (1.0 - animation.value),
//               0.0,
//             ),
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(6.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: ListTile(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//           leading: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: _getCategoryColor(category.categoryName),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 category.categoryName[0],
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           title: Text(
//             category.categoryName,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
//           ),
//           subtitle: Text(
//             'Created: ${_formatDate(category.created)}',
//             style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
//           ),
//           trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
//           onTap: onTap,
//         ),
//       ),
//     );
//   }

//   Color _getCategoryColor(String categoryName) {
//     // Assign colors based on category name
//     final colors = [
//       Colors.blue,
//       Colors.purple,
//       Colors.orange,
//       Colors.green,
//       Colors.red,
//       Colors.teal,
//       Colors.pink,
//       Colors.indigo,
//     ];

//     final index = categoryName.length % colors.length;
//     return colors[index];
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// class SubCategoriesScreen extends StatefulWidget {
//   final Category category;

//   const SubCategoriesScreen({super.key, required this.category});

//   @override
//   State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
// }

// class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
//   List<SubCategory> subCategories = [];
//   bool isLoading = true;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchSubCategoriesData();
//   }

//   Future<void> fetchSubCategoriesData() async {
//     try {
//       final List<SubCategory> fetchedSubCategories =
//           await ApiService.fetchSubCategories();
//       final filteredSubCategories = fetchedSubCategories
//           .where((subCategory) => subCategory.categoryId == widget.category.id)
//           .toList();

//       setState(() {
//         subCategories = filteredSubCategories;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = e.toString();
//       });
//     }
//   }

//   Future<void> refreshData() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     await fetchSubCategoriesData();
//   }

//   void _showAddSubCategoryBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => AddSubCategoryBottomSheet(
//         category: widget.category,
//         onSubCategoryAdded: () {
//           Navigator.pop(context);
//           refreshData();
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.blue.shade900,
//         foregroundColor: Colors.white,
//         title: Text(
//           '${widget.category.categoryName} Subcategories',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.sp,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blue.shade900,
//         onPressed: _showAddSubCategoryBottomSheet,
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error: $errorMessage',
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: refreshData,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//           : RefreshIndicator(
//               onRefresh: refreshData,
//               child: subCategories.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.category,
//                             size: 50.sp,
//                             color: Colors.grey.shade400,
//                           ),
//                           SizedBox(height: 2.h),
//                           Text(
//                             'No subcategories found',
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                           SizedBox(height: 1.h),
//                           Text(
//                             'Tap the + button to add a new subcategory',
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.grey.shade500,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: EdgeInsets.all(2.w),
//                       itemCount: subCategories.length,
//                       itemBuilder: (context, index) {
//                         final subCategory = subCategories[index];
//                         return Container(
//                           margin: EdgeInsets.symmetric(vertical: 0.5.h),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(6.0),
//                             boxShadow: [
//                               BoxShadow(
//                                 // ignore: deprecated_member_use
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: ListTile(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             leading: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: _getSubCategoryColor(subCategory.name),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   subCategory.name[0],
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             title: Text(
//                               subCategory.name,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 17.sp,
//                               ),
//                             ),
//                             subtitle: Text(
//                               'Created: ${_formatDate(subCategory.created)}',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//     );
//   }

//   Color _getSubCategoryColor(String subCategoryName) {
//     final colors = [
//       Colors.blue.shade700,
//       Colors.purple.shade700,
//       Colors.orange.shade700,
//       Colors.green.shade700,
//       Colors.red.shade700,
//       Colors.teal.shade700,
//       Colors.pink.shade700,
//       Colors.indigo.shade700,
//     ];

//     final index = subCategoryName.length % colors.length;
//     return colors[index];
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// class AddSubCategoryBottomSheet extends StatefulWidget {
//   final Category category;
//   final VoidCallback onSubCategoryAdded;

//   const AddSubCategoryBottomSheet({
//     super.key,
//     required this.category,
//     required this.onSubCategoryAdded,
//   });

//   @override
//   State<AddSubCategoryBottomSheet> createState() =>
//       _AddSubCategoryBottomSheetState();
// }

// class _AddSubCategoryBottomSheetState extends State<AddSubCategoryBottomSheet> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final success = await ApiService.createSubCategory(
//           _nameController.text.trim(),
//           widget.category.id,
//           widget.category.categoryName,
//         );

//         if (success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Subcategory created successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           widget.onSubCategoryAdded();
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Failed to create subcategory. Please try again.'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         padding: EdgeInsets.all(4.w),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 15.w,
//                   height: 0.5.h,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               Center(
//                 child: Text(
//                   'Add New Subcategory',
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               Text(
//                 'Category: ${widget.category.categoryName}',
//                 style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
//               ),
//               SizedBox(height: 2.h),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Subcategory Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 4.w,
//                     vertical: 2.h,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a subcategory name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 3.h),
//               SizedBox(
//                 width: double.infinity,
//                 height: 6.h,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade900,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : Text(
//                           'Create Subcategory',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                 ),
//               ),
//               SizedBox(height: 2.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/category_entity.dart';
import 'package:nanohospic/database/repository/item_cat_repo.dart';
import 'package:nanohospic/model/item_cat_model.dart';
import 'package:nanohospic/screens/banner_widget.dart';
import 'package:nanohospic/screens/sub_cat_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryEntity> _categories = [];
  List<CategoryEntity> _filteredCategories = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late CategoryRepository _categoryRepository;
  Timer? _syncTimer;

  // Sync statistics
  int _totalRecords = 0;
  int _syncedRecords = 0;
  int _pendingRecords = 0;

  // Banner images
  final List<String> _bannerImages = [
    'assets/indflag.jpg',
    'assets/isrflag.jpg',
    'assets/russianflag.png',
  ];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _searchController.addListener(() {
      _filterCategories(_searchController.text);
    });

    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _syncDataSilently();
    });
  }

  Future<void> _initializeDatabase() async {
    final db = await DatabaseProvider.database;
    _categoryRepository = CategoryRepository(db.categoryDao);
    _loadLocalCategories();
    _loadSyncStats();
    _syncFromServer();
  }

  Future<void> _loadLocalCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await _categoryRepository.getAllCategories();
      print('Loaded ${categories.length} categories from database');

      setState(() {
        _categories = categories;
        _filteredCategories = List.from(_categories);
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
    _totalRecords = await _categoryRepository.getTotalCount();
    _syncedRecords = await _categoryRepository.getSyncedCount();
    _pendingRecords = await _categoryRepository.getPendingCount();
    setState(() {});
  }

  Future<void> _syncFromServer() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://202.140.138.215:85/api/CategoryMasterApi'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> categoriesData = data['data'];

          print('Received ${categoriesData.length} categories from server');

          final List<Map<String, dynamic>> categoryList = categoriesData
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

          await _categoryRepository.syncFromServer(categoryList);

          await _loadLocalCategories();
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
      final pendingCategories = await _categoryRepository.getPendingSync();

      for (final category in pendingCategories) {
        if (category.isDeleted) {
          if (category.serverId != null) {
            await _deleteFromServer(category.serverId!);
            await _categoryRepository.markAsSynced(category.id!, 'synced');
          } else {
            await _categoryRepository.markAsSynced(category.id!, 'synced');
          }
        } else if (category.serverId == null) {
          final serverId = await _addToServer(category);
          if (serverId != null) {
            category.serverId = serverId;
            await _categoryRepository.updateCategory(category);
            await _categoryRepository.markAsSynced(category.id!, 'synced');
          }
        } else {
          final success = await _updateOnServer(category);
          if (success) {
            await _categoryRepository.markAsSynced(category.id!, 'synced');
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

  Future<int?> _addToServer(CategoryEntity category) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://202.140.138.215:85/api/CategoryMasterApi'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'id': 0, 'categoryName': category.categoryName}),
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

  Future<bool> _updateOnServer(CategoryEntity category) async {
    try {
      final response = await http
          .put(
            Uri.parse(
              'http://202.140.138.215:85/api/CategoryMasterApi/${category.serverId}',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': category.serverId,
              'categoryName': category.categoryName,
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
            Uri.parse(
              'http://202.140.138.215:85/api/CategoryMasterApi/$serverId',
            ),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete from server failed: $e');
      return false;
    }
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = List.from(_categories);
      } else {
        _filteredCategories = _categories
            .where(
              (category) => category.categoryName.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  Future<void> _addCategory(String categoryName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final category = CategoryEntity(
        categoryName: categoryName,
        createdAt: DateTime.now().toIso8601String(),
        isSynced: false,
      );

      await _categoryRepository.insertCategory(category);

      await _loadLocalCategories();
      await _loadSyncStats();

      await _syncPendingChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.save, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('$categoryName saved locally'),
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
        _error = 'Failed to add category: $e';
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

  Future<bool> _deleteCategory(int categoryId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _categoryRepository.deleteCategory(categoryId);
      await _loadLocalCategories();
      await _loadSyncStats();

      await _syncPendingChanges();

      return true;
    } catch (e) {
      setState(() {
        _error = 'Failed to delete category: $e';
      });
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(CategoryEntity category) {
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
                  'Delete Category?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${category.categoryName}"?',
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
                          final success = await _deleteCategory(category.id!);

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
                                      'Category "${category.categoryName}" deleted',
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
                                    Text('Failed to delete category'),
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

  void _showAddCategoryDialog() {
    final categoryNameController = TextEditingController();
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
                  'Add New Category',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
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
                    hintText: 'Enter category name',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8, left: 12),
                      child: Icon(Icons.category, color: Colors.blue.shade600),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
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
                                if (categoryNameController.text.isEmpty) {
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
                                          Text('Please enter a category name'),
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

                                await _addCategory(categoryNameController.text);

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
                                          '${categoryNameController.text} added successfully!',
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
                                  Text('Add Category'),
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
                        'Total Categories',
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
              shadowColor: Colors.blue.withOpacity(0.4),
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
                          'Categories',
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
                          'Manage product categories',
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
                        hintText: 'Search category...',
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
                              _filteredCategories = List.from(_categories);
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
        body: Column(
          children: [
            BannerSlider(bannerImages: _bannerImages),
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
                onPressed: _showAddCategoryDialog,
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
    final displayCategories = _isSearching ? _filteredCategories : _categories;

    if (_isLoading && _categories.isEmpty) {
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
                  'Loading categories...',
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
                onPressed: _loadLocalCategories,
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

    if (_categories.isEmpty) {
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
                'No Categories Found',
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
                  'Get started by adding your first category',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showAddCategoryDialog,
                icon: Icon(Icons.add, size: 20),
                label: Text('Add First Category'),
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
        _filteredCategories.isEmpty &&
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
                'No categories found for "${_searchController.text}"',
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
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayCategories.length,
        itemBuilder: (context, index) {
          final category = displayCategories[index];
          return _buildCategoryItem(category, index);
        },
      ),
    );
  }

  Widget _buildCategoryItem(CategoryEntity category, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child:
          Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: 1,
                shadowColor: Colors.blue.withOpacity(0.1),
                child: InkWell(
                  onTap: () {
                    final categoryModel = Category(
                      id: category.serverId ?? 0,
                      categoryName: category.categoryName,
                      created: category.createdAt != null
                          ? DateTime.parse(category.createdAt!)
                          : null,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SubCategoriesScreen(category: categoryModel),
                      ),
                    );
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(category);
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
                                color: _getColorFromIndex(
                                  index,
                                ).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category.categoryName.isNotEmpty
                                  ? category.categoryName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
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
                                      category.categoryName,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (!category.isSynced)
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
                              if (category.createdAt != null) ...[
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
                                      'Created: ${_formatDate(category.createdAt!)}',
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
                            _showDeleteConfirmationDialog(category);
                          },
                          tooltip: 'Delete Category',
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
