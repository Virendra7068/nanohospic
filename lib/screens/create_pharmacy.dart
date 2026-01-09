// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _buttonColorController;
  late Animation<Color?> _buttonColorAnimation;
  late Animation<double> slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _gstNoController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ifssaiNoController = TextEditingController();
  final TextEditingController _drugLicNoController = TextEditingController();
  final TextEditingController _jurisdictionController = TextEditingController();
  final TextEditingController _branchCodeController = TextEditingController();

  bool _isFormComplete = false;
  final int _companyType = 1;
  final int _workingStyle = 1;
  final int _businessType = 1;
  final int _calanderType = 1;
  final int _taxType = 1;
  final int _countryId = 0;
  final int _stateId = 0;
  final int _cityId = 0;
  final String _countryName = "";
  final String _stateName = "";
  final String _cityName = "";

  File? _logo;
  final ImagePicker _picker = ImagePicker();

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
    for (int i = 0; i < 15; i++) {
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

    _companyNameController.addListener(_checkFormCompletion);
    _emailController.addListener(_checkFormCompletion);
    _contactPersonController.addListener(_checkFormCompletion);
    _phoneController.addListener(_checkFormCompletion);
    _mobileNoController.addListener(_checkFormCompletion);
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonColorController.dispose();
    for (var controller in _fieldAnimationControllers) {
      controller.dispose();
    }

    _companyNameController.dispose();
    _emailController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _locationController.dispose();
    _pinCodeController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _mobileNoController.dispose();
    _gstNoController.dispose();
    _branchController.dispose();
    _descriptionController.dispose();
    _ifssaiNoController.dispose();
    _drugLicNoController.dispose();
    _jurisdictionController.dispose();
    _branchCodeController.dispose();
    super.dispose();
  }

  void _checkFormCompletion() {
    final isComplete =
        _companyNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _contactPersonController.text.isNotEmpty &&
        (_phoneController.text.isNotEmpty ||
            _mobileNoController.text.isNotEmpty);
    if (isComplete != _isFormComplete) {
      setState(() {
        _isFormComplete = isComplete;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          _logo = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      final requestBody = {
        "created": DateTime.now().toIso8601String(),
        "createdBy": "admin",
        "lastModified": DateTime.now().toIso8601String(),
        "lastModifiedBy": "admin",
        "deleted": null,
        "deletedBy": null,
        "id": 0,
        "name": _companyNameController.text,
        "tenant": {
          "id": "",
          "name": _companyNameController.text,
          "email": _emailController.text,
          "address1": _address1Controller.text,
          "address2": _address2Controller.text,
          "location": _locationController.text,
          "countryId": _countryId,
          "country": {
            "created": DateTime.now().toIso8601String(),
            "createdBy": "admin",
            "lastModified": DateTime.now().toIso8601String(),
            "lastModifiedBy": "admin",
            "deleted": null,
            "deletedBy": null,
            "id": _countryId,
            "name": _countryName,
          },
          "stateId": _stateId,
          "state": {
            "created": DateTime.now().toIso8601String(),
            "createdBy": "admin",
            "lastModified": DateTime.now().toIso8601String(),
            "lastModifiedBy": "admin",
            "deleted": null,
            "deletedBy": null,
            "id": _stateId,
            "name": _stateName,
            "countryId": _countryId,
            "country": {
              "created": DateTime.now().toIso8601String(),
              "createdBy": "admin",
              "lastModified": DateTime.now().toIso8601String(),
              "lastModifiedBy": "admin",
              "deleted": null,
              "deletedBy": null,
              "id": _countryId,
              "name": _countryName,
            },
          },
          "cityId": _cityId,
          "city": {
            "created": DateTime.now().toIso8601String(),
            "createdBy": "admin",
            "lastModified": DateTime.now().toIso8601String(),
            "lastModifiedBy": "admin",
            "deleted": null,
            "deletedBy": null,
            "id": _cityId,
            "name": _cityName,
            "countryId": _countryId,
            "country": {
              "created": DateTime.now().toIso8601String(),
              "createdBy": "admin",
              "lastModified": DateTime.now().toIso8601String(),
              "lastModifiedBy": "admin",
              "deleted": null,
              "deletedBy": null,
              "id": _countryId,
              "name": _countryName,
            },
            "stateId": _stateId,
            "state": {
              "created": DateTime.now().toIso8601String(),
              "createdBy": "admin",
              "lastModified": DateTime.now().toIso8601String(),
              "lastModifiedBy": "admin",
              "deleted": null,
              "deletedBy": null,
              "id": _stateId,
              "name": _stateName,
              "countryId": _countryId,
              "country": {
                "created": DateTime.now().toIso8601String(),
                "createdBy": "admin",
                "lastModified": DateTime.now().toIso8601String(),
                "lastModifiedBy": "admin",
                "deleted": null,
                "deletedBy": null,
                "id": _countryId,
                "name": _countryName,
              },
            },
          },
          "pinCode": _pinCodeController.text,
          "contactPerson": _contactPersonController.text,
          "phone": _phoneController.text,
          "mobileNo": _mobileNoController.text,
          "gstNo": _gstNoController.text,
          "companyType": _companyType,
          "branch": _branchController.text,
          "logo": _logo != null ? "has_logo" : "",
          "description": _descriptionController.text,
          "ifssaiNo": _ifssaiNoController.text,
          "drugLicNo": _drugLicNoController.text,
          "licenceExpiryDate": DateTime.now()
              .add(Duration(days: 365))
              .toIso8601String(),
          "jurisdiction": _jurisdictionController.text,
          "workingStyle": _workingStyle,
          "branchCode": _branchCodeController.text,
          "businessType": _businessType,
          "calanderType": _calanderType,
          "yearFrom": DateTime.now().toIso8601String(),
          "yearTo": DateTime.now().add(Duration(days: 365)).toIso8601String(),
          "taxType": _taxType,
        },
        "tenantId": "",
      };

      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/CompanyApi'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );
      Navigator.of(context).pop();
      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Company created successfully!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to create company: ${response.body}'),
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
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create company: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Create Company',
          style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
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
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
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
                        controller: _companyNameController,
                        onChanged: (value) => _checkFormCompletion(),
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: "Company Name *",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.business,
                              color: Colors.orange,
                              size: 20.sp,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
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
                            return 'Please enter company name';
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
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Email Address *',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
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
                        controller: _contactPersonController,
                        onChanged: (value) => _checkFormCompletion(),
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: "Contact Person *",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
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
                            return 'Please enter contact person name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 3,
                      child: TextFormField(
                        controller: _phoneController,
                        onChanged: (value) => _checkFormCompletion(),
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
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
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 4,
                      child: TextFormField(
                        controller: _mobileNoController,
                        onChanged: (value) => _checkFormCompletion(),
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Mobile Number *',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone_iphone,
                              color: Colors.green,
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
                          if ((value == null || value.isEmpty) &&
                              _phoneController.text.isEmpty) {
                            return 'Please enter either phone or mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 5,
                      child: TextFormField(
                        controller: _address1Controller,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Address Line 1',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
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
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 6,
                      child: TextFormField(
                        controller: _address2Controller,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Address Line 2',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
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
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 7,
                      child: TextFormField(
                        controller: _gstNoController,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'GST Number',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.receipt,
                              color: Colors.teal,
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
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _buildAnimatedFormField(
                      index: 8,
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Description',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.amber.shade100,
                              child: Icon(
                                Icons.description,
                                color: Colors.amber,
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
                      ),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: double.infinity,
                      height: 6.5.h,
                      child: ElevatedButton(
                        onPressed: _isFormComplete ? _submitForm : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormComplete
                              ? _buttonColorAnimation.value
                              : Colors.blue.shade900,
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              'Create Company',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                shadows: _isFormComplete
                                    ? [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 2,
                                          offset: Offset(1, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            if (_isFormComplete)
                              Positioned(
                                right: 20,
                                child: ScaleTransition(
                                  scale: _buttonColorController.drive(
                                    Tween<double>(begin: 0.8, end: 1.0),
                                  ),
                                  child: Icon(Icons.arrow_forward, size: 20),
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
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.shade900.withOpacity(0.3),
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade900.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: _logo != null ? FileImage(_logo!) : null,
                  child: _logo == null
                      ? Icon(Icons.business, size: 50, color: Colors.grey[400])
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    onPressed: _pickImage,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
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
              'Create Your Company\nProfile',
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
              'Fill in your company details to get started',
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
