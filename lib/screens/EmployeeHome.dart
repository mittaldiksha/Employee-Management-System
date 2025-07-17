import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employement_management_system/widgets/support_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {

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
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "HELLO",
                  style: AppWidget.boldTextFeildStyle(),
                ),
                SizedBox(width: 50),
                Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ],
            ),
            Text(
              "Good Morning",
              style: AppWidget.lightTextFeildStyle(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: checkedIn ? checkOut : checkIn,
                child: Text(
                  checkedIn ? "Check Out" : "Check In",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.yellow.shade800,
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width*0.4,

                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.yellow.shade800,
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width*0.4,

                ),
              ],
            ),

          ],
        ),
      ),

    );
  }
}
