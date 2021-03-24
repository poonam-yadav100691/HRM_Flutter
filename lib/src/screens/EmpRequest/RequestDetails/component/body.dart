

import 'package:HRMNew/components/approvalAction.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/EmpRequest/RequestDetails/empReqDetailPODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:HRMNew/utils/UIhelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import './background.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final String data;
  Body({Key key, @required this.data}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(data);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  String data;
  final _formKey = GlobalKey<FormState>();

  List<RequestTitleObject> myReqTitleObj = new List();
  List<ApprovedObject> approvedObject = [];
  List<RequestItemObject> requestItemObject = new List();
  bool isLoading = true;

  int totalDays;

  String errortext;
  _BodyState(this.data);

  @override
  void initState() {
    super.initState();
    String empLevId = widget.data;
      _getEmpReqDetails(empLevId);
  }

  void takeAction(text) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApprovalAction(text)),
    );
  }



  int totalDayss;

  DateTime strDate,endDate;

  int _onDateRangeSelect(String startDate, String endstrDate) {
    DateFormat format = DateFormat.yMd();

    strDate = format.parse(startDate);
    endDate = format.parse(endstrDate);

    print('$strDate  $endDate ');
    final difference = endDate.difference(strDate).inDays;

     return difference;


  }

  Future<void> _getEmpReqDetails(reqID) async {
    print("reqID:::$reqID");
    setState(() {
      isLoading = true;
    });
    myReqTitleObj.clear();
    approvedObject.clear();
    requestItemObject.clear();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);

    final uri = Services.EmpRequestDetails;
    Map body = {"Tokenkey": token, "requestID": reqID, "lang": '2'};

    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("R2 : $jsonResponse");
      EmpReqDetails getLevReqDetails = new EmpReqDetails.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        myReqTitleObj = getLevReqDetails.requestTitleObject??[];
        approvedObject = getLevReqDetails.approvedObject??[];
        requestItemObject = getLevReqDetails.requestItemObject??[];

        setState(() {
          isLoading = false;
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _getEmpReqDetails(reqID);
          });
          // Future<String> token = getToken();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  TextEditingController resoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("data ((((...$data");
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, addRequestRoute);
          // Add your onPressed code here!
        },
        elevation: 4,
        child: Icon(
          Icons.calendar_today,
        ),
        backgroundColor: Colors.pink,
      ),
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: (myReqTitleObj.isEmpty && (isLoading))
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()))
          : Background(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, .15),
                              blurRadius: 16.0)
                        ],
                      ),
                      margin: EdgeInsets.all(15),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  // Icon(Icons.arrow_back_ios),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        "lib/assets/images/profile.jpg",
                                        height: 55,
                                        // width: 90,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(myReqTitleObj[0].empName,
                                              style: TextStyle(
                                                  fontSize: 19.0,
                                                  fontWeight: FontWeight.bold)),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                                myReqTitleObj[0].empPosition,
                                                style:
                                                    TextStyle(fontSize: 14.0)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.phone),
                                    ),
                                    onTap: () => launch(
                                        "tel://" + myReqTitleObj[0].empContact),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                            Text('${requestItemObject.length}'),
                            // requestItemObject.length > 0 ||
                            //         requestItemObject[0].strDate != null
                            //     ? Padding(
                            //         padding:
                            //             const EdgeInsets.symmetric(vertical: 8),
                            //         child: Text(
                            //             'Period: ${(requestItemObject[0].strDate).substring(0, 9)} - ${requestItemObject[0].endDate.substring(0, 9)}'),
                            //       )
                            //     : Container(),
                            SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Duration: ${requestItemObject.isNotEmpty?requestItemObject[0].duration:""}'),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Request Status: ${myReqTitleObj[0].statusText}'),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Reason: ${requestItemObject[0].requestReason}'),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Manager: ${requestItemObject[0].responseName}'),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),

                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Requested For: ${requestItemObject[0].requestFor}'),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: TextFormField(
                                decoration: new InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  contentPadding: EdgeInsets.only(
                                      bottom: 10.0, left: 10.0, right: 10.0),
                                  // suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  labelText: 'Comment',
                                  errorText: errortext,
                                ),
                                controller: resoneController,
                                onChanged: (str) {
                                  setState(() {
                                    errortext = null;
                                  });
                                },


                              ),
                            ),

                            Padding(padding: EdgeInsets.symmetric(vertical: 8,),


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(onPressed:() async{

                                  if(resoneController.text!="") {
                                    setState(() {
                                      isLoading = true;
                                    });

                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();
                                        String token =
                                            sharedPreferences.getString(
                                                AppConstant.ACCESS_TOKEN);
                                        final uri = Services.RejectLeave;
                                        Map body = {
                                          "TokenKey": token,
                                          "lang": '2',
                                          "requestID":
                                              myReqTitleObj[0].requestID,
                                          "rejectDescription":
                                              resoneController.text ?? " ",
                                        };

                                        print('$body');
                                        http
                                            .post(uri, body: body)
                                            .then((response) {
                                          var jsonResponse =
                                              jsonDecode(response.body);
                                          // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);
                                          if (jsonResponse["StatusCode"] ==
                                              200) {
                                            setState(() {
                                              isLoading = false;
                                            });

                                            print("j&&& $jsonResponse");
                                            Navigator.pop(context);
                                          } else {
                                            print(
                                                "ModelError: ${jsonResponse["ModelErrors"]}");
                                            if (jsonResponse["ModelErrors"] ==
                                                'Unauthorized') {
                                              Future<String> token =
                                                  GetToken().getToken();
                                            } else {
                                              // .showSnackBar(
                                              //     currentState   UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
                                            }
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          errortext = "Please Enter Comment";
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Reject',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.red,
                                  ),
                                  RaisedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      String token = sharedPreferences
                                          .getString(AppConstant.ACCESS_TOKEN);
                                      final uri = Services.ApproveLeave;
                                      Map body = {
                                        "TokenKey": token,
                                        "lang": '2',
                                        "requestID": myReqTitleObj[0].requestID,
                                        "rejectDescription":
                                            resoneController.text ?? " ",
                                        "approveby": sharedPreferences
                                            .getString(AppConstant.EMP_ID),
                                        "approvedescription":
                                            resoneController.text ?? " ",
                                      };

                                  print('$body');
                                  http.post(uri, body: body).then((response) {
                                    var jsonResponse = jsonDecode(response.body);
                                    // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);
                                    if (jsonResponse["StatusCode"] == 200) {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      print("j&&& $jsonResponse");
                                      Navigator.pop(context);



                                    } else {
                                      print("ModelError: ${jsonResponse["ModelErrors"]}");
                                      if (jsonResponse["ModelErrors"] == 'Unauthorized') {
                                        Future<String> token = GetToken().getToken();
                                      } else {
                                        // .showSnackBar(
                                        //     currentState   UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
                                      }
                                    }
                                  });

                                },
                                  child: Text('Approve',style: Theme.of(context).textTheme.button.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
                                  color: Colors.green,
                                ),

                              ],
                            ),
                            ),
                            isLoading?LinearProgressIndicator():Container(),

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
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 70),
                        child: Column(
                          children: getApproveObjects(),
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> getApproveObjects() {
    List<Widget> list = [];

    if (approvedObject.isNotEmpty) {
      approvedObject.forEach((element) {
        list.add(planetCard(context, element.approvedName, element.comment,
            element.approvedDate));
      });
    }
    return list;
  }

  List<Widget> getRequestedLeaves() {
    List<Widget> list = [];

    myReqTitleObj.forEach((element) {
      //todo pending implementation of my request

      // list.add(Column(
      //   children: [
      //     _itemBuilder(
      //         'Leave Type : ', element.requestType),
      //     SizedBox(
      //       width: size.width,
      //       height: 1.0,
      //       child: Container(
      //         color: Colors.grey[300],
      //       ),
      //     ),
      //     _itemBuilder('Period : ', element.dateRequest),
      //     SizedBox(
      //       width: size.width,
      //       height: 1.0,
      //       child: Container(
      //         color: Colors.grey[300],
      //       ),
      //     ),
      //     _itemBuilder('Duration : ', element.),
      //     SizedBox(
      //       width: size.width,
      //       height: 1.0,
      //       child: Container(
      //         color: Colors.grey[300],
      //       ),
      //     ),
      //     _itemBuilder(
      //         'Note : ', "Attendance brother-in-law'\s marriage"),
      //     SizedBox(
      //       width: size.width,
      //       height: 1.0,
      //       child: Container(
      //         color: Colors.grey[300],
      //       ),
      //     ),
      //     _itemBuilder('Manager : ', 'Ta Manager'),
      //     SizedBox(
      //       width: size.width,
      //       height: 1.0,
      //       child: Container(
      //         color: Colors.grey[300],
      //       ),
      //     ),
      //     _itemBuilder(
      //         'Leave Entry At : ', '12 Mar 2020 - 11:04 AM'),
      //     SizedBox(
      //       width: size.width,
      //       height: 1.0,
      //       child: Container(
      //         color: Colors.grey[300],
      //       ),
      //     ),
      //     Form(
      //       key: _formKey,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Padding(
      //             padding: const EdgeInsets.only(
      //                 top: 10.0, bottom: 10),
      //             child: TextFormField(
      //               maxLines: 4,
      //               scrollPadding: EdgeInsets.all(10),
      //               textAlign: TextAlign.start,
      //               decoration: new InputDecoration(
      //                 fillColor: Colors.white,
      //                 border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.all(
      //                         Radius.circular(5.0)),
      //                     borderSide:
      //                     BorderSide(color: leaveCardcolor)),
      //                 filled: true,
      //                 contentPadding: EdgeInsets.only(
      //                     bottom: 10.0,
      //                     left: 10.0,
      //                     right: 10.0,
      //                     top: 16),
      //                 labelText: "Manager Reason",
      //               ),
      //               validator: (value) {
      //                 if (value.isEmpty) {
      //                   return 'Please enter reason here..';
      //                 }
      //                 return null;
      //               },
      //             ),
      //           ),
      //           Row(
      //             mainAxisAlignment:
      //             MainAxisAlignment.spaceEvenly,
      //             children: <Widget>[
      //               RaisedButton(
      //                 color: Colors.red,
      //                 child: Text(
      //                   'REJECT',
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 16.0),
      //                 ),
      //                 onPressed: () {
      //                   if (_formKey.currentState.validate()) {
      //                     takeAction("Reject");
      //                   }
      //                 },
      //
      //                 ///_handleLogout()
      //               ),
      //               RaisedButton(
      //                 color: Colors.green,
      //                 child: Text(
      //                   'APPROVE',
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                       color: kWhiteColor,
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 16.0),
      //                 ),
      //                 onPressed: () {
      //                   if (_formKey.currentState.validate()) {
      //                     takeAction("Approve");
      //                   }
      //                 },
      //               ),
      //               // )),
      //             ],
      //           )
      //         ],
      //       ),
      //     )
      //     ,
      //   ]
      //   ,
      // ););
    });
  }
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
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: size.width * 0.7,
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
