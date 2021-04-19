import 'dart:convert';

import 'package:HRMNew/components/MyCustomDate.dart';
import 'package:HRMNew/components/MyCustomDateRange.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/constants/select_single_item_dialog.dart';
import 'package:HRMNew/src/screens/Delegates/AddDelegates/delegatePODO.dart';
import 'package:HRMNew/src/screens/home.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './background.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.DelegatePerson;
    print(uri);
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) {
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
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
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
      selectedDateRange = '${picked.start.toUtc().toString().substring(0,10)} to ${picked.end.toUtc().toString().substring(0,10)}';
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
  final TextEditingController subject =
  new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
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
                          borderRadius: BorderRadius.all(
                              Radius.circular(8))),
                      child: Text('$selectedDateRange')),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius:
                        BorderRadius.all(Radius.circular(8))),
                    child: Text(
                        'Applying for  ${totalDays.toString()} days')),
                GestureDetector(
                  onTap: () async {
                    final DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
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
                          borderRadius:
                          BorderRadius.all(Radius.circular(8))),
                      child: Text(dateSelectedreturn
                          ? 'Return Date: ${returndate.toString().substring(0,10)}'
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
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0)),
                          borderSide:
                          BorderSide(color: leaveCardcolor))
                          : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0)),
                          borderSide:
                          BorderSide(color: Colors.grey)),
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
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0)),
                          borderSide:
                          BorderSide(color: leaveCardcolor))
                          : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0)),
                          borderSide:
                          BorderSide(color: Colors.grey)),
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
              width: MediaQuery.of(context).size.width*.8,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Submit",style: Theme.of(context).textTheme.button.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
                  color: Colors.green,
                  onPressed: () async {




                        setState(() {
                          isLoading = true;
                        });

                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        String token = sharedPreferences
                            .getString(AppConstant.ACCESS_TOKEN);
                        int id = sharedPreferences
                            .getInt(AppConstant.EMP_ID);
                        String  uri = Services.AddDelegate;

                        Map body = {


                            "tokenKey": token,
                            "toEmp": '$id',
                            "noted": "",
                            "startDate": strDate.toString().substring(0,10),
                            "endDate": endDate.toString().substring(0,10)
                          };

                          // "tokenKey": token,
                          // "lang": '2',
                          // "OTDate": date,
                          // "stTime": selectedstartdateTime,
                          // "endTime": selectedenddateTime,
                          // "otTitle": subjectController.text,
                          // "otReason": reasonController.text,
                          // // "reasone": .text,
                          // "empId": id,


                        print(body);

                        http.post(uri, body: body).then((response) {
                          var jsonResponse = jsonDecode(response.body);
                          // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);

                          print(jsonResponse.toString());
                          if (jsonResponse["StatusCode"] == 200) {
                            setState(() {
                              isLoading = false;
                            });

                            print("j&&& $jsonResponse");
                            Navigator.pushReplacementNamed(context,delegateRoute);
                          } else {
                            print(
                                "ModelError: ${jsonResponse["ModelErrors"]}");
                            if (jsonResponse["ModelErrors"] ==
                                'Unauthorized') {
                              GetToken().getToken().then((value) {});
                              // Future<String> token = getToken();
                            } else {
                              // currentState.showSnackBar(
                              //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
                            }
                          }
                        });
                      }
                  ),
            ),
            // RaisedButton(
            //     child: Text("Reset",style: Theme.of(context).textTheme.button.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
            //     color: Colors.red,
            //     onPressed: () {
            //       _fbKey.currentState.reset();
            //     })
          ],
        ),
        isLoading?LinearProgressIndicator():Container(),
      ],
    )));
  }
}
