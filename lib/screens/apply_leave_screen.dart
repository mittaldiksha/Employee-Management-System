import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:employement_management_system/services/leave_service.dart';
import 'package:employement_management_system/models/leave_model.dart';

class ApplyLeaveScreen extends StatefulWidget {
  @override
  _ApplyLeaveScreenState createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  final _reasonController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
      final user = FirebaseAuth.instance.currentUser!;
      final userDoc = await FirebaseFirestore.instance.collection('employees').doc(user.uid).get();

      final employeeName = userDoc['name'] ?? 'Unknown';
      final employeeEmail = user.email ?? 'Unknown';
      final leave = LeaveRequest(
        id: '',
        employeeId: user.uid,
        employeeName: employeeName,
        employeeEmail: employeeEmail,
        startDate: _startDate!,
        endDate: _endDate!,
        reason: _reasonController.text.trim(),
        status: 'pending',
      );
      await LeaveService().applyLeave(leave);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Apply for Leave")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
                validator: (value) => value!.isEmpty ? 'Enter a reason' : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _startDate = date);
                },
                child: Text(_startDate == null
                    ? 'Select Start Date'
                    : 'Start Date: ${_startDate!.toLocal().toString().split(' ')[0]}'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _endDate = date);
                },
                child: Text(_endDate == null
                    ? 'Select End Date'
                    : 'End Date: ${_endDate!.toLocal().toString().split(' ')[0]}'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
