import 'package:employement_management_system/screens/apply_leave_screen.dart';
import 'package:employement_management_system/screens/employee_payroll_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Dashboard.dart';

class Servicesscreen extends StatefulWidget {
  @override
  _ServicesscreenState createState() => _ServicesscreenState();
}

class _ServicesscreenState extends State<Servicesscreen> {
  String userRole = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('employees').doc(uid).get();

    if (doc.exists) {
      setState(() {
        userRole = doc['role'] ?? 'employee';
        isLoading = false;
      });
    } else {
      setState(() {
        userRole = 'employee'; // default or fallback role
        isLoading = false;
      });
      print("No employee document found for UID: $uid");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
          title: Text("Services"),
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
      body: ListView(
        children: [
          if (userRole.toLowerCase() == 'admin' || userRole.toLowerCase() == 'hr') ...[
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Add Employee"),
              onTap: () {
                Navigator.pushNamed(context, '/addEmployee');
              },
            ),
            ListTile(
              leading: Icon(Icons.task_alt),
              title: Text("Assign Task"),
              onTap: () {
                Navigator.pushNamed(context, '/assignTask');
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text("Attendance Report"),
              onTap: () {
                Navigator.pushNamed(context, '/adminAttendance');
              },
            ),
            ListTile(
              leading: Icon(Icons.leave_bags_at_home),
              title: Text("Manage Leaves"),
              onTap: () {
                Navigator.pushNamed(context, '/leaveAdmin');
              },
            ),
          ],

          ListTile(
            leading: Icon(Icons.checklist),
            title: Text("My Tasks"),
            onTap: () {
              Navigator.pushNamed(context, '/employeeTasks');
            },
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text("Attendance"),
            onTap: () {
              Navigator.pushNamed(context, '/attendance');
            },
          ),
          ListTile(
            leading: Icon(Icons.beach_access),
            title: Text("Apply Leave"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeaveScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.download),
            title: Text("Download Salary Slip"),
            onTap: () {
              // Navigator.pushNamed(context, '/salarySlip');
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeePayslipScreen()));

            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text("Performance Review"),
            onTap: () {
              Navigator.pushNamed(context, '/performance');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
