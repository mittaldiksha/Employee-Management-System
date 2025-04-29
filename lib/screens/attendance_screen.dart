import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../helper/location_helper.dart';


class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool checkedIn = false;
  DocumentReference? todayDocRef;

  Future<void> checkIn() async {
    final user = FirebaseAuth.instance.currentUser!;
    final name = user.displayName ?? user.email!;
    final now = DateTime.now();
    // final location = await LocationHelper.getCurrentLocation();

    final docRef = FirebaseFirestore.instance.collection('attendance').doc(user.uid).collection('records').doc("${now.year}-${now.month}-${now.day}");

    await docRef.set({
      'employeeId': user.uid,
      'employeeName': name,
      'checkIn': now,
      // 'location': location,
      'checkOut': null,
    });

    setState(() {
      checkedIn = true;
      todayDocRef = docRef;
    });
  }

  Future<void> checkOut() async {
    final now = DateTime.now();
    await todayDocRef?.update({'checkOut': now});
    setState(() => checkedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance")),
      body: Center(
        child: ElevatedButton(
          onPressed: checkedIn ? checkOut : checkIn,
          child: Text(checkedIn ? "Check Out" : "Check In"),
        ),
      ),
    );
  }
}
