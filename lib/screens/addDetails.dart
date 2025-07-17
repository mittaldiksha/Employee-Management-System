import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employement_management_system/screens/Dashboard.dart';
import 'package:flutter/material.dart';

class addDetails extends StatefulWidget {
  const addDetails({super.key});

  @override
  State<addDetails> createState() => _addDetailsState();
}

class _addDetailsState extends State<addDetails> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();

  bool isLoading = false;

  Future<void> addEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final employeeData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role': roleController.text.trim(),
      };

      await FirebaseFirestore.instance.collection('employees').add(employeeData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Details added successfully")),
      );

      // Clear form
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      roleController.clear();

        Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard()));


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Details")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                validator: (value) => value!.isEmpty ? "Enter phone number" : null,
              ),
              TextFormField(
                controller: roleController,
                decoration: InputDecoration(labelText: "Role (e.g. Developer)"),
                validator: (value) => value!.isEmpty ? "Enter role" : null,
              ),
              SizedBox(height: 12),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: addEmployee,
                child: Text("Add Details"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
