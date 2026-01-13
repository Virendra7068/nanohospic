// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nanohospic/screens/category_master.dart';
import 'package:nanohospic/screens/master/area/country_screen.dart';
import 'package:nanohospic/screens/get_patient_list.dart';
import 'package:nanohospic/screens/get_pharmacy_list.dart';
import 'package:nanohospic/screens/hsn_screen.dart';
import 'package:nanohospic/screens/master/branch_type_list_screen.dart';
import 'package:nanohospic/screens/master/client_list_screen.dart';
import 'package:nanohospic/screens/master/collection_center_entry/collection_center_entry_list_screen.dart';
import 'package:nanohospic/screens/master/commission_master/commission_master_widget.dart';
import 'package:nanohospic/screens/master/item_master/division/division_list_screen.dart';
import 'package:nanohospic/screens/master/item_master/unit_screen.dart';
import 'package:nanohospic/screens/master/items/items_list_screen.dart';
import 'package:nanohospic/screens/master/patient_identity.dart';
import 'package:nanohospic/screens/master/sample_type_screen.dart';
import 'package:nanohospic/screens/master/staff/staff_widget.dart';
import 'package:nanohospic/screens/master/test_master/test_master_widget.dart';
import 'package:nanohospic/screens/payment_mode_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Category {
  final int id;
  final String categoryName;
  final IconData icon;

  Category({required this.id, required this.categoryName, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['categoryName'],
      icon: _getIconForCategory(json['categoryName']),
    );
  }

  static IconData _getIconForCategory(String categoryName) {
    switch (categoryName) {
      case "Item Master":
        return Icons.inventory_2;
      case "Area":
        return Icons.location_on;
      case "Offers":
        return Icons.local_offer;
      case "Term Conditions":
        return Icons.description;
      case "Mode Of Payment":
        return Icons.payment;
      case "Company":
        return Icons.business;
      case "Customer":
        return Icons.people;
      case "Supplier":
        return Icons.local_shipping;
      case "Currency":
        return Icons.currency_exchange;
      case "Items Category":
        return Icons.category;
      case "HSN":
        return Icons.list_alt;
      case "Country":
        return Icons.flag;
      case "My Items":
        return Icons.inventory;
      case "Division":
        return Icons.account_tree;
      default:
        return Icons.widgets;
    }
  }
}

class GetMasterItems extends StatefulWidget {
  const GetMasterItems({super.key});

  @override
  State<GetMasterItems> createState() => _GetMasterItemsState();
}

