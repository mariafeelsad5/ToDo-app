import 'package:flutter/cupertino.dart';

class done extends StatelessWidget {
  done({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Done Tasks",
      style: TextStyle(fontSize: 30,
          color: CupertinoColors.inactiveGray),));
  }
}