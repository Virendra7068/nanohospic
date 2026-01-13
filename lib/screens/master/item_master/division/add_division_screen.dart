import 'package:flutter/material.dart';

class AddDivisionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> companies;
  final Function(String name, int? companyId, String? companyName) onSave;

  const AddDivisionDialog({
    Key? key,
    required this.companies,
    required this.onSave,
  }) : super(key: key);

  @override
  _AddDivisionDialogState createState() => _AddDivisionDialogState();
}

class _AddDivisionDialogState extends State<AddDivisionDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCompanyId;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
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
                  colors: [Colors.teal.shade400, Colors.teal.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business,
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Add New Division',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Division Name *',
                labelStyle: TextStyle(
                  color: Colors.teal.shade600,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
                filled: true,
                fillColor: Colors.teal.shade50,
                hintText: 'Enter division name',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Container(
                  margin: EdgeInsets.only(right: 8, left: 12),
                  child: Icon(Icons.business, color: Colors.teal.shade600),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 40),
              ),
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
            SizedBox(height: 16),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade300),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCompanyId,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.teal.shade700),
                  hint: Text(
                    'Select Company *',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  items: [
                    ...widget.companies.map((company) {
                      return DropdownMenuItem(
                        value: company['id'].toString(),
                        child: Text(
                          company['name'],
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCompanyId = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
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
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            if (_nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Please enter division name'),
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

                            if (_selectedCompanyId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Please select a company'),
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
                              _isSubmitting = true;
                            });

                            final companyId = int.tryParse(_selectedCompanyId!);
                            final company = widget.companies.firstWhere(
                              (c) => c['id'] == companyId,
                              orElse: () => {'name': ''},
                            );
                            final companyName = company['name'] as String?;

                            widget.onSave(
                              _nameController.text,
                              companyId,
                              companyName,
                            );

                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 20),
                              SizedBox(width: 8),
                              Text('Add Division'),
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
}

