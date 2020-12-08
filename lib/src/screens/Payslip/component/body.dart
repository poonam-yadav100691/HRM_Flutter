import 'package:HRMNew/src/models/notiList.dart';
import 'package:HRMNew/src/screens/Payslip/PayslipDesc/payslipDesc.dart';
import 'package:flutter/material.dart';

import './background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<NotiList> notiLists = [
    NotiList(
        title: 'SlipNo.3030',
        profileImg: 'img/pic-1.png',
        desc: "Short desc",
        date: 'Jan20'),
    NotiList(
        title: 'PayslipNo.#030',
        profileImg: 'img/pic-2.png',
        desc: "Salary 20/2/20",
        date: 'Feb20'),
    NotiList(
        title: 'SlipNo.3030',
        profileImg: 'img/pic-3.png',
        desc: "Salary 03",
        date: 'Mar20')
  ];

  void takeAction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PayslipDesc()),
    );
  }

  Widget notiDetailCard(NotiList) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
      // decoration: new BoxDecoration(color: Colors.blue),
      // child: new Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   // mainAxisSize: MainAxisSize.min,
      //   children: [
      child: new InkWell(
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    Center(
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        // padding: EdgeInsets.all(10),
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                NotiList.date,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          // color: Colors.yellow,
                        ),
                      ),
                    ),

                    // new Placeholder(),
                  ],
                ),
              ),
              Container(
                // color: Colors.pink,
                width: size.width * 0.76,
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
                          // Text(
                          //   NotiList.date,
                          //   style: new TextStyle(fontSize: 14.0),
                          // ), // new Placeholder(),
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
        onTap: () => takeAction(),
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
