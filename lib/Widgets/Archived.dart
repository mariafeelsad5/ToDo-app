import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/components/to_do_cubit.dart';

class archived extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<ToDoCubit, ToDoState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = BlocProvider.of<ToDoCubit>(context);

          if (cubit.archivetask.isEmpty) {
            return Center(
              child: Text(
                "No Tasks Yet",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: cubit.archivetask.length,
              itemBuilder: (context, index) {
                var task = cubit.archivetask[index];
                final taskId = task['id'] as int;

                return Dismissible(
                  key: Key(taskId.toString()),

                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),

                  secondaryBackground: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.push_pin, color: Colors.white),
                  ),

                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final currentIndex =
                      cubit.archivetask.indexWhere((t) => t['id'] == taskId);
                      if (currentIndex != -1) {
                        final removed = cubit.archivetask.removeAt(currentIndex);

                        if (cubit.pinnedTasks.contains(taskId)) {
                          cubit.pinnedTasks.remove(taskId);
                          cubit.archivetask.add(removed);
                        } else {
                          cubit.pinnedTasks.add(taskId);
                          cubit.archivetask.insert(0, removed);
                        }

                        cubit.emit(GetDBStates());
                      }
                      return false;
                    }
                    return direction == DismissDirection.startToEnd;
                  },

                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      final deletedTask = task;
                      final removedIndex = index;
                      cubit.archivetask.removeAt(removedIndex);
                      cubit.deleteDatabase(id: taskId);
                      cubit.emit(GetDBStates());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "the task '${task['title']}' has been deleted "),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'undo',
                            textColor: Colors.white,
                            onPressed: () {
                              cubit.insertDatabase(
                                title: deletedTask['title'],
                                date: deletedTask['date'],
                                time: deletedTask['time'],
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blueGrey,
                          child: Text(
                            task['time'],
                            style:
                            TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                task['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          task['date'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              onPressed: () {
                                cubit.updateDatabase(
                                    status: "donetask", id: taskId);
                              },
                              icon: Icon(Icons.check_circle_outline),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.updateDatabase(
                                    status: "newtask", id: taskId);
                              },
                              icon: Icon(Icons.archive),
                            ),
                            if (cubit.pinnedTasks.contains(taskId))
                              Icon(Icons.push_pin),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
