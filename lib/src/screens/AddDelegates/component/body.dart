import 'dart:convert';

import 'package:HRMNew/components/MyCustomDate.dart';
import 'package:HRMNew/components/MyCustomDateRange.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/constants/select_single_item_dialog.dart';
import 'package:HRMNew/src/screens/AddDelegates/delegatePODO.dart';
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
          GetToken().getToken();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

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
                MyCustomDateRange(
                  title: "Select Leave Date Range",
                  attrName: 'date_range',
                ),
                MyCustomTextField(title: "Total Days", attrName: 'total_days'),
                MyCustomDate(
                  title: "Return to work on",
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
                MyCustomTextField(title: "Subject", attrName: 'subject'),
                MyCustomTextField(title: "Reason", attrName: 'reason'),
                MyCustomFileUpload(),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  if (_fbKey.currentState.saveAndValidate()) {
                    print(_fbKey.currentState.value);
                  }
                }),
            RaisedButton(
                child: Text("Reset"),
                onPressed: () {
                  _fbKey.currentState.reset();
                })
          ],
        )
      ],
    )));
  }
}
