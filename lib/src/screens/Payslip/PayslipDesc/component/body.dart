import 'dart:convert';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/Payslip/PayslipDesc/component/payslipDetailsPODO.dart';
import 'package:HRMNew/src/screens/Payslip/component/paySlipListPODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import './background.dart';

class Body extends StatefulWidget {
  final String data;
  final List<ResultObject> payslipList;
  Body({Key key, @required this.data, @required this.payslipList})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState(data, payslipList);
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  String data;
  List<ResultObject> payslipList;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ResultObjectDetails> payslipDetails = new List();
  AnimationController animationController;
  Animation<dynamic> animation;
  bool isLoading = true;

  _BodyState(this.data, this.payslipList);

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    String id = widget.data;

    _getpayslipDetails(id);
    super.initState();
  }

  var _focusNode = new FocusNode();

  _focusListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  Future<void> _getpayslipDetails(String id) async {
    setState(() {
      isLoading = true;
    });
    payslipDetails.clear();
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    Map body = {"Tokenkey": token, "salaryID": id, "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2"};
    print(body);

    final uri1 = Services.PayslipDetails;
    print(uri1);
    http.post(Uri.parse(uri1), body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      PayslipDetails payslipDetailsLst =
          new PayslipDetails.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
          payslipDetails = payslipDetailsLst.resultObject;
        });

        print("DD--->>>${payslipDetails[0].earningObject}");
      } else {
        setState(() {
          isLoading = false;
        });
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          print("ModelError: ${jsonResponse["ModelErrors"]}");
          GetToken().getToken().then((value) {
            _getpayslipDetails(id);
          });
        } else {
          Toast.show("Something went wrong, please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ResultObject> payslipLst = widget.payslipList;

    if (!isLoading) {
      Size size = MediaQuery.of(context).size;
      return Background(
        child: payslipDetails.length > 0
            ? Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
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
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                    "lib/assets/logo/tk.png",
                                    height: 77,
                                    // width: 90,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 0.0, top: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("TK Supports Sole Co., Ltd ",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                  "3/33 Ban Simuang, Samsenthai Road, Sisattanak district, Vientiane, Vientiane, Postal code: 01000",
                                                  style: TextStyle(
                                                      fontSize: 13.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 24),
                                        // color: Colors.pink,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("Salary Month",
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                  payslipLst[0].slipMonthYr,
                                                  style: TextStyle(
                                                      fontSize: 13.0)),
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
                        ),
                        Container(
                          width: size.width * .9,
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "Earnings",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent)),
                            child: isLoading
                                ? LinearProgressIndicator()
                                : Column(
                                    children: getEarningObject(),
                                  ),
                          ),
                        ),
                        Container(
                          width: size.width * .9,
                          child: Text(
                            "Deductions",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        isLoading
                            ? Container()
                            : Container(
                                color: Colors.white,
                                child: Container(
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  child: isLoading
                                      ? LinearProgressIndicator()
                                      : Column(
                                          children: getDeductionObject(),
                                        ),
                                ),
                              ),
                        isLoading
                            ? Container()
                            : Container(
                                width: size.width * .9,
                                color: Colors.white,
                                child: new RichText(
                                  text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text:
                                              "Net Salary: \$ ${payslipDetails[0].netSalary} ",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                child: Text(
                  "No payslip",
                  textAlign: TextAlign.center,
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  List<Widget> getEarningObject() {
    List<Widget> list = [];

    payslipDetails[0].earningObject.forEach((element) {
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${element.earningDescrip}',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text('${element.earningValues}')
          ],
        ),
      ));
    });
    return list;
  }

  List<Widget> getDeductionObject() {
    List<Widget> list = [];

    payslipDetails[0].deductionObject.forEach((element) {
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${element.deductionDescrip}',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text('${element.deductionValues}')
          ],
        ),
      ));
    });
    return list;
  }
}
