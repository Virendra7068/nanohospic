import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nanohospic/screens/create_pharmacy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompanyService {
  static const String baseUrl = 'http://202.140.138.215:85/api';

  Future<CompanyResponse> getCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/CompanyApi'));

    if (response.statusCode == 200) {
      return CompanyResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<bool> deleteCompany(int companyId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/CompanyApi/$companyId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete company');
    }
  }
}

class CompanyResponse {
  final bool success;
  final List<Company> data;

  CompanyResponse({
    required this.success,
    required this.data,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
              ?.map((e) => Company.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Company {
  final int id;
  final String name;
  final dynamic tenant;
  final dynamic tenantId;
  final DateTime created;
  final String createdBy;
  final dynamic lastModified;
  final dynamic lastModifiedBy;
  final dynamic deleted;
  final dynamic deletedBy;

  Company({
    required this.id,
    required this.name,
    this.tenant,
    this.tenantId,
    required this.created,
    required this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      tenant: json['tenant'],
      tenantId: json['tenantId'],
      created: DateTime.parse(json['created'] ?? DateTime.now().toString()),
      createdBy: json['createdBy'] ?? '',
      lastModified: json['lastModified'],
      lastModifiedBy: json['lastModifiedBy'],
      deleted: json['deleted'],
      deletedBy: json['deletedBy'],
    );
  }
}

class GetCompanyListScreen extends StatefulWidget {
  const GetCompanyListScreen({super.key});

  @override
  State<GetCompanyListScreen> createState() => _GetCompanyListScreenState();
}

class _GetCompanyListScreenState extends State<GetCompanyListScreen> {
  final CompanyService _service = CompanyService();
  CompanyResponse? _companyResponse;
  bool _isLoading = false;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final List<Company> _filteredCompanies = [];

  // Color scheme
  final Color _primaryColor = Colors.blue.shade900;
  final Color _secondaryColor = Colors.blue.shade700;
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _cardColor = Colors.white;
  final Color _textColor = Colors.grey.shade800;
  final Color _accentColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
    
    // Add listener to search controller
    _searchController.addListener(() {
      _filterCompanies(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCompanies(String query) {
    if (_companyResponse == null) return;
    
    setState(() {
      if (query.isEmpty) {
        _filteredCompanies.clear();
        _filteredCompanies.addAll(_companyResponse!.data);
      } else {
        _filteredCompanies.clear();
        _filteredCompanies.addAll(
          _companyResponse!.data.where((company) {
            final companyName = company.name.toLowerCase();
            final searchQuery = query.toLowerCase();
            return companyName.contains(searchQuery);
          }).toList(),
        );
      }
    });
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final response = await _service.getCompanies();
      setState(() {
        _companyResponse = response;
        _filteredCompanies.clear();
        _filteredCompanies.addAll(response.data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      _showErrorSnackBar('Error loading companies: $e');
    }
  }

  Future<void> _deleteCompany(int companyId, String companyName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$companyName"?'),
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
        _isLoading = true;
      });

      try {
        final success = await _service.deleteCompany(companyId);
        
        if (success) {
          // Remove the company from the list
          setState(() {
            _companyResponse!.data.removeWhere((company) => company.id == companyId);
            _filterCompanies(_searchController.text);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$companyName" has been deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        _showErrorSnackBar('Error deleting company: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search companies...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'Companies',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: Colors.blue.withOpacity(0.4),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  if (_companyResponse != null) {
                    _filteredCompanies.clear();
                    _filteredCompanies.addAll(_companyResponse!.data);
                  }
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
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
            )
          else if (!_isSearching)
            IconButton(
              onPressed: _loadCompanies,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ).animate().fadeIn(duration: 300.ms),
        ],
      ),
      floatingActionButton: _isSearching
          ? null
          : FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateCompanyScreen()));
              },
              backgroundColor: _secondaryColor,
              foregroundColor: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, size: 24),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut).then(delay: 200.ms).shake(hz: 3, curve: Curves.easeInOut),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _companyResponse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading companies...',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 1000.ms, duration: 1500.ms),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ).animate().shake(duration: 600.ms, hz: 4),
              const SizedBox(height: 20),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Failed to load companies. Please try again.',
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadCompanies,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_companyResponse == null || _companyResponse!.data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.business, size: 80, color: Colors.blue.shade200)
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(delay: 1000.ms, duration: 2000.ms)
                  .then(),
              const SizedBox(height: 20),
              Text(
                'No companies found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Check back later for company updates',
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCompanies,
      backgroundColor: Colors.white,
      color: Colors.blue,
      displacement: 40,
      edgeOffset: 20,
      strokeWidth: 2.5,
      child: Column(
        children: [
          if (_isSearching && _filteredCompanies.isEmpty && _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No results found for "${_searchController.text}"',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.h),
              itemCount: _filteredCompanies.length,
              itemBuilder: (context, index) {
                final company = _filteredCompanies[index];
                return Dismissible(
                  key: Key(company.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete "${company.name}"?'),
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
                  },
                  onDismissed: (direction) {
                    _deleteCompany(company.id, company.name);
                  },
                  child: _buildCompanyItem(company, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyItem(Company company, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        elevation: 2,
        shadowColor: Colors.blue.withOpacity(0.1),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(6),
          splashColor: Colors.blue.withOpacity(0.1),
          highlightColor: Colors.blue.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
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
                      company.name.isNotEmpty ? company.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                        company.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   'ID: ${company.id}',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey.shade600,
                      //   ),
                      // ),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${_formatDate(company.created)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: _getStatusColor(company).withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Icon(
                //     _getStatusIcon(company),
                //     color: _getStatusColor(company),
                //     size: 20,
                //   ),
                // ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade400),
                  onPressed: () => _deleteCompany(company.id, company.name),
                  tooltip: 'Delete Company',
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.5, curve: Curves.easeOutQuart).scale(curve: Curves.easeOutBack),
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