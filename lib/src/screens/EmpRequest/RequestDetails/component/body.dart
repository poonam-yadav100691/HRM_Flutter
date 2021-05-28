import 'package:HRMNew/components/approvalAction.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/EmpRequest/RequestDetails/empReqDetailPODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
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

  DateTime strDate, endDate;

  Future<void> _getEmpReqDetails(reqID) async {
    print("reqID:::$reqID");
    setState(() {
      isLoading = true;
    });
    myReqTitleObj.clear();
    approvedObject.clear();
    requestItemObject.clear();

    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);

    final uri = Services.EmpRequestDetails;
    Map body = {"Tokenkey": token, "requestID": reqID, "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2"};

    http.post(Uri.parse(uri), body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      EmpReqDetails getLevReqDetails = new EmpReqDetails.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        myReqTitleObj = getLevReqDetails.requestTitleObject ?? [];
        approvedObject = getLevReqDetails.approvedObject ?? [];
        requestItemObject = getLevReqDetails.requestItemObject ?? [];

        print("R2 : ${myReqTitleObj.first.toJson()}");
        // print("R2 : ${approvedObject.first.toJson()}");
        print("R2 : ${requestItemObject.first.toJson()}");



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
          Toast.show("Something went wrong, please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
                                      child: Image.memory(
                                        base64Decode(myReqTitleObj[0].empPhoto),
                                        height: 47,
                                        width: 47,
                                        fit: BoxFit.cover,
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
                                  'Request No: ${myReqTitleObj.isNotEmpty ? myReqTitleObj[0].requestNo : "-"}'),
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
                                  'Request Date: ${myReqTitleObj.isNotEmpty ? myReqTitleObj[0].dateRequest : "-"}'),
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
                                  'Start Date: ${requestItemObject.isNotEmpty ? requestItemObject[0].strDate : "-"}'),
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
                                  'End Date: ${requestItemObject.isNotEmpty ? requestItemObject[0].endDate??"" : "-"}'),
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
                                  'Return Date: ${requestItemObject.isNotEmpty ? requestItemObject[0].returnDate??"" : "-"}'),
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
                                  'Request Reason: ${requestItemObject.isNotEmpty ? requestItemObject[0].requestReason??"" : "-"}'),
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
                                  'Response Name: ${requestItemObject.isNotEmpty ? requestItemObject[0].responseName??"" : "-"}'),
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
                                  'Requested For: ${requestItemObject.isNotEmpty ? requestItemObject[0].requestFor : "-"}'),
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    onPressed: () async {
                                      if (resoneController.text != "") {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        String token =
                                            globalMyLocalPrefes.getString(
                                                AppConstant.ACCESS_TOKEN);
                                        final uri = Services.RejectOT;
                                        Map body = {
                                          "TokenKey": token,
                                          "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2",
                                          "requestID":
                                              myReqTitleObj[0].requestID,
                                          "rejectDescription":
                                              resoneController.text ?? " ",
                                        };

                                        print('$body');
                                        http
                                            .post(Uri.parse(uri), body: body)
                                            .then((response) {
                                          var jsonResponse =
                                              jsonDecode(response.body);
                                          // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);
                                          if (jsonResponse["StatusCode"] ==
                                              200) {
                                            setState(() {
                                              isLoading = false;
                                            });

                                            Toast.show(
                                                jsonResponse['ModelErrors'],
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);

                                            print("j&&& $jsonResponse");
                                            Navigator.pop(context);
                                          } else {
                                            print(
                                                "ModelError: ${jsonResponse["ModelErrors"]}");
                                            if (jsonResponse["ModelErrors"] ==
                                                'Unauthorized') {
                                              GetToken()
                                                  .getToken()
                                                  .then((value) {
                                                Toast.show(
                                                    "Please try again!!!",
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.BOTTOM);
                                              });
                                            } else {
                                              Toast.show(
                                                  "Something went wrong, please try again later.",
                                                  context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.BOTTOM);
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
                              if (resoneController.text != "") {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      String token = globalMyLocalPrefes
                                          .getString(AppConstant.ACCESS_TOKEN);
                                      final uri = Services.ApproveOT;
                                      Map body = {
                                        "TokenKey": token,
                                        "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2",
                                        "requestID": myReqTitleObj[0].requestID,
                                        "approvedescription":
                                            resoneController.text ?? " ",
                                        "approveby": globalMyLocalPrefes
                                            .getString(AppConstant.EMP_ID)
                                            .toString(),
                                        "approvedescription":
                                            resoneController.text ?? " ",
                                      };

                                      print('$body');
                                      http
                                          .post(Uri.parse(uri), body: body)
                                          .then((response) {
                                        var jsonResponse =
                                            jsonDecode(response.body);
                                        // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);
                                        if (jsonResponse["StatusCode"] == 200) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Toast.show(
                                              jsonResponse['ModelErrors'],
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);

                                          print("j&&& $jsonResponse");
                                          Navigator.pop(context);
                                        } else {
                                          print(
                                              "ModelError: ${jsonResponse["ModelErrors"]}");
                                          if (jsonResponse["ModelErrors"] ==
                                              'Unauthorized') {
                                            GetToken().getToken().then((value) {
                                              Toast.show("Please try again!!!",
                                                  context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.BOTTOM);
                                            });
                                          } else {
                                            Toast.show(
                                                "Something went wrong, please try again later.",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
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
                                      'Approve',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            isLoading ? LinearProgressIndicator() : Container(),
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
