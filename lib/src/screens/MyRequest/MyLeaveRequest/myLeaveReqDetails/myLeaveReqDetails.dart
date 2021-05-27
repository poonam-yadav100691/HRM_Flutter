import 'dart:convert';
import 'dart:typed_data';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/Account/component/background.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveReqDetails/myLevReqDetailPODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // _loadUserInfo();
    _getReqDetails(levDetails);
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
    setState(() {
      isLoading = true;
    });
    myReqTitleObj.clear();
    approvedObject.clear();
    requestItemObject.clear();
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.MyLevReqDetails;
    Map body = {"Tokenkey": token, "requestID": reqID, "lang":globalMyLocalPrefes.getString(AppConstant.LANG)??"2"};
    http.post(Uri.parse(uri), body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("Reponse---2 : $jsonResponse");
      GetLevReqDetails getLevReqDetails =
          new GetLevReqDetails.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        print(".requestItemObject---2 : ${getLevReqDetails.requestItemObject}");
        setState(() {
          myReqTitleObj = getLevReqDetails.requestTitleObject;
          approvedObject = getLevReqDetails.approvedObject;
          requestItemObject = getLevReqDetails.requestItemObject;
          isLoading = false;
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _getReqDetails(reqID);
          });
          // Future<String> token = getToken();
        } else {
          Toast.show("Something went wrong, please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

  Future<void> cancelMyRequest(reqID) async {
    setState(() {
      isLoading = true;
    });
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.CancelMyrequest;
    Map body = {"Tokenkey": token, "requestID": reqID, "lang":globalMyLocalPrefes.getString(AppConstant.LANG)??"2"};

    http.post(Uri.parse(uri), body: body).then((response) {
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
          Toast.show("Something went wrong, please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {


   Uint8List bytes= Base64Codec().decode(globalMyLocalPrefes.getString(AppConstant.IMAGE));

    print("requestItemObject[0] :: $requestItemObject");
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
                        padding: EdgeInsets.all(16),
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
                                        height: 47,
                                         width: 47,
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
                                          Text(globalMyLocalPrefes.getString(AppConstant.USERNAME),
                                              style: TextStyle(
                                                  fontSize: 19.0,
                                                  fontWeight: FontWeight.bold)),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                                globalMyLocalPrefes.getString(AppConstant.DEPARTMENT),
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
                                        "tel://" + globalMyLocalPrefes.getString(AppConstant.PHONENO)),
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
                                  'Request ID: ${requestItemObject.isNotEmpty ? requestItemObject[0].itemID : "-"}'),
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
                                  'Duration: ${requestItemObject.isNotEmpty ? requestItemObject[0].duration : "-"} days'),
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
                                  'Request Status: ${requestItemObject.isNotEmpty ? myReqTitleObj[0].statusText : "-"}'),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8),
                            //   child: Text(
                            //       'Period: ${requestItemObject.isNotEmpty ? requestItemObject[0].strDate : "-"}'),
                            // ),
                            // SizedBox(
                            //   width: size.width,
                            //   height: 1.0,
                            //   child: Container(
                            //     color: Colors.grey[300],
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Return Date: ${requestItemObject.isNotEmpty ? requestItemObject[0].returnDate : "-"}'),
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
                                  'Reason: ${requestItemObject.isNotEmpty ? requestItemObject[0].requestReason : "-"}'),
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
                                  'Manager: ${requestItemObject.isNotEmpty ? requestItemObject[0].responseName : "-"}'),
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
                                  'Submit Date: ${myReqTitleObj.isNotEmpty ? myReqTitleObj[0].submitDate : "-"}'),
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
                                  'Start Date ${myReqTitleObj.isNotEmpty ? requestItemObject[0].strDate : "-"}'),
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
                                  'End Date ${myReqTitleObj.isNotEmpty ? requestItemObject[0].endDate : "-"}'),
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
                                  'Requested For: ${requestItemObject.isNotEmpty ? requestItemObject[0].itemType : "-"}'),
                            ),

                            ( approvedObject!=null &&  approvedObject.isNotEmpty)? SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ):Container(),

                            ( approvedObject!=null &&  approvedObject.isNotEmpty) ?  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Aproved Date: ${approvedObject.isNotEmpty ? approvedObject[0].approvedDate : "-"}'),
                            ):Container(),
                            ( approvedObject!=null &&  approvedObject.isNotEmpty)? SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ):Container(),


                            ( approvedObject!=null &&  approvedObject.isNotEmpty) ?  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'ApprovedName Name: ${approvedObject.isNotEmpty ? approvedObject[0].approvedName : "-"}'),
                            ):Container(),
                            ( approvedObject!=null &&  approvedObject.isNotEmpty)? SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ):Container(),

                            ( approvedObject!=null &&  approvedObject.isNotEmpty) ?  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  'Comment: ${approvedObject.isNotEmpty ? approvedObject[0].comment : "-"}'),
                            ):Container(),
                            ( approvedObject!=null &&  approvedObject.isNotEmpty)? SizedBox(
                              width: size.width,
                              height: 1.0,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ):Container(),

                            // SizedBox(
                            //   width: size.width,
                            //   height: 1.0,
                            //   child: Container(
                            //     color: Colors.grey[300],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8),
                            //   child: Text(
                            //       'Requested Type: ${requestItemObject.isNotEmpty ? requestItemObject[0].itemType : "-"}'),
                            // ),


                          ],
                        ),
                      ),
                    ),
                    (myReqTitleObj[0].statusText != null &&
                            myReqTitleObj[0].statusText != 'Pending')
                        ? Container(
                            width: size.width * .9,
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Previous Manager's Notes",
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          )
                        : Container(),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                        child: Column(
                          children: isLoading
                              ? <Widget>[LinearProgressIndicator()]
                              : _getapprovedObjectUI(),
                        )),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                        child: Column(
                          children: isLoading
                              ? <Widget>[LinearProgressIndicator()]
                              : _getrequestItemObjectUI(),
                        )),
                    (myReqTitleObj[0].statusText != null &&
                            myReqTitleObj[0].statusText == 'Pending')
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                            child: Column(children: [
                              getPermissionObject('My Request').app_edit == "1"
                                  ? OutlineButton(
                                      onPressed: () {
                                        cancelMyRequest(
                                            myReqTitleObj[0].requestID);
                                      },
                                      child: Text('Cancel Request',
                                          style: TextStyle(color: Colors.red)),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    )
                                  : Container()
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

  String errortext;
  TextEditingController resoneController = TextEditingController();

  Widget leaveReqItems(BuildContext context, reqItmObj) {
    var inputFormat = DateFormat('M/d/yyyy HH:mm:ss a');
    var outputFormat = DateFormat('dd/MM/yy');
    var inputDate = inputFormat.parse(reqItmObj.strDate);
    var startDate = outputFormat.format(inputDate);

    var inputDate1 = inputFormat.parse(reqItmObj.endDate);
    var endDate = outputFormat.format(inputDate1);

    var inputDate2 = inputFormat.parse(reqItmObj.returnDate);
    var returnDate = outputFormat.format(inputDate2);

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
                          : Container(),
                           Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                        'Requested For: ${(reqItmObj != null) ? (reqItmObj.requestFor) : "-"}'),
                                  ),
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

  // Widget _itemBuilder(label, textValue) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(top: 15.0, bottom: 15),
  //           child: Row(
  //             children: [
  //               Text(
  //                 label,
  //                 style: new TextStyle(fontWeight: FontWeight.w400),
  //               ),
  //               Text(
  //                 textValue,
  //                 style: new TextStyle(fontWeight: FontWeight.w500),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
