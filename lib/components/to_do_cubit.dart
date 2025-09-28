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
List newtask =[];
  List donetask =[];
  List archivetask =[];
  List<int> pinnedTasks = [];

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

  void createDatabase() async {
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
        getTasksFromDatabase(db: database);
      },
    ).then((value) {
      database = value;

    });
  }
void opened (){



}

  Future<void> getTasksFromDatabase({required db}) async {


    donetask = [];
    archivetask = [];

   var alltask=[];
   newtask=alltask;
   newtask=[];
    alltask = await db.rawQuery('SELECT * FROM Tasks');

    print("------ Tasks in DB ------");
    for (var task in alltask) {
      if (task ['status'] == 'newtask') {
        newtask.add(task);
      } else if (task['status'] == 'donetask') {
        donetask.add(task);

      } else {
        archivetask.add(task);
      }
    }

    print(alltask);
    emit(GetDBStates());
  }
 updateDatabase({required String status, required int id})async{
    return database.rawUpdate
      ('UPDATE tasks SET status = ? WHERE id = ?',['$status','$id'],).
    then((value){

      print("update is $value");
      getTasksFromDatabase(db: database);
    }) ;


  }


  deleteDatabase({ required int id})async{
    return database.rawDelete('DELETE FROM tasks WHERE id = ?',['$id'],).
    then((value){

      print("delete is $value");
      getTasksFromDatabase(db: database);
    }) ;


  }


  insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      await txn.rawInsert (
        "INSERT INTO Tasks (title, date, time, status) VALUES('$title', '$date', '$time','newtask')",
      );
    });
    await getTasksFromDatabase(db: database);
  }
}
