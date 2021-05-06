import 'dart:convert';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/EmpRequest/RequestDetails/requestDetails.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveReqDetails/myLeaveReqDetails.dart';
import 'package:flutter/material.dart';
import '../../empRequestPODO.dart';
import './background.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  final List<ResultObject> empOtList;
  Body({Key key, @required this.empOtList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(empOtList);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  List<ResultObject> empOtList;

  // var totalDays = 0;

  _BodyState(this.empOtList);

  @override
  AnimationController animationController;
  Animation<dynamic> animation;

  Widget build(BuildContext context) {
    // List jsonResponse = jsonDecode(empOtList);
    final children = <Widget>[];
    for (var i = 0; i < empOtList.length; i++) {
      children.add(new GestureDetector(
        onTap: () {
          print("empOtList[i].requestID:: ${empOtList[i].requestID}");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MyLeaveReqDetails(levReqDetailID: empOtList[i].requestID),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: planetCard(
            context,
            empOtList[i],
          ),
        ),
      ));
    }
    return Background(child: ListView(children: children));
  }

  Widget planetCard(BuildContext context, ResultObject object) {
    Size size = MediaQuery.of(context).size;

    var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss a');
    var outputFormat = DateFormat('dd/MM/yy');
    var inputDate2 = inputFormat.parse(object.dateRequest); // <-- Incoming date
    var returnDate = outputFormat.format(inputDate2);

    return InkWell(
      child: Container(
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
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: 13,
                      height: 65.0,
                      // color: Colors.pink,
                      child: new Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0)),
                          color: Colors.green,
                        ),
                      )),
                  Expanded(
                    child: Row(
                      children: [
                        object.empPhoto==null?Container():  Container(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: ClipOval(
                            child: Image.memory(
                              base64Decode(object.empPhoto),
                              height: 47,
                              width: 47,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: size.width * 0.70,
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      object.empName,
                                      style: new TextStyle(
                                          color: kRedColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      returnDate,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                object.empPosition,
                                style: new TextStyle(),
                              ),
                              Text(
                                object.requestID,
                                style: new TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RequestDetails(
                      levReqDetailID: object.requestID,
                    )));
      },
    );
  }
}
