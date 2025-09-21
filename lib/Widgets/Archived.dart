import 'package:flutter/cupertino.dart';

class archived extends StatelessWidget {
  const archived({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Archived Tasks",
      style: TextStyle(fontSize: 30,
          color: CupertinoColors.inactiveGray),));
  }
}