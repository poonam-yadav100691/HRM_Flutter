import 'dart:async';
import 'dart:convert';

import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/Task/TaskAll/taskAll.dart';
import 'package:HRMNew/src/screens/Task/TaskCompleted/taskCompleted.dart';
import 'package:HRMNew/src/screens/Task/TaskPending/component/PODO.dart';
import 'package:HRMNew/src/screens/Task/TaskPending/taskPending.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './background.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ResultObject> myTaskAllList = new List();
  List<ResultObject> myTaskPenList = new List();

  List<ResultObject> myTaskCompList = new List();

  AnimationController animationController;
  Animation<dynamic> animation;
  bool isLoading = false;

  @override
  void initState() {
    _getTaskList();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<void> _getTaskList() async {
    setState(() {
      isLoading = true;
    });
    myTaskAllList.clear();

    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.TaskList;
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      TaskList myRequest = new TaskList.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });

        print("j&&& $myRequest");
        myTaskAllList = myRequest.resultObject ?? [];
        for (int i = 0; i < myTaskAllList.length; i++) {
          if (myTaskAllList[i].taskStatus) {
            myTaskCompList.add(myTaskAllList[i]);
          } else {
            myTaskPenList.add(myTaskAllList[i]);
          }
        }
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _getTaskList();
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Toast.show("Something went wrong, please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

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
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ),
        body: TabBarView(
          children: [
            TaskPending(data: myTaskPenList),
            TaskCompleted(data: myTaskCompList),
            TaskAll(data: myTaskAllList)
          ],
        ),
      ),
    ));
  }
}
