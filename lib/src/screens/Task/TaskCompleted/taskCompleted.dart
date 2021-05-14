import 'package:HRMNew/src/screens/Task/TaskCompleted/component/body.dart';
import 'package:HRMNew/src/screens/Task/TaskPending/component/PODO.dart';
import 'package:flutter/material.dart';

class TaskCompleted extends StatelessWidget {
  final List<ResultObject> data;
  TaskCompleted({Key key, @required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(taskComList: data),

    );
  }
}
