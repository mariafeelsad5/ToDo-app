import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../HomeLayout.dart';
import 'package:untitled2/components/to_do_cubit.dart';
import 'package:flutter/material.dart';

class TaskForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController dateController;
  final TextEditingController timeController;

  TaskForm({
    required this.formKey,
    required this.titleController,
    required this.dateController,
    required this.timeController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration:InputDecoration(
              labelText: "Title",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: dateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Date",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                dateController.text =
                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return "Required";
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: timeController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Time",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.access_time),
            ),
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                timeController.text = pickedTime.format(context);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return "Required";
              return null;
            },
          ),
        ],
      ),
    );
  }
}
