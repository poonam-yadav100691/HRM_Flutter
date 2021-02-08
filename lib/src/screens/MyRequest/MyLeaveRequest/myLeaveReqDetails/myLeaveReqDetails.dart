import 'dart:convert';

import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/Account/component/background.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveReqDetails/myLevReqDetailPODO.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    print("reqID---:::${widget.levReqDetailID}");
    String levDetails = widget.levReqDetailID;
    _getReqDetails(levDetails);
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

        print("j&&& $getLevReqDetails");
        myReqTitleObj = getLevReqDetails.requestTitleObject;
        approvedObject = getLevReqDetails.approvedObject;
        requestItemObject = getLevReqDetails.requestItemObject;

        // print(getLevReqDetailsList.toString());
        // print(leaveReqList.toString());
        // print(otReqList.toString());
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
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
                                            // leaveList.requestNo != null?
                                            Text(
                                              "Request No. : XXXXX",
                                              style: new TextStyle(
                                                  color: kRedColor,
                                                  fontWeight: FontWeight.w500),
                                            )
                                            // : Container(),
                                          ],
                                        ),
                                      ),

                                      // leaveList.statusText != null
                                      // ?
                                      Text(
                                        "leaveList.statusText",
                                        style: new TextStyle(
                                            color: kRedColor,
                                            fontWeight: FontWeight.w500),
                                      )
                                      // : Container(),

                                      // totalDays.toString(),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Date Of Request :',
                                          style: new TextStyle(),
                                        ),
                                        Text(
                                          "returnDate",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // : Container(),
                                  // leaveList.submitDate != null?
                                  Row(
                                    children: [
                                      Text(
                                        'Manager :',
                                        style: new TextStyle(),
                                      ),
                                      Text(
                                        "leaveList.managerName",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                  // : Container(),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                      child: planetCard(
                          context,
                          "Team Lead",
                          "Remark here... text remark here..",
                          '04/09/2020 10:30AM'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                      child: leaveReqItems(
                          context,
                          "Team Lead",
                          "Remark here... text remark here..",
                          '04/09/2020 10:30AM'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                      child: leaveReqItems(
                          context,
                          "Team Lead",
                          "Remark here... text remark here..",
                          '04/09/2020 10:30AM'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }

  Widget leaveReqItems(BuildContext context, name, remark, date) {
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // leaveList.requestNo != null?
                                Text(
                                  "Leave Type : Personal Leave (Full Day)",
                                  style: new TextStyle(
                                      color: kRedColor,
                                      fontWeight: FontWeight.w500),
                                )
                                // : Container(),
                              ],
                            ),
                          ),
                          Text(
                            "5 Days",
                            style: new TextStyle(
                                color: kRedColor, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            Text(
                              'Period : ',
                              style: new TextStyle(),
                            ),
                            Text(
                              "01/02/2020 - 05/02/2020",
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
                              'Return Date :',
                              style: new TextStyle(),
                            ),
                            Text(
                              "06/02/2020",
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
                              'Reason : ',
                              style: new TextStyle(),
                            ),
                            Text(
                              "Reason desc here text here.....",
                              style: new TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Delegation : ',
                            style: new TextStyle(),
                          ),
                          Text(
                            "Mr. Reason desc",
                            style: new TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
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
                        // Container(
                        //   padding: const EdgeInsets.only(left: 6.0),
                        //   child: ClipOval(
                        //     child: Image.asset(
                        //       "lib/assets/images/profile.jpg",
                        //       height: 47,
                        //       // width: 90,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: size.width * 0.65,
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
