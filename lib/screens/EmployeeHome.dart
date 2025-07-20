import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employement_management_system/screens/employee_notifications.dart';
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
  String employeeName = '';
  bool hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    fetchEmployeeName();
    checkUnreadNotifications();
  }

  Future<void> fetchEmployeeName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docSnapshot = await FirebaseFirestore.instance
        .collection('employees') // Update if your collection name is different
        .doc(uid)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        employeeName = docSnapshot.data()?['name'] ?? '';
      });
    }
  }

  Future<void> checkUnreadNotifications() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(uid)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .get();

    print("Unread notifications: ${snapshot.docs.length}");

    setState(() {
      hasUnreadNotifications = snapshot.docs.isNotEmpty;
    });
  }


  Future<void> checkIn() async {
    final user = FirebaseAuth.instance.currentUser!;
    final name = employeeName.isNotEmpty ? employeeName : user.email!;
    final now = DateTime.now();

    final docRef = FirebaseFirestore.instance
        .collection('attendance')
        .doc(user.uid)
        .collection('records')
        .doc("${now.year}-${now.month}-${now.day}");

    await docRef.set({
      'employeeId': user.uid,
      'employeeName': name,
      'checkIn': now,
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

  void navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeNotifications()),
    ).then((_) {
      checkUnreadNotifications(); // Re-check after visiting notifications screen
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Greeting & Notification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  employeeName.isNotEmpty
                      ? "Hello, $employeeName"
                      : "Hello",
                  style: AppWidget.boldTextFeildStyle(),
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: navigateToNotifications,
                    ),
                    if (hasUnreadNotifications)
                      const Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.red,
                        ),
                      ),
                  ],
                )
              ],
            ),
            Text(
              getGreeting(),
              style: AppWidget.lightTextFeildStyle(),
            ),

            const SizedBox(height: 20),

            // Check In/Out Button
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
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sample Dashboard Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.yellow.shade800,
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.yellow.shade800,
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
