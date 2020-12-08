import 'package:HRMNew/routes/route_names.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // bool valuefirst = false;
  List<bool> valuefirst = new List<bool>();
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      for (int i = 0; i < 4; i++) {
        valuefirst.add(false);
      }
    });
  }

  void ItemChange(bool val, int index) {
    setState(() {
      valuefirst[index] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, addTaskRoute);
              },
              child: Card(
                child: new Container(
                  // padding: new EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Task'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              )),
          Expanded(
            child: ListView.builder(
                itemCount: valuefirst.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(0.0),
                      child: new Column(
                        children: <Widget>[
                          new CheckboxListTile(
                              activeColor: Colors.green,
                              value: valuefirst[index],
                              title: new Text('Task ${index + 1}'),
                              subtitle: Text('Subtitle Task ${index + 1}'),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool val) {
                                ItemChange(val, index);
                              })
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
