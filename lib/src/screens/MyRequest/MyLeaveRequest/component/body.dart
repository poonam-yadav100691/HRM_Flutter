import 'dart:convert';

import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveReqDetails/myLeaveReqDetails.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/PODO/myRequest.dart';
import 'package:flutter/material.dart';
import './background.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  final List<ResultObject> leaveList;
  Body({Key key, @required this.leaveList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(leaveList);
}

class _BodyState extends State<Body> {
  List<ResultObject> leaveList;

  // var totalDays = 0;

  _BodyState(this.leaveList);

  // void _onDateRangeSelect(startdate, enddate) async {
  //   DateTime tempDate1 =
  //       new DateFormat("MM/dd/yyyy hh:mm:ss a").parse(startdate);
  //   DateTime tempDate = new DateFormat("MM/dd/yyyy hh:mm:ss a").parse(enddate);
  //   print("enddate-- ${tempDate}");
  //   print("startdate ${tempDate1}");

  //   // DateTime tempDate = DateTime.parse(startdate);
  //   // new DateFormat("MM-dd-yyyy hh:mm:ss a").parse(startdate);

  //   final startDate = tempDate1;
  //   final endDate = tempDate;
  //   final difference = await endDate.difference(startDate).inDays;
  //   setState(() {
  //     totalDays = difference;
  //   });
  //   print(difference);
  // }

  @override
  Widget build(BuildContext context) {
    // List jsonResponse = jsonDecode(leaveList);
    final children = <Widget>[];
    for (var i = 0; i < leaveList.length; i++) {
      children.add(
        new GestureDetector(
          onTap: () {
            print("leaveList[i].requestID:: ${leaveList[i].requestID}");
            // Navigator.pushNamed(context, myLeaveReqDetails,
            //     arguments: {'levReqDetailID': leaveList[i].requestID});

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MyLeaveReqDetails(levReqDetailID: leaveList[i].requestID),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: new Stack(
              children: <Widget>[
                planetCard(context, leaveList[i]),
                planetThumbnail(context, leaveList[i]),
              ],
            ),
          ),
        ),
      );
    }
    Size size = MediaQuery.of(context).size;
    return Background(child: ListView(children: children));
  }

  Widget planetThumbnail(BuildContext context, leaveList) {
    // _onDateRangeSelect(leaveList.strDate, leaveList.endDate);
    return Container(
      child: new Image(
        image: new AssetImage(
            "lib/assets/images/" + leaveList.statusText + ".png"),
        height: 40.0,
        width: 40.0,
      ),
    );
  }

  Widget planetCard(BuildContext context, leaveList) {
    var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss a');
    var outputFormat = DateFormat('dd/MM/yy');
    // var inputDate = inputFormat.parse(leaveList.strDate);
    // var startDate = outputFormat.format(inputDate);
    // var inputDate1 = inputFormat.parse(leaveList.endDate);
    // var endDate = outputFormat.format(inputDate1);
    var inputDate2 =
        inputFormat.parse(leaveList.submitDate); // <-- Incoming date
    var returnDate = outputFormat.format(inputDate2); // <-- Desired date

    return Container(
      // width: MediaQuery.of(context).size.width * 0.88,
      margin: new EdgeInsets.fromLTRB(21.0, 0, 0, 0),
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
        padding: EdgeInsets.only(left: 20),
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
                            leaveList.requestNo != null
                                ? Text(
                                    leaveList.requestNo,
                                    style: new TextStyle(
                                        color: kRedColor,
                                        fontWeight: FontWeight.w500),
                                  )
                                : Container(),
                          ],
                        ),
                      ),

                      leaveList.statusText != null
                          ? Text(
                              leaveList.statusText,
                              style: new TextStyle(
                                  color: kRedColor,
                                  fontWeight: FontWeight.w500),
                            )
                          : Container(),

                      // totalDays.toString(),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 5.0),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         startDate + "  To  " + endDate,
                  //         style: new TextStyle(fontWeight: FontWeight.w500),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  leaveList.submitDate != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            children: [
                              Text(
                                'Date Of Request :',
                                style: new TextStyle(),
                              ),
                              Text(
                                returnDate,
                                style:
                                    new TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  leaveList.submitDate != null
                      ? Row(
                          children: [
                            Text(
                              'Manager :',
                              style: new TextStyle(),
                            ),
                            Text(
                              leaveList.managerName,
                              style: new TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
