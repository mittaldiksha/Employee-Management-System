import 'package:flutter/material.dart';
import 'package:employement_management_system/models/leave_model.dart';
import 'package:employement_management_system/services/leave_service.dart';

class AdminLeaveRequests extends StatelessWidget {
  void _showLeaveDetailsDialog(BuildContext context, LeaveRequest leave) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Leave Request Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Employee Name: ${leave.employeeName}"),
              SizedBox(height: 8),
              Text("Email: ${leave.employeeEmail}"),
              SizedBox(height: 8),
              Text("Reason: ${leave.reason}"),
              SizedBox(height: 8),
              Text("From: ${leave.startDate.toLocal().toString().split(' ')[0]}"),
              Text("To: ${leave.endDate.toLocal().toString().split(' ')[0]}"),
              SizedBox(height: 8),
              Text(
                "Status: ${leave.status}",
                style: TextStyle(
                  color: leave.status == "pending"
                      ? Colors.orange
                      : leave.status == "approved"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: leave.status == 'pending'
              ? [
            TextButton(
              onPressed: () {
                LeaveService().updateLeaveStatus(leave.id, 'approved');
                Navigator.pop(context);
              },
              child: Text("Approve", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                LeaveService().updateLeaveStatus(leave.id, 'rejected');
                Navigator.pop(context);
              },
              child: Text("Reject", style: TextStyle(color: Colors.red)),
            ),
          ]
              : [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leave Requests")),
      body: StreamBuilder<List<LeaveRequest>>(
        stream: LeaveService().getAllLeaveRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final leaves = snapshot.data!;
          if (leaves.isEmpty) {
            return Center(child: Text("No leave requests"));
          }

          return ListView.builder(
            itemCount: leaves.length,
            itemBuilder: (context, index) {
              final leave = leaves[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  onTap: () => _showLeaveDetailsDialog(context, leave),
                  title: Text(leave.employeeName),
                  subtitle: Text(
                    "${leave.reason}\n"
                        "From: ${leave.startDate.toLocal().toString().split(' ')[0]} "
                        "To: ${leave.endDate.toLocal().toString().split(' ')[0]}\n"
                        "Status: ${leave.status}",
                  ),
                  trailing: leave.status == 'pending'
                      ? Icon(Icons.info_outline, color: Colors.orange)
                      : Icon(
                    leave.status == 'approved' ? Icons.check_circle : Icons.cancel,
                    color: leave.status == 'approved' ? Colors.green : Colors.red,
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
