import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employement_management_system/Database/employee_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/employee_model.dart';

class Profilescreen extends StatefulWidget {
   Profilescreen({super.key});

   TextEditingController _id = TextEditingController();
   TextEditingController _email = TextEditingController();
   TextEditingController _name = TextEditingController();
   TextEditingController _phone = TextEditingController();
   TextEditingController _role = TextEditingController();

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body:StreamBuilder<List<Employee>>(
        stream: EmployeeDatabase().getEmployees(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading employee data"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

             final employees = snapshot.data!;
             return Column(
                    children: [

                    ],
                );

          },
      ),
    );
  }
}
