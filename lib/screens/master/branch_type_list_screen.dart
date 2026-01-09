// import 'package:flutter/material.dart';
// import 'package:nanohospic/database/database_provider.dart';
// import 'package:nanohospic/database/entity/branch_type_entity.dart';

// class BranchTypeListScreen extends StatefulWidget {
//   const BranchTypeListScreen({super.key});

//   @override
//   _BranchTypeListScreenState createState() => _BranchTypeListScreenState();
// }

// class _BranchTypeListScreenState extends State<BranchTypeListScreen> {
//   List<BranchTypeEntity> _branchTypes = [];
//   bool _isLoading = true;
//   String _searchQuery = '';

//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _initializeScreen();
//   }

//   Future<void> _initializeScreen() async {
//     try {
//       await DatabaseProvider.initializeBranchTypeScreen();
//       await _loadBranchTypes();
//     } catch (e) {
//       print('Error initializing: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadBranchTypes() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       final repository = await DatabaseProvider.branchTypeRepository;
//       final branchTypes = await repository.getAllBranchTypes();

//       setState(() {
//         _branchTypes = branchTypes;
//       });
//     } catch (e) {
//       print('Error loading branch types: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load branch types: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _searchBranchTypes(String query) async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _searchQuery = query;
//       });

//       final repository = await DatabaseProvider.branchTypeRepository;
//       final results = await repository.searchBranchTypes(query);

//       setState(() {
//         _branchTypes = results;
//       });
//     } catch (e) {
//       print('Error searching: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _deleteBranchType(BranchTypeEntity branchType) async {
//     try {
//       final confirmed = await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Confirm Delete'),
//           content: Text('Are you sure you want to delete ${branchType.companyName}?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         ),
//       );

//       if (confirmed == true) {
//         setState(() {
//           _isLoading = true;
//         });

//         final repository = await DatabaseProvider.branchTypeRepository;
//         await repository.softDeleteBranchType(branchType.id!, 'User');

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${branchType.companyName} deleted successfully')),
//         );

//         await _loadBranchTypes();
//       }
//     } catch (e) {
//       print('Error deleting: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showBranchTypeDetails(BranchTypeEntity branchType) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         minChildSize: 0.5,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (context, scrollController) {
//           return SingleChildScrollView(
//             controller: scrollController,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: Text(
//                       branchType.companyName,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildDetailRow('Contact Person', branchType.contactPerson),
//                   _buildDetailRow('Contact No', branchType.contactNo),
//                   _buildDetailRow('Email', branchType.email),
//                   _buildDetailRow('Mobile No', branchType.mobileNo),
//                   _buildDetailRow('Designation', branchType.designation),
//                   _buildDetailRow('Type', branchType.type),
//                   _buildDetailRow('Location', branchType.location),
//                   _buildDetailRow('Address 1', branchType.address1),
//                   _buildDetailRow('Address 2', branchType.address2),
//                   _buildDetailRow('Country', branchType.country),
//                   _buildDetailRow('State', branchType.state),
//                   _buildDetailRow('City', branchType.city),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => BranchTypeFormScreen(
//                                 branchType: branchType,
//                                 onSaved: _loadBranchTypes,
//                               ),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.edit, size: 18),
//                         label: const Text('Edit'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                         ),
//                       ),
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           _deleteBranchType(branchType);
//                         },
//                         icon: const Icon(Icons.delete, size: 18),
//                         label: const Text('Delete'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               '$label:',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               value.isNotEmpty ? value : 'Not specified',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Branch Types'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadBranchTypes,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       labelText: 'Search Branch Types',
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: _searchQuery.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 _searchController.clear();
//                                 _searchBranchTypes('');
//                               },
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       _searchBranchTypes(value);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: _branchTypes.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.business,
//                                 size: 80,
//                                 color: Colors.grey,
//                               ),
//                               const SizedBox(height: 20),
//                               Text(
//                                 _searchQuery.isEmpty
//                                     ? 'No branch types found'
//                                     : 'No results for "$_searchQuery"',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               if (_searchQuery.isNotEmpty)
//                                 TextButton(
//                                   onPressed: () {
//                                     _searchController.clear();
//                                     _searchBranchTypes('');
//                                   },
//                                   child: const Text('Clear search'),
//                                 ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: const EdgeInsets.all(8),
//                           itemCount: _branchTypes.length,
//                           itemBuilder: (context, index) {
//                             final branchType = _branchTypes[index];
//                             return Card(
//                               margin: const EdgeInsets.symmetric(
//                                 vertical: 4,
//                                 horizontal: 8,
//                               ),
//                               child: ListTile(
//                                 leading: CircleAvatar(
//                                   backgroundColor: Colors.blue[100],
//                                   child: const Icon(
//                                     Icons.business,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                                 title: Text(
//                                   branchType.companyName,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(branchType.contactPerson),
//                                     Text(
//                                       '${branchType.contactNo} • ${branchType.type}',
//                                       style: const TextStyle(fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: IconButton(
//                                   icon: const Icon(Icons.more_vert),
//                                   onPressed: () => _showBranchTypeDetails(branchType),
//                                 ),
//                                 onTap: () => _showBranchTypeDetails(branchType),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const BranchTypeFormScreen(),
//             ),
//           );

