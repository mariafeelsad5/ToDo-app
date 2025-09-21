import 'package:flutter/material.dart';
import 'package:untitled2/Widgets/Archived.dart';
import 'package:untitled2/Widgets/Done.dart';
import 'package:untitled2/Widgets/new_tasks.dart';
import 'package:sqflite/sqflite.dart';

import 'Widgets/TaskForm.dart';

late Database database;

class HomeLayout extends StatefulWidget {
  HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  List<Widget> screens = [NewTasks(), done(), archived()];
  List<String> title = ["New Tasks", "Done Tasks", "Archived Tasks"];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: createDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else {
          database = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey.shade400,
              title: Text(title[currentIndex]),
            ),
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              backgroundColor: Colors.blueGrey.shade100,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archived"),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child: TaskForm(),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }
}

Future<Database> createDatabase() async {
  return await openDatabase(
    "todo.db",
    version: 1,
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
      );
    },
    onOpen: (db) {
      print("Database opened ");
      getTasksFromDatabase(db: db).then((value) {
        print(value.toString());
      });
    },
  );
}

Future<void> insertDatabase({
  required String title,
  required String date,
  required String time,
}) async {
  await database.transaction((txn) async {
    return txn
        .rawInsert(
      "INSERT INTO Tasks (title, date, time, status) VALUES('$title', '$date', '$time','new task')",
    )
        .then((value) {
      print("inserted success and id is $value");
    }).catchError((error) {
      print("the error is :$error");
    });
  });
}

Future<List<Map>> getTasksFromDatabase({required db}) async {
  return await db.rawQuery('SELECT * FROM Tasks');
}
