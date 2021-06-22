import 'dart:convert';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/constants/select_single_item_dialog.dart';
import 'package:HRMNew/src/screens/Delegates/AddDelegates/delegatePODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './background.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  Body({this.title, this.validator});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var _focusNode = new FocusNode();

  List<ResultObject> delPersonList = new List();
  List<String> delPerList = new List();
  final TextEditingController delPerController = new TextEditingController();
  String leaveLable = "Leave";
  String leaveId;
  // String endDate;

  int totalDays = 0;

  String delPerLable = "Leave";
  String delPerId;

  bool isLoading = true;

  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    super.initState();
    getDelegatePerson();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  Future<void> getDelegatePerson() async {
    setState(() {
      isLoading = true;
    });
    delPersonList.clear();
    delPerList.clear();
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.DelegatePerson;

    Map body = {
      "Tokenkey": token,
      "lang": globalMyLocalPrefes.getString(AppConstant.LANG) ?? "2"
    };
    http.post(Uri.parse(uri), body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("js.." + jsonResponse.toString());
      Delegates resPerson = new Delegates.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          delPersonList = resPerson.resultObject;
          for (int i = 0; i < delPersonList.length; i++) {
            delPerList.add(delPersonList[i].firstname);
          }
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            getDelegatePerson();
          });
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong, please try again later.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // Toast.show("Something went wrong, please try again later.", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

  String selectedDateRange = 'Select Date Range';

  dateTimeRangePicker() async {
    DateTimeRange picked = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: DateTimeRange(
        end: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
        start: DateTime.now(),
      ),
    );

    setState(() {
      selectedDateRange =
          '${picked.start.toUtc().toString().substring(0, 10)} to ${picked.end.toUtc().toString().substring(0, 10)}';
    });

    _onDateRangeSelect(picked);
  }

  DateTime strDate, endDate;
  void _onDateRangeSelect(DateTimeRange val) {
    strDate = val.start;
    endDate = val.end;

    print('$strDate  $endDate ');
    final difference = this.endDate.difference(strDate).inDays;
    setState(() {
      totalDays = difference;
    });
  }

  DateTime returndate = DateTime.now();
  bool dateSelectedreturn = false;
  final TextEditingController resoneController = new TextEditingController();
  final TextEditingController subject = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
        child: FormBuilder(
            child: Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    dateTimeRangePicker();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text('$selectedDateRange')),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text('Applying for ${totalDays.toString()} days')),
                GestureDetector(
                  onTap: () async {
                    final DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().weekday == 6 ||
                                DateTime.now().weekday == 7
                            ? DateTime(
                                DateTime.now().year, DateTime.now().month, 1)
                            : DateTime.now(),
                        selectableDayPredicate: (DateTime val) =>
                            val.weekday == 6 || val.weekday == 7 ? false : true,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (pickedDate != null && pickedDate != returndate)
                      setState(() {
                        returndate = pickedDate;
                        dateSelectedreturn = true;
                      });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Text(dateSelectedreturn
                          ? 'Return Date: ${returndate.toString().substring(0, 10)}'
                          : 'Return to Work date')),
                ),

                Container(
                  padding: const EdgeInsets.all(9),
                  child: TextFormField(
                    readOnly: true,
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: _focusNode.hasFocus
                          ? OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: leaveCardcolor))
                          : OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                      filled: true,
                      contentPadding: EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      labelText: 'Select Delegate Person',
                    ),
                    controller: delPerController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Select Delegate Person';
                      } else {
                        return null;
                      }
                    },
                    onTap: () {
                      SelectItemDialog.showModal<String>(
                        context,
                        label: "Select Delegate Person",
                        titleStyle: TextStyle(color: Colors.black),
                        showSearchBox: false,
                        selectedValue: delPerLable,
                        items: delPerList,
                        onChange: (String selected) {
                          setState(() {
                            delPerLable = (selected.isEmpty
                                ? 'Select Delegate Person'
                                : selected);
                            delPerController.text = delPerLable;
                            for (int i = 0; i < delPersonList.length; i++) {
                              if (delPersonList[i]
                                  .firstname
                                  .contains(selected)) {
                                delPerId = delPersonList[i].empid;
                                print("id" + delPerId);
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(9),
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: _focusNode.hasFocus
                          ? OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: leaveCardcolor))
                          : OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                      filled: true,
                      contentPadding: EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      // suffixIcon: Icon(Icons.keyboard_arrow_down),
                      labelText: 'Subject',
                    ),
                    controller: subject,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Enter Subject';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(9),
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: _focusNode.hasFocus
                          ? OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: leaveCardcolor))
                          : OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                      filled: true,
                      contentPadding: EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      // suffixIcon: Icon(Icons.keyboard_arrow_down),
                      labelText: 'Reason',
                    ),
                    controller: resoneController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please Select Reason';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                // MyCustomFileUpload(),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Submit",
                    style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    String token =
                        globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
                    String id =
                        globalMyLocalPrefes.getString(AppConstant.EMP_ID);
                    String uri = Services.AddDelegate;

                    Map body = {
                      "tokenKey": token,
                      "toEmp": '$delPerId',
                      "noted": resoneController.text,
                      "startDate": strDate.toString().substring(0, 10),
                      "endDate": endDate.toString().substring(0, 10)
                    };

                    print(body);

                    http.post(Uri.parse(uri), body: body).then((response) {
                      var jsonResponse = jsonDecode(response.body);
                      // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);

                      print(jsonResponse.toString());
                      if (jsonResponse["StatusCode"] == 200) {
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Delegates Added Successfully!!!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        print("j&&& $jsonResponse");
                        print("j&&& $jsonResponse");
                        Navigator.pushReplacementNamed(context, delegateRoute);
                      } else {
                        print("ModelError: ${jsonResponse["ModelErrors"]}");
                        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
                          GetToken().getToken().then((value) {
                            Fluttertoast.showToast(
                                msg: "Please try again!!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
                          // Future<String> token = getToken();
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Something went wrong, please try again later!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    });
                  }),
            ),
          ],
        ),
        isLoading ? LinearProgressIndicator() : Container(),
      ],
    )));
  }
}
