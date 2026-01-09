import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanohospic/screens/master_cat_screen.dart';
import 'package:nanohospic/screens/master_item.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double profileCompletion = 0.85;

  // User data variables
  String _userName = '';
  String _email = '';
  String _role = '';
  String _phoneNumber = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();

      // Load user data from shared preferences
      setState(() {
        _userName = prefs.getString('userName') ?? 'User';
        _email = prefs.getString('email') ?? 'user@example.com';
        _role = prefs.getString('role') ?? 'User';
        _phoneNumber = prefs.getString('phoneNumber') ?? '';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phoneNumber);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
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
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Edit Profile',
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
                  labelText: 'Name',
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
                  prefixIcon: Container(
                    margin: EdgeInsets.only(right: 8, left: 12),
                    child: Icon(Icons.person, color: Colors.blue.shade600),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 40),
                ),
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                  prefixIcon: Container(
                    margin: EdgeInsets.only(right: 8, left: 12),
                    child: Icon(Icons.email, color: Colors.blue.shade600),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 40),
                ),
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ),
              SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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
                  prefixIcon: Container(
                    margin: EdgeInsets.only(right: 8, left: 12),
                    child: Icon(Icons.phone, color: Colors.blue.shade600),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 40),
                ),
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
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
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
                          Icon(Icons.save, size: 20),
                          SizedBox(width: 8),
                          Text('Save'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', nameController.text);
        await prefs.setString('email', emailController.text);
        await prefs.setString('phoneNumber', phoneController.text);

        setState(() {
          _userName = nameController.text;
          _email = emailController.text;
          _phoneNumber = phoneController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Profile updated successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Failed to update profile'),
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
    }
  }

  final List<Map<String, dynamic>> settingsItems = [
    {'icon': Icons.category, 'title': 'Master', 'trailing': '>'},
    {'icon': Icons.shopping_cart, 'title': 'Patient Registration', 'trailing': '>'},
    {'icon': Icons.pending, 'title': 'Pending Prescription', 'trailing': '>'},
    {'icon': Icons.production_quantity_limits, 'title': 'Sales', 'trailing': '>'},
    {'icon': Icons.report, 'title': 'Report Generation', 'trailing': '>'},
    {'icon': Icons.report, 'title': 'Report', 'trailing': '>'},
    {'icon': Icons.settings, 'title': 'Settings', 'trailing': '>'},
    {'icon': Icons.logout, 'title': 'Logout', 'trailing': '>'},
  ];

  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => _buildLogoutDialog(context),
        ) ??
        false;

    if (shouldLogout) {
      await _logout();
    }
  }

  Widget _buildLogoutDialog(BuildContext context) {
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
                Icons.logout,
                color: Colors.red,
                size: 32,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Logout?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
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
                    onPressed: () => Navigator.of(context).pop(true),
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
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text('Logout'),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // ✅ Same as CountryScreen
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 12.h, // ✅ Similar expanded height
            floating: false,
            pinned: true,
            backgroundColor: Color(0xff016B61), // ✅ Same primary color
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
                    top: 60,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Profile & Settings',
                        style: TextStyle(
                          fontSize: 24,
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
                      SizedBox(height: 4),
                      Text(
                        'Manage your profile and settings',
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
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 2.h),
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, -0.5),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: _buildProfileCard(context),
                  ),
                ),
                SizedBox(height: 24),
                _isLoading ? _buildLoadingSection() : _buildSettingsList(),
                // Always show logout button
                _buildLogoutButton(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 45,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(_animation),
          child: FloatingActionButton.extended(
            onPressed: () {
              // Navigate to help screen
            },
            icon: Icon(Icons.support_agent, size: 24, color: Colors.white),
            label: Text(
              'Help',
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Color(0xff016B61), // ✅ Same primary color
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // ✅ Same border radius
            ),
            splashColor: Colors.teal.shade800.withOpacity(0.3),
            heroTag: 'help_fab',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff016B61)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading profile...',
              style: TextStyle(fontSize: 16.sp, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Card(
        elevation: 4,
        color: Color(0xff016B61),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              _isLoading
                  ? _buildProfileCardLoading()
                  : _buildProfileCardContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCardLoading() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 20,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 180,
                    height: 15,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 20,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            SizedBox(width: 20),
            Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCardContent() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _updateProfile,
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                        SizedBox(width: 10),
                        Text(
                          _userName,
                          style: GoogleFonts.abel(
                            textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _email,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Role: $_role',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                  ),
                  SizedBox(height: 0.5.h),
                  if (_phoneNumber.isNotEmpty)
                    Text(
                      'Phone: $_phoneNumber',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                // Handle profile image tap
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xff016B61),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Text(
                '  Profile Status',
                style: GoogleFonts.abel(
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedCircularProgress(
                    value: profileCompletion,
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.grey.shade300,
                    valueColor: Colors.white,
                    size: 50,
                    strokeWidth: 6,
                  ),
                  Text(
                    '${(profileCompletion * 100).toInt()}%',
                    style: GoogleFonts.abel(
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xff016B61),
                        fontWeight: FontWeight.bold,
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

  Widget _buildSettingsList() {
    return Column(
      children: settingsItems
          .where((item) => item['title'] != 'Logout')
          .map((item) => _buildSettingsListItem(item))
          .toList(),
    );
  }

  Widget _buildLogoutButton() {
    final logoutItem = settingsItems.firstWhere(
      (item) => item['title'] == 'Logout',
    );

    return _buildSettingsListItem(logoutItem);
  }

  Widget _buildSettingsListItem(Map<String, dynamic> item) {
    final index = settingsItems.indexOf(item);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // ✅ Same border radius
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _handleSettingsItemTap(item['title'] as String);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 23.sp,
                  height: 23.sp,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item['title'] == 'Logout'
                          ? [Colors.red.shade400, Colors.red.shade600]
                          : [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12), // ✅ Same border radius
                    boxShadow: [
                      BoxShadow(
                        color: (item['title'] == 'Logout'
                                ? Colors.red
                                : Colors.blue)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      item['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'].toString(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSettingsItemTap(String title) {
    switch (title) {
      case "Master":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GetMasterItems()),
        );
        break;
      case "Logout":
        _showLogoutConfirmation();
        break;
      default:
        break;
    }
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('authToken');
      await prefs.remove('tokenExpiry');
      await prefs.remove('userId');
      await prefs.remove('userName');
      await prefs.remove('email');
      await prefs.remove('role');
      await prefs.remove('phoneNumber');
      await prefs.remove('avatar');
      await prefs.remove('loginTime');

      // Navigate to login screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LoginPage()),
      // );
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}

class AnimatedCircularProgress extends StatefulWidget {
  final double value;
  final Duration duration;
  final Color backgroundColor;
  final Color valueColor;
  final double size;
  final double strokeWidth;

  const AnimatedCircularProgress({
    super.key,
    required this.value,
    required this.duration,
    required this.backgroundColor,
    required this.valueColor,
    this.size = 100,
    this.strokeWidth = 8,
  });

  @override
  _AnimatedCircularProgressState createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            value: _animation.value,
            backgroundColor: widget.backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}