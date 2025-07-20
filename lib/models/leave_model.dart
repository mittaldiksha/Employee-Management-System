import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeEmail;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeEmail,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeeEmail': employeeEmail,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status,
    };
  }

  factory LeaveRequest.fromMap(Map<String, dynamic> map, String id) {
    return LeaveRequest(
      id: id,
      employeeId: map['employeeId']?.toString() ?? '',
      employeeName: map['employeeName']?.toString() ?? '',
      employeeEmail: map['employeeEmail']?.toString() ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      reason: map['reason'],
      status: map['status'],
    );
  }
}
