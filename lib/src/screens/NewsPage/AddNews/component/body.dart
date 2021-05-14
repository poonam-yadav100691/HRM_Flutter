import 'dart:convert';
import 'package:HRMNew/components/MyCustomDateRange.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:HRMNew/utils/UIhelper.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
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
    final uri = Services.AddNews;
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
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

    http.post(Uri.parse(uri), body: body1).then((response) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        Toast.show(getTranslated(context, "AddNewsSuccessfully"), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pushNamed(context, newsList);
      } else {
        setState(() {
          isLoading = false;
        });
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            addNews(body);
          });
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
                            child: Column(
                              children: [
                                MyCustomTextField(
                                    title: getTranslated(context, "NewsTitle"),
                                    attrName: 'newsTitle'),
                                MyCustomDateRange(
                                  title: getTranslated(
                                      context, "SelectNewsDateRange"),
                                  attrName: 'rangeDate',
                                  validator: (value) {
                                    print("Selected date rangr $value");
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderTextField(
                                    name: 'newsContent',

                                    minLines: 1,
                                    maxLines: 5,

                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: getTranslated(
                                          context, "NewsDescription"),
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
                                      labelText: getTranslated(
                                          context, "NewsDescription"),
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
                                        getTranslated(context, "Send"),
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
