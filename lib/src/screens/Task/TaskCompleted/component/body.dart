import 'package:HRMNew/src/screens/Task/TaskPending/component/PODO.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatefulWidget {
  final List<ResultObject> taskComList;
  Body({Key key, @required this.taskComList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(taskComList);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  List<ResultObject> taskComList;

  // var totalDays = 0;

  _BodyState(this.taskComList);
  @override
  Widget build(BuildContext context) {
    print(taskComList.length);
    if (taskComList.length != 0) {
      return Background(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: taskComList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                      child: new Container(
                        padding: new EdgeInsets.all(15.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(taskComList[index].taskName),
                            ),
                            Text(taskComList[index].taskDetail),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    } else {
      return Container(
          child: Center(
        child: Text(
          'No Completed Task.',
          style: TextStyle(fontSize: 20.0),
        ),
      ));
    }
  }
}
