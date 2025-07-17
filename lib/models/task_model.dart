import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final String assignedBy;
  final DateTime dueDate;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.assignedBy,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromDocument(Map<String, dynamic> doc, String docId) {
    return Task(
      id: docId,
      title: doc['title'] ?? '',
      description: doc['description'] ?? '',
      assignedTo: doc['assignedTo'] ?? '',
      assignedBy: doc['assignedBy'] ?? '',
      dueDate: (doc['dueDate'] as Timestamp).toDate(),
      status: doc['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'dueDate': dueDate,
      'status': status,
    };
  }
}


