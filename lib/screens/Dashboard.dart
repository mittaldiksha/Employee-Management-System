import 'package:employement_management_system/screens/EmployeeHome.dart';
import 'package:employement_management_system/screens/admin_home_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ProfileScreen.dart';
import 'ServicesScreen.dart';
import 'attendance_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});


  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String uid = FirebaseAuth.instance.currentUser!.uid;

  // void getid() {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final User? user = _auth.currentUser;
  //
  //   if (user != null) {
  //    final  String id = user.uid;
  //     print('Current User UID: $uid');
  //   }
  // }
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeDashboard(),
    // EmployeeHome(),
    Servicesscreen(),
    AttendanceScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
