// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nanohospic/screens/master/area/country_screen.dart';
import 'package:nanohospic/screens/get_patient_list.dart';
import 'package:nanohospic/screens/get_pharmacy_list.dart';
import 'package:nanohospic/screens/hsn_screen.dart';
import 'package:nanohospic/screens/master/commission_master/doctor_commision_screen.dart';
import 'package:nanohospic/screens/master/commission_master/referrer_list_screen.dart';
import 'package:nanohospic/screens/master/staff/staff_list_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CommissionMasterModel {
  final int id;
  final String categoryName;
  final IconData icon;

  CommissionMasterModel({
    required this.id,
    required this.categoryName,
    required this.icon,
  });

  factory CommissionMasterModel.fromJson(Map<String, dynamic> json) {
    return CommissionMasterModel(
      id: json['id'],
      categoryName: json['categoryName'],
      icon: _getIconForCategory(json['categoryName']),
    );
  }

  static IconData _getIconForCategory(String categoryName) {
    switch (categoryName) {
      case "Staff":
        return Icons.spatial_audio_off;
      case "Department":
        return Icons.location_on;
      case "Designation":
        return Icons.local_offer;
      default:
        return Icons.widgets;
    }
  }
}

class CommissionMasterWidget extends StatefulWidget {
  const CommissionMasterWidget({super.key});

  @override
  State<CommissionMasterWidget> createState() => _CommissionMasterWidgetState();
}

class _CommissionMasterWidgetState extends State<CommissionMasterWidget> {
  List<CommissionMasterModel> categories = [
    CommissionMasterModel(
      id: 1,
      categoryName: "Referrer",
      icon: Icons.inventory_2,
    ),
    CommissionMasterModel(
      id: 2,
      categoryName: "Doctor Commission",
      icon: Icons.design_services,
    ),
  ];

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<CommissionMasterModel> _filteredCategories = [];

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
      case "Referrer":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ReferrerListScreen(),
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
      case "Doctor Commission":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                DoctorCommissionListScreen(),
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
                          'Commision Master Management',
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

  Widget _buildCategoryCard(CommissionMasterModel category, int index) {
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
      Color(0xff016B61), // Teal
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

