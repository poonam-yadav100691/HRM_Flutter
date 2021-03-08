import 'package:HRMNew/components/approvalAction.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import './background.dart';
import 'dart:async';
import 'dart:convert';
import 'package:HRMNew/src/screens/home.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final String data;
  Body({Key key, @required this.data}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(data);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  String data;

  bool isLoading = false;

  _BodyState(this.data);

  final _formKey = GlobalKey<FormState>();

  void takeAction(text) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApprovalAction(text)),
    );
  }

  Future<void> _getEmpReqDetails(reqID) async {
    print("reqID:::$reqID");
    setState(() {
      isLoading = true;
    });
    // myReqTitleObj.clear();
    // approvedObject.clear();
    // requestItemObject.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.MyLevReqDetails;
    Map body = {"Tokenkey": token, "requestID": reqID, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("Reponse---2 : $jsonResponse");
      // GetLevReqDetails getLevReqDetails =
      //     new GetLevReqDetails.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });

        // myReqTitleObj = getLevReqDetails.requestTitleObject;
        // approvedObject = getLevReqDetails.approvedObject;
        // requestItemObject = getLevReqDetails.requestItemObject;
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
    print("data ((((...$data");
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .15), blurRadius: 16.0)
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Poonam Yadav",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("Mobile Developer",
                                        style: TextStyle(fontSize: 14.0)),
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
                            onTap: () => launch("tel://21213123123"),
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
                    _itemBuilder('Leave Type : ', 'PERSONAL LEAVE'),
                    SizedBox(
                      width: size.width,
                      height: 1.0,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    _itemBuilder('Period : ', '13 Mar 20 - 14 Mar 20'),
                    SizedBox(
                      width: size.width,
                      height: 1.0,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    _itemBuilder('Duration : ', '2.0 days'),
                    SizedBox(
                      width: size.width,
                      height: 1.0,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    _itemBuilder(
                        'Note : ', "Attendance brother-in-law'\s marriage"),
                    SizedBox(
                      width: size.width,
                      height: 1.0,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    _itemBuilder('Manager : ', 'Ta Manager'),
                    SizedBox(
                      width: size.width,
                      height: 1.0,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    _itemBuilder('Leave Entry At : ', '12 Mar 2020 - 11:04 AM'),
                    SizedBox(
                      width: size.width,
                      height: 1.0,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10),
                            child: TextFormField(
                              maxLines: 4,
                              scrollPadding: EdgeInsets.all(10),
                              textAlign: TextAlign.start,
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide:
                                        BorderSide(color: leaveCardcolor)),
                                filled: true,
                                contentPadding: EdgeInsets.only(
                                    bottom: 10.0,
                                    left: 10.0,
                                    right: 10.0,
                                    top: 16),
                                labelText: "Manager Reason",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter reason here..';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.red,
                                child: Text(
                                  'REJECT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    takeAction("Reject");
                                  }
                                },

                                ///_handleLogout()
                              ),
                              RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  'APPROVE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    takeAction("Approve");
                                  }
                                },
                              ),
                              // )),
                            ],
                          )
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
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 70),
              child: planetCard(context, "Team Lead",
                  "Remark here... text remark here..", '04/09/2020 10:30AM'),
            ),
          ],
        ),
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
