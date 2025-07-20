import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EmployeePayslipScreen extends StatefulWidget {
  @override
  _EmployeePayslipScreenState createState() => _EmployeePayslipScreenState();
}

class _EmployeePayslipScreenState extends State<EmployeePayslipScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late Future<List<DocumentSnapshot>> _payslipsFuture;

  Future<List<DocumentSnapshot>> _fetchPayslips() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('payrolls')
        .where('employeeId', isEqualTo: user!.uid)
        .orderBy('generatedDate', descending: true)
        .get();
    return querySnapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    _payslipsFuture = _fetchPayslips();
  }

  void _downloadPayslipPdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final date = (data['generatedDate'] as Timestamp).toDate();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Payslip', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Employee Name: ${data['employeeName']}'),
            pw.Text('Role: ${data['role']}'),
            pw.Text('Email: ${data['email']}'),
            pw.Text('Month: ${DateFormat.yMMMM().format(date)}'),
            pw.Divider(),
            pw.Text('Basic Salary: ₹${(data['basicSalary'] as num).toStringAsFixed(2)}'),
            pw.Text('Allowances: ₹${(data['allowances'] as num).toStringAsFixed(2)}'),
            pw.Text('Deductions: ₹${(data['deductions'] as num).toStringAsFixed(2)}'),
            pw.SizedBox(height: 10),
            pw.Text('Net Pay: ₹${(data['netPay'] as num).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Payslips')),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _payslipsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching payslips'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payslips found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index].data() as Map<String, dynamic>;
              final date = (data['generatedDate'] as Timestamp).toDate();
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['employeeName']} (${data['role']})',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Email: ${data['email']}'),
                      Text('Month: ${DateFormat.yMMMM().format(date)}'),
                      Divider(height: 20, thickness: 1),
                      Text('Basic Salary: ₹${(data['basicSalary'] as num).toStringAsFixed(2)}'),
                      Text('Allowances: ₹${(data['allowances'] as num).toStringAsFixed(2)}'),
                      Text('Deductions: ₹${(data['deductions'] as num).toStringAsFixed(2)}'),
                      SizedBox(height: 8),
                      Text(
                        'Net Pay: ₹${(data['netPay'] as num).toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _downloadPayslipPdf(data),
                        icon: Icon(Icons.picture_as_pdf),
                        label: Text('Download PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
