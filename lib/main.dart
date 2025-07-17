import 'package:employement_management_system/firebase_options.dart';
import 'package:employement_management_system/screens/admin_home_dashboard.dart';
import 'package:employement_management_system/screens/Login.dart';
import 'package:employement_management_system/screens/ProfileScreen.dart';
import 'package:employement_management_system/screens/SignUp.dart';
import 'package:employement_management_system/screens/addEmployee.dart';
import 'package:employement_management_system/screens/assign_task_screen.dart';
import 'package:employement_management_system/screens/attendance_screen.dart';
import 'package:employement_management_system/screens/employee_task_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: BottomNavHome(),
    routes: {
      '/': (context) => MyLogin(), // Default route
      '/addEmployee': (context) => AddEmployeeScreen(),
      '/assignTask': (context) => AssignTaskScreen(),
      '/employeeTasks': (context) => EmployeeTaskScreen(),
      '/attendance': (context) => AttendanceScreen(),
      '/profile': (context) => ProfileScreen(),

      // other routes
    },

  ));
}



