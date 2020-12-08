import 'package:HRMNew/src/screens/Task/TaskPending/component/body.dart';
import 'package:flutter/material.dart';

class TaskPending extends StatefulWidget {
  // final TabController tabBar;
  TaskPending();

  @override
  _TaskPendingState createState() => _TaskPendingState();
}

class _TaskPendingState extends State<TaskPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      resizeToAvoidBottomPadding: true,
    );
  }
}
