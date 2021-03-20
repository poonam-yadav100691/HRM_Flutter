import 'dart:convert';

import 'package:HRMNew/components/MyCustomDate.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  TextEditingController reasonController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController managerController = TextEditingController();

  String date, startFrom, endOn;

  ValueChanged _onDateTimeChanged(val) {
    date = val.toString();
  }

  ValueChanged _onstrDateChanged(val) {
    startFrom = val.toString();
  }

  ValueChanged _onendDateChanged(val) {
    endOn = val.toString();
  }

  DateTime selecteddate = DateTime.now();
  bool dateSelectedselect = false;
  String selectedenddateTime = '${DateTime.now().add(Duration(minutes: 40))}';
  String selectedstartdateTime = '${DateTime.now().add(Duration(minutes: 40))}';

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return Background(
        child: Column(
      children: [
        SafeArea(
            bottom: true,
            top: false,
            child: FormBuilder(
                key: _fbKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final DateTime pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 1));
                              if (pickedDate != null &&
                                  pickedDate != selecteddate)
                                setState(() {
                                  selecteddate = pickedDate;
                                  dateSelectedselect = true;
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
                                child: Text(dateSelectedselect
                                    ? 'Selected OT Date : $selecteddate'
                                    : 'Select OT Date ')),
                          ),

                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 6,
                                child: DateTimePicker(
                                  type: DateTimePickerType.dateTime,
                                  use24HourFormat: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.calendar_today),
                                      labelText: 'OT Start From'),
                                  initialValue:
                                      '${DateTime.now().add(Duration(minutes: 40))}',
                                  firstDate:
                                      DateTime.now().add(Duration(minutes: 40)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 8)),
                                  dateLabelText: ' OT Start From',
                                  style: Theme.of(context).textTheme.caption,
                                  onChanged: (val) {
                                    selectedstartdateTime = val;
                                  },
                                  validator: (val) {
                                    print(val);
                                    return null;
                                  },
                                  onSaved: (val) => print(val),
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: FormBuilderDateTimePicker(
                          //     attribute: 'OTStartTime',
                          //     decoration: new InputDecoration(
                          //       fillColor: Colors.white,
                          //       border: _focusNode.hasFocus
                          //           ? OutlineInputBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(5.0)),
                          //               borderSide:
                          //                   BorderSide(color: leaveCardcolor))
                          //           : OutlineInputBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(5.0)),
                          //               borderSide:
                          //                   BorderSide(color: Colors.grey)),
                          //       filled: true,
                          //       contentPadding: EdgeInsets.only(
                          //           bottom: 10.0, left: 10.0, right: 10.0),
                          //       labelText: 'OT Start From',
                          //     ),
                          //     onChanged: _onstrDateChanged,
                          //     validators: [FormBuilderValidators.required()],
                          //   ),
                          // ),

                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 6,
                                child: DateTimePicker(
                                  type: DateTimePickerType.dateTime,
                                  use24HourFormat: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.calendar_today),
                                      labelText: 'OT Ends On'),
                                  initialValue:
                                      '${DateTime.now().add(Duration(minutes: 40))}',
                                  firstDate:
                                      DateTime.now().add(Duration(minutes: 40)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 8)),
                                  dateLabelText: 'OT Ends On',
                                  style: Theme.of(context).textTheme.caption,
                                  onChanged: (val) {
                                    selectedenddateTime = val;
                                  },
                                  validator: (val) {
                                    print(val);
                                    return null;
                                  },
                                  onSaved: (val) => print(val),
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: FormBuilderDateTimePicker(
                          //     attribute: 'OTEndTime',
                          //     decoration: new InputDecoration(
                          //       fillColor: Colors.white,
                          //       border: _focusNode.hasFocus
                          //           ? OutlineInputBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(5.0)),
                          //               borderSide:
                          //                   BorderSide(color: leaveCardcolor))
                          //           : OutlineInputBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(5.0)),
                          //               borderSide:
                          //                   BorderSide(color: Colors.grey)),
                          //       filled: true,
                          //       contentPadding: EdgeInsets.only(
                          //           bottom: 10.0, left: 10.0, right: 10.0),
                          //       labelText: 'OT End On',
                          //     ),
                          //     onChanged: _onendDateChanged,
                          //     validators: [FormBuilderValidators.required()],
                          //   ),
                          // ),

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
                                labelText: 'Manager',
                              ),
                              controller: managerController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Manager';
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
                                labelText: 'Subject',
                              ),
                              controller: subjectController,
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
                              controller: reasonController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Reason';
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
                    Container(
                      width: size.width * 0.9,
                      height: 50,
                      child: RaisedButton(
                          color: leaveCardcolor,
                          textColor: kWhiteColor,
                          child: Text(
                            "Send",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            if (_fbKey.currentState.saveAndValidate()) {
                              print(_fbKey.currentState.value);

                              setState(() {
                                isLoading = true;
                              });

                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              String token = sharedPreferences
                                  .getString(AppConstant.ACCESS_TOKEN);
                              String id = sharedPreferences
                                  .getString(AppConstant.EMP_ID);
                               String  uri = Services.AddNewOT;

                              Map body = {
                                "tokenKey": token,
                                "lang": '2',
                                "OTDate": date,
                                "stTime": selectedstartdateTime,
                                "endTime": selectedenddateTime,
                                "otTitle": subjectController.text,
                                "otReason": reasonController.text,
                                // "reasone": .text,
                                "empId": id,
                              };

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
                                  Navigator.pop(context);
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
                          }),
                    ),
                  ],
                ))),
      ],
    ));
  }
}