class _GetMasterItemsState extends State<GetMasterItems> {
  List<Category> categories = [
    Category(id: 1, categoryName: "Item Master", icon: Icons.inventory_2),
    Category(id: 2, categoryName: "Staff", icon: Icons.list_alt),
    Category(id: 3, categoryName: "Area", icon: Icons.location_on),
    Category(id: 4, categoryName: "Patient Identity", icon: Icons.local_offer),
    Category(id: 5, categoryName: "Mode Of Payment", icon: Icons.payment),
    Category(id: 6, categoryName: "Test Master", icon: Icons.description),
    Category(id: 7, categoryName: "Client", icon: Icons.business),
    Category(id: 8, categoryName: "Sample Type", icon: Icons.people),
    Category(id: 9, categoryName: "Branch Type", icon: Icons.local_shipping),
    Category(
      id: 10,
      categoryName: "Collection Centre Entry",
      icon: Icons.currency_exchange,
    ),
    Category(id: 11, categoryName: "Commision Master", icon: Icons.category),
    // Category(id: 11, categoryName: "HSN", icon: Icons.list_alt),
  ];

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Category> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(categories);
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = List.from(categories);
      } else {
        _filteredCategories = categories
            .where(
              (category) => category.categoryName.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  void _navigateToScreen(String categoryName, BuildContext context) {
    switch (categoryName) {
      case "Item Master":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ItemMasterScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Area":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AreaScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Branch Type":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BranchTypeListScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Collection Centre Entry":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CollectionCenterListScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Staff":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StaffWidget(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Test Master":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                TestMasterWidget(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Patient Identity":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PatientIdentity(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Commision Master":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CommissionMasterWidget(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Sample Type":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SampleTypeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Mode Of Payment":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentModeScreen()),
        );
        break;
      case "Client":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => GetCompanyListScreen()),
        // );
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ClientListScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case "Customer":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerListScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('$categoryName - Coming Soon!'),
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
                          'Master Items',
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
                          'Manage all your master data in one place',
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
                              _filteredCategories = List.from(categories);
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
              ],
            ),
          ];
        },
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
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
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
      },
      backgroundColor: Colors.white,
      color: Color(0xff016B61),
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.w,
          mainAxisSpacing: 1.h,
          childAspectRatio: 1,
        ),
        itemCount: _filteredCategories.length,
        itemBuilder: (context, index) {
          final category = _filteredCategories[index];
          return _buildCategoryCard(category, index);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category, int index) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      child:
          InkWell(
                onTap: () => _navigateToScreen(category.categoryName, context),
                borderRadius: BorderRadius.circular(20),
                splashColor: Color(0xff016B61).withOpacity(0.1),
                highlightColor: Color(0xff016B61).withOpacity(0.05),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _getColorFromIndex(index).withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            category.icon,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        category.categoryName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: (index * 100).ms)
              .slideY(begin: 0.5, curve: Curves.easeOutQuart),
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
      Colors.deepOrange.shade600,
    ];
    return colors[index % colors.length];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class AreaScreen extends StatelessWidget {
  final List<Category> areaCategories = [
    Category(id: 1, categoryName: "Country", icon: Icons.flag),
  ];

  AreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xff016B61),
        foregroundColor: Colors.white,
        title: Text('Area Management'),
        elevation: 4,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: areaCategories.length,
        itemBuilder: (context, index) {
          final category = areaCategories[index];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 1,
            shadowColor: Colors.grey.withOpacity(0.1),
            child:
                InkWell(
                      onTap: () {
                        if (category.categoryName == "Country") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CountryScreen(),
                            ),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Color(0xff016B61).withOpacity(0.1),
                      highlightColor: Color(0xff016B61).withOpacity(0.05),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.symmetric(vertical: 8),
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
                                  category.icon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                category.categoryName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade400,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (index * 100).ms)
                    .slideX(begin: 0.5, curve: Curves.easeOutQuart),
          );
        },
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
    ];
    return colors[index % colors.length];
  }
}

class ItemMasterScreen extends StatelessWidget {
  final List<Category> itemMasterCategories = [
    Category(id: 1, categoryName: "Items", icon: Icons.inventory),
    Category(id: 2, categoryName: "Items Category", icon: Icons.category),
    Category(id: 2, categoryName: "Unit", icon: Icons.category),
    Category(id: 5, categoryName: "Company", icon: Icons.business),
    Category(id: 4, categoryName: "Division", icon: Icons.account_tree),
    Category(id: 3, categoryName: "HSN", icon: Icons.list_alt),
    // Category(id: 6, categoryName: "Country", icon: Icons.flag),
    // Category(id: 7, categoryName: "Customer", icon: Icons.people),
    // Category(id: 8, categoryName: "Supplier", icon: Icons.local_shipping),
  ];

  ItemMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xff016B61),
        foregroundColor: Colors.white,
        title: Text('Item Master'),
        elevation: 4,
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 1.h,
          childAspectRatio: 1,
        ),
        itemCount: itemMasterCategories.length,
        itemBuilder: (context, index) {
          final category = itemMasterCategories[index];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            elevation: 2,
            shadowColor: Colors.grey.withOpacity(0.2),
            child:
                InkWell(
                      onTap: () {
                        switch (category.categoryName) {
                          case "Items":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemsListScreen(),
                              ),
                            );
                            break;
                          case "Unit":
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        UnitScreen(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                              ),
                            );
                            break;
                          case "Division":
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DivisionScreen(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                              ),
                            );
                            break;
                          case "Items Category":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoriesScreen(),
                              ),
                            );
                            break;
                          case "HSN":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HsnScreen(),
                              ),
                            );
                            break;
                          case "Company":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GetCompanyListScreen(),
                              ),
                            );
                            break;
                          case "Country":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryScreen(),
                              ),
                            );
                            break;
                          case "Customer":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerListScreen(),
                              ),
                            );
                            break;
                          default:
                            // Show coming soon message for other categories
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${category.categoryName} - Coming Soon!',
                                    ),
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
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Color(0xff016B61).withOpacity(0.1),
                      highlightColor: Color(0xff016B61).withOpacity(0.05),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getColorFromIndex(index),
                                    _getColorFromIndex(index).withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
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
                                  category.icon,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              category.categoryName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (index * 100).ms)
                    .slideY(begin: 0.5, curve: Curves.easeOutQuart),
          );
        },
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
    ];
    return colors[index % colors.length];
  }
}
