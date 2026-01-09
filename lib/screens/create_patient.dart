// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateCustomerScreen extends StatefulWidget {
  const CreateCustomerScreen({super.key});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _buttonColorController;
  late Animation<Color?> _buttonColorAnimation;
  late Animation<double> slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isFormComplete = false;
  bool _isLoading = false;

  final List<AnimationController> _fieldAnimationControllers = [];
  final List<Animation<double>> _fieldAnimations = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _buttonColorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    slideAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _buttonColorAnimation = ColorTween(
      begin: Colors.orange[700],
      end: Colors.orange[400],
    ).animate(_buttonColorController);

    // Animation controllers for the fields
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

      _fieldAnimationControllers.add(controller);
      _fieldAnimations.add(animation);
    }

    _controller.forward();

    for (int i = 0; i < _fieldAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + (i * 100)), () {
        if (mounted) {
          _fieldAnimationControllers[i].forward();
        }
      });
    }

    _nameController.addListener(_checkFormCompletion);
    _addressController.addListener(_checkFormCompletion);
    _phoneController.addListener(_checkFormCompletion);
    _emailController.addListener(_checkFormCompletion);
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonColorController.dispose();
    for (var controller in _fieldAnimationControllers) {
      controller.dispose();
    }

    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _checkFormCompletion() {
    final isComplete =
        _nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty;

    if (isComplete != _isFormComplete) {
      setState(() {
        _isFormComplete = isComplete;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/CustomerApi'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": 0,
          "name": _nameController.text,
          "address": _addressController.text,
          "phoneNo": _phoneController.text,
          "email": _emailController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        // Error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                'Failed to create customer: ${response.statusCode}',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create customer: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Create Customer',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
      ),
      body: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedHeader(),
                    SizedBox(height: 30),
                    _buildAnimatedFormField(
                      index: 0,
                      child: TextFormField(
                        controller: _nameController,
                        onChanged: (value) => _checkFormCompletion(),
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          hintText: "Name *",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 1,
                      child: TextFormField(
                        controller: _emailController,
                        onChanged: (value) => _checkFormCompletion(),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          hintText: 'Email Address *',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.email,
                              color: Colors.purple,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 2,
                      child: TextFormField(
                        controller: _phoneController,
                        onChanged: (value) => _checkFormCompletion(),
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          hintText: 'Phone Number *',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.blue.shade900,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 3,
                      child: TextFormField(
                        controller: _addressController,
                        onChanged: (value) => _checkFormCompletion(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          hintText: 'Address *',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.red.shade100,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    SizedBox(
                      width: double.infinity,
                      height: 5.5.h,
                      child: ElevatedButton(
                        onPressed:
                            _isFormComplete && !_isLoading ? _submitForm : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isFormComplete && !_isLoading
                                  ? _buttonColorAnimation.value
                                  : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 5,
                          shadowColor: Colors.orange.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        child:
                            _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      'Create Customer',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        shadows:
                                            _isFormComplete
                                                ? [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 2,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ]
                                                : null,
                                      ),
                                    ),
                                    if (_isFormComplete && !_isLoading)
                                      Positioned(
                                        right: 20,
                                        child: ScaleTransition(
                                          scale: _buttonColorController.drive(
                                            Tween<double>(begin: 0.8, end: 1.0),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_add, size: 50, color: Colors.orange),
          ),
          SizedBox(height: 15),
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(0.3, 0.8, curve: Curves.easeIn),
              ),
            ),
            child: Text(
              'Create New Customer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8),
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(0.5, 1.0, curve: Curves.easeIn),
              ),
            ),
            child: Text(
              'Fill in customer details to create a new customer',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFormField({required int index, required Widget child}) {
    if (index < _fieldAnimations.length) {
      return AnimatedBuilder(
        animation: _fieldAnimations[index],
        builder: (context, child) {
          return Opacity(
            opacity: _fieldAnimations[index].value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - _fieldAnimations[index].value)),
              child: child,
            ),
          );
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}
