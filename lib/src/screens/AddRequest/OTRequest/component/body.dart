import 'dart:convert';

import 'package:HRMNew/components/MyCustomDate.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
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


  TextEditingController reasonController=TextEditingController();
  TextEditingController subjectController=TextEditingController();
  TextEditingController managerController=TextEditingController();

  String date,startFrom,endOn;

  ValueChanged _onDateTimeChanged  (val) {
    date=val.toString();
  }
  ValueChanged _onstrDateChanged  (val) {
    startFrom=val.toString();
  }

  ValueChanged _onendDateChanged  (val) {
    endOn=val.toString();
  }


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
                          MyCustomDate(
                            title: "Select OT Date ",
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderDateTimePicker(
                              attribute: 'OTStartTime',
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
                                labelText: 'OT Start From',
                              ),
                              onChanged: _onstrDateChanged,
                              validators: [FormBuilderValidators.required()],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderDateTimePicker(
                              attribute: 'OTEndTime',
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
                                labelText: 'OT End On',
                              ),
                              onChanged: _onendDateChanged,
                              validators: [FormBuilderValidators.required()],
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
                          onPressed: () async{
                            if (_fbKey.currentState.saveAndValidate()) {
                              print(_fbKey.currentState.value);

                              setState(() {
                                isLoading = true;
                              });

                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
                              String id = sharedPreferences.getString(AppConstant.EMP_ID);
                              final uri = Services.AddNewOT;


                              Map body = {
                                "TokenKey": token,
                                "lang": '2',
                                "OTDate": date,
                                "stTime": startFrom,
                                "endTime": endOn,
                                "otTitle": subjectController.text,
                                "otReason": reasonController.text,
                                // "reasone": .text,
                                "empId": id,
                                "LeaveFor": "",
                              };


                              print(body);

                              http.post(uri, body: body).then((response) {
                                var jsonResponse = jsonDecode(response.body);
                                // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);
                                if (jsonResponse["StatusCode"] == 200) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  print("j&&& $jsonResponse");
                                  Navigator.pop(context);



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
                          }),
                    ),
                  ],
                ))),
      ],
    ));
  }
}
