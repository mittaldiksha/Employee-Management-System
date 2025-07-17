import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool checkedIn = false;
  DocumentReference? todayDocRef;
  List<Map<String, dynamic>> pastRecords = [];

  @override
  void initState() {
    super.initState();
    fetchPastRecords();
  }

  Future<void> fetchPastRecords() async {
    final user = FirebaseAuth.instance.currentUser!;
    final recordsSnapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(user.uid)
        .collection('records')
        .orderBy('checkIn', descending: true)
        .limit(10)
        .get();

    setState(() {
      pastRecords = recordsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> checkIn() async {
    final user = FirebaseAuth.instance.currentUser!;
    final name = user.displayName ?? '';
    final email = user.email ?? '';
    final now = DateTime.now();

    final docRef = FirebaseFirestore.instance
        .collection('attendance')
        .doc(user.uid)
        .collection('records')
        .doc("${now.year}-${now.month}-${now.day}");

    await docRef.set({
      'employeeId': user.uid,
      'employeeName': name,
      'employeeEmail': email,
      'checkIn': now,
      'checkOut': null,
    });

    setState(() {
      checkedIn = true;
      todayDocRef = docRef;
    });

    fetchPastRecords(); // Refresh list
  }

  Future<void> checkOut() async {
    final now = DateTime.now();
    await todayDocRef?.update({'checkOut': now});
    setState(() => checkedIn = false);
    fetchPastRecords(); // Refresh list
  }

  String formatTimestamp(Timestamp? ts) {
    if (ts == null) return '-';
    final dt = ts.toDate();
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} - ${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: checkedIn ? checkOut : checkIn,
              child: Text(checkedIn ? "Check Out" : "Check In"),
            ),
            SizedBox(height: 40),
            Text("Past Attendance Record", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: pastRecords.length,
                itemBuilder: (context, index) {
                  final record = pastRecords[index];
                  return ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text("Check-in: ${formatTimestamp(record['checkIn'])}"),
                    subtitle: Text("Check-out: ${formatTimestamp(record['checkOut'])}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

