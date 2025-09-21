import 'package:flutter/material.dart';
import '../HomeLayout.dart';

class NewTasks extends StatefulWidget {
  const NewTasks({super.key});

  @override
  State<NewTasks> createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map>>(
      future: getTasksFromDatabase(db: database),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(   radius: 40,
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        task['time'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    title: Text(task['title']),
                    subtitle: Text(task['date']),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("No Tasks Yet"));
        }
      },
    );
  }
}
