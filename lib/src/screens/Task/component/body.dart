import 'package:HRMNew/components/textWithIcon.dart';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/Task/TaskAll/taskAll.dart';
import 'package:HRMNew/src/screens/Task/TaskCompleted/taskCompleted.dart';
import 'package:HRMNew/src/screens/Task/TaskPending/taskPending.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
        child: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.pending_actions),
                text: "Pending",
              ),
              Tab(icon: Icon(Icons.done), text: "Complete"),
              Tab(icon: Icon(Icons.all_inbox), text: "All"),
            ],
          ),
          title: Text(getTranslated(context, 'MyTask')),
        ),
        body: TabBarView(
          children: [TaskPending(), TaskCompleted(), TaskAll()],
        ),
      ),
    ));
  }
}
