import 'package:HRMNew/src/screens/Task/TaskAll/component/body.dart';
import 'package:flutter/material.dart';

class TaskAll extends StatefulWidget {
  // final TabController tabBar;
  TaskAll();

  @override
  _TaskAllState createState() => _TaskAllState();
}

class _TaskAllState extends State<TaskAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      resizeToAvoidBottomPadding: true,
    );
  }
}
