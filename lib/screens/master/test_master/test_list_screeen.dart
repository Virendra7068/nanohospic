// // lib/ui/screens/test_screen.dart
// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';
// import 'package:nanohospic/database/database_provider.dart';
// import 'package:nanohospic/database/repository/test_repo.dart';
// import 'package:nanohospic/model/test_model.dart';
// import 'package:nanohospic/database/repository/group_repo.dart';
// import 'package:nanohospic/database/repository/hsn_repo.dart';

// class TestListScreen extends StatefulWidget {
//   const TestListScreen({super.key});

//   @override
//   State<TestListScreen> createState() => _TestListScreenState();
// }

// class _TestListScreenState extends State<TestListScreen> {
//   late TestRepository _repository;
//   List<TestModel> _tests = [];
//   bool _isLoading = true;
//   TextEditingController _searchController = TextEditingController();
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     print('🔄 Initializing TestListScreen...');
//     try {
//       // Initialize database first
//       final db = await DatabaseProvider.database;
//       print('✅ Database initialized');

//       // Check if test table exists
//       await DatabaseProvider.ensureTestTableExists();
//       print('✅ Test table verified');

//       // Create repository
//       _repository = TestRepository();

//       // Load tests
//       await _loadTests();

//       print('✅ TestListScreen initialized successfully');
//     } catch (e, stackTrace) {
//       print('❌ Initialization error: $e');
//       print('Stack trace: $stackTrace');
//       setState(() {
//         _errorMessage = 'Initialization error: ${e.toString()}';
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _loadTests() async {
//     print('📥 Loading tests...');
//     setState(() => _isLoading = true);
//     try {
//       final tests = await _repository.getAllTests();
//       setState(() {
//         _tests = tests;
//         _isLoading = false;
//         _errorMessage = '';
//       });
//       print('✅ Loaded ${tests.length} tests');
//     } catch (e, stackTrace) {
//       print('❌ Error loading tests: $e');
//       print('Stack trace: $stackTrace');
//       setState(() {
//         _errorMessage = 'Error loading tests: ${e.toString()}';
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading tests'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _searchTests(String query) async {
//     if (query.isEmpty) {
//       await _loadTests();
//       return;
//     }

//     try {
//       final results = await _repository.searchTests(query);
//       setState(() {
//         _tests = results;
//       });
//     } catch (e) {
//       print('❌ Error searching tests: $e');
//     }
//   }

//   Future<void> _deleteTest(String code, String name) async {
//     try {
//       await _repository.deleteTest(code, 'user');
//       await _loadTests();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Test deleted successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print('❌ Error deleting test: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Error deleting test'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _confirmDelete(String code, String name) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Test'),
//         content: Text('Are you sure you want to delete "$name"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deleteTest(code, name);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tests'),
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTests),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddTestScreen()),
//           );
//           if (result == true) {
//             await _loadTests();
//           }
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading tests...'),
//                 ],
//               ),
//             )
//           : _errorMessage.isNotEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _errorMessage,
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _initialize,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search by name or code...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onChanged: _searchTests,
//                   ),
//                 ),
//                 Expanded(
//                   child: _tests.isEmpty
//                       ? const Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.inventory,
//                                 size: 64,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 'No tests found',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Add your first test by tapping the + button',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           itemCount: _tests.length,
//                           itemBuilder: (context, index) {
//                             final test = _tests[index];
//                             return Card(
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 4,
//                               ),
//                               child: ListTile(
//                                 leading: CircleAvatar(
//                                   backgroundColor: Colors.blue,
//                                   child: Text(
//                                     test.name.substring(0, 1).toUpperCase(),
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   test.name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Code: ${test.code}'),
//                                     Text('Group: ${test.group}'),
//                                     Text(
//                                       'MRP: ₹${test.mrp.toStringAsFixed(2)}',
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(
//                                         Icons.edit,
//                                         color: Colors.blue,
//                                       ),
//                                       onPressed: () async {
//                                         final result = await Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 AddTestScreen(test: test),
//                                           ),
//                                         );
//                                         if (result == true) {
//                                           await _loadTests();
//                                         }
//                                       },
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(
//                                         Icons.delete,
//                                         color: Colors.red,
//                                       ),
//                                       onPressed: () =>
//                                           _confirmDelete(test.code, test.name),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => AlertDialog(
//                                       title: const Text('Test Details'),
//                                       content: SingleChildScrollView(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             _buildDetailRow('Code', test.code),
//                                             _buildDetailRow('Name', test.name),
//                                             _buildDetailRow(
//                                               'Group',
//                                               test.group,
//                                             ),
//                                             _buildDetailRow(
//                                               'MRP',
//                                               '₹${test.mrp.toStringAsFixed(2)}',
//                                             ),
//                                             _buildDetailRow(
//                                               'Sales Rate A',
//                                               '₹${test.salesRateA.toStringAsFixed(2)}',
//                                             ),
//                                             _buildDetailRow(
//                                               'Sales Rate B',
//                                               '₹${test.salesRateB.toStringAsFixed(2)}',
//                                             ),
//                                             _buildDetailRow(
//                                               'HSN/SAC',
//                                               test.hsnSac ?? 'N/A',
//                                             ),
//                                             _buildDetailRow(
//                                               'GST',
//                                               '${test.gst}%',
//                                             ),
//                                             _buildDetailRow(
//                                               'Barcode',
//                                               test.barcode ?? 'N/A',
//                                             ),
//                                             _buildDetailRow(
//                                               'Min Value',
//                                               test.minValue.toString(),
//                                             ),
//                                             _buildDetailRow(
//                                               'Max Value',
//                                               test.maxValue.toString(),
//                                             ),
//                                             _buildDetailRow('Unit', test.unit),
//                                           ],
//                                         ),
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () =>
//                                               Navigator.pop(context),
//                                           child: const Text('Close'),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

// class AddTestScreen extends StatefulWidget {
//   final TestModel? test;

//   const AddTestScreen({Key? key, this.test}) : super(key: key);

//   @override
//   State<AddTestScreen> createState() => _AddTestScreenState();
// }

// class _AddTestScreenState extends State<AddTestScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TestRepository _testRepository;
//   GroupRepo? _groupRepository;
//   HsnRepository? _hsnRepository;

//   // Form controllers
//   final TextEditingController _codeController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mrpController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _salesRateAController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _salesRateBController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _gstController = TextEditingController(text: '0');
//   final TextEditingController _barcodeController = TextEditingController();
//   final TextEditingController _minValueController = TextEditingController(
//     text: '0',
//   );
//   final TextEditingController _maxValueController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _unitController = TextEditingController();

//   // Dropdown values
//   String? _selectedGroup;
//   String? _selectedHsnSac;
//   String? _selectedUnit;
//   int? _selectedGst;

//   // Lists for dropdowns
//   List<String> groupList = [];
//   List<String> hsnList = [];
//   List<String> unitList = ['PCS', 'KG', 'LTR', 'MTR', 'BOX', 'ML'];
//   List<int> gstOptions = [0, 5, 12, 18, 28];

//   bool _isLoading = true;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeRepositories();
//   }

//   Future<void> _initializeRepositories() async {
//     print('🔄 Initializing AddTestScreen...');
//     try {
//       // Initialize database
//       await DatabaseProvider.database;
//       await DatabaseProvider.ensureTestTableExists();

//       _testRepository = TestRepository();

//       // Try to load repositories, but don't fail if they don't exist
//       try {
//         _groupRepository = await DatabaseProvider.groupRepository;
//       } catch (e) {
//         print('⚠️ Group repository not available: $e');
//       }

//       try {
//         _hsnRepository = await DatabaseProvider.hsnRepository;
//       } catch (e) {
//         print('⚠️ HSN repository not available: $e');
//       }

//       await _loadData();
//       print('✅ AddTestScreen initialized successfully');
//     } catch (e, stackTrace) {
//       print('❌ Error initializing repositories: $e');
//       print('Stack trace: $stackTrace');
//       setState(() {
//         _errorMessage = 'Error: ${e.toString()}';
//         _isLoading = false;
//       });
//     }
//   }

//   // In your AddTestScreen's _loadData method, update it like this:
//   Future<void> _loadData() async {
//     try {
//       // Load groups with better error handling
//       await _loadGroups();

//       // Load HSN codes
//       await _loadHsnCodes();

//       // Pre-fill if editing existing test
//       if (widget.test != null) {
//         _prefillForm(widget.test!);
//       }

//       setState(() => _isLoading = false);
//     } catch (e) {
//       print('❌ Error loading data: $e');

//       // Provide default values on error
//       groupList = ['General', 'Medical', 'Laboratory', 'Pharmacy'];
//       hsnList = ['1234', '5678', '9101'];

//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _loadGroups() async {
//     try {
//       if (_groupRepository != null) {
//         print('📥 Loading groups...');
//         final groups = await _groupRepository!.getAllGroups();
//         groupList = groups
//             .map((g) => g.name)
//             .where((name) => name.isNotEmpty)
//             .toList();

//         if (groupList.isEmpty) {
//           groupList = ['General', 'Medical', 'Laboratory', 'Pharmacy'];
//         }

//         print('✅ Loaded ${groupList.length} groups');
//       } else {
//         print('⚠️ Group repository is null, using defaults');
//         groupList = ['General', 'Medical', 'Laboratory', 'Pharmacy'];
//       }
//     } catch (e) {
//       print('⚠️ Error loading groups: $e');
//       groupList = ['General', 'Medical', 'Laboratory', 'Pharmacy'];
//     }
//   }

//   Future<void> _loadHsnCodes() async {
//     try {
//       if (_hsnRepository != null) {
//         print('📥 Loading HSN codes...');
//         final hsnCodes = await _hsnRepository!.getAllHsnCodes();
//         hsnList = hsnCodes
//             .map((h) => h.hsnCode)
//             .where((code) => code.isNotEmpty)
//             .toList();

//         if (hsnList.isEmpty) {
//           hsnList = ['1234', '5678', '9101'];
//         }

//         print('✅ Loaded ${hsnList.length} HSN codes');
//       } else {
//         print('⚠️ HSN repository is null, using defaults');
//         hsnList = ['1234', '5678', '9101'];
//       }
//     } catch (e) {
//       print('⚠️ Error loading HSN codes: $e');
//       hsnList = ['1234', '5678', '9101'];
//     }
//   }

//   void _prefillForm(TestModel test) {
//     _codeController.text = test.code;
//     _nameController.text = test.name;
//     _selectedGroup = test.group;
//     _mrpController.text = test.mrp.toStringAsFixed(2);
//     _salesRateAController.text = test.salesRateA.toStringAsFixed(2);
//     _salesRateBController.text = test.salesRateB.toStringAsFixed(2);
//     _selectedHsnSac = test.hsnSac;
//     _gstController.text = test.gst.toString();
//     _selectedGst = test.gst;
//     _barcodeController.text = test.barcode ?? '';
//     _minValueController.text = test.minValue.toStringAsFixed(2);
//     _maxValueController.text = test.maxValue.toStringAsFixed(2);
//     _selectedUnit = test.unit;
//     _unitController.text = test.unit;
//   }

//   Future<void> _saveTest() async {
//     if (_formKey.currentState!.validate()) {
//       print('💾 Saving test...');
//       try {
//         final test = TestModel(
//           code: _codeController.text.trim(),
//           name: _nameController.text.trim(),
//           group: _selectedGroup ?? '',
//           mrp: double.tryParse(_mrpController.text) ?? 0.0,
//           salesRateA: double.tryParse(_salesRateAController.text) ?? 0.0,
//           salesRateB: double.tryParse(_salesRateBController.text) ?? 0.0,
//           hsnSac: _selectedHsnSac,
//           gst: int.tryParse(_gstController.text) ?? 0,
//           barcode: _barcodeController.text.trim().isEmpty
//               ? null
//               : _barcodeController.text.trim(),
//           minValue: double.tryParse(_minValueController.text) ?? 0.0,
//           maxValue: double.tryParse(_maxValueController.text) ?? 0.0,
//           unit: _selectedUnit ?? _unitController.text.trim(),
//         );

//         if (widget.test == null) {
//           await _testRepository.saveTest(test);
//         } else {
//           await _testRepository.updateTest(test);
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               widget.test == null
//                   ? 'Test saved successfully!'
//                   : 'Test updated successfully!',
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );

//         Navigator.pop(context, true);
//       } catch (e, stackTrace) {
//         print('❌ Error saving test: $e');
//         print('Stack trace: $stackTrace');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error saving test: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.test == null ? 'Add Test' : 'Edit Test'),
//         actions: [
//           IconButton(icon: const Icon(Icons.save), onPressed: _saveTest),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading form...'),
//                 ],
//               ),
//             )
//           : _errorMessage.isNotEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _errorMessage,
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _initializeRepositories,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     _buildTextField(
//                       'Code *',
//                       _codeController,
//                       isRequired: true,
//                     ),
//                     _buildTextField(
//                       'Name *',
//                       _nameController,
//                       isRequired: true,
//                     ),

//                     // Group Dropdown
//                     if (groupList.isNotEmpty)
//                       _buildDropdownField(
//                         label: 'Group *',
//                         value: _selectedGroup,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedGroup = value;
//                           });
//                         },
//                         items: groupList,
//                       )
//                     else
//                       _buildTextField(
//                         'Group *',
//                         TextEditingController(text: _selectedGroup),
//                         isRequired: true,
//                       ),

//                     _buildNumberField(
//                       'Mrp *',
//                       _mrpController,
//                       isRequired: true,
//                     ),
//                     _buildNumberField(
//                       'Sales Rate A *',
//                       _salesRateAController,
//                       isRequired: true,
//                     ),
//                     _buildNumberField(
//                       'Sales Rate B *',
//                       _salesRateBController,
//                       isRequired: true,
//                     ),

//                     // HSN/SAC Dropdown
//                     if (hsnList.isNotEmpty)
//                       _buildDropdownField(
//                         label: 'HSN/SAC',
//                         value: _selectedHsnSac,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedHsnSac = value;
//                           });
//                         },
//                         items: hsnList,
//                         isRequired: false,
//                       ),

//                     // GST Dropdown
//                     DropdownButtonFormField<int>(
//                       value: _selectedGst,
//                       decoration: const InputDecoration(
//                         labelText: 'GST *',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.percent),
//                       ),
//                       items: gstOptions.map((gst) {
//                         return DropdownMenuItem<int>(
//                           value: gst,
//                           child: Text('$gst%'),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedGst = value;
//                           if (value != null) {
//                             _gstController.text = value.toString();
//                           }
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null) {
//                           return 'Please select GST';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 16),
//                     _buildTextField('Barcode', _barcodeController),
//                     _buildNumberField('Min Value', _minValueController),
//                     _buildNumberField('Max Value', _maxValueController),

//                     // Unit Field with dropdown and custom input
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Unit *',
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 value: _selectedUnit,
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 16,
//                                   ),
//                                 ),
//                                 items: [
//                                   const DropdownMenuItem<String>(
//                                     value: null,
//                                     child: Text(
//                                       'Select Unit',
//                                       style: TextStyle(color: Colors.grey),
//                                     ),
//                                   ),
//                                   ...unitList.map((unit) {
//                                     return DropdownMenuItem<String>(
//                                       value: unit,
//                                       child: Text(unit),
//                                     );
//                                   }).toList(),
//                                 ],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedUnit = value;
//                                     if (value != null) {
//                                       _unitController.text = value;
//                                     }
//                                   });
//                                 },
//                                 validator: (value) {
//                                   if (value == null &&
//                                       (_unitController.text.isEmpty ||
//                                           _unitController.text ==
//                                               'Select Unit')) {
//                                     return 'Please select or enter unit';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: TextFormField(
//                                 controller: _unitController,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Or enter custom',
//                                   border: OutlineInputBorder(),
//                                 ),
//                                 onChanged: (value) {
//                                   if (value.isNotEmpty) {
//                                     setState(() {
//                                       _selectedUnit = null;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: _saveTest,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: Text(
//                         widget.test == null ? 'Save Test' : 'Update Test',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller, {
//     bool isRequired = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         validator: (value) {
//           if (isRequired && (value == null || value.isEmpty)) {
//             return 'This field is required';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildNumberField(
//     String label,
//     TextEditingController controller, {
//     bool isRequired = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: const InputDecoration(
//           labelText: 'label',
//           border: OutlineInputBorder(),
//           prefixIcon: Icon(Icons.attach_money),
//         ),
//         keyboardType: TextInputType.numberWithOptions(decimal: true),
//         validator: (value) {
//           if (isRequired && (value == null || value.isEmpty)) {
//             return 'This field is required';
//           }
//           if (value != null && value.isNotEmpty) {
//             try {
//               double.parse(value);
//             } catch (e) {
//               return 'Please enter a valid number';
//             }
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildDropdownField({
//     required String label,
//     required String? value,
//     required Function(String?) onChanged,
//     required List<String> items,
//     bool isRequired = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         items: [
//           if (isRequired)
//             DropdownMenuItem<String>(
//               value: null,
//               child: Text(
//                 'Select $label',
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ),
//           ...items.map((item) {
//             return DropdownMenuItem<String>(value: item, child: Text(item));
//           }).toList(),
//         ],
//         onChanged: onChanged,
//         validator: isRequired
//             ? (value) {
//                 if (value == null) {
//                   return 'Please select $label';
//                 }
//                 return null;
//               }
//             : null,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _codeController.dispose();
//     _nameController.dispose();
//     _mrpController.dispose();
//     _salesRateAController.dispose();
//     _salesRateBController.dispose();
//     _gstController.dispose();
//     _barcodeController.dispose();
//     _minValueController.dispose();
//     _maxValueController.dispose();
//     _unitController.dispose();
//     super.dispose();
//   }
// }

// lib/ui/screens/test_screen.dart
// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/repository/test_repo.dart';
import 'package:nanohospic/model/test_model.dart';
import 'package:nanohospic/database/repository/group_repo.dart';
import 'package:nanohospic/database/repository/hsn_repo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TestListScreen extends StatefulWidget {
  const TestListScreen({super.key});

  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  List<TestModel> _tests = [];
  List<TestModel> _filteredTests = [];
  bool _isLoading = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late TestRepository _testRepository;
  Timer? _syncTimer;
  int _totalRecords = 0;
  int _syncedRecords = 0;
  int _pendingRecords = 0;

  final Color _primaryColor = Color(0xff016B61);
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _searchController.addListener(() {
      _filterTests(_searchController.text);
    });

    _syncTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _syncDataSilently();
    });
  }

  Future<void> _initializeDatabase() async {
    try {
      // await DatabaseProvider.ensureTestTableExists();
      await DatabaseProvider.database;
      _testRepository = TestRepository();
      await _loadLocalTests();
      await _loadSyncStats();
    } catch (e) {
      print('Error initializing database: $e');
      setState(() {
        _error = 'Failed to initialize database: $e';
      });
    }
  }

  Future<void> _loadLocalTests() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final tests = await _testRepository.getAllTests();
      print('Loaded ${tests.length} tests from database');
      setState(() {
        _tests = tests;
        _filteredTests = List.from(_tests);
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
    _totalRecords = await _testRepository.getTestCount();
    // For now, set synced and pending records based on total
    _syncedRecords = _totalRecords;
    _pendingRecords = 0;
    setState(() {});
  }

  Future<void> _syncDataSilently() async {
    try {
      // Implement silent sync logic here
      print('Silent sync running...');
    } catch (e) {
      print('Silent sync failed: $e');
    }
  }

  void _filterTests(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTests = List.from(_tests);
      } else {
        _filteredTests = _tests
            .where(
              (test) =>
                  test.name.toLowerCase().contains(query.toLowerCase()) ||
                  test.code.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Future<void> _deleteTest(String code, String name) async {
    try {
      await _testRepository.deleteTest(code, 'user');
      await _loadLocalTests();
      await _loadSyncStats();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Test deleted successfully!'),
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
      print('❌ Error deleting test: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Failed to delete test'),
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

  void _showDeleteConfirmationDialog(TestModel test) {
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
                  'Delete Test?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${test.name}"?',
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
                          await _deleteTest(test.code, test.name);
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
                        'Total Tests',
                        '$_totalRecords',
                        Icons.inventory,
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
              shadowColor: Colors.blue.withOpacity(0.4),
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
                          'Test Management',
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
                          'Manage all medical tests in one place',
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
                        hintText: 'Search tests...',
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
                              _filteredTests = List.from(_tests);
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
                  icon: Icon(Icons.refresh, color: Colors.white, size: 22),
                  onPressed: _loadLocalTests,
                  tooltip: 'Refresh',
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
        body: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTestScreen()),
          );
          if (result == true) {
            await _loadLocalTests();
          }
        },
        backgroundColor: Color(0xff016B61),
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildBody() {
    final displayTests = _isSearching ? _filteredTests : _tests;

    if (_isLoading && _tests.isEmpty) {
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
              'Loading tests...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
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
              ),
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
                onPressed: _loadLocalTests,
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

    if (_tests.isEmpty) {
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
                  Iconsax.health,
                  size: 60,
                  color: Colors.blue.shade600,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'No Tests Found',
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
                  'Get started by adding your first medical test to the system',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTestScreen()),
                  );
                  if (result == true) {
                    await _loadLocalTests();
                  }
                },
                icon: Icon(Icons.add, size: 20),
                label: Text('Add New Test'),
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
        _filteredTests.isEmpty &&
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
                'No tests found for "${_searchController.text}"',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLocalTests,
      backgroundColor: Colors.white,
      color: Colors.blue,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        itemCount: displayTests.length,
        itemBuilder: (context, index) {
          final test = displayTests[index];
          return _buildTestItem(test, index);
        },
      ),
    );
  }

  Widget _buildTestItem(TestModel test, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: Colors.blue.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            _showTestDetailsDialog(test);
          },
          onLongPress: () {
            _showDeleteConfirmationDialog(test);
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
                        color: _getColorFromIndex(index).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(Iconsax.health, color: Colors.white, size: 24),
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
                              test.name,
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
                              color: _getStatusColor(
                                test.group,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getStatusColor(
                                  test.group,
                                ).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              test.group,
                              style: TextStyle(
                                fontSize: 11,
                                color: _getStatusColor(test.group),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.code,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Code: ${test.code}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'MRP: ₹${test.mrp.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Iconsax.dollar_circle,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Unit: ${test.unit}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
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
                    _showDeleteConfirmationDialog(test);
                  },
                  tooltip: 'Delete Test',
                ),
              ],
            ),
          ),
        ),
      ),
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

  Color _getStatusColor(String group) {
    switch (group.toLowerCase()) {
      case 'lab':
        return Colors.blue;
      case 'medical':
        return Colors.green;
      case 'surgical':
        return Colors.red;
      case 'pharmacy':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  void _showTestDetailsDialog(TestModel test) {
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
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Test Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 20),
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
                      _buildDetailRow('Name', test.name),
                      _buildDetailRow('Code', test.code),
                      _buildDetailRow('Group', test.group),
                      _buildDetailRow('MRP', '₹${test.mrp.toStringAsFixed(2)}'),
                      _buildDetailRow(
                        'Sales Rate A',
                        '₹${test.salesRateA.toStringAsFixed(2)}',
                      ),
                      _buildDetailRow(
                        'Sales Rate B',
                        '₹${test.salesRateB.toStringAsFixed(2)}',
                      ),
                      _buildDetailRow('HSN/SAC', test.hsnSac ?? 'N/A'),
                      _buildDetailRow('GST', '${test.gst}%'),
                      _buildDetailRow('Barcode', test.barcode ?? 'N/A'),
                      _buildDetailRow(
                        'Min Value',
                        test.minValue.toStringAsFixed(2),
                      ),
                      _buildDetailRow(
                        'Max Value',
                        test.maxValue.toStringAsFixed(2),
                      ),
                      _buildDetailRow('Unit', test.unit),
                    ],
                  ),
                ),
                SizedBox(height: 24),
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
                        onPressed: () async {
                          Navigator.pop(context);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTestScreen(test: test),
                            ),
                          );
                          if (result == true) {
                            await _loadLocalTests();
                          }
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTestScreen extends StatefulWidget {
  final TestModel? test;

  const AddTestScreen({Key? key, this.test}) : super(key: key);

  @override
  State<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final _formKey = GlobalKey<FormState>();
  late TestRepository _testRepository;
  late GroupRepository _groupRepository;
  late HsnRepository _hsnRepository;

  // Form controllers
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _salesRateAController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _salesRateBController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _gstController = TextEditingController(text: '0');
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _minValueController = TextEditingController(
    text: '0',
  );
  final TextEditingController _maxValueController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _unitController = TextEditingController();

  // Dropdown values
  String? _selectedGroup;
  String? _selectedHsnSac;
  String? _selectedUnit;
  int? _selectedGst;

  // Lists for dropdowns
  List<String> groupList = [];
  List<String> hsnList = [];
  List<String> unitList = ['PCS', 'KG', 'LTR', 'MTR', 'BOX', 'ML'];
  List<int> gstOptions = [0, 5, 12, 18, 28];

  bool _isLoading = true;
  String _errorMessage = '';

  final Color _primaryColor = Color(0xff016B61);

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
  }

  Future<void> _initializeRepositories() async {
    print('🔄 Initializing AddTestScreen...');
    try {
      await DatabaseProvider.database;
      // await DatabaseProvider.ensureTestTableExists();

      _testRepository = TestRepository();
      _groupRepository = await DatabaseProvider.groupRepository;
      _hsnRepository = await DatabaseProvider.hsnRepository;

      await _loadData();
      print('✅ AddTestScreen initialized successfully');
    } catch (e, stackTrace) {
      print('❌ Error initializing repositories: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      // Load groups
      await _loadGroups();

      // Load HSN codes
      await _loadHsnCodes();

      // Pre-fill if editing existing test
      if (widget.test != null) {
        _prefillForm(widget.test!);
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('❌ Error loading data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadGroups() async {
    try {
      print('📥 Loading groups...');
      final groups = await _groupRepository.getAllGroups();
      groupList = groups
          .map((g) => g.name)
          .where((name) => name.isNotEmpty)
          .toList();
      if (groupList.isEmpty) {
        groupList = ['Lab', 'Medical', 'Surgical', 'Pharmacy', 'General'];
      }
      print('✅ Loaded ${groupList.length} groups');
    } catch (e) {
      print('⚠️ Error loading groups: $e');
      groupList = ['Lab', 'Medical', 'Surgical', 'Pharmacy', 'General'];
    }
  }

  Future<void> _loadHsnCodes() async {
    try {
      print('📥 Loading HSN codes...');
      final hsnCodes = await _hsnRepository.getAllHsnCodes();
      hsnList = hsnCodes
          .map((h) => h.hsnCode)
          .where((code) => code.isNotEmpty)
          .toList();
      if (hsnList.isEmpty) {
        hsnList = ['1234', '5678', '9101', '1121'];
      }
      print('✅ Loaded ${hsnList.length} HSN codes');
    } catch (e) {
      print('⚠️ Error loading HSN codes: $e');
      hsnList = ['1234', '5678', '9101', '1121'];
    }
  }

  void _prefillForm(TestModel test) {
    _codeController.text = test.code;
    _nameController.text = test.name;
    _selectedGroup = test.group;
    _mrpController.text = test.mrp.toStringAsFixed(2);
    _salesRateAController.text = test.salesRateA.toStringAsFixed(2);
    _salesRateBController.text = test.salesRateB.toStringAsFixed(2);
    _selectedHsnSac = test.hsnSac;
    _gstController.text = test.gst.toString();
    _selectedGst = test.gst;
    _barcodeController.text = test.barcode ?? '';
    _minValueController.text = test.minValue.toStringAsFixed(2);
    _maxValueController.text = test.maxValue.toStringAsFixed(2);
    _selectedUnit = test.unit;
    _unitController.text = test.unit;
  }

  Future<void> _saveTest() async {
    if (_formKey.currentState!.validate()) {
      print('💾 Saving test...');
      try {
        final test = TestModel(
          code: _codeController.text.trim(),
          name: _nameController.text.trim(),
          group: _selectedGroup ?? '',
          mrp: double.tryParse(_mrpController.text) ?? 0.0,
          salesRateA: double.tryParse(_salesRateAController.text) ?? 0.0,
          salesRateB: double.tryParse(_salesRateBController.text) ?? 0.0,
          hsnSac: _selectedHsnSac,
          gst: int.tryParse(_gstController.text) ?? 0,
          barcode: _barcodeController.text.trim().isEmpty
              ? null
              : _barcodeController.text.trim(),
          minValue: double.tryParse(_minValueController.text) ?? 0.0,
          maxValue: double.tryParse(_maxValueController.text) ?? 0.0,
          unit: _selectedUnit ?? _unitController.text.trim(),
        );

        if (widget.test == null) {
          await _testRepository.saveTest(test);
        } else {
          await _testRepository.updateTest(test);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  widget.test == null
                      ? 'Test saved successfully!'
                      : 'Test updated successfully!',
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

        Navigator.pop(context, true);
      } catch (e, stackTrace) {
        print('❌ Error saving test: $e');
        print('Stack trace: $stackTrace');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Error saving test: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(widget.test == null ? 'Add New Test' : 'Edit Test'),
        centerTitle: true,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(Icons.save, size: 24),
              onPressed: _saveTest,
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
                    'Loading form...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
          ? Center(
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
                  ),
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
                      _errorMessage,
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _initializeRepositories,
                    icon: Icon(Icons.refresh, size: 20),
                    label: Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basic Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildTextFieldWithIcon(
                            Icons.code,
                            'Code *',
                            _codeController,
                            isRequired: true,
                          ),
                          SizedBox(height: 12),
                          _buildTextFieldWithIcon(
                            Icons.label,
                            'Name *',
                            _nameController,
                            isRequired: true,
                          ),
                          SizedBox(height: 12),
                          _buildDropdownFieldWithIcon(
                            Icons.category,
                            'Group *',
                            value: _selectedGroup,
                            onChanged: (value) {
                              setState(() {
                                _selectedGroup = value;
                              });
                            },
                            items: groupList,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Card for pricing information
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pricing Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildNumberFieldWithIcon(
                            Icons.currency_rupee,
                            'MRP *',
                            _mrpController,
                            isRequired: true,
                          ),
                          SizedBox(height: 12),
                          _buildNumberFieldWithIcon(
                            Icons.attach_money,
                            'Sales Rate A *',
                            _salesRateAController,
                            isRequired: true,
                          ),
                          SizedBox(height: 12),
                          _buildNumberFieldWithIcon(
                            Icons.attach_money,
                            'Sales Rate B *',
                            _salesRateBController,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Card for tax information
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tax Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildDropdownFieldWithIcon(
                            Icons.receipt,
                            'HSN/SAC',
                            value: _selectedHsnSac,
                            onChanged: (value) {
                              setState(() {
                                _selectedHsnSac = value;
                              });
                            },
                            items: hsnList,
                            isRequired: false,
                          ),
                          SizedBox(height: 12),
                          _buildGSTDropdownField(),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Card for additional information
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildTextFieldWithIcon(
                            Icons.qr_code,
                            'Barcode',
                            _barcodeController,
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildNumberFieldWithIcon(
                                  Icons.line_weight,
                                  'Min Value',
                                  _minValueController,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildNumberFieldWithIcon(
                                  Icons.line_weight,
                                  'Max Value',
                                  _maxValueController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          _buildUnitField(),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Save button
                    ElevatedButton(
                      onPressed: _saveTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, size: 22),
                          SizedBox(width: 12),
                          Text(
                            widget.test == null ? 'Save Test' : 'Update Test',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFieldWithIcon(
    IconData icon,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 8, left: 12),
          child: Icon(icon, color: Colors.blue.shade600),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildNumberFieldWithIcon(
    IconData icon,
    String label,
    TextEditingController controller, {
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 8, left: 12),
          child: Icon(icon, color: Colors.blue.shade600),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixText: label.contains('MRP') || label.contains('Rate')
            ? '₹'
            : null,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        if (value != null && value.isNotEmpty) {
          try {
            double.parse(value);
          } catch (e) {
            return 'Please enter a valid number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildDropdownFieldWithIcon(
    IconData icon,
    String label, {
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
    bool isRequired = true,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 8, left: 12),
          child: Icon(icon, color: Colors.blue.shade600),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: [
        if (isRequired)
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'Select $label',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(color: Colors.grey.shade800)),
          );
        }).toList(),
      ],
      onChanged: onChanged,
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      validator: isRequired
          ? (value) {
              if (value == null) {
                return 'Please select $label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildGSTDropdownField() {
    return DropdownButtonFormField<int>(
      value: _selectedGst,
      decoration: InputDecoration(
        labelText: 'GST *',
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 8, left: 12),
          child: Icon(Icons.percent, color: Colors.blue.shade600),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: gstOptions.map((gst) {
        return DropdownMenuItem<int>(
          value: gst,
          child: Text('$gst%', style: TextStyle(color: Colors.grey.shade800)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGst = value;
          if (value != null) {
            _gstController.text = value.toString();
          }
        });
      },
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      validator: (value) {
        if (value == null) {
          return 'Please select GST';
        }
        return null;
      },
    );
  }

  Widget _buildUnitField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedUnit,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: EdgeInsets.only(right: 8, left: 12),
                    child: Icon(Icons.settings, color: Colors.blue.shade600),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 40),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Select Unit',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      'Select Unit',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                  ...unitList.map((unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(
                        unit,
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                    if (value != null) {
                      _unitController.text = value;
                    }
                  });
                },
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _unitController,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: EdgeInsets.only(right: 8, left: 12),
                    child: Icon(Icons.edit, color: Colors.blue.shade600),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 40),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Or enter custom',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _selectedUnit = null;
                    });
                  }
                },
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _mrpController.dispose();
    _salesRateAController.dispose();
    _salesRateBController.dispose();
    _gstController.dispose();
    _barcodeController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}
