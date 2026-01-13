// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nanohospic/database/entity/sales/test_booking_entity.dart';
// import 'package:nanohospic/database/database_provider.dart';
// import 'package:nanohospic/database/repository/test_booking/testbooking_repo.dart';

// class CreateTestBookingScreen extends StatefulWidget {
//   const CreateTestBookingScreen({super.key});

//   @override
//   _CreateTestBookingScreenState createState() =>
//       _CreateTestBookingScreenState();
// }

// class _CreateTestBookingScreenState extends State<CreateTestBookingScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TestBookingRepository _testBookingRepository;
//   bool _isLoading = true;
//   bool _isSaving = false;

//   // Form Controllers
//   final TextEditingController _registrationNoController =
//       TextEditingController();
//   final TextEditingController _mrdNoController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _phoneNoController = TextEditingController();
//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController(text: '0');
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _barcodeController = TextEditingController();
//   final TextEditingController _tokenNoController = TextEditingController();
//   final TextEditingController _totalController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _billDiscountController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _totalDiscountController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _gstController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _totalAmountController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _paidAmountController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _balanceController = TextEditingController(
//     text: '0.00',
//   );
//   final TextEditingController _returnAmountController = TextEditingController(
//     text: '0.00',
//   );

//   String? _selectedGender;
//   String? _selectedDoctorReferrer;
//   String? _selectedAssignTo;
//   String? _selectedClient;

//   // Test Items
//   List<TestItem> testItems = [
//     TestItem(
//       type: 'Test',
//       name: '',
//       mrp: 0.0,
//       rate: 0.0,
//       quantity: 1,
//       gstPercent: 0.0,
//       discountPercent: 0.0,
//       amount: 0.0,
//     ),
//   ];

//   // Payment Details
//   List<PaymentDetailItem> paymentDetails = [
//     PaymentDetailItem(
//       paymentMode: 'CASH',
//       amount: 0.0,
//       referenceNo: '',
//       description: '',
//     ),
//   ];

//   // Dropdown options
//   final List<String> genderOptions = ['Male', 'Female', 'Other'];
//   final List<String> doctorReferrerOptions = [
//     'Dr. Smith',
//     'Dr. Johnson',
//     'Dr. Williams',
//     'Dr. Brown',
//   ];
//   final List<String> assignToOptions = [
//     'Lab 1',
//     'Lab 2',
//     'Lab 3',
//     'Phlebotomist 1',
//     'Phlebotomist 2',
//   ];
//   final List<String> clientOptions = [
//     'Client A',
//     'Client B',
//     'Client C',
//     'Direct',
//   ];
//   final List<String> paymentModes = [
//     'CASH',
//     'UPI',
//     'CREDIT CARD',
//     'DEBIT CARD',
//     'NET BANKING',
//     'CHEQUE',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     try {
//       print('🚀 Initializing Test Booking screen...');

//       // Initialize the database and get repository
//       await DatabaseProvider.initializeTestBookingScreen();
//       _testBookingRepository = await DatabaseProvider.testBookingRepository;

//       // Generate next registration and token numbers
//       final nextRegNo = await _testBookingRepository
//           .generateNextRegistrationNo();
//       final nextTokenNo = await _testBookingRepository.generateNextTokenNo();

//       setState(() {
//         _registrationNoController.text = nextRegNo;
//         _tokenNoController.text = nextTokenNo;
//         _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
//         _isLoading = false;
//       });

