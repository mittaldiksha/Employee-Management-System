// lib/screens/assign_task_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import 'package:employement_management_system/services/task_services.dart';


class AssignTaskScreen extends StatefulWidget {
  @override
  _AssignTaskScreenState createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployeeId;
  String? _title;
  String? _description;
  DateTime? _dueDate;

  Future<void> _submitTask() async {
    if (_formKey.currentState!.validate() && _selectedEmployeeId != null && _dueDate != null) {
      _formKey.currentState!.save();
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final newTask = Task(
        id: '',
        title: _title!,
        description: _description!,
        assignedTo: _selectedEmployeeId!,
        assignedBy: currentUser.uid,
        dueDate: _dueDate!,
        status: 'pending',
      );

      await TaskService().addTask(newTask);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task assigned successfully")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assign Task"),
      backgroundColor: Colors.purple.shade200,),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('employees').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  return DropdownButtonFormField<String>(
                    value: _selectedEmployeeId,
                    onChanged: (val) => setState(() => _selectedEmployeeId = val),
                    items: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(data['name'] ?? 'Unknown'),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Select Employee'),
                    validator: (val) => val == null ? 'Please select employee' : null,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Title'),
                onSaved: (val) => _title = val,
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (val) => _description = val,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(_dueDate == null
                    ? 'Select Due Date'
                    : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Assign Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
