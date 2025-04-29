import 'package:employement_management_system/screens/Dashboard.dart';
import 'package:employement_management_system/screens/ProfileScreen.dart';
import 'package:employement_management_system/screens/ServicesScreen.dart';
import 'package:employement_management_system/screens/attendance_screen.dart';
import 'package:flutter/material.dart';
import '../Database/employee_database.dart';
import '../models/employee_model.dart';
import 'package:employement_management_system/screens/addEmployee.dart';


class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddEmployeeScreen()));
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Employee>>(
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
      ),
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






