part of 'to_do_cubit.dart';

@immutable
sealed class ToDoState {}

final class ToDoInitial extends ToDoState {}
class CreatedDBStates extends ToDoState{}
class InsertedDBStates extends ToDoState{}
class GetDBStates extends ToDoState{}
class ChangeNavBarState extends ToDoState{}
class ChangeFabIconState extends ToDoState{}