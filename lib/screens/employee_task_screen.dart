import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import '../services/task_services.dart';

class EmployeeTaskScreen extends StatelessWidget {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Tasks"),
      backgroundColor: Colors.purple.shade200,),
      body: StreamBuilder<List<Task>>(
        stream: TaskService().getTasksForEmployee(_uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error loading tasks"));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final tasks = snapshot.data!;
          if (tasks.isEmpty) return Center(child: Text("No tasks assigned"));

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text("Due: ${task.dueDate.toLocal().toString().split(' ')[0]}"),
                  trailing: DropdownButton<String>(
                    value: task.status,
                    onChanged: (val) {
                      if (val != null) {
                        TaskService().updateTaskStatus(task.id, val);
                      }
                    },
                    items: ['pending', 'in-progress', 'completed'].map((status) {
                      return DropdownMenuItem<String>(value: status, child: Text(status));
                    }).toList(),
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
