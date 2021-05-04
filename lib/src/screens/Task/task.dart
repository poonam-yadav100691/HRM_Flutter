import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/screens/Task/component/body.dart';
import 'package:HRMNew/src/screens/home.dart';
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, addTaskRoute);
            // Add your onPressed code here!
          },
          elevation: 4,
          label: Text(getTranslated(context, 'AddTask')),
          icon: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.pink,
        ));
  }
}
