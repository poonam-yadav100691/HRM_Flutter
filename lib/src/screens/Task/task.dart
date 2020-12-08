import 'package:HRMNew/src/screens/Task/component/body.dart';
import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  // final TabController tabBar;
  Task();

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      resizeToAvoidBottomPadding: true,
    );
  }
}