//       print('✅ Test Booking screen ready');
//     } catch (e) {
//       print('❌ Error initializing: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error initializing: $e')));
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _addTestItem() {
//     setState(() {
//       testItems.add(
//         TestItem(
//           type: 'Test',
//           name: '',
//           mrp: 0.0,
//           rate: 0.0,
//           quantity: 1,
//           gstPercent: 0.0,
//           discountPercent: 0.0,
//           amount: 0.0,
//         ),
//       );
//     });
//   }

//   void _removeTestItem(int index) {
//     if (testItems.length > 1) {
//       setState(() {
//         testItems.removeAt(index);
//         _calculateTotals();
//       });
//     }
//   }

//   void _addPaymentDetail() {
//     setState(() {
//       paymentDetails.add(
//         PaymentDetailItem(
//           paymentMode: 'CASH',
//           amount: 0.0,
//           referenceNo: '',
//           description: '',
//         ),
//       );
//     });
//   }

//   void _removePaymentDetail(int index) {
//     if (paymentDetails.length > 1) {
//       setState(() {
//         paymentDetails.removeAt(index);
//         _calculatePaymentTotal();
//       });
//     }
//   }

//   void _calculateTotals() {
//     double total = 0;
//     double totalDiscount = 0;

//     for (var item in testItems) {
//       double itemAmount = item.rate * item.quantity;
//       // Apply GST
//       itemAmount += itemAmount * (item.gstPercent / 100);
//       // Apply discount
//       itemAmount -= itemAmount * (item.discountPercent / 100);

//       // Update item amount
//       final index = testItems.indexOf(item);
//       testItems[index] = item.copyWith(
//         amount: double.parse(itemAmount.toStringAsFixed(2)),
//       );

//       total += itemAmount;
//       totalDiscount += (item.mrp - item.rate) * item.quantity;
//     }

//     setState(() {
//       _totalController.text = total.toStringAsFixed(2);
//       _totalDiscountController.text = totalDiscount.toStringAsFixed(2);
//       _totalAmountController.text = total.toStringAsFixed(2);
//       _calculatePaymentTotal(); // Recalculate payment totals
//     });
//   }

//   void _calculatePaymentTotal() {
//     double paid = 0;
//     for (var payment in paymentDetails) {
//       paid += payment.amount;
//     }

//     double totalAmount = double.tryParse(_totalAmountController.text) ?? 0;
//     double balance = totalAmount - paid;
//     double returnAmount = paid > totalAmount ? paid - totalAmount : 0;
//     double finalBalance = balance > 0 ? balance : 0;

//     setState(() {
//       _paidAmountController.text = paid.toStringAsFixed(2);
//       _balanceController.text = finalBalance.toStringAsFixed(2);
//       _returnAmountController.text = returnAmount.toStringAsFixed(2);
//     });
//   }

//   Future<void> _saveBooking() async {
//     if (_isSaving) return;

//     if (_formKey.currentState!.validate()) {
//       // Validate test items
//       for (var item in testItems) {
//         if (item.name.isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Please enter test/package name')),
//           );
//           return;
//         }
//         if (item.rate <= 0) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Please enter valid rate for all items'),
//             ),
//           );
//           return;
//         }
//       }

//       setState(() {
//         _isSaving = true;
//       });

//       try {
//         // Create BookingItems list
//         final bookingItems = testItems.map((item) {
//           return BookingItem(
//             bookingId: 0, // Will be updated after booking creation
//             type: item.type,
//             name: item.name,
//             mrp: item.mrp,
//             rate: item.rate,
//             quantity: item.quantity,
//             gstPercent: item.gstPercent,
//             discountPercent: item.discountPercent,
//             amount: item.amount,
//             createdAt: DateTime.now().toIso8601String(),
//             isDeleted: 0,
//             isSynced: 0,
//           );
//         }).toList();

//         // Create PaymentDetails list
//         final paymentDetailsList = paymentDetails
//             .where((payment) => payment.amount > 0)
//             .map((payment) {
//               return PaymentDetail(
//                 bookingId: 0, // Will be updated after booking creation
//                 paymentMode: payment.paymentMode,
//                 amount: payment.amount,
//                 referenceNo: payment.referenceNo.isNotEmpty
//                     ? payment.referenceNo
//                     : null,
//                 description: payment.description.isNotEmpty
//                     ? payment.description
//                     : null,
//                 paymentDate: DateTime.now(),
//                 createdAt: DateTime.now().toIso8601String(),
//                 isDeleted: 0,
//                 isSynced: 0,
//               );
//             })
//             .toList();

//         // Calculate totals
//         final total = double.tryParse(_totalController.text) ?? 0;
//         final totalAmount = double.tryParse(_totalAmountController.text) ?? 0;
//         final paidAmount = double.tryParse(_paidAmountController.text) ?? 0;
//         final balance = double.tryParse(_balanceController.text) ?? 0;
//         final returnAmount = double.tryParse(_returnAmountController.text) ?? 0;

//         // Create TestBooking
//         final testBooking = TestBooking(
//           registrationNo: _registrationNoController.text,
//           mrdNo: _mrdNoController.text.isNotEmpty
//               ? _mrdNoController.text
//               : null,
//           date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
//           phoneNo: _phoneNoController.text.isNotEmpty
//               ? _phoneNoController.text
//               : null,
//           patientName: _patientNameController.text,
//           gender: _selectedGender,
//           age: int.tryParse(_ageController.text) ?? 0,
//           email: _emailController.text,
//           address: _addressController.text.isNotEmpty
//               ? _addressController.text
//               : null,
//           doctorReferrer: _selectedDoctorReferrer,
//           barcode: _barcodeController.text.isNotEmpty
//               ? _barcodeController.text
//               : null,
//           tokenNo: _tokenNoController.text,
//           assignTo: _selectedAssignTo,
//           client: _selectedClient,
//           total: total,
//           billDiscount: double.tryParse(_billDiscountController.text) ?? 0,
//           totalDiscount: double.tryParse(_totalDiscountController.text) ?? 0,
//           gst: double.tryParse(_gstController.text) ?? 0,
//           totalAmount: totalAmount,
//           paidAmount: paidAmount,
//           balance: balance,
//           returnAmount: returnAmount,
//           createdAt: DateTime.now().toIso8601String(),
//           createdBy: 'user', // Replace with actual logged in user
//           isDeleted: 0,
//           isSynced: 0,
//           syncStatus: 'pending',
//           syncAttempts: 0,
//           bookingStatus: 'pending',
//           paymentStatus: paidAmount >= totalAmount
//               ? 'completed'
//               : paidAmount > 0
//               ? 'partial'
//               : 'pending',
//         );

//         // Use the repository to save complete booking
//         final result = await _testBookingRepository.createCompleteBooking(
//           booking: testBooking,
//           items: bookingItems,
//           payments: paymentDetailsList,
//         );

//         if (result['success'] == true) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Booking saved successfully! ID: ${result['bookingId']}',
//               ),
//             ),
//           );

//           // Generate next registration and token numbers
//           final nextRegNo = await _testBookingRepository
//               .generateNextRegistrationNo();
//           final nextTokenNo = await _testBookingRepository
//               .generateNextTokenNo();

//           // Clear form
//           _formKey.currentState!.reset();
//           setState(() {
//             _registrationNoController.text = nextRegNo;
//             _tokenNoController.text = nextTokenNo;
//             _dateController.text = DateFormat(
//               'dd/MM/yyyy',
//             ).format(DateTime.now());
//             testItems = [
//               TestItem(
//                 type: 'Test',
//                 name: '',
//                 mrp: 0.0,
//                 rate: 0.0,
//                 quantity: 1,
//                 gstPercent: 0.0,
//                 discountPercent: 0.0,
//                 amount: 0.0,
//               ),
//             ];
//             paymentDetails = [
//               PaymentDetailItem(
//                 paymentMode: 'CASH',
//                 amount: 0.0,
//                 referenceNo: '',
//                 description: '',
//               ),
//             ];
//             _selectedGender = null;
//             _selectedDoctorReferrer = null;
//             _selectedAssignTo = null;
//             _selectedClient = null;

//             // Reset amount fields
//             _totalController.text = '0.00';
//             _billDiscountController.text = '0.00';
//             _totalDiscountController.text = '0.00';
//             _gstController.text = '0.00';
//             _totalAmountController.text = '0.00';
//             _paidAmountController.text = '0.00';
//             _balanceController.text = '0.00';
//             _returnAmountController.text = '0.00';
//           });
//         } else {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
//         }
//       } catch (e, stackTrace) {
//         print('Error saving booking: $e');
//         print('Stack trace: $stackTrace');
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error saving booking: $e')));
//       } finally {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }

//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Test Booking'),
//         actions: [
//           IconButton(
//             icon: _isSaving
//                 ? const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   )
//                 : const Icon(Icons.save),
//             onPressed: _isSaving ? null : _saveBooking,
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
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHeader(),
//                     const SizedBox(height: 20),
//                     _buildPatientInfoSection(),
//                     const SizedBox(height: 20),
//                     _buildTestItemsSection(),
//                     const SizedBox(height: 20),
//                     _buildPaymentDetailsSection(),
//                     const SizedBox(height: 20),
//                     _buildSummarySection(),
//                     const SizedBox(height: 30),
//                     _buildActionButtons(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildHeader() {
//     return const Text(
//       'Create Test Booking',
//       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _buildPatientInfoSection() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Patient Information',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: [
//                 _buildTextField(
//                   'Registration No *',
//                   _registrationNoController,
//                   true,
//                   200,
//                   enabled: false,
//                 ),
//                 _buildTextField('MRD No', _mrdNoController, false, 200),
//                 SizedBox(
//                   width: 200,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Date *'),
//                       const SizedBox(height: 4),
//                       TextFormField(
//                         controller: _dateController,
//                         readOnly: true,
//                         onTap: _selectDate,
//                         decoration: const InputDecoration(
//                           suffixIcon: Icon(Icons.calendar_today),
//                           border: OutlineInputBorder(),
//                           hintText: 'Select date',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select date';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildTextField('Phone No', _phoneNoController, false, 200),
//                 _buildTextField(
//                   'Patient Name *',
//                   _patientNameController,
//                   true,
//                   200,
//                 ),
//                 SizedBox(
//                   width: 200,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Gender'),
//                       const SizedBox(height: 4),
//                       DropdownButtonFormField<String>(
//                         value: _selectedGender,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'select',
//                           isDense: true,
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 12,
//                           ),
//                         ),
//                         items: genderOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedGender = newValue;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 200,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Age *'),
//                       const SizedBox(height: 4),
//                       TextFormField(
//                         controller: _ageController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'Enter age',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter age';
//                           }
//                           final age = int.tryParse(value);
//                           if (age == null || age < 0) {
//                             return 'Please enter a valid age';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             final age = int.tryParse(value);
//                             if (age != null && age > 150) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                     'Please enter a valid age (0-150)',
//                                   ),
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildTextField('Email *', _emailController, true, 200),
//                 SizedBox(
//                   width: 400,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Address'),
//                       const SizedBox(height: 4),
//                       TextFormField(
//                         controller: _addressController,
//                         maxLines: 2,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'Enter address',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 200,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Doctor Referrer'),
//                       const SizedBox(height: 4),
//                       DropdownButtonFormField<String>(
//                         value: _selectedDoctorReferrer,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'select',
//                           isDense: true,
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 12,
//                           ),
//                         ),
//                         items: doctorReferrerOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedDoctorReferrer = newValue;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildTextField('Barcode', _barcodeController, false, 200),
//                 _buildTextField('Token No *', _tokenNoController, true, 200),
//                 SizedBox(
//                   width: 200,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Assign To'),
//                       const SizedBox(height: 4),
//                       DropdownButtonFormField<String>(
//                         value: _selectedAssignTo,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'select',
//                           isDense: true,
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 12,
//                           ),
//                         ),
//                         items: assignToOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedAssignTo = newValue;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 200,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Client'),
//                       const SizedBox(height: 4),
//                       DropdownButtonFormField<String>(
//                         value: _selectedClient,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'select',
//                           isDense: true,
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 12,
//                           ),
//                         ),
//                         items: clientOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedClient = newValue;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTestItemsSection() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Test Items',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columnSpacing: 16,
//                 columns: const [
//                   DataColumn(label: Text('Type')),
//                   DataColumn(label: Text('Test/Package'), numeric: false),
//                   DataColumn(label: Text('Mrp'), numeric: true),
//                   DataColumn(label: Text('Rate'), numeric: true),
//                   DataColumn(label: Text('Qty'), numeric: true),
//                   DataColumn(label: Text('Gst %'), numeric: true),
//                   DataColumn(label: Text('Disc %'), numeric: true),
//                   DataColumn(label: Text('Amount'), numeric: true),
//                   DataColumn(label: Text('Actions')),
//                 ],
//                 rows: testItems.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final item = entry.value;
//                   return DataRow(
//                     cells: [
//                       DataCell(
//                         DropdownButton<String>(
//                           value: item.type,
//                           underline: const SizedBox(),
//                           onChanged: (newValue) {
//                             setState(() {
//                               testItems[index] = item.copyWith(type: newValue!);
//                               _calculateTotals();
//                             });
//                           },
//                           items: ['Package', 'Test'].map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 200,
//                           child: TextFormField(
//                             controller: TextEditingController(text: item.name),
//                             decoration: const InputDecoration(
//                               hintText: 'Enter name',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 testItems[index] = item.copyWith(name: value);
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 80,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: item.mrp.toStringAsFixed(2),
//                             ),
//                             keyboardType: TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                             textAlign: TextAlign.right,
//                             decoration: const InputDecoration(
//                               hintText: '0.00',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               final mrp = double.tryParse(value) ?? 0;
//                               setState(() {
//                                 testItems[index] = item.copyWith(mrp: mrp);
//                               });
//                               _calculateTotals();
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 80,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: item.rate.toStringAsFixed(2),
//                             ),
//                             keyboardType: TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                             textAlign: TextAlign.right,
//                             decoration: const InputDecoration(
//                               hintText: '0.00',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               final rate = double.tryParse(value) ?? 0;
//                               setState(() {
//                                 testItems[index] = item.copyWith(rate: rate);
//                               });
//                               _calculateTotals();
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 60,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: item.quantity.toString(),
//                             ),
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.right,
//                             decoration: const InputDecoration(
//                               hintText: '1',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               final qty = int.tryParse(value) ?? 1;
//                               setState(() {
//                                 testItems[index] = item.copyWith(quantity: qty);
//                               });
//                               _calculateTotals();
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 60,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: item.gstPercent.toStringAsFixed(2),
//                             ),
//                             keyboardType: TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                             textAlign: TextAlign.right,
//                             decoration: const InputDecoration(
//                               hintText: '0.00',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               final gst = double.tryParse(value) ?? 0;
//                               setState(() {
//                                 testItems[index] = item.copyWith(
//                                   gstPercent: gst,
//                                 );
//                               });
//                               _calculateTotals();
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 60,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: item.discountPercent.toStringAsFixed(2),
//                             ),
//                             keyboardType: TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                             textAlign: TextAlign.right,
//                             decoration: const InputDecoration(
//                               hintText: '0.00',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               final disc = double.tryParse(value) ?? 0;
//                               setState(() {
//                                 testItems[index] = item.copyWith(
//                                   discountPercent: disc,
//                                 );
//                               });
//                               _calculateTotals();
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 80,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: '₹${item.amount.toStringAsFixed(2)}',
//                             ),
//                             textAlign: TextAlign.right,
//                             readOnly: true,
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         IconButton(
//                           icon: const Icon(
//                             Icons.delete,
//                             color: Colors.red,
//                             size: 20,
//                           ),
//                           onPressed: () => _removeTestItem(index),
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _addTestItem,
//               icon: const Icon(Icons.add),
//               label: const Text('Add Row'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentDetailsSection() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Payment Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columnSpacing: 16,
//                 columns: const [
//                   DataColumn(label: Text('Payment Mode')),
//                   DataColumn(label: Text('Amount'), numeric: true),
//                   DataColumn(label: Text('Reference NO')),
//                   DataColumn(label: Text('Description')),
//                   DataColumn(label: Text('Actions')),
//                 ],
//                 rows: paymentDetails.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final payment = entry.value;
//                   return DataRow(
//                     cells: [
//                       DataCell(
//                         SizedBox(
//                           width: 150,
//                           child: DropdownButton<String>(
//                             value: payment.paymentMode,
//                             isExpanded: true,
//                             underline: const SizedBox(),
//                             onChanged: (newValue) {
//                               setState(() {
//                                 paymentDetails[index] = payment.copyWith(
//                                   paymentMode: newValue!,
//                                 );
//                               });
//                             },
//                             items: paymentModes.map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 100,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: payment.amount.toStringAsFixed(2),
//                             ),
//                             keyboardType: TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                             textAlign: TextAlign.right,
//                             decoration: const InputDecoration(
//                               hintText: '0.00',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               final amount = double.tryParse(value) ?? 0;
//                               setState(() {
//                                 paymentDetails[index] = payment.copyWith(
//                                   amount: amount,
//                                 );
//                               });
//                               _calculatePaymentTotal();
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 150,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: payment.referenceNo,
//                             ),
//                             decoration: const InputDecoration(
//                               hintText: 'Ref No',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 paymentDetails[index] = payment.copyWith(
//                                   referenceNo: value,
//                                 );
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         SizedBox(
//                           width: 200,
//                           child: TextFormField(
//                             controller: TextEditingController(
//                               text: payment.description,
//                             ),
//                             decoration: const InputDecoration(
//                               hintText: 'Description',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 paymentDetails[index] = payment.copyWith(
//                                   description: value,
//                                 );
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         IconButton(
//                           icon: const Icon(
//                             Icons.delete,
//                             color: Colors.red,
//                             size: 20,
//                           ),
//                           onPressed: () => _removePaymentDetail(index),
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _addPaymentDetail,
//               icon: const Icon(Icons.add),
//               label: const Text('Add Row'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummarySection() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               _buildSummaryItem('Total', _totalController, 120),
//               const SizedBox(width: 16),
//               _buildSummaryItem('Bill Discount', _billDiscountController, 120),
//               const SizedBox(width: 16),
//               _buildSummaryItem(
//                 'Total Discount',
//                 _totalDiscountController,
//                 120,
//               ),
//               const SizedBox(width: 16),
//               _buildSummaryItem('Gst', _gstController, 120),
//               const SizedBox(width: 16),
//               _buildSummaryItem('Total Amount', _totalAmountController, 120),
//               const SizedBox(width: 16),
//               _buildSummaryItem('Paid Amount', _paidAmountController, 120),
//               const SizedBox(width: 16),
//               _buildSummaryItem('Balance', _balanceController, 120),
//               const SizedBox(width: 16),
//               _buildSummaryItem('Return Amount', _returnAmountController, 120),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryItem(
//     String label,
//     TextEditingController controller,
//     double width,
//   ) {
//     return SizedBox(
//       width: width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           TextFormField(
//             controller: controller,
//             readOnly: true,
//             textAlign: TextAlign.right,
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 8,
//               ),
//               prefixText:
//                   label.contains('Amount') ||
//                       label.contains('Total') ||
//                       label.contains('Discount') ||
//                       label.contains('Balance') ||
//                       label == 'Gst'
//                   ? '₹'
//                   : '',
//               prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Center(
//       child: Wrap(
//         spacing: 16,
//         runSpacing: 16,
//         children: [
//           ElevatedButton(
//             onPressed: _isSaving ? null : _saveBooking,
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//             ),
//             child: _isSaving
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 : const Text('Save Booking'),
//           ),
//           OutlinedButton(
//             onPressed: _isSaving
//                 ? null
//                 : () {
//                     _formKey.currentState!.reset();
//                     setState(() {
//                       testItems = [
//                         TestItem(
//                           type: 'Test',
//                           name: '',
//                           mrp: 0.0,
//                           rate: 0.0,
//                           quantity: 1,
//                           gstPercent: 0.0,
//                           discountPercent: 0.0,
//                           amount: 0.0,
//                         ),
//                       ];
//                       paymentDetails = [
//                         PaymentDetailItem(
//                           paymentMode: 'CASH',
//                           amount: 0.0,
//                           referenceNo: '',
//                           description: '',
//                         ),
//                       ];
//                       _selectedGender = null;
//                       _selectedDoctorReferrer = null;
//                       _selectedAssignTo = null;
//                       _selectedClient = null;

//                       // Reset amount fields
//                       _totalController.text = '0.00';
//                       _billDiscountController.text = '0.00';
//                       _totalDiscountController.text = '0.00';
//                       _gstController.text = '0.00';
//                       _totalAmountController.text = '0.00';
//                       _paidAmountController.text = '0.00';
//                       _balanceController.text = '0.00';
//                       _returnAmountController.text = '0.00';
//                     });
//                   },
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//             ),
//             child: const Text('Clear All'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller,
//     bool required,
//     double width, {
//     bool enabled = true,
//   }) {
//     return SizedBox(
//       width: width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(required ? '$label *' : label),
//           const SizedBox(height: 4),
//           TextFormField(
//             controller: controller,
//             enabled: enabled,
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               hintText: 'Enter ${label.toLowerCase()}',
//             ),
//             validator: required
//                 ? (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter $label';
//                     }
//                     if (label.contains('Email') && !value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   }
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _registrationNoController.dispose();
//     _mrdNoController.dispose();
//     _dateController.dispose();
//     _phoneNoController.dispose();
//     _patientNameController.dispose();
//     _ageController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _barcodeController.dispose();
//     _tokenNoController.dispose();
//     _totalController.dispose();
//     _billDiscountController.dispose();
//     _totalDiscountController.dispose();
//     _gstController.dispose();
//     _totalAmountController.dispose();
//     _paidAmountController.dispose();
//     _balanceController.dispose();
//     _returnAmountController.dispose();
//     super.dispose();
//   }
// }

// // Helper classes for temporary data
// class TestItem {
//   String type;
//   String name;
//   double mrp;
//   double rate;
//   int quantity;
//   double gstPercent;
//   double discountPercent;
//   double amount;

//   TestItem({
//     required this.type,
//     required this.name,
//     required this.mrp,
//     required this.rate,
//     required this.quantity,
//     required this.gstPercent,
//     required this.discountPercent,
//     required this.amount,
//   });

//   TestItem copyWith({
//     String? type,
//     String? name,
//     double? mrp,
//     double? rate,
//     int? quantity,
//     double? gstPercent,
//     double? discountPercent,
//     double? amount,
//   }) {
//     return TestItem(
//       type: type ?? this.type,
//       name: name ?? this.name,
//       mrp: mrp ?? this.mrp,
//       rate: rate ?? this.rate,
//       quantity: quantity ?? this.quantity,
//       gstPercent: gstPercent ?? this.gstPercent,
//       discountPercent: discountPercent ?? this.discountPercent,
//       amount: amount ?? this.amount,
//     );
//   }
// }

// class PaymentDetailItem {
//   String paymentMode;
//   double amount;
//   String referenceNo;
//   String description;

//   PaymentDetailItem({
//     required this.paymentMode,
//     required this.amount,
//     required this.referenceNo,
//     required this.description,
//   });

//   PaymentDetailItem copyWith({
//     String? paymentMode,
//     double? amount,
//     String? referenceNo,
//     String? description,
//   }) {
//     return PaymentDetailItem(
//       paymentMode: paymentMode ?? this.paymentMode,
//       amount: amount ?? this.amount,
//       referenceNo: referenceNo ?? this.referenceNo,
//       description: description ?? this.description,
//     );
//   }
// }
