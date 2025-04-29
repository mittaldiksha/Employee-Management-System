import 'package:employement_management_system/models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDatabase {
  final CollectionReference employeeRef =
  FirebaseFirestore.instance.collection('employees');

  Future<void> addEmployee(Employee employee) async {
    await employeeRef.add(employee.toMap());
  }

  Stream<List<Employee>> getEmployees() {
    return employeeRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Employee.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateEmployee(Employee employee) async {
    await employeeRef.doc(employee.id).update(employee.toMap());
  }

  Future<void> deleteEmployee(String id) async {
    await employeeRef.doc(id).delete();
  }


  Future<Employee> getEmployeeById(String id) async {
    final doc = await employeeRef.doc(id).get();
    if (!doc.exists) {
      throw Exception("Employee not found!");
    }
    // Check if data is null before converting it
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("No data available for the employee.");
    }
    return Employee.fromDocument(data, doc.id);
  }
}