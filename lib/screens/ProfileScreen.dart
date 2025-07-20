import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employement_management_system/screens/Dashboard.dart';
import 'package:employement_management_system/screens/EmployeeHome.dart';
import 'package:employement_management_system/screens/Login.dart';
import 'package:employement_management_system/screens/edit_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance.collection('employees').get();

      final matchingDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        return data.containsKey('email') && data['email'] == currentUser.email;
      });

      if (matchingDocs.isNotEmpty) {
        setState(() {
          userData = matchingDocs.first.data();
          isLoading = false;
        });
      } else {
        print("No employee document found for UID: ${currentUser.uid}");
        setState(() {
          userData = null;
          isLoading = false;
        });
      }
    } else {
      print("User not logged in");
      setState(() {
        userData = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );

        }
      ),
    ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(child: Text("No profile data found"))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  userData!['name']?.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(fontSize: 40, color: Colors.blue),
                ),
              ),
              SizedBox(height: 12),
              Text(
                userData!['name'] ?? 'No Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                userData!['role'] ?? '',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              Divider(),

              // Profile Details
              _buildDetailTile(Icons.email, "Email", userData!['email']),
              _buildDetailTile(Icons.phone, "Phone", userData!['phone']),
              _buildDetailTile(Icons.work, "Role", userData!['role']),

              SizedBox(height: 30),

              // Buttons
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
                },
                icon: Icon(Icons.edit),
                label: Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyLogin()));
                },
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value ?? 'Not available'),
    );
  }
}
