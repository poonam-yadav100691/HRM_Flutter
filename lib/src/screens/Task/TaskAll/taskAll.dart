import 'package:HRMNew/src/screens/Task/TaskAll/component/body.dart';
import 'package:HRMNew/src/screens/Task/TaskPending/component/PODO.dart';
import 'package:flutter/material.dart';

class TaskAll extends StatelessWidget {
  final List<ResultObject> data;
  TaskAll({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(taskAll: data),
      resizeToAvoidBottomPadding: true,
    );
  }
}
