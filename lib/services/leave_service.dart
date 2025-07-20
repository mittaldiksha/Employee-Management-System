import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leave_model.dart';

class LeaveService {
  final CollectionReference leaveRef = FirebaseFirestore.instance.collection('leave_requests');

  Future<void> applyLeave(LeaveRequest leave) async {
    await leaveRef.add(leave.toMap());
  }

  Stream<List<LeaveRequest>> getLeaveRequestsForEmployee(String employeeId) {
    return leaveRef.where('employeeId', isEqualTo: employeeId).snapshots().map(
          (snapshot) {
        return snapshot.docs
            .map((doc) => LeaveRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      },
    );
  }

  Stream<List<LeaveRequest>> getAllLeaveRequests() {
    return leaveRef.snapshots().map(
          (snapshot) {
        return snapshot.docs
            .map((doc) => LeaveRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      },
    );
  }

  // Future<void> updateLeaveStatus(String id, String status) async {
  //   await leaveRef.doc(id).update({'status': status});
  // }

  Future<void> updateLeaveStatus(String id, String status) async {
    DocumentSnapshot doc = await leaveRef.doc(id).get();
    final data = doc.data() as Map<String, dynamic>;

    await leaveRef.doc(id).update({'status': status});

    // Add notification
    String employeeId = data['employeeId'];
    String employeeName = data['employeeName'];
    DateTime start = (data['startDate'] as Timestamp).toDate();
    DateTime end = (data['endDate'] as Timestamp).toDate();

    String message = status == 'approved'
        ? 'Your leave from ${start.toLocal().toString().split(" ")[0]} to ${end.toLocal().toString().split(" ")[0]} is approved.'
        : 'Your leave from ${start.toLocal().toString().split(" ")[0]} to ${end.toLocal().toString().split(" ")[0]} is rejected.';

    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(employeeId)
        .collection('messages')
        .add({
      'title': 'Leave ${status[0].toUpperCase()}${status.substring(1)}',
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

}
