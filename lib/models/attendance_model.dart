import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String employeeId;
  final String employeeName;
  final DateTime checkIn;
  final DateTime? checkOut;
  // final String location;

  Attendance({
    required this.employeeId,
    required this.employeeName,
    required this.checkIn,
    this.checkOut,
    // required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'checkIn': checkIn,
      'checkOut': checkOut,
      // 'location': location,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      employeeId: map['employeeId'],
      employeeName: map['employeeName'],
      checkIn: (map['checkIn'] as Timestamp).toDate(),
      checkOut: map['checkOut'] != null ? (map['checkOut'] as Timestamp).toDate() : null,
      // location: map['location'],
    );
  }
}
