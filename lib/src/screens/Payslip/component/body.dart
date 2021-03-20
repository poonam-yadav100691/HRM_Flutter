import 'dart:convert';

import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/Payslip/PayslipDesc/payslipDesc.dart';
import 'package:HRMNew/src/screens/Payslip/component/paySlipListPODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  var _focusNode = new FocusNode();

  _focusListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ResultObject> payslipList = new List();
  AnimationController animationController;
  Animation<dynamic> animation;
  bool isLoading = true;

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    _getInsurHeader();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<void> _getInsurHeader() async {
    payslipList.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.PayslipList;
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      PayslipList payslipLists = new PayslipList.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        payslipList = payslipLists.resultObject;
        print("DDDDDDD--->>>${payslipList.toString()}");
      } else {
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          print("ModelError: ${jsonResponse["ModelErrors"]}");
          GetToken().getToken().then((value) {
            _getInsurHeader();
          });
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  void takeAction(id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PayslipDesc(payslipDetailID: id)),
    );
  }

  Widget notiDetailCard(PayslipList) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
      // decoration: new BoxDecoration(color: Colors.blue),
      // child: new Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   // mainAxisSize: MainAxisSize.min,
      //   children: [
      child: new InkWell(
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    Center(
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        // padding: EdgeInsets.all(10),
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                PayslipList.slipMonthYr,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          // color: Colors.yellow,
                        ),
                      ),
                    ),

                    // new Placeholder(),
                  ],
                ),
              ),
              Container(
                // color: Colors.pink,
                width: size.width * 0.76,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "SlipNo." + PayslipList.slipNo,
                            style: new TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   PayslipList.date,
                          //   style: new TextStyle(fontSize: 14.0),
                          // ), // new Placeholder(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                        children: <Widget>[
                          Text(
                            PayslipList.slipDate,
                            style: new TextStyle(fontSize: 14.0),
                          ),
                          // new Placeholder(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => takeAction(PayslipList.slipID),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: payslipList.map((p) {
            return notiDetailCard(p);
          }).toList()
          // SizedBox(height: size.height * 0.03),

          ),
    );
  }
}
