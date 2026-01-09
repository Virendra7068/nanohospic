// screens/master/staff/add_staff_screen.dart
import 'package:flutter/material.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/staff_entity.dart';
import 'package:nanohospic/database/repository/staff_repo.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _credentialsController = TextEditingController();

  // Dummy data for departments
  final List<String> _departments = [
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Oncology',
    'Dermatology',
    'Gynecology',
    'General Surgery',
    'Emergency Medicine',
    'Radiology',
    'Pathology',
    'Anesthesiology',
    'Psychiatry',
    'Ophthalmology',
    'ENT',
    'Urology',
    'Nephrology',
    'Gastroenterology',
    'Pulmonology',
    'Endocrinology',
    'Hematology',
    'Rheumatology',
    'Physical Therapy',
    'Nutrition & Dietetics',
    'Pharmacy',
    'Laboratory',
    'Administration',
    'Human Resources',
    'Finance',
    'Housekeeping',
    'Security',
    'IT Support',
    'Maintenance',
  ];

  // Dummy data for designations
  final List<String> _designations = [
    'Consultant',
    'Senior Consultant',
    'Junior Consultant',
    'Medical Director',
    'Head of Department',
    'Resident Doctor',
    'Intern Doctor',
    'Medical Officer',
    'Staff Nurse',
    'Senior Nurse',
    'Head Nurse',
    'Nursing Supervisor',
    'Nursing Assistant',
    'Pharmacist',
    'Senior Pharmacist',
    'Pharmacy Technician',
    'Lab Technician',
    'Senior Lab Technician',
    'Radiology Technician',
    'Physiotherapist',
    'Occupational Therapist',
    'Dietitian',
    'Nutritionist',
    'Medical Records Officer',
    'Administrative Officer',
    'HR Manager',
    'HR Executive',
    'Finance Manager',
    'Accountant',
    'Receptionist',
    'Office Assistant',
    'Data Entry Operator',
    'IT Manager',
    'System Administrator',
    'Security Officer',
    'Housekeeping Supervisor',
    'Sanitary Worker',
    'Driver',
    'Technician',
    'Electrician',
    'Plumber',
    'Carpenter',
  ];

  String? _selectedDepartment;
  String? _selectedDesignation;
  bool _isLoading = false;
  late StaffRepository _staffRepository;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    final db = await DatabaseProvider.database;
    _staffRepository = StaffRepository(db.staffDao);
  }

  Future<void> _saveStaff() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDepartment == null || _selectedDesignation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Please select department and designation'),
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
      _isLoading = true;
    });

    try {
      final staff = StaffEntity(
        name: _nameController.text,
        department: _selectedDepartment!,
        designation: _selectedDesignation!,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        phone: _phoneController.text,
        requiredCredentials: _credentialsController.text,
        createdAt: DateTime.now().toIso8601String(),
        isSynced: 0,
      );

      await _staffRepository.insertStaff(staff);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Staff added successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Return to previous screen with success
      Navigator.pop(context, true);
    } catch (e) {
      print('Error saving staff: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Failed to save staff: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedDepartment = null;
      _selectedDesignation = null;
    });
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _credentialsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add New Staff',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff016B61),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 22),
            onPressed: _clearForm,
            tooltip: 'Clear Form',
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xff016B61).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xff016B61).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff016B61),
                              Color(0xff019587),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff016B61).withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Add New Staff Member',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff016B61),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Fill in the details below to add a new staff member',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff016B61).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xff016B61).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 14,
                                  color: Color(0xff016B61),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'All fields marked with * are required',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff016B61),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Name Field
                Row(
                  children: [
                    Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter staff name';
                    }
                    if (value.length < 2) {
                      return 'Name should be at least 2 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter full name (e.g., Dr. John Smith)',
                    prefixIcon: Icon(Icons.person, color: Color(0xff016B61)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff016B61),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: 20),

                // Department Dropdown
                Row(
                  children: [
                    Text(
                      'Department',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade50,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.business,
                        color: Color(0xff016B61),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      hintText: 'Select Department',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xff016B61),
                      size: 24,
                    ),
                    dropdownColor: Colors.white,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          'Select Department',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                      ..._departments.map((department) {
                        return DropdownMenuItem(
                          value: department,
                          child: Text(
                            department,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartment = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a department';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Designation Dropdown
                Row(
                  children: [
                    Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade50,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDesignation,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.badge, color: Color(0xff016B61)),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      hintText: 'Select Designation',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xff016B61),
                      size: 24,
                    ),
                    dropdownColor: Colors.white,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          'Select Designation',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                      ..._designations.map((designation) {
                        return DropdownMenuItem(
                          value: designation,
                          child: Text(
                            designation,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDesignation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a designation';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Phone Field
                Row(
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    // FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length < 10) {
                      return 'Phone number must be at least 10 digits';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter numbers only';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter 10-digit phone number',
                    prefixIcon: Icon(Icons.phone, color: Color(0xff016B61)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff016B61),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                  maxLength: 10,
                ),
                SizedBox(height: 20),

                // Email Field
                Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter valid email address';
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter email address (optional)',
                    prefixIcon: Icon(Icons.email, color: Color(0xff016B61)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff016B61),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Required Credentials
                Text(
                  'Required Credentials',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _credentialsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Enter required credentials, certifications, or specializations',
                    prefixIcon: Icon(
                      Icons.verified_user,
                      color: Color(0xff016B61),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xff016B61),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    alignLabelWithHint: true,
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 32),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveStaff,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff016B61),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 18),
                          elevation: 4,
                          shadowColor: Color(0xff016B61).withOpacity(0.3),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Save Staff',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Quick Stats
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Options:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: 14,
                            color: Color(0xff016B61),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${_departments.length} Departments',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(width: 24),
                          Icon(
                            Icons.badge,
                            size: 14,
                            color: Color(0xff016B61),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${_designations.length} Designations',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _credentialsController.dispose();
    super.dispose();
  }
}