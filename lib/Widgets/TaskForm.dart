import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../HomeLayout.dart';

class TaskForm extends StatefulWidget {
  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeController.text = TimeOfDay.now().format(context);  });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(labelText: "Title", prefixIcon: Icon(Icons.title)),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(labelText: "Date", prefixIcon: Icon(Icons.calendar_today)),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            }
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: timeController,
          readOnly: true,
          decoration: InputDecoration(labelText: "Time", prefixIcon: Icon(Icons.access_time)),
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              timeController.text = pickedTime.format(context);
            }
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            insertDatabase(
              title: titleController.text,
              date: dateController.text,
              time: timeController.text,
            );
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("the task added successfully "),
                backgroundColor: Colors.green.shade600,
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text("Add Task"),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
