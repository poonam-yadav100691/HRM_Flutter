import 'dart:async';
import 'dart:convert';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/src/screens/Insurance/component/insuranceDetailsPODO.dart';
import 'package:HRMNew/src/screens/Insurance/component/insuranceHeaderPODO.dart';
import 'package:http/http.dart' as http;

import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import './background.dart';

class Body extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  Body({this.title, this.validator});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  var _focusNode = new FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ResultObject> insuHeader = new List();
  List<ResultDetailsObject> insuDetails = new List();
  AnimationController animationController;
  Animation<dynamic> animation;
  bool isLoading = true;

  @override
  void initState() {
    _getInsurHeader();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<void> _getInsurHeader() async {
    insuHeader.clear();
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.InsuranceHeader;
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(Uri.parse(uri), body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      InsuHeaderData insuranceHeaderLst =
          new InsuHeaderData.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        insuHeader = insuranceHeaderLst.resultObject;
        print("DDDDDDD--->>>${insuHeader.toString()}");

        final uri1 = Services.InsuranceDetail;
        http.post(Uri.parse(uri1), body: body).then((response) async {
          var jsonResponse = jsonDecode(response.body);
          InsuranceDetails insuranceDetailsLst =
              new InsuranceDetails.fromJson(jsonResponse);
          if (jsonResponse["StatusCode"] == 200) {
            setState(() {
              isLoading = false;
            });
            insuDetails = insuranceDetailsLst.resultObject;
            print("DD--->>>${insuDetails.toString()}");
          } else {
            if (jsonResponse["ModelErrors"] == 'Unauthorized') {
              print("ModelError: ${jsonResponse["ModelErrors"]}");
              GetToken().getToken().then((value) {
                _getInsurHeader();
              });
            } else {
              Toast.show(
                  "Something went wrong, please try again later.", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          }
        });
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (!isLoading) {
      return Background(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: <Widget>[
                //1stBox
                Container(
                  // padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey[350],
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Insurance Bal : " +
                                      insuHeader[0].insuranceBalance.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Insurance Limit : ' +
                                      insuHeader[0].insuranceLimit.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Insurance Used : ' +
                                      insuHeader[0].insuranceUsed.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //2nd Box
                Container(child: insuranceDetailsList(context))
                //buttons
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }

  Widget insuranceDetailsList(BuildContext context) {
    final children = <Widget>[];
    if (insuDetails != null) {
      for (var i = 0; i < insuDetails.length; i++) {
        children.add(new Container(
            // width: size.width,
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey[350],
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date : ' + insuDetails[i].dateUsing),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:
                          Text('Hospital/Clinic : ' + insuDetails[i].hotspital),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Contact : ' + insuDetails[i].contact),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                          'Amount : ' + insuDetails[i].amountPay.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Sent Date : ' + insuDetails[i].sentDate),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                          'Received Date : ' + insuDetails[i].receivedDate),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Desc : ' + insuDetails[i].descript),
                    ),
                  ],
                ),
              ),
            )));
      }
    } else {
      children.add(Container());
    }

    return Expanded(
        child:
            SizedBox(height: 200.0, child: new ListView(children: children)));
  }
}