//           if (result == true) {
//             await _loadBranchTypes();
//           }
//         },
//         icon: const Icon(Icons.add),
//         label: const Text('Add Branch'),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }

// class BranchTypeFormScreen extends StatefulWidget {
//   final BranchTypeEntity? branchType;
//   final Function()? onSaved;

//   const BranchTypeFormScreen({
//     Key? key,
//     this.branchType,
//     this.onSaved,
//   }) : super(key: key);

//   @override
//   _BranchTypeFormScreenState createState() => _BranchTypeFormScreenState();
// }

// class _BranchTypeFormScreenState extends State<BranchTypeFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _isEditing = false;

//   // Controllers for form fields
//   final TextEditingController _companyNameController = TextEditingController();
//   final TextEditingController _contactPersonController = TextEditingController();
//   final TextEditingController _contactNoController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _address1Controller = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _typeController = TextEditingController();
//   final TextEditingController _designationController = TextEditingController();
//   final TextEditingController _mobileNoController = TextEditingController();
//   final TextEditingController _address2Controller = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();

//   // Lists for dropdowns
//   List<String> _typeOptions = ['Head Office', 'Branch', 'Sub Branch', 'Regional Office'];
//   List<String> _designationOptions = ['Manager', 'Director', 'CEO', 'Supervisor', 'Owner'];
//   List<String> _countryOptions = ['India', 'USA', 'UK', 'Canada', 'Australia'];
//   List<String> _stateOptions = ['Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Gujarat'];
//   List<String> _cityOptions = ['Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Ahmedabad'];

//   @override
//   void initState() {
//     super.initState();
//     _isEditing = widget.branchType != null;

//     if (_isEditing) {
//       _populateForm();
//     }
//   }

//   void _populateForm() {
//     final branchType = widget.branchType!;
//     _companyNameController.text = branchType.companyName;
//     _contactPersonController.text = branchType.contactPerson;
//     _contactNoController.text = branchType.contactNo;
//     _emailController.text = branchType.email;
//     _address1Controller.text = branchType.address1;
//     _locationController.text = branchType.location;
//     _typeController.text = branchType.type;
//     _designationController.text = branchType.designation;
//     _mobileNoController.text = branchType.mobileNo;
//     _address2Controller.text = branchType.address2;
//     _countryController.text = branchType.country;
//     _stateController.text = branchType.state;
//     _cityController.text = branchType.city;
//   }

