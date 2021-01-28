import 'dart:convert';

import 'package:HRMNew/components/MyCustomDate.dart';
import 'package:HRMNew/components/MyCustomDateRange.dart';
import 'package:HRMNew/components/MyCustomDropDown.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Network.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/constants/select_single_item_dialog.dart';
import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/PODO/GetLeaveType.dart';
import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/PODO/GetResponsiblePerson.dart';
import 'package:HRMNew/src/screens/Login/PODO/loginResponse.dart';
import 'package:HRMNew/utils/UIhelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
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
  SharedPreferences sharedPreferences;
  var _focusNode = new FocusNode();
  bool showHalf = false;
  bool isLoading = true;
  final TextEditingController leaveController = new TextEditingController();
  final TextEditingController responsiblePerController =
      new TextEditingController();
  List<ResultObject> leaveList = new List();
  List<String> leaveTypeList = new List();

  List<ResResultObject> resPersonList = new List();
  List<String> resPerLsit = new List();

  String leaveLable = "Leave";
  String leaveId;

  int totalDays = 0;

  String respPerLable = "Leave";
  String respPerId;
  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    getTypeOfLeave();
    getResponsiblePerson();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  void _onRadioChanged(val) {
    print(val);
    if (val == "Half Day") {
      setState(() {
        this.showHalf = true;
      });
    } else {
      setState(() {
        this.showHalf = false;
      });
    }
  }

  void _onDateRangeSelect(val) {
    final startDate = val[0];
    final endDate = val[1];
    final difference = endDate.difference(startDate).inDays;
    setState(() {
      totalDays = difference;
    });
    print(difference);
  }

  ValueChanged _onhalfChanged = (val) => print(val);
  // ValueChanged _onRadioChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    if (!isLoading) {
      return Background(
          child: Column(
        children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  FormBuilder(
                    key: _fbKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderRadioGroup(
                            attribute: 'LeaveApplyFor',
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
                                  bottom: 3.0, left: 3.0, right: 3.0),
                              labelText: 'Leave Apply For ',
                            ),
                            onChanged: _onRadioChanged,
                            validators: [FormBuilderValidators.required()],
                            options: ["Full Day", "Half Day"]
                                .map((lang) => FormBuilderFieldOption(
                                      value: lang,
                                      child: Text('$lang'),
                                    ))
                                .toList(growable: false),
                          ),
                        ),
                        showHalf
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderRadioGroup(
                                  attribute: 'LeaveApplyFrom',
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: _focusNode.hasFocus
                                        ? OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            borderSide: BorderSide(
                                                color: leaveCardcolor))
                                        : OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                    filled: true,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 3.0, left: 3.0, right: 3.0),
                                    labelText: 'Leave Start From',
                                  ),
                                  onChanged: _onhalfChanged,
                                  validators: [
                                    FormBuilderValidators.required()
                                  ],
                                  options: ["First Half", "Second Half"]
                                      .map((lang) => FormBuilderFieldOption(
                                            value: lang,
                                            child: Text('$lang'),
                                          ))
                                      .toList(growable: false),
                                ),
                              )
                            : Container(),
                        // MyCustomDateRange(
                        //   onChanged: _onChanged,
                        //   title: "Select Leave Date Range",
                        //   attrName: 'date_range',
                        //   validator: (value) {
                        //     print("Selected date rangr $value");
                        //   },
                        // ),

                        Container(
                          padding: const EdgeInsets.all(9),
                          child: FormBuilderDateRangePicker(
                            attribute: 'date_range',
                            onChanged: _onDateRangeSelect,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                            format: DateFormat('dd-MM-yyyy'),
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
                              labelText: "Select Leave Date Range",
                            ),
                          ),
                        ),
                        MyCustomTextField(
                            title: totalDays.toString(),
                            attrName: 'total_days'),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderDateTimePicker(
                              attribute: "date",
                              inputType: InputType.date,
                              firstDate: DateTime.now(),
                              format: DateFormat("dd-MM-yyyy"),
                              // initialValue: DateTime.now(),
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
                                labelText: "Return to work date",
                              ),
                              autocorrect: false,
                              focusNode: _focusNode,
                              style: TextStyle(color: Colors.black),
                            )),
                        Container(
                          padding: const EdgeInsets.all(9),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
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
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              labelText: 'Select Type of Leave',
                            ),
                            controller: leaveController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please Select Type of Leave';
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              SelectItemDialog.showModal<String>(
                                context,
                                label: "Select Type of Leave",
                                titleStyle: TextStyle(color: Colors.black),
                                showSearchBox: false,
                                selectedValue: leaveLable,
                                items: leaveTypeList,
                                onChange: (String selected) {
                                  setState(() {
                                    leaveLable = (selected.isEmpty
                                        ? 'Select Leave Type'
                                        : selected);
                                    leaveController.text = leaveLable;
                                    for (int i = 0; i < leaveList.length; i++) {
                                      if (leaveList[i]
                                          .typeName
                                          .contains(selected)) {
                                        leaveId = leaveList[i].typeID;
                                        print("id" + leaveId);
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
                            readOnly: true,
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
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              labelText: 'Select Responsible Person',
                            ),
                            controller: responsiblePerController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please Select Responsible Person';
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              SelectItemDialog.showModal<String>(
                                context,
                                label: "Select Responsible Person",
                                titleStyle: TextStyle(color: Colors.black),
                                showSearchBox: false,
                                selectedValue: respPerLable,
                                items: resPerLsit,
                                onChange: (String selected) {
                                  setState(() {
                                    respPerLable = (selected.isEmpty
                                        ? 'Select Responsible Person'
                                        : selected);
                                    responsiblePerController.text =
                                        respPerLable;
                                    for (int i = 0;
                                        i < resPersonList.length;
                                        i++) {
                                      if (resPersonList[i]
                                          .firstname
                                          .contains(selected)) {
                                        respPerId = resPersonList[i].empid;
                                        print("id" + respPerId);
                                      }
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        // MyCustomDropDown(
                        //   title: "Select Responsible Person",
                        //   controller:responsiblePerController
                        // ),
                        // MyCustomTextField(
                        //     title: "Total Days", attrName: 'total_days'),
                        // MyCustomTextField(title: "Subject", attrName: 'subject'),
                        MyCustomTextField(title: "Reason", attrName: 'reason'),
                        MyCustomFileUpload(),
                        Container(
                          width: size.width * 0.9,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 30, top: 20),
                          child: RaisedButton(
                              color: leaveCardcolor,
                              textColor: kWhiteColor,
                              child: Text(
                                "Send",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  print(_fbKey.currentState.value);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ]))),
          ),
        ],
      ));
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> getTypeOfLeave() async {
    setState(() {
      isLoading = true;
    });
    leaveList.clear();
    leaveTypeList.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.GetLeaveType;
    print(uri);
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("jsonResponse...kk.." + jsonResponse.toString());
      GetLeaveType leave = new GetLeaveType.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          leaveList = leave.resultObject;
          for (int i = 0; i < leaveList.length; i++) {
            leaveTypeList.add(leaveList[i].typeName);
          }
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          Future<String> token = getToken();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  Future<String> getToken() async {
    Network().check().then((intenet) async {
      if (intenet != null && intenet) {
        sharedPreferences = await SharedPreferences.getInstance();
        String username = sharedPreferences.getString(AppConstant.LoginGmailID);
        String password = sharedPreferences.getString(AppConstant.PASSWORD);
        String urname = sharedPreferences.getString(AppConstant.USERNAME);
        print("username---2 : $username");
        print("urname---2 : $urname");

        try {
          final uri = Services.LOGIN;
          Map body = {
            "PassKey": "a486f489-76c0-4c49-8ff0-d0fdec0a162b",
            "UserName": username,
            "UserPassword": password
          };

          http.post(uri, body: body).then((response) {
            if (response.statusCode == 200) {
              var jsonResponse = jsonDecode(response.body);
              print("Reponse---2 : $jsonResponse");
              if (jsonResponse["StatusCode"] == 200) {
                loginResponse login =
                    new loginResponse.fromJson(jsonResponse["ResultObject"][0]);

                sharedPreferences.setInt(
                    AppConstant.USER_ID.toString(), login.userId);
                sharedPreferences.setString(AppConstant.EMP_ID, login.emp_no);
                sharedPreferences.setString(
                    AppConstant.ACCESS_TOKEN, login.tokenKey);
                sharedPreferences.setString(
                    AppConstant.USERNAME, login.eng_fullname);
                sharedPreferences.setString(AppConstant.IMAGE, login.emp_photo);
                sharedPreferences.setString(
                    AppConstant.PHONENO, login.emp_mobile);
                sharedPreferences.setString(AppConstant.EMAIL, login.userEmail);
                sharedPreferences.setString(
                    AppConstant.DEPARTMENT, login.emp_dep);
                sharedPreferences.setString(
                    AppConstant.COMPANY, login.emp_company);
                return sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
              } else {
                Toast.show(
                    "Something wnet wrong.. Please try again later.", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return "Something wnet wrong.. Please try again later.";
              }
            } else {
              print("response.statusCode.." + response.statusCode.toString());
              Toast.show(
                  "Something wnet wrong.. Please try again later.", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              return "Something wnet wrong.. Please try again later.";
            }
          });
        } catch (e) {
          print("Error: $e");

          return (e);
        }
      } else {
        Navigator.pop(context);
        Toast.show("Please check internet connection", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  Future<void> getResponsiblePerson() async {
    setState(() {
      isLoading = true;
    });
    resPersonList.clear();
    resPerLsit.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.GetResponsiblePer;
    print(uri);
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("jsonResponse...resPerson.." + jsonResponse.toString());
      GetResponsiblePerson resPerson =
          new GetResponsiblePerson.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          resPersonList = resPerson.resultObject;
          for (int i = 0; i < resPersonList.length; i++) {
            resPerLsit.add(resPersonList[i].firstname);
          }
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          getToken();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }
}
