import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/components/to_do_cubit.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = BlocProvider.of<ToDoCubit>(context);
        if (cubit.tasks.isEmpty) {
          return Center(child: Text("No Tasks Yet"));
        } else {
          return ListView.builder(
            itemCount: cubit.tasks.length,
            itemBuilder: (context, index) {
              var task = cubit.tasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
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
        }
      },
    );
  }
}
