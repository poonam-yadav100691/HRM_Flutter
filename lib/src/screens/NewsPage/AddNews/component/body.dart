import 'dart:convert';
import 'package:HRMNew/components/MyCustomDateRange.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:HRMNew/utils/UIhelper.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

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

  addNews(body) async {
    setState(() {
      isLoading = true;
    });
    print("body ${body["rangeDate"][0]}");
    final uri = Services.AddNews;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    var bodyFinal = {
      "TokenKey": token,
      "newsTitle": body["newsTitle"],
      "newsContent": body["newsContent"],
      "attachec_file": "sample string 4",
      "pubish_date": body["rangeDate"][0].toString(),
      "exp_date": body["rangeDate"][1].toString()
    };
    print("bodyFinal $bodyFinal");

    Map body1 = bodyFinal;

    http.post(uri, body: body1).then((response) {
      var jsonResponse = jsonDecode(response.body);

      print("j&&&ffff $jsonResponse");

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
      } else {
        setState(() {
          isLoading = false;
        });
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          print("unauthro");
          GetToken();
          // _getNewsList();
          // Future<String> token = getToken();
        } else {
          _scaffoldKey.currentState.showSnackBar(
              UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return Scaffold(
        key: _scaffoldKey,
        body: Background(
            child: Column(
          children: [
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                    !isLoading
                        ? FormBuilder(
                            key: _fbKey,
                            // initialValue: {
                            //   'date': DateTime.now(),
                            //   'accept_terms': false,
                            // },
                            child: Column(
                              children: [
                                MyCustomTextField(
                                    title: "News Title", attrName: 'newsTitle'),
                                MyCustomDateRange(
                                  title: "Select News Date Range",
                                  attrName: 'rangeDate',
                                  validator: (value) {
                                    print("Selected date rangr $value");
                                  },
                                ),
                                // MyCustomTextField(
                                //   title: "News Description",
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderTextField(
                                    attribute: 'newsContent',
                                    minLines: 1,
                                    maxLines: 5,
                                    validators: [
                                      FormBuilderValidators.required()
                                    ],
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: 'News Description',
                                      hintStyle: TextStyle(color: Colors.grey),
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
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                      filled: true,
                                      contentPadding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 2.0,
                                          left: 10.0,
                                          right: 10.0),
                                      labelText: "News Description",
                                    ),
                                  ),
                                ),
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
                                        if (_fbKey.currentState
                                            .saveAndValidate()) {
                                          addNews(_fbKey.currentState.value);
                                        }
                                      }),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: Center(child: CircularProgressIndicator()))
                  ]))),
            ),
          ],
        )));
  }
}
