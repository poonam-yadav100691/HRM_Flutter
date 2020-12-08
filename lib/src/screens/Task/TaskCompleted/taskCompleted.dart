import 'package:HRMNew/src/screens/Task/TaskCompleted/component/body.dart';
import 'package:flutter/material.dart';

class TaskCompleted extends StatefulWidget {
  // final TabController tabBar;
  TaskCompleted();

  @override
  _TaskCompletedState createState() => _TaskCompletedState();
}

class _TaskCompletedState extends State<TaskCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      resizeToAvoidBottomPadding: true,
    );
  }
}
