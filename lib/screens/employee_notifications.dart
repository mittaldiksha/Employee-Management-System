import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeNotifications extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear All',
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Clear All Notifications"),
                  content: const Text("Are you sure you want to delete all notifications?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                final batch = FirebaseFirestore.instance.batch();
                final snapshot = await FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(uid)
                    .collection('messages')
                    .get();

                for (var doc in snapshot.docs) {
                  batch.delete(doc.reference);
                }

                await batch.commit();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All notifications cleared")),
                );
              }
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(uid)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text("No notifications"));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Icon(Icons.notifications),
                title: Text(data['title'] ?? ''),
                subtitle: Text(data['message'] ?? ''),
                trailing: data['isRead'] == false
                    ? Icon(Icons.fiber_new, color: Colors.red)
                    : null,
                onTap: () async {
                  // Mark notification as read
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(uid)
                      .collection('messages')
                      .doc(docs[index].id)
                      .update({'isRead': true});

                  String status = (data['status'] ?? '').toString().toLowerCase();

                  Color dialogColor;
                  Icon dialogIcon;
                  String dialogTitle;

                  if (status == 'approved') {
                    dialogColor = Colors.green.shade100;
                    dialogIcon = const Icon(Icons.check_circle, color: Colors.green, size: 40);
                    dialogTitle = 'Leave Approved ✅';
                  } else if (status == 'rejected') {
                    dialogColor = Colors.red.shade100;
                    dialogIcon = const Icon(Icons.cancel, color: Colors.red, size: 40);
                    dialogTitle = 'Leave Rejected ❌';
                  } else {
                    dialogColor = Colors.grey.shade200;
                    dialogIcon = const Icon(Icons.notifications, color: Colors.blue, size: 40);
                    dialogTitle = 'Notification';
                  }

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: dialogColor,
                        title: Row(
                          children: [
                            dialogIcon,
                            const SizedBox(width: 10),
                            Expanded(child: Text(dialogTitle)),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Message: ${data['message'] ?? 'No details'}"),
                            const SizedBox(height: 8),
                            if (data['timestamp'] != null)
                              Text(
                                "Time: ${DateTime.fromMillisecondsSinceEpoch(data['timestamp'].millisecondsSinceEpoch)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          )
                        ],
                      );
                    },
                  );
                },

              );

            },
          );
        },
      ),
    );
  }
}
