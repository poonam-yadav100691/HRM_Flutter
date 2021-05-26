import 'dart:convert';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/models/balancePodo.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveReqDetails/myLeaveReqDetails.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/PODO/myRequest.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import './background.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final List<ResultObject> leaveList;
  Body({Key key, @required this.leaveList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(leaveList);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  List<ResultObject> leaveList;

  _BodyState(this.leaveList);

  void initState() {
    getLeaveCounts();
    super.initState();
  }

  bool isLoading;
  String _username, firstName, lastName, username, department, image;
  Future<void> getLeaveCounts() async {
    balanceList.clear();
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.LeaveBalance;

    setState(() {
      isLoading = true;
    });
    Map body = {"Tokenkey": token, "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2"};
    http.post(Uri.parse(uri), body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      print("j&&&&&&&&&&&&&&&&&&&&&&&" + jsonResponse.toString());
      GetBalance balance = new GetBalance.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
          username = globalMyLocalPrefes.getString(AppConstant.USERNAME);
          department = globalMyLocalPrefes.getString(AppConstant.DEPARTMENT);
          image = globalMyLocalPrefes.getString(AppConstant.IMAGE);
          balanceList = balance.resultObject;
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          await GetToken().getToken().then((value) {
            getLeaveCounts();
          });
        } else {
          Toast.show("Something went wrong, please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

  List<ResultObject1> balanceList = new List();
  @override
  AnimationController animationController;
  Animation<dynamic> animation;
  Widget build(BuildContext context) {
    // List jsonResponse = jsonDecode(leaveList);

    final children = <Widget>[];
    for (var i = 0; i < leaveList.length; i++) {
      children.add(
        new GestureDetector(
          onTap: () {
            print("leaveList[i].requestID:: ${leaveList[i].requestID}");

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
                planetThumbnail(context, leaveList[i].statusText.toLowerCase()),
              ],
            ),
          ),
        ),
      );
    }
    Size size = MediaQuery.of(context).size;
    return Background(
        child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [

          isLoading
              ?LinearProgressIndicator():Container(),
          AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInToLinear,
                  height: isLoading
                      ?0:size.height * 0.13,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    // BoxShape.circle or BoxShape.retangle
                    color: leaveCardcolor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[800],
                          blurRadius: 4.0,
                          spreadRadius: 1),
                    ],
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var i = 0; i < balanceList.length; i++)
                        _homeSlider(
                            balanceList[i].leaveName,
                            balanceList[i].leaveUse,
                            balanceList[i].leaveTotal,
                            _color[i])
                    ],
                  ),
                ),
          Expanded(
            child: Container(child: ListView(children: children)),
          ),
        ],
      ),
    ));
  }

  var _color = [
    Colors.pink[200],
    Colors.green[100],
    Colors.orange[100],
    Colors.purple[100],
    Colors.blue[100],
    Colors.pink[200],
    Colors.green[100],
    Colors.orange[100],
    Colors.purple[100],
  ];

  Widget _homeSlider(
      String title, String leaveValues, String leaveTotal, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        // shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
        color: leaveCardcolor1,
      ),
      padding: EdgeInsets.all(7),
      child: Container(
        width: 90,
        height: 70,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "$leaveValues / $leaveTotal",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(top: 6)),
              Container(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget planetThumbnail(BuildContext context, String statusText) {
    // _onDateRangeSelect(leaveList.strDate, leaveList.endDate);
    return Container(
      child: new Image(
        image: new AssetImage(
            "lib/assets/images/${statusText[0].toLowerCase()}${statusText.substring(1)}.png"),
        height: 40.0,
        width: 40.0,
      ),
    );
  }

  Widget planetCard(BuildContext context, leaveList) {
    var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss a');
    var outputFormat = DateFormat('dd/MM/yy');
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
                  leaveList.submitDate != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            children: [
                              Text(
                                getTranslated(context, 'dateofrequest'),
                                style: new TextStyle(),
                              ),
                              Text(
                                " : " + returnDate,
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
                              getTranslated(context, 'manager'),
                              style: new TextStyle(),
                            ),
                            Text(
                              " : " + leaveList.managerName,
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
