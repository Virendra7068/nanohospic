import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nanohospic/screens/create_patient.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Customer {
  final int id;
  final String name;
  final String address;
  final String phoneNo;
  final String? email;
  final String created;

  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNo,
    this.email,
    required this.created,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      created: json['created'],
    );
  }
}

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Customer> customers = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final List<Customer> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    _searchController.addListener(() {
      _filterCustomers(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers.clear();
        _filteredCustomers.addAll(customers);
      } else {
        _filteredCustomers.clear();
        _filteredCustomers.addAll(
          customers.where((customer) {
            final customerName = customer.name.toLowerCase();
            final customerPhone = customer.phoneNo.toLowerCase();
            final searchQuery = query.toLowerCase();
            return customerName.contains(searchQuery) ||
                customerPhone.contains(searchQuery);
          }).toList(),
        );
      }
    });
  }

  Future<void> fetchCustomers() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://202.140.138.215:85/api/CustomerApi'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> customerData = data['data'];
          setState(() {
            customers =
                customerData.map((json) => Customer.fromJson(json)).toList();
            _filteredCustomers.clear();
            _filteredCustomers.addAll(customers);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                'Failed to load customers: API returned unsuccessful';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load customers: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load customers: $e';
      });
    }
  }

  // Function to delete customer
  Future<void> _deleteCustomer(int customerId, String customerName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$customerName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await http.delete(
          Uri.parse('http://202.140.138.215:85/api/CustomerApi/$customerId'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // Remove the customer from the list
          setState(() {
            customers.removeWhere((customer) => customer.id == customerId);
            _filterCustomers(_searchController.text);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$customerName" has been deleted'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Failed to delete customer: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting customer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Function to launch phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  // Function to launch WhatsApp
  Future<void> _openWhatsApp(String phoneNumber) async {
    // Remove any non-digit characters from the phone number
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: cleanedNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search customers...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                )
                : Text(
                  'Party List',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.blue.withOpacity(0.4),
        actions: [
          // if (_isSearching)
          //   IconButton(
          //     icon: const Icon(Icons.clear),
          //     onPressed: () {
          //       setState(() {
          //         _isSearching = false;
          //         _searchController.clear();
          //         _filteredCustomers.clear();
          //         _filteredCustomers.addAll(customers);
          //       });
          //     },
          //   )
          // else
          //   IconButton(
          //     icon: const Icon(Icons.search),
          //     onPressed: () {
          //       setState(() {
          //         _isSearching = true;
          //       });
          //     },
          //   ),
          // if (isLoading)
          //   const Padding(
          //     padding: EdgeInsets.only(right: 16.0),
          //     child: Center(
          //       child: SizedBox(
          //         width: 20,
          //         height: 20,
          //         child: CircularProgressIndicator(
          //           strokeWidth: 2,
          //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //         ),
          //       ),
          //     ),
          //   )
          // else if (!_isSearching)
          //   IconButton(
          //     onPressed: fetchCustomers,
          //     icon: const Icon(Iconsax.refresh),
          //   ),

            IconButton(
              onPressed: fetchCustomers,
              icon: const Icon(Iconsax.refresh),
            ),
        ],
      ),
      body:
          isLoading
              ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading customers...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(delay: 1000.ms, duration: 1500.ms)
              : errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.close_circle,
                      size: 64,
                      color: Colors.red.shade400,
                    ).animate().shake(duration: 600.ms, hz: 4),
                    const SizedBox(height: 20),
                    Text(
                      'Oops! Something went wrong',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: fetchCustomers,
                      icon: const Icon(Iconsax.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : _filteredCustomers.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                          Iconsax.profile_2user,
                          size: 80,
                          color: Colors.blue.shade200,
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .scale(delay: 1000.ms, duration: 2000.ms)
                        .then(),
                    const SizedBox(height: 20),
                    Text(
                      _searchController.text.isNotEmpty
                          ? 'No customers found for "${_searchController.text}"'
                          : 'No customers found',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Check back later for customer updates',
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchCustomers,
                backgroundColor: Colors.white,
                color: Colors.blue,
                displacement: 40,
                edgeOffset: 20,
                strokeWidth: 2.5,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.5.w,
                    vertical: 2.h,
                  ),
                  itemCount: _filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomers[index];
                    return Dismissible(
                      key: Key(customer.id.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: Text(
                                'Are you sure you want to delete "${customer.name}"?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        _deleteCustomer(customer.id, customer.name);
                      },
                      child: _buildCustomerItem(customer, index),
                    );
                  },
                ),
              ),
      floatingActionButton:
          _isSearching
              ? null
              : FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateCustomerScreen(),
                        ),
                      );
                    },
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Iconsax.add, size: 24),
                  )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .then(delay: 200.ms)
                  .shake(hz: 3, curve: Curves.easeInOut),
    );
  }

  Widget _buildCustomerItem(Customer customer, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            elevation: 2,
            shadowColor: Colors.blue.withOpacity(0.1),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              splashColor: Colors.blue.withOpacity(0.1),
              highlightColor: Colors.blue.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getColorFromIndex(index),
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getColorFromIndex(index),
                            _getColorFromIndex(index).withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            customer.address,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15.sp,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            customer.phoneNo,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                              icon: Icon(Iconsax.message, color: Colors.green),
                              onPressed: () {
                                _openWhatsApp(customer.phoneNo);
                              },
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shake(delay: 1000.ms, hz: 2, duration: 2000.ms)
                            .then(),
                        IconButton(
                              icon: Icon(Iconsax.call, color: Colors.blue),
                              onPressed: () {
                                _makePhoneCall(customer.phoneNo);
                              },
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shake(delay: 1500.ms, hz: 2, duration: 2000.ms)
                            .then(),
                        IconButton(
                          icon: Icon(Iconsax.trash, color: Colors.red),
                          onPressed: () {
                            _deleteCustomer(customer.id, customer.name);
                          },
                        ),
                      ],
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

  Color _getColorFromIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}
