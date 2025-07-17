import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(title: Text("Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(child: Text("No profile data found"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileField("Name", userData!['name']),
            _buildProfileField("Email", userData!['email']),
            _buildProfileField("Phone", userData!['phone']),
            _buildProfileField("Role", userData!['role']),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text("Logout"),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/editProfile');
              },
              child: Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
