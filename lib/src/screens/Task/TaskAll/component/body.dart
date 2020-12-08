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
          Expanded(
            child: ListView.builder(
                itemCount: valuefirst.length,
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
                            child: Text('Task ${index + 1}'),
                          ),
                          Text('Subtitle Task ${index + 1}'),
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
