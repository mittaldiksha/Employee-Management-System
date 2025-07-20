import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();

  bool isLoading = true;
  late String docId;
  late String oldEmail;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance.collection('employees').get();
      final doc = snapshot.docs.firstWhere(
            (doc) => doc['email'] == user.email,
        orElse: () => throw Exception("User data not found"),
      );
      setState(() {
        docId = doc.id;
        _nameController.text = doc['name'] ?? '';
        _phoneController.text = doc['phone'] ?? '';
        _emailController.text = doc['email'] ?? '';
        _roleController.text = doc['role'] ?? '';
        oldEmail = doc['email'] ?? '';
        isLoading = false;
      });
    }
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection('employees').doc(docId).update({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'role': _roleController.text.trim(),
        });

        // Update Firebase Auth email if changed
        if (user != null && oldEmail != _emailController.text.trim()) {
          await user.updateEmail(_emailController.text.trim());
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, '/profile'); // Go to profile screen

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", _nameController, TextInputType.text),
              SizedBox(height: 16),
              _buildTextField("Phone", _phoneController, TextInputType.phone),
              SizedBox(height: 16),
              _buildTextField("Email", _emailController, TextInputType.emailAddress),
              SizedBox(height: 16),
              _buildTextField("Role", _roleController, TextInputType.text),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: saveChanges,
                icon: Icon(Icons.save),
                label: Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                  textStyle: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? '$label is required' : null,
    );
  }
}
