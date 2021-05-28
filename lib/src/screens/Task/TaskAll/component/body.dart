import 'package:HRMNew/src/screens/Task/TaskPending/component/PODO.dart';
import 'package:flutter/material.dart';

import './background.dart';

class Body extends StatefulWidget {
  final List<ResultObject> taskAll;
  Body({Key key, @required this.taskAll}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(taskAll);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  List<ResultObject> taskAll;

  // var totalDays = 0;

  _BodyState(this.taskAll);
  @override
  Widget build(BuildContext context) {
    print(taskAll.length);
    if (taskAll.length != 0) {
      return Background(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: taskAll.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                      child: new Container(
                        padding: new EdgeInsets.all(15.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(taskAll[index].taskName),
                                ),
                                taskAll[index].taskStatus
                                    ? Text("Completed",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold))
                                    : Text("Pending",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(taskAll[index].taskDetail),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            )
          ],
        ),
      );
    } else {
      return Container(
          child: Center(
        child: Text(
          'No Task.',
          style: TextStyle(fontSize: 20.0),
        ),
      ));
    }
  }
}
