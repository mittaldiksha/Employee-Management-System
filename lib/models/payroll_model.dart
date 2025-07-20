class Payroll {
  final String employeeId;
  final String employeeName;
  final String email;
  final String role;
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double netPay;
  final DateTime generatedDate;

  Payroll({
    required this.employeeId,
    required this.employeeName,
    required this.email,
    required this.role,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.netPay,
    required this.generatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'email': email,
      'role': role,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'netPay': netPay,
      'generatedDate': generatedDate.toIso8601String(),
    };
  }

  factory Payroll.fromMap(Map<String, dynamic> map) {
    return Payroll(
      employeeId: map['employeeId'],
      employeeName: map['employeeName'],
      email: map['email'],
      role: map['role'],
      basicSalary: map['basicSalary'],
      allowances: map['allowances'],
      deductions: map['deductions'],
      netPay: map['netPay'],
      generatedDate: DateTime.parse(map['generatedDate']),
    );
  }
}
