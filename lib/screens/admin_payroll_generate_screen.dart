import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GeneratePayrollScreen extends StatefulWidget {
  @override
  _GeneratePayrollScreenState createState() => _GeneratePayrollScreenState();
}

class _GeneratePayrollScreenState extends State<GeneratePayrollScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployeeId;
  String? _selectedEmployeeName;
  String? _selectedEmployeeEmail;
  DateTime? _selectedDate;
  String monthLabel = 'Select Month and Year';

  double basic = 0;
  double allowances = 0;
  double deductions = 0;

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Month and Year',
      fieldHintText: 'MM/YYYY',
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        monthLabel = DateFormat.yMMMM().format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedEmployeeId != null && _selectedDate != null) {
      _formKey.currentState!.save();

      final netPay = basic + allowances - deductions;

      await FirebaseFirestore.instance.collection('payrolls').add({
        'employeeId': _selectedEmployeeId,
        'employeeName': _selectedEmployeeName,
        'employeeEmail': _selectedEmployeeEmail,
        'basicSalary': basic,
        'allowances': allowances,
        'deductions': deductions,
        'netPay': netPay,
        'generatedDate': _selectedDate,
        'month': _selectedDate!.month,
        'year': _selectedDate!.year,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payroll slip generated successfully')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete all fields')));
    }
  }

  Widget _buildTextField(String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Payroll')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('employees').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: _selectedEmployeeId,
                    hint: Text('Select Employee'),
                    items: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(data['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selectedDoc = snapshot.data!.docs.firstWhere((doc) => doc.id == value);
                      setState(() {
                        _selectedEmployeeId = value;
                        _selectedEmployeeName = (selectedDoc.data() as Map<String, dynamic>)['name'];
                      });
                    },
                    validator: (value) => value == null ? 'Please select employee' : null,
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('employees').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: _selectedEmployeeId,
                    hint: Text('Select Employee Email'),
                    items: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(data['email'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selectedDoc = snapshot.data!.docs.firstWhere((doc) => doc.id == value);
                      setState(() {
                        _selectedEmployeeId = value;
                        _selectedEmployeeEmail = (selectedDoc.data() as Map<String, dynamic>)['email'];
                      });
                    },
                    validator: (value) => value == null ? 'Please select employee' : null,
                  );
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(monthLabel),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectMonthYear(context),
              ),
              _buildTextField('Basic Salary', (value) => basic = double.parse(value)),
              _buildTextField('Allowances', (value) => allowances = double.parse(value)),
              _buildTextField('Deductions', (value) => deductions = double.parse(value)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Generate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