//   Future<void> _saveBranchType() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       final repository = await DatabaseProvider.branchTypeRepository;
//       final branchType = BranchTypeEntity(
//         id: widget.branchType?.id,
//         serverId: widget.branchType?.serverId,
//         companyName: _companyNameController.text.trim(),
//         contactPerson: _contactPersonController.text.trim(),
//         contactNo: _contactNoController.text.trim(),
//         email: _emailController.text.trim(),
//         address1: _address1Controller.text.trim(),
//         location: _locationController.text.trim(),
//         type: _typeController.text.trim(),
//         designation: _designationController.text.trim(),
//         mobileNo: _mobileNoController.text.trim(),
//         address2: _address2Controller.text.trim(),
//         country: _countryController.text.trim(),
//         state: _stateController.text.trim(),
//         city: _cityController.text.trim(),
//         createdAt: widget.branchType?.createdAt ?? DateTime.now().toIso8601String(),
//         createdBy: widget.branchType?.createdBy ?? 'User',
//         lastModified: DateTime.now().toIso8601String(),
//         lastModifiedBy: 'User',
//       );

//       if (_isEditing) {
//         await repository.updateBranchType(branchType);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${branchType.companyName} updated successfully')),
//         );
//       } else {
//         await repository.insertBranchType(branchType);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${branchType.companyName} added successfully')),
//         );
//       }

//       if (widget.onSaved != null) {
//         widget.onSaved!();
//       }

//       Navigator.pop(context, true);
//     } catch (e) {
//       print('Error saving branch type: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildTextFormField({
//     required String label,
//     required TextEditingController controller,
//     required String? Function(String?)? validator,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     bool isRequired = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: '$label${isRequired ? ' *' : ''}',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           filled: true,
//           fillColor: Colors.grey[50],
//         ),
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         validator: validator,
//       ),
//     );
//   }

//   Widget _buildDropdownFormField({
//     required String label,
//     required TextEditingController controller,
//     required List<String> options,
//     required String? Function(String?)? validator,
//     bool isRequired = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: DropdownButtonFormField<String>(
//         value: controller.text.isNotEmpty ? controller.text : null,
//         decoration: InputDecoration(
//           labelText: '$label${isRequired ? ' *' : ''}',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           filled: true,
//           fillColor: Colors.grey[50],
//         ),
//         items: options.map((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//         onChanged: (String? newValue) {
//           setState(() {
//             controller.text = newValue ?? '';
//           });
//         },
//         validator: validator,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isEditing ? 'Edit Branch Type' : 'Add New Branch Type'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveBranchType,
//             tooltip: 'Save',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildTextFormField(
//                       label: 'Company Name',
//                       controller: _companyNameController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter company name';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildTextFormField(
//                       label: 'Contact Person',
//                       controller: _contactPersonController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter contact person name';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildTextFormField(
//                       label: 'Contact No',
//                       controller: _contactNoController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter contact number';
//                         }
//                         if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value)) {
//                           return 'Please enter a valid contact number';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.phone,
//                     ),
//                     _buildTextFormField(
//                       label: 'Email',
//                       controller: _emailController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter email address';
//                         }
//                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                           return 'Please enter a valid email address';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     _buildTextFormField(
//                       label: 'Address 1',
//                       controller: _address1Controller,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter address';
//                         }
//                         return null;
//                       },
//                       maxLines: 2,
//                     ),
//                     _buildTextFormField(
//                       label: 'Location',
//                       controller: _locationController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter location';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildDropdownFormField(
//                       label: 'Type',
//                       controller: _typeController,
//                       options: _typeOptions,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select type';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildDropdownFormField(
//                       label: 'Designation',
//                       controller: _designationController,
//                       options: _designationOptions,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select designation';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildTextFormField(
//                       label: 'Mobile No',
//                       controller: _mobileNoController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter mobile number';
//                         }
//                         if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value)) {
//                           return 'Please enter a valid mobile number';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.phone,
//                     ),
//                     _buildTextFormField(
//                       label: 'Address 2',
//                       controller: _address2Controller,
//                       validator: null,
//                       isRequired: false,
//                       maxLines: 2,
//                     ),
//                     _buildDropdownFormField(
//                       label: 'Country',
//                       controller: _countryController,
//                       options: _countryOptions,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select country';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildDropdownFormField(
//                       label: 'State',
//                       controller: _stateController,
//                       options: _stateOptions,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select state';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildDropdownFormField(
//                       label: 'City',
//                       controller: _cityController,
//                       options: _cityOptions,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select city';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton.icon(
//                       onPressed: _saveBranchType,
//                       icon: _isLoading
//                           ? const SizedBox(
//                               width: 16,
//                               height: 16,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Icon(Icons.save),
//                       label: Text(_isEditing ? 'Update Branch Type' : 'Save Branch Type'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextButton.icon(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.cancel),
//                       label: const Text('Cancel'),
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     _companyNameController.dispose();
//     _contactPersonController.dispose();
//     _contactNoController.dispose();
//     _emailController.dispose();
//     _address1Controller.dispose();
//     _locationController.dispose();
//     _typeController.dispose();
//     _designationController.dispose();
//     _mobileNoController.dispose();
//     _address2Controller.dispose();
//     _countryController.dispose();
//     _stateController.dispose();
//     _cityController.dispose();
//     super.dispose();
//   }
// }

