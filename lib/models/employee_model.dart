class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? documentUrl;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.documentUrl,
  });

  factory Employee.fromDocument(Map<String, dynamic> doc, String docId) {
    return Employee(
      id: docId,
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '',
      role: doc['role'] ?? '',
      documentUrl: doc['documentUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role, 
      'documentUrl': documentUrl,
    };
  }
}