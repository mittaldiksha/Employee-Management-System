import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class AddEmployeeScreen extends StatefulWidget {
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();

  bool isLoading = false;
  String? uploadedDocUrl;

  Future<void> uploadDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.first.bytes != null) {
      final fileBytes = result.files.first.bytes!;
      final fileName = path.basename(result.files.first.name);

      final storageRef = FirebaseStorage.instance.ref('documents/$fileName');

      try {
        final uploadTask = await storageRef.putData(fileBytes);
        final downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          uploadedDocUrl = downloadUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Document uploaded successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    }
  }

  Future<void> addEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final employeeData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role': roleController.text.trim(),
        'documentUrl': uploadedDocUrl,
      };

      await FirebaseFirestore.instance.collection('employees').add(employeeData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Employee added successfully")),
      );

      // Clear form
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      roleController.clear();
      setState(() => uploadedDocUrl = null);
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
      appBar: AppBar(title: Text("Add Employee")),
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
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: uploadDocument,
                icon: Icon(Icons.upload_file),
                label: Text("Upload Document"),
              ),
              if (uploadedDocUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Document Uploaded",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: addEmployee,
                child: Text("Add Employee"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
