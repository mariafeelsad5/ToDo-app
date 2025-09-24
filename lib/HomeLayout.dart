import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/components/to_do_cubit.dart';
import 'Widgets/TaskForm.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ToDoCubit>(context);

    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey.shade400,
            title: Text(cubit.title[cubit.currentIndex]),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changenabar(index);
            },
            backgroundColor: Colors.blueGrey.shade100,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: "Done"),
              BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archived"),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: SingleChildScrollView(
                          child: TaskForm(
                            formKey: formKey,
                            titleController: titleController,
                            dateController: dateController,
                            timeController: timeController,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: -30, // فوق الشيت مباشرة
                        child: FloatingActionButton(
                          child: Icon(Icons.add), // الحجم العادي
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.insertDatabase(
                                title: titleController.text,
                                date: dateController.text,
                                time: timeController.text,
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),

                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
