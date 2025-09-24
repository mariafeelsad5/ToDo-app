import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import '../Widgets/Archived.dart';
import '../Widgets/Done.dart';
import '../Widgets/new_tasks.dart';

part 'to_do_state.dart';

class ToDoCubit extends Cubit<ToDoState> {
  ToDoCubit() : super(ToDoInitial()) {
    createDatabase();
  }

  late Database database;
  int currentIndex = 0;

  List<Widget> screens = [NewTasks(), done(), archived()];
  List<String> title = ["New Tasks", "Done Tasks", "Archived Tasks"];

  bool isBottomSheetOpen = false;


  void changeFabIcon(bool isOpen) {
    isBottomSheetOpen = isOpen;
    emit(ChangeFabIconState());
  }


  void changenabar(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  Future<void> createDatabase() async {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
        );
        emit(CreatedDBStates());
      },
      onOpen: (db) {
        print("opened database");
        database = db;
        getTasksFromDatabase();
      },
    ).then((value) {
      database = value;

    });
  }

  List<Map> tasks = [];
  Future<void> getTasksFromDatabase() async {
    tasks = await database.rawQuery('SELECT * FROM Tasks');

    print("------ Tasks in DB ------");
    for (var task in tasks) {
      print(task);
    }
    emit(GetDBStates());
  }


  Future<void> insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
        "INSERT INTO Tasks (title, date, time, status) VALUES('$title', '$date', '$time','new task')",
      );
    });
    await getTasksFromDatabase();
  }
}
