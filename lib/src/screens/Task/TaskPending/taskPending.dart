import 'package:HRMNew/src/screens/Task/TaskPending/component/PODO.dart';
import 'package:HRMNew/src/screens/Task/TaskPending/component/body.dart';
import 'package:flutter/material.dart';

class TaskPending extends StatelessWidget {
  final List<ResultObject> data;
  TaskPending({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(taskPenList: data),
      resizeToAvoidBottomPadding: true,
    );
  }
}