// ignore_for_file: avoid_print, deprecated_member_use, depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/branch_type_entity.dart';

class BranchTypeListScreen extends StatefulWidget {
  const BranchTypeListScreen({super.key});

  @override
  State<BranchTypeListScreen> createState() => _BranchTypeListScreenState();
}

class _BranchTypeListScreenState extends State<BranchTypeListScreen> {
  List<BranchTypeEntity> _branchTypes = [];
  List<BranchTypeEntity> _filteredBranchTypes = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _syncTimer;

  final Color _primaryColor = Color(0xff016B61);
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _searchController.addListener(() {
      _filterBranchTypes(_searchController.text);
    });

    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _syncDataSilently();
    });
  }

  Future<void> _initializeScreen() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // await DatabaseProvider.initializeBranchTypeScreen();
      await _loadBranchTypes();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing: $e');
      setState(() {
        _error = 'Failed to initialize: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBranchTypes() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final repository = await DatabaseProvider.branchTypeRepository;
      final branchTypes = await repository.getAllBranchTypes();

      setState(() {
        _branchTypes = branchTypes;
        _filteredBranchTypes = List.from(_branchTypes);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading branch types: $e');
      setState(() {
        _error = 'Failed to load branch types: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _filterBranchTypes(String query) async {
    try {
      final repository = await DatabaseProvider.branchTypeRepository;
      final results = await repository.searchBranchTypes(query);

      setState(() {
        _filteredBranchTypes = results;
      });
    } catch (e) {
      print('Error searching: $e');
    }
  }

  Future<void> _syncDataSilently() async {
    try {
      // Silent sync logic here
      // You can add your sync logic similar to PaymentModeScreen
    } catch (e) {
      print('Silent sync failed: $e');
    }
  }

  Future<void> _deleteBranchType(BranchTypeEntity branchType) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                child: Icon(Icons.delete_forever, color: Colors.red, size: 32),
              ),
              SizedBox(height: 20),
              Text(
                'Delete Branch Type?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${branchType.companyName}"?',
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
                      onPressed: () async {
                        Navigator.of(context).pop(true);
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
      ),
    );

    if (confirmed == true) {
      try {
        setState(() {
          _isLoading = true;
        });

        final repository = await DatabaseProvider.branchTypeRepository;
        await repository.softDeleteBranchType(branchType.id!, 'User');

        await _loadBranchTypes();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('${branchType.companyName} deleted successfully'),
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
      } catch (e) {
        print('Error deleting: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Failed to delete: $e'),
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showBranchTypeDetails(BranchTypeEntity branchType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryColor,
                              _primaryColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Iconsax.building,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        branchType.companyName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (branchType.type.isNotEmpty)
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _primaryColor),
                          ),
                          child: Text(
                            branchType.type,
                            style: TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 24),
                    _buildDetailCard(
                      icon: Iconsax.profile_circle,
                      title: 'Contact Details',
                      items: [
                        _buildDetailItem(
                          'Contact Person',
                          branchType.contactPerson,
                        ),
                        _buildDetailItem('Designation', branchType.designation),
                        _buildDetailItem('Contact No', branchType.contactNo),
                        _buildDetailItem('Mobile No', branchType.mobileNo),
                        _buildDetailItem('Email', branchType.email),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildDetailCard(
                      icon: Iconsax.location,
                      title: 'Location Details',
                      items: [
                        _buildDetailItem('Location', branchType.location),
                        _buildDetailItem('Address 1', branchType.address1),
                        _buildDetailItem('Address 2', branchType.address2),
                        _buildDetailItem('City', branchType.city),
                        _buildDetailItem('State', branchType.state),
                        _buildDetailItem('Country', branchType.country),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BranchTypeFormScreen(
                                    branchType: branchType,
                                    onSaved: _loadBranchTypes,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Iconsax.edit, size: 20),
                            label: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteBranchType(branchType);
                            },
                            icon: Icon(Iconsax.trash, size: 20),
                            label: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
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
      backgroundColor: _backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 15.h,
              floating: false,
              pinned: true,
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 6,
              shadowColor: _primaryColor.withOpacity(0.4),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _primaryColor,
                        _primaryColor,
                        _primaryColor.withOpacity(0.4),
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
                          'Branch Types',
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
                          'Manage all branches and offices',
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
                        hintText: 'Search branches...',
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
                              _filterBranchTypes('');
                            });
                          },
                        ),
                      ),
                    )
                  : null,
              actions: [
                if (!_isSearching)
                  IconButton(
                    icon: Icon(Iconsax.search_normal, size: 22),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                IconButton(
                  icon: Icon(Iconsax.refresh, color: Colors.white, size: 22),
                  onPressed: _loadBranchTypes,
                  tooltip: 'Refresh',
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
        body: _buildBody(),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BranchTypeFormScreen(onSaved: _loadBranchTypes),
                    ),
                  );

                  if (result == true) {
                    await _loadBranchTypes();
                  }
                },
                icon: Icon(Iconsax.add, size: 24),
                label: Text('Add Branch'),
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then(delay: 200.ms)
              .shake(hz: 3, curve: Curves.easeInOut),
    );
  }

  Widget _buildBody() {
    final displayBranchTypes = _isSearching
        ? _filteredBranchTypes
        : _branchTypes;

    if (_isLoading && _branchTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
                  'Loading branches...',
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
                  Iconsax.close_circle,
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
                onPressed: _initializeScreen,
                icon: Icon(Iconsax.refresh, size: 20),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
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

    if (_branchTypes.isEmpty) {
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
                        colors: [
                          _primaryColor.withOpacity(0.1),
                          _primaryColor.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.building,
                      size: 60,
                      color: _primaryColor,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(delay: 1000.ms, duration: 2000.ms)
                  .then(),
              SizedBox(height: 24),
              Text(
                'No Branches Found',
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
                  'Get started by adding your first branch to the system',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BranchTypeFormScreen(onSaved: _loadBranchTypes),
                    ),
                  );

                  if (result == true) {
                    await _loadBranchTypes();
                  }
                },
                icon: Icon(Iconsax.add, size: 20),
                label: Text('Add First Branch'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
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
        _filteredBranchTypes.isEmpty &&
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
                  Iconsax.search_normal,
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
                'No branches found for "${_searchController.text}"',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
                child: Text('Clear Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBranchTypes,
      backgroundColor: Colors.white,
      color: _primaryColor,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayBranchTypes.length,
        itemBuilder: (context, index) {
          final branchType = displayBranchTypes[index];
          return _buildBranchTypeItem(branchType, index);
        },
      ),
    );
  }

  Widget _buildBranchTypeItem(BranchTypeEntity branchType, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child:
          Material(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                elevation: 1,
                shadowColor: Colors.blue.withOpacity(0.1),
                child: InkWell(
                  onTap: () => _showBranchTypeDetails(branchType),
                  onLongPress: () {
                    _deleteBranchType(branchType);
                  },
                  borderRadius: BorderRadius.circular(16),
                  splashColor: _primaryColor.withOpacity(0.1),
                  highlightColor: _primaryColor.withOpacity(0.05),
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
                            child: Icon(
                              _getBranchIcon(branchType.type),
                              color: Colors.white,
                              size: 24,
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
                                      branchType.companyName,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(
                                        branchType.type,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _getTypeColor(branchType.type),
                                      ),
                                    ),
                                    child: Text(
                                      branchType.type,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _getTypeColor(branchType.type),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.profile_circle,
                                    size: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      branchType.contactPerson,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.call,
                                    size: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${branchType.contactNo} • ${branchType.city}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (branchType.createdAt != null) ...[
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.calendar,
                                      size: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Created: ${_formatDate(branchType.createdAt!)}',
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
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Iconsax.more,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onPressed: () => _showBranchTypeDetails(branchType),
                          tooltip: 'View Details',
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

  IconData _getBranchIcon(String type) {
    final typeLower = type.toLowerCase();
    if (typeLower.contains('head')) return Iconsax.crown;
    if (typeLower.contains('regional')) return Iconsax.global;
    if (typeLower.contains('sub')) return Iconsax.building_3;
    return Iconsax.building;
  }

  Color _getTypeColor(String type) {
    final typeLower = type.toLowerCase();
    if (typeLower.contains('head')) return Colors.amber.shade700;
    if (typeLower.contains('regional')) return Colors.purple.shade600;
    if (typeLower.contains('sub')) return Colors.blue.shade600;
    return Colors.green.shade600;
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

class BranchTypeFormScreen extends StatefulWidget {
  final BranchTypeEntity? branchType;
  final Function()? onSaved;

  const BranchTypeFormScreen({Key? key, this.branchType, this.onSaved})
    : super(key: key);

  @override
  _BranchTypeFormScreenState createState() => _BranchTypeFormScreenState();
}

class _BranchTypeFormScreenState extends State<BranchTypeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditing = false;

  // Controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // Dropdown options
  List<String> _typeOptions = [
    'Head Office',
    'Branch',
    'Sub Branch',
    'Regional Office',
  ];
  List<String> _designationOptions = [
    'Manager',
    'Director',
    'CEO',
    'Supervisor',
    'Owner',
  ];
  List<String> _countryOptions = ['India', 'USA', 'UK', 'Canada', 'Australia'];
  List<String> _stateOptions = [
    'Maharashtra',
    'Delhi',
    'Karnataka',
    'Tamil Nadu',
    'Gujarat',
  ];
  List<String> _cityOptions = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Ahmedabad',
  ];

  final Color _primaryColor = Color(0xff016B61);

  @override
  void initState() {
    super.initState();
    _isEditing = widget.branchType != null;

    if (_isEditing) {
      _populateForm();
    }
  }

  void _populateForm() {
    final branchType = widget.branchType!;
    _companyNameController.text = branchType.companyName;
    _contactPersonController.text = branchType.contactPerson;
    _contactNoController.text = branchType.contactNo;
    _emailController.text = branchType.email;
    _address1Controller.text = branchType.address1;
    _locationController.text = branchType.location;
    _typeController.text = branchType.type;
    _designationController.text = branchType.designation;
    _mobileNoController.text = branchType.mobileNo;
    _address2Controller.text = branchType.address2;
    _countryController.text = branchType.country;
    _stateController.text = branchType.state;
    _cityController.text = branchType.city;
  }

  Future<void> _saveBranchType() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final repository = await DatabaseProvider.branchTypeRepository;
      final branchType = BranchTypeEntity(
        id: widget.branchType?.id,
        serverId: widget.branchType?.serverId,
        companyName: _companyNameController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        contactNo: _contactNoController.text.trim(),
        email: _emailController.text.trim(),
        address1: _address1Controller.text.trim(),
        location: _locationController.text.trim(),
        type: _typeController.text.trim(),
        designation: _designationController.text.trim(),
        mobileNo: _mobileNoController.text.trim(),
        address2: _address2Controller.text.trim(),
        country: _countryController.text.trim(),
        state: _stateController.text.trim(),
        city: _cityController.text.trim(),
        createdAt:
            widget.branchType?.createdAt ?? DateTime.now().toIso8601String(),
        createdBy: widget.branchType?.createdBy ?? 'User',
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'User',
      );

      if (_isEditing) {
        await repository.updateBranchType(branchType);
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${branchType.companyName} updated successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        await repository.insertBranchType(branchType);
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('${branchType.companyName} added successfully'),
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
    } catch (e) {
      print('Error saving branch type: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Failed to save: $e'),
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

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          labelStyle: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          hintText: 'Enter $label',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
    required String? Function(String?)? validator,
    bool isRequired = true,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          labelStyle: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          prefixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.grey.shade800)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            controller.text = newValue ?? '';
          });
        },
        validator: validator,
        dropdownColor: Colors.white,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        icon: Icon(Iconsax.arrow_down_1, color: _primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Branch' : 'Add New Branch',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Iconsax.save_2),
            onPressed: _saveBranchType,
            tooltip: 'Save',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Saving branch...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.building, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Company Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildTextFormField(
                              label: 'Company Name',
                              controller: _companyNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter company name';
                                }
                                return null;
                              },
                              icon: Iconsax.building,
                            ),
                            _buildDropdownFormField(
                              label: 'Type',
                              controller: _typeController,
                              options: _typeOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select type';
                                }
                                return null;
                              },
                              icon: Iconsax.category,
                            ),
                            _buildTextFormField(
                              label: 'Location',
                              controller: _locationController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter location';
                                }
                                return null;
                              },
                              icon: Iconsax.location,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.profile_circle,
                                  color: _primaryColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Contact Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildTextFormField(
                              label: 'Contact Person',
                              controller: _contactPersonController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter contact person name';
                                }
                                return null;
                              },
                              icon: Iconsax.user,
                            ),
                            _buildDropdownFormField(
                              label: 'Designation',
                              controller: _designationController,
                              options: _designationOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select designation';
                                }
                                return null;
                              },
                              icon: Iconsax.briefcase,
                            ),
                            _buildTextFormField(
                              label: 'Contact No',
                              controller: _contactNoController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter contact number';
                                }
                                if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              icon: Iconsax.call,
                            ),
                            _buildTextFormField(
                              label: 'Mobile No',
                              controller: _mobileNoController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter mobile number';
                                }
                                if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value)) {
                                  return 'Please enter a valid mobile number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              icon: Iconsax.mobile,
                            ),
                            _buildTextFormField(
                              label: 'Email',
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email address';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              icon: Iconsax.sms,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.location_add,
                                  color: _primaryColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Address Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            _buildTextFormField(
                              label: 'Address 1',
                              controller: _address1Controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter address';
                                }
                                return null;
                              },
                              maxLines: 2,
                              icon: Iconsax.home,
                            ),
                            _buildTextFormField(
                              label: 'Address 2',
                              controller: _address2Controller,
                              validator: null,
                              isRequired: false,
                              maxLines: 2,
                              icon: Iconsax.home_2,
                            ),
                            _buildDropdownFormField(
                              label: 'Country',
                              controller: _countryController,
                              options: _countryOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select country';
                                }
                                return null;
                              },
                              icon: Iconsax.global,
                            ),
                            _buildDropdownFormField(
                              label: 'State',
                              controller: _stateController,
                              options: _stateOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select state';
                                }
                                return null;
                              },
                              icon: Iconsax.map,
                            ),
                            _buildDropdownFormField(
                              label: 'City',
                              controller: _cityController,
                              options: _cityOptions,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select city';
                                }
                                return null;
                              },
                              icon: Iconsax.buildings,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveBranchType,
                      icon: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Iconsax.save_2, size: 20),
                      label: Text(_isEditing ? 'Update Branch' : 'Save Branch'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                    SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Iconsax.close_circle, size: 20),
                      label: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _contactNoController.dispose();
    _emailController.dispose();
    _address1Controller.dispose();
    _locationController.dispose();
    _typeController.dispose();
    _designationController.dispose();
    _mobileNoController.dispose();
    _address2Controller.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
