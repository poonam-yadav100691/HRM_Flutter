import 'dart:convert';

import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/PODO/myRequest.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatefulWidget {
  final List<ResultObject> leaveList;
  Body({Key key, @required this.leaveList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(leaveList);
}

class _BodyState extends State<Body> {
  List<ResultObject> leaveList;

// MyRequests myRequest = new MyRequests.fromJson(leaveList);
//         print("j&&& $myRequest");
//         myRequestList = myRequest.resultObject;
//        print("myRequestList $myRequestList");
  _BodyState(this.leaveList);

  @override
  Widget build(BuildContext context) {
    // List jsonResponse = jsonDecode(leaveList);
    print("############statusText## $leaveList");
    // print("@@@@@@@@@@@@@@@@ $jsonResponse");
    final children = <Widget>[];
    for (var i = 0; i < leaveList.length; i++) {
      children.add(new Column(
        children: [
          new Container(
              margin: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0,
              ),
              child: new Stack(
                children: <Widget>[
                  // new ListView(
                  //   children: children,
                  // )
                  planetCard(context, leaveList),
                  planetThumbnail,
                ],
              )),
        ],
      ));
    }
    Size size = MediaQuery.of(context).size;
    return Background(child: ListView(children: children));
  }

  final planetThumbnail = new Container(
    // margin: new EdgeInsets.symmetric(vertical: double.maxFinite * 0.5),
    // color: Colors.pink,
    // alignment: FractionalOffset.centerLeft,
    child: new Image(
      image: new AssetImage("lib/assets/images/cancel.png"),
      height: 50.0,
      width: 50.0,
    ),
  );
  Widget planetCard(BuildContext context, leaveList) {
    // print(leaveList);
    return Container(
      // width: MediaQuery.of(context).size.width * 0.88,
      margin: new EdgeInsets.only(left: 26.0),
      decoration: new BoxDecoration(
        color: kWhiteColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: kGreyLightColor,
            blurRadius: 5.0,
            offset: new Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              leaveList.requestTitle,
                              style: new TextStyle(
                                  color: kRedColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Full Day',
                              style: new TextStyle(),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '2.0 days ',
                        style: new TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: [
                        Text(
                          '13 Mar 20 - 14 Mar 20',
                          style: new TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'Date Of Reply :',
                          style: new TextStyle(),
                        ),
                        Text(
                          '13 Mar 20',
                          style: new TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Manager :',
                        style: new TextStyle(),
                      ),
                      Text(
                        'Ta Manager',
                        style: new TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
