import 'package:employement_management_system/firebase_options.dart';
import 'package:employement_management_system/screens/Home_Dashboard.dart';
import 'package:employement_management_system/screens/Login.dart';
import 'package:employement_management_system/screens/SignUp.dart';
import 'package:employement_management_system/screens/addEmployee.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


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
      // other routes
    },

  ));
}



