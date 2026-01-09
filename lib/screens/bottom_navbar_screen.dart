// // import 'package:easybillnew/view/dashboard_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

// // class AnimatedNavScreen extends StatefulWidget {
// //   const AnimatedNavScreen({super.key});

// //   @override
// //   _AnimatedNavScreenState createState() => _AnimatedNavScreenState();
// // }

// // class _AnimatedNavScreenState extends State<AnimatedNavScreen>
// //     with TickerProviderStateMixin {
// //   int _bottomNavIndex = 0;
// //   late AnimationController _animationController;
// //   late Animation<double> animation;
// //   late CurvedAnimation curve;

// //   final iconList = <IconData>[
// //     Icons.home_outlined,
// //     Icons.person_2_outlined,
// //     Icons.insert_emoticon,
// //     Icons.real_estate_agent,
// //     Icons.more_horiz_outlined,
// //   ];

// //   final colorList = [
// //     Colors.blue,
// //     Colors.purple,
// //     Colors.orange,
// //     Colors.orange,
// //     Colors.teal,
// //   ];

// //   final List<Widget> _screens = [
// //     DashboardScreen(),
// //     DashboardScreen(),
// //     DashboardScreen(),
// //     DashboardScreen(),
// //     DashboardScreen(),
// //   ];

// //   // Watermark icons configuration
// //   final List<IconData> _watermarkIcons = [
// //     Icons.receipt_long,
// //     Icons.account_balance,
// //     Icons.payment,
// //     Icons.bar_chart,
// //     Icons.attach_money,
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       duration: const Duration(seconds: 1),
// //       vsync: this,
// //     );
// //     curve = CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeInOut,
// //     );
// //     animation = Tween<double>(begin: 0, end: 1).animate(curve);
// //     _animationController.forward();
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBody: true,
// //       body: Stack(
// //         children: [
// //           _buildWatermarkBackground(),
// //           FadeTransition(
// //             opacity: animation,
// //             child: IndexedStack(
// //               index: _bottomNavIndex,
// //               children: _screens,
// //             ),
// //           ),
// //         ],
// //       ),
// //       bottomNavigationBar: AnimatedBottomNavigationBar(
// //         icons: iconList,
// //         elevation: 10,
// //         activeIndex: _bottomNavIndex,
// //         gapLocation: GapLocation.none,
// //         activeColor: Colors.blue.shade700,
// //         splashColor: Colors.blue.shade700,
// //         inactiveColor: Colors.black.withOpacity(0.5),
// //         notchAndCornersAnimation: animation,
// //         splashSpeedInMilliseconds: 300,
// //         leftCornerRadius: 0,
// //         rightCornerRadius: 0,
// //         onTap: (index) {
// //           setState(() {
// //             _bottomNavIndex = index;
// //             _animationController.reset();
// //             _animationController.forward();
// //           });
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildWatermarkBackground() {
// //     return IgnorePointer(
// //       child: Container(
// //         color: Colors.grey[50], // Light background color
// //         child: Stack(
// //           children: [
// //             // Large centered watermark
// //             Positioned(
// //               right: -100,
// //               top: MediaQuery.of(context).size.height * 0.3,
// //               child: Transform.rotate(
// //                 angle: -0.2,
// //                 child: Icon(
// //                   _watermarkIcons[0],
// //                   size: 200,
// //                   color: Colors.grey[200],
// //                 ),
// //               ),
// //             ),
// //             // Smaller watermarks scattered
// //             Positioned(
// //               left: 30,
// //               top: MediaQuery.of(context).size.height * 0.1,
// //               child: Icon(
// //                 _watermarkIcons[1],
// //                 size: 80,
// //                 color: Colors.grey[200],
// //               ),
// //             ),
// //             Positioned(
// //               right: 40,
// //               bottom: MediaQuery.of(context).size.height * 0.2,
// //               child: Icon(
// //                 _watermarkIcons[2],
// //                 size: 100,
// //                 color: Colors.grey[200],
// //               ),
// //             ),
// //             Positioned(
// //               left: 50,
// //               bottom: MediaQuery.of(context).size.height * 0.4,
// //               child: Transform.rotate(
// //                 angle: 0.3,
// //                 child: Icon(
// //                   _watermarkIcons[3],
// //                   size: 120,
// //                   color: Colors.grey[200],
// //                 ),
// //               ),
// //             ),
// //             Positioned(
// //               right: 20,
// //               top: MediaQuery.of(context).size.height * 0.5,
// //               child: Icon(
// //                 _watermarkIcons[4],
// //                 size: 90,
// //                 color: Colors.grey[200],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

// class AnimatedNavScreen extends StatefulWidget {
//   const AnimatedNavScreen({super.key});

//   @override
//   _AnimatedNavScreenState createState() => _AnimatedNavScreenState();
// }

// class _AnimatedNavScreenState extends State<AnimatedNavScreen>
//     with TickerProviderStateMixin {
//   int _bottomNavIndex = 0;
//   late AnimationController _animationController;
//   late Animation<double> animation;
//   late CurvedAnimation curve;

//   // Navigation items with icons and titles
//   final List<Map<String, dynamic>> navItems = [
//     {'icon': Icons.home_outlined, 'title': 'Dashboard'},
//     {'icon': Icons.people_outline, 'title': 'Parties'},
//     {'icon': Icons.inventory_2_outlined, 'title': 'Items'},
//     {'icon': Icons.star_outline, 'title': 'For You'},
//     {'icon': Icons.more_horiz_outlined, 'title': 'More'},
//   ];

//   // Screen content for each tab
//   final List<Widget> _screens = [
//     const Center(child: Text('Dashboard Content', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Parties Content', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Items Content', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('For You Content', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('More Content', style: TextStyle(fontSize: 24))),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     curve = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//     animation = Tween<double>(begin: 0, end: 1).animate(curve);
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(navItems[_bottomNavIndex]['title']),
//         centerTitle: true,
//       ),
//       body: FadeTransition(
//         opacity: animation,
//         child: IndexedStack(
//           index: _bottomNavIndex,
//           children: _screens,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {},
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildCustomBottomNavBar(),
//     );
//   }

//   Widget _buildCustomBottomNavBar() {
//     return AnimatedBottomNavigationBar(
//       icons: navItems.map((item) => item['icon'] as IconData).toList(),
//       activeIndex: _bottomNavIndex,
//       gapLocation: GapLocation.center,
//       activeColor: Colors.blue,
//       inactiveColor: Colors.grey,
//       splashColor: Colors.blue,
//       leftCornerRadius: 32,
//       rightCornerRadius: 32,
//       onTap: (index) {
//         setState(() {
//           _bottomNavIndex = index;
//           _animationController.reset();
//           _animationController.forward();
//         });
//       },
//       tabBuilder: (index, isActive) {
//         final color = isActive ? Colors.blue : Colors.grey;
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               navItems[index]['icon'],
//               size: 24,
//               color: color,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               navItems[index]['title'],
//               style: TextStyle(
//                 fontSize: 12,
//                 color: color,
//                 fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanohospic/screens/dashboard_screen.dart';
import 'package:nanohospic/screens/home_screen.dart';
import 'package:nanohospic/screens/profile_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AnimatedNavScreen extends StatefulWidget {
  const AnimatedNavScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedNavScreenState createState() => _AnimatedNavScreenState();
}

class _AnimatedNavScreenState extends State<AnimatedNavScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_outlined, 'title': 'Dashboard'},
    {'icon': Icons.people_outline, 'title': 'Parties'},
    {'icon': Icons.inventory_2_outlined, 'title': 'Items'},
    // {'icon': Icons.star_outline, 'title': 'For You'},
    {'icon': Icons.more_horiz_outlined, 'title': 'More'},
  ];

  final List<Widget> _screens = [
    DashboardScreen(),
    HomeScreen(),
    // ItemListScreen(),
    // DashboardScreen(),
    ProfileScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: _navItems.map((item) {
            return SalomonBottomBarItem(
              icon: Icon(item['icon']),
              title: Text(
                item['title'],
                style: GoogleFonts.abel(textStyle: TextStyle(fontSize: 15.sp)),
              ),
              selectedColor: Colors.blue,
              unselectedColor: Colors.grey,
            );
          }).toList(),
          backgroundColor: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
