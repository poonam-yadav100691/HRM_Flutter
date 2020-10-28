import 'package:HRMNew/src/models/notiList.dart';
import 'package:flutter/material.dart';

import './background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<NotiList> notiLists = [
    NotiList(
        title: 'Bill Will',
        profileImg: 'img/pic-1.png',
        desc: "Software Developer",
        date: '20/02/20'),
    NotiList(
        title: 'Andy Smith',
        profileImg: 'img/pic-2.png',
        desc: "UI Designer",
        date: '20/02/20'),
    NotiList(
        title: 'Creepy Story',
        profileImg: 'img/pic-3.png',
        desc: "Software Tester",
        date: '20/02/20')
  ];

  Widget notiDetailCard(NotiList) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
      // decoration: new BoxDecoration(color: Colors.blue),
      // child: new Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   // mainAxisSize: MainAxisSize.min,
      //   children: [
      child: new Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  Icon(
                    Icons.notification_important,
                    size: 20,
                    color: Colors.orange,
                  ),

                  // new Placeholder(),
                ],
              ),
            ),
            Container(
              // color: Colors.pink,
              width: size.width * 0.8,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          NotiList.title,
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          NotiList.date,
                          style: new TextStyle(fontSize: 14.0),
                        ), // new Placeholder(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          NotiList.desc,
                          style: new TextStyle(fontSize: 14.0),
                        ),
                        // new Placeholder(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: notiLists.map((p) {
            return notiDetailCard(p);
          }).toList()
          // SizedBox(height: size.height * 0.03),

          ),
    );
  }
}
