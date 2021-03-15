import 'dart:convert';

import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/Loans/component/loanDetailsPODO.dart';
import 'package:HRMNew/src/screens/Loans/component/loanPODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './background.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  Body({this.title, this.validator});

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

  List<ResultObject> loanHeader = new List();
  List<ResultDetailsObject> loanDetails = new List();
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
    loanHeader.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.LoanHeader;
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      LoanHeader insuranceHeaderLst = new LoanHeader.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        loanHeader = insuranceHeaderLst.resultObject;
        print("DDDDDDD--->>>${loanHeader.toString()}");
      } else {
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          print("ModelError: ${jsonResponse["ModelErrors"]}");
          await GetToken().getToken();
          _getInsurHeader();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  Future<void> _getLoanDetails(String id) async {
    loanDetails.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    Map body = {"Tokenkey": token, "loanID": id, "lang": '2'};
    print(body);

    final uri1 = Services.LoanDetail;
    print(uri1);
    http.post(uri1, body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      LoanDetails loanDetailsLst = new LoanDetails.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        loanDetails = loanDetailsLst.resultObject;
        print("DD--->>>${loanDetails.toString()}");
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, loanDetails),
        );
      } else {
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          print("ModelError: ${jsonResponse["ModelErrors"]}");
          await GetToken().getToken();
          _getInsurHeader();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  Widget _buildPopupDialog(BuildContext context, data) {
    Size size = MediaQuery.of(context).size;
    return new AlertDialog(
      insetPadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: const Text('Loans Details'),
      content: Expanded(
        child: Container(
          height: size.height,
          width: size.width * 0.9,
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(color: Colors.grey[200]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Interest : " +
                                  data[i].loanInterest.toString()),
                              Text(data[i].paymentDate),
                              Text(
                                "Total Pay : " +
                                    data[i].loanTotalPay.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Balance : " + data[i].loanBalance.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ));
                    })
              ]),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Background(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(child: loanList(context)),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }

  Widget loanList(BuildContext context) {
    final children = <Widget>[];
    if (loanHeader != null) {
      for (var i = 0; i < loanHeader.length; i++) {
        children.add(new GestureDetector(
            onTap: () {
              print("id ${loanHeader[i].loanID}");

              _getLoanDetails(loanHeader[i].loanID.toString());
            },
            child: new Container(
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
                              'Laon amount: ' +
                                  loanHeader[i].loanAmount.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Months: 5" +
                                  loanHeader[i].loanAmuntMonth.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Fee :' +
                                  loanHeader[i].loanMonthlyFee.toString(),
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            Text(
                              'Interest : ' +
                                  loanHeader[i].loanInterest.toString(),
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Balance :' +
                                  loanHeader[i].loanTotalBalance.toString(),
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget loanDetailsList(BuildContext context) {
    final children = <Widget>[];
    if (loanDetails != null) {
      for (var i = 0; i < loanDetails.length; i++) {
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
                        // Text('Pay Date :' + loanDetails[i].paymentDate),
                        Text('Interest: ' +
                            loanDetails[i].loanInterest.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        'Total Pay :' + loanDetails[i].loanTotalPay.toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        'Balance :' + loanDetails[i].loanBalance.toString()),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    } else {
      children.add(Container());
    }

    return Expanded(
        child:
            SizedBox(height: 200.0, child: new ListView(children: children)));
  }
}
