import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employement_management_system/screens/Dashboard.dart';
import 'package:employement_management_system/screens/Login.dart';
import 'package:employement_management_system/screens/ProfileScreen.dart';
import 'package:employement_management_system/screens/ServicesScreen.dart';
import 'package:employement_management_system/screens/admin_payroll_generate_screen.dart';
import 'package:employement_management_system/screens/assign_task_screen.dart';
import 'package:employement_management_system/screens/attendance_screen.dart';
import 'package:employement_management_system/screens/addEmployee.dart';
import 'package:flutter/material.dart';
import '../Database/employee_database.dart';
import '../models/employee_model.dart';
import 'admin_leave_requests.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    Servicesscreen(),
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
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.orangeAccent,
        leading: Builder(
          builder: (context) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leaves')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                bool showDot = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                    if (showDot)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmployeeScreen()));
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orangeAccent),
              child: Text("Admin Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Employees"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text("Assign Tasks"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AssignTaskScreen())),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text("Attendance"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceScreen())),
            ),
            ListTile(
              leading: Icon(Icons.payments_outlined),
              title: Text("Generate Payslip"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GeneratePayrollScreen())),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leaves')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                bool showRedDot = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                return ListTile(
                  leading: Stack(
                    children: [
                      Icon(Icons.event_note),
                      if (showRedDot)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text("Leave Management"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLeaveRequests()),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyLogin()))
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Employee>>(
      stream: EmployeeDatabase().getEmployees(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error loading employees"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final employees = snapshot.data!;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  DashboardTile(title: "Employees", count: employees.length),
                  DashboardTile(title: "Tasks", count: 0),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(emp.name),
                    subtitle: Text("${emp.email} • ${emp.role}"),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final int count;

  const DashboardTile({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text(count.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
