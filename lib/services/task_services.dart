import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final CollectionReference taskRef = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    await taskRef.add(task.toMap());
  }

  Stream<List<Task>> getTasksForEmployee(String employeeId) {
    return taskRef.where('assignedTo', isEqualTo: employeeId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromDocument(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  Stream<List<Task>> getAllTasks() {
    return taskRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromDocument(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await taskRef.doc(taskId).update({'status': newStatus});
  }
}
