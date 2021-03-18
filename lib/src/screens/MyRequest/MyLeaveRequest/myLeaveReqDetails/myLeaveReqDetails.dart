import 'dart:convert';

import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/Account/component/background.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveReqDetails/myLevReqDetailPODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

class MyLeaveReqDetails extends StatefulWidget {
  final String levReqDetailID;
  MyLeaveReqDetails({Key key, @required this.levReqDetailID}) : super(key: key);

  @override
  _MyLeaveReqDetailsState createState() => _MyLeaveReqDetailsState();
}

class _MyLeaveReqDetailsState extends State<MyLeaveReqDetails> {
  String levReqDetailID;
  // _MyLeaveReqDetailsState(this.levReqDetailID);
  final _formKey = GlobalKey<FormState>();

  List<RequestTitleObject> myReqTitleObj = new List();
  List<ApprovedObject> approvedObject = new List();
  List<RequestItemObject> requestItemObject = new List();
  bool isLoading = true;

  int totalDays;

  @override
  void initState() {
    super.initState();
    String levDetails = widget.levReqDetailID;
    _getReqDetails(levDetails);
  }

  void _onDateRangeSelect(startdate, enddate) async {
    DateTime tempDate1 =
        new DateFormat("MM/dd/yyyy hh:mm:ss a").parse(startdate);
    DateTime tempDate = new DateFormat("MM/dd/yyyy hh:mm:ss a").parse(enddate);

    final startDate = tempDate1;
    final endDate = tempDate;
    final difference = await endDate.difference(startDate).inDays;
    setState(() {
      totalDays = difference;
    });
    print(difference);
  }

  List<Widget> _getrequestItemObjectUI() {
    List<Widget> list = [];
    if (requestItemObject != null) {
      for (var rqtItmObj in requestItemObject)
        leaveReqItems(context, rqtItmObj);
    } else {
      list.add(Container());
    }
    return list;
  }

  List<Widget> _getapprovedObjectUI() {
    List<Widget> list = [];
    if (approvedObject != null) {
      for (var apprvObj in approvedObject) {
        list.add(planetCard(context, apprvObj.approvedName, apprvObj.comment,
            apprvObj.approvedDate));
      }
    } else {
      list.add(Container());
    }
    return list;
  }

  Future<void> _getReqDetails(reqID) async {
    print("reqID:::$reqID");
    setState(() {
      isLoading = true;
    });
    myReqTitleObj.clear();
    approvedObject.clear();
    requestItemObject.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.MyLevReqDetails;
    Map body = {"Tokenkey": token, "requestID": reqID, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("Reponse---2 : $jsonResponse");
      GetLevReqDetails getLevReqDetails =
          new GetLevReqDetails.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });

        myReqTitleObj = getLevReqDetails.requestTitleObject;
        approvedObject = getLevReqDetails.approvedObject;
        requestItemObject = getLevReqDetails.requestItemObject;
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _getReqDetails(reqID);
          });
          // Future<String> token = getToken();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  Future<void> cancelMyRequest(reqID) async {
    print("reqID66:::$reqID");
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.CancelMyrequest;
    Map body = {"Tokenkey": token, "requestID": reqID, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("Reponse---44432222 : $jsonResponse");

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, myRequestRoute);
      } else {
        setState(() {
          isLoading = false;
        });
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            cancelMyRequest(reqID);
          });

          // Future<String> token = getToken();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (!isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Request Details'),
        ),
        body: Background(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.88,
                      margin: new EdgeInsets.all(10),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            myReqTitleObj[0].requestID != null
                                                ? Text(
                                                    "Request No. : " +
                                                        myReqTitleObj[0]
                                                            .requestID,
                                                    style: new TextStyle(
                                                        color: kRedColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),

                                      myReqTitleObj[0].statusText != null
                                          ? Text(
                                              myReqTitleObj[0].statusText,
                                              style: new TextStyle(
                                                  color: kRedColor,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Container(),

                                      // totalDays.toString(),
                                    ],
                                  ),

                                  myReqTitleObj[0].submitDate != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Date Of Request : ',
                                                style: new TextStyle(),
                                              ),
                                              Text(
                                                myReqTitleObj[0].submitDate,
                                                style: new TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  // : Container(),
                                  myReqTitleObj[0].managerName != null
                                      ? Row(
                                          children: [
                                            Text(
                                              'Manager : ',
                                              style: new TextStyle(),
                                            ),
                                            Text(
                                              myReqTitleObj[0].managerName,
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w500),
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
                    ),
                    Container(
                      width: size.width * .9,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Previous Manager's Notes",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                        child: Column(
                          children: _getapprovedObjectUI(),
                        )),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                        child: Column(
                          children: _getrequestItemObjectUI(),
                        )),
                    (myReqTitleObj[0].statusText != null &&
                            myReqTitleObj[0].statusText == 'Pending')
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                            child: Column(children: [
                              OutlineButton(
                                onPressed: () {
                                  cancelMyRequest(myReqTitleObj[0].requestID);
                                },
                                child: Text('Cancel Request',
                                    style: TextStyle(color: Colors.red)),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              )
                            ]))
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Request Details'),
          ),
          body: Background(child: Center(child: CircularProgressIndicator())));
    }
  }

  Widget leaveReqItems(BuildContext context, reqItmObj) {
    var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss a');
    var outputFormat = DateFormat('dd/MM/yy');
    var inputDate = inputFormat.parse(reqItmObj.strDate);
    var startDate = outputFormat.format(inputDate);

    var inputDate1 = inputFormat.parse(reqItmObj.endDate);
    var endDate = outputFormat.format(inputDate1);

    var inputDate2 = inputFormat.parse(reqItmObj.returnDate);
    var returnDate = outputFormat.format(inputDate2);

    Size size = MediaQuery.of(context).size;
    return Container(
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
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                            child: reqItmObj.itemType != null
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Leave Type : ",
                                        style: new TextStyle(
                                            color: kRedColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      reqItmObj.itemType != null
                                          ? Text(
                                              reqItmObj.itemType,
                                              style: new TextStyle(
                                                  color: kRedColor,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Container(),
                                      reqItmObj.requestFor != null
                                          ? Text(
                                              "(" + reqItmObj.itemType + ")",
                                              style: new TextStyle(
                                                  color: kRedColor,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Container(),
                                    ],
                                  )
                                : Container(),
                          ),
                          Text(
                            reqItmObj.duration + " day",
                            style: new TextStyle(
                                color: kRedColor, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      startDate != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Period : ',
                                    style: new TextStyle(),
                                  ),
                                  Text(
                                    startDate + " To " + endDate,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      returnDate != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Return Date :',
                                    style: new TextStyle(),
                                  ),
                                  Text(
                                    returnDate,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      reqItmObj.requestReason != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Reason : ',
                                    style: new TextStyle(),
                                  ),
                                  Text(
                                    reqItmObj.requestReason,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      reqItmObj.responseName != null
                          ? Row(
                              children: [
                                Text(
                                  'Delegation : ',
                                  style: new TextStyle(),
                                ),
                                Text(
                                  reqItmObj.responseName,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget planetCard(BuildContext context, name, remark, date) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: size.width * 0.83,
                                padding: EdgeInsets.only(bottom: 10),
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
                                      date,
                                      textAlign: TextAlign.right,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                remark,
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
    );
  }

  Widget _itemBuilder(label, textValue) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15),
            child: Row(
              children: [
                Text(
                  label,
                  style: new TextStyle(fontWeight: FontWeight.w400),
                ),
                Text(
                  textValue,
                  style: new TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
