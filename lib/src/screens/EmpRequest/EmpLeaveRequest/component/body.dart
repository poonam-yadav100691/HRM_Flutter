import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/EmpRequest/RequestDetails/requestDetails.dart';
import 'package:flutter/material.dart';
import '../../empRequestPODO.dart';
import './background.dart';

import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  final List<ResultObject> empLeaveList;
  Body({Key key, @required this.empLeaveList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(empLeaveList);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  List<ResultObject> empLeaveList;

  // var totalDays = 0;

  _BodyState(this.empLeaveList);

  @override
  AnimationController animationController;
  Animation<dynamic> animation;
  Widget build(BuildContext context) {
    // List jsonResponse = jsonDecode(empLeaveList);
    final children = <Widget>[];
    if (empLeaveList != null) {
      for (var i = 0; i < empLeaveList.length; i++) {
        print(empLeaveList[i].toJson());
        children.add(
          new Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: planetCard(
                context,
                empLeaveList[i].empName,
                empLeaveList[i].empPosition,
                empLeaveList[i].dateRequest,
                empLeaveList[i].requestID),
          ),
        );
      }
    } else {
      children.add(Container());
    }
    Size size = MediaQuery.of(context).size;
    return Background(child: ListView(children: children));
  }
  // Widget build(BuildContext context) {
  //   return Background(

  //       child: Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: planetCard(context, "Juil", "Backend Developer", '29/09/2020'),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(
  //             bottom: 5.0, top: 5.0, left: 10.0, right: 10),
  //         child:
  //             planetCard(context, "Mike", "Front End Developer", '04/09/2020'),
  //       ),
  //     ],
  //   ));
  // }

  Widget planetCard(BuildContext context, name, design, date, id) {
    var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss a');
    var outputFormat = DateFormat('dd/MM/yy');
    var inputDate2 = inputFormat.parse(date); // <-- Incoming date
    var returnDate = outputFormat.format(inputDate2);

    Size size = MediaQuery.of(context).size;
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
                        Container(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: ClipOval(
                            child: Image.asset(
                              "lib/assets/images/profile.jpg",
                              height: 47,
                              // width: 90,
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
                                      name,
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
                                design,
                                style: new TextStyle(),
                              ),
                              Text(
                                "Request Id: " + id,
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
        print("empLeaveList[i].requestID:: ${id}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestDetails(levReqDetailID: id),
          ),
        );
      },
    );
  }
}
