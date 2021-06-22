import 'dart:convert';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime strDate, endDate, endStartDate;

  String selectedDateRange = 'Select Date Range';

  DateTime selecteddate;
  bool dateSelectedselect = false;

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
    print("body1234567890::: $selectedDateRange");
    print("body1234567890::: $strDate $endDate");
    final uri = Services.AddNews;
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    // var bodyFinal = {
    //   "TokenKey": token,
    //   "newsTitle": body["newsTitle"],
    //   "newsContent": body["newsContent"],
    //   "attachec_file": "sample string 4",
    //   "pubish_date": strDate,
    //   "exp_date": endDate
    // };
    print("bodybodyFinal $body");

    Map<String, dynamic> body1 = {
      "TokenKey": token,
      "newsTitle": body["newsTitle"],
      "newsContent": body["newsContent"],
      "attachec_file": "sample string 4",
      "pubish_date": strDate.toIso8601String(),
      "exp_date": endDate.toIso8601String()
    };
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    print("BODY: $body1");

    http
        .post(Uri.parse(uri), body: json.encode(body1), headers: headers)
        .then((response) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: getTranslated(context, "AddNewsSuccessfully"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

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
        print("jsonResponsModelErrors:: $jsonResponse");
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
                                // MyCustomDateRange(
                                //   title: getTranslated(
                                //       context, "SelectNewsDateRange"),
                                //   attrName: 'rangeDate',
                                //   validator: (value) {
                                //     print("Selected date rangr $value");
                                //   },
                                // ),

                                // GestureDetector(
                                //   onTap: () async {
                                //     final DateTime pickedDate =
                                //         await showDatePicker(
                                //             context: context,
                                //             initialDate: DateTime.now(),
                                //             firstDate: DateTime.now()
                                //                 .subtract(Duration(days: 150)),
                                //             lastDate: DateTime(
                                //                 DateTime.now().year + 1));
                                //     if (pickedDate != null)
                                //       setState(() {
                                //         selecteddate = dateFormat
                                //             .parse(pickedDate.toString());

                                //         dateSelectedselect = true;
                                //       });
                                //   },
                                //   child: Container(
                                //       width: MediaQuery.of(context).size.width,
                                //       padding: EdgeInsets.all(16),
                                //       margin: EdgeInsets.all(8),
                                //       decoration: BoxDecoration(
                                //           border: Border.all(
                                //             color: Colors.grey,
                                //           ),
                                //           shape: BoxShape.rectangle,
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(8))),
                                //       child: Text(dateSelectedselect
                                //           ? 'Selected Date: ${selecteddate.day}/${selecteddate.month}/${selecteddate.year}'
                                //           : 'Select Date')),
                                // ),
                                //   ):
                                Container(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final DateTime pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now()
                                                      .subtract(
                                                          Duration(days: 150)),
                                                  lastDate: DateTime.now().add(
                                                      Duration(days: 120)));
                                          if (pickedDate != null)
                                            setState(() {
                                              strDate = dateFormat
                                                  .parse(pickedDate.toString());
                                              endStartDate = strDate;
                                            });
                                          // dateTimeRangePicker();
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.all(16),
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: strDate == null
                                                ? Text('Select Start Date')
                                                : Text(
                                                    '${strDate.day}/${strDate.month}/${strDate.year}')),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          // dateTimeRangePicker();
                                          final DateTime pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: endStartDate,
                                                  firstDate: endStartDate,
                                                  lastDate: DateTime(
                                                      endStartDate.year + 1));
                                          if (pickedDate != null)
                                            setState(() {
                                              endDate = dateFormat
                                                  .parse(pickedDate.toString());
                                              selectedDateRange =
                                                  '${strDate.day}/${strDate.month}/${strDate.year}  To  ${endDate.day}/${endDate.month}/${endDate.year}';
                                            });
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.all(16),
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: endDate == null
                                                ? Text('Select End Date')
                                                : Text(
                                                    '${endDate.day}/${endDate.month}/${endDate.year}')),
                                      ),
                                    ],
                                  ),
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
                                // MyCustomFileUpload(),
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
