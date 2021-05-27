import 'dart:convert';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/constants/select_single_item_dialog.dart';
import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/PODO/GetLeaveType.dart';
import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/PODO/GetResponsiblePerson.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import './background.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:HRMNew/src/screens/home.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<dynamic> animation;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _focusNode = new FocusNode();
  bool showHalf = false;
  bool isLoading = true;
  final TextEditingController leaveController = new TextEditingController();
  final TextEditingController resoneController = new TextEditingController();
  final TextEditingController responsiblePerController =
      new TextEditingController();
  final TextEditingController returnDateSelected = new TextEditingController();
  final TextEditingController leaveDateSelected = new TextEditingController();
  final TextEditingController rangeDateSelected = new TextEditingController();
  final TextEditingController leaveApplyFor = new TextEditingController();

  List<ResultObject> leaveList = new List();
  List<String> leaveTypeList = new List();

  List<ResResultObject> resPersonList = new List();
  List<String> resPerLsit = new List();

  String leaveLable = "Leave";
  String leaveId;
  double totalDays = 0;

  String respPerLable = "Leave";
  String respPerId;

  DateFormat dateFormat =
  DateFormat("yyyy-MM-dd");

  DateTime returndate ;

  bool dateSelectedreturn = false;

  DateTime selecteddate;
  bool dateSelectedselect = false;

  _focusListener() {
    setState(() {});
  }

  void getStartDate(){
    selecteddate= dateFormat.parse(DateTime.now().toString());
    returndate= dateFormat.parse(DateTime.now().toString());
  }

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    getTypeOfLeave();
    getResponsiblePerson();
    getStartDate();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  DateTime strDate, endDate,endStartDate;
  void _onDateRangeSelect() {
    // strDate =dateFormat.parse(val.start.toString()) ;
    // endDate = dateFormat.parse(val.end.toString());
    final difference = this.endDate.difference(strDate).inDays;
    setState(() {
      totalDays = (difference==0)?selectedLeaveStartRadio==2?1:1:difference.toDouble();
    });
  }

  String selectedDateRange = 'Select Date Range';
  int selectedLeaveRadio = 1;
  int selectedLeaveStartRadio = 1;
  DateTime returnDate;

  @override
  Widget build(BuildContext context) {
    // String selectedDateRange = getTranslated(context, "SelectDateRange");
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
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      getTranslated(context, "LeaveApplyFor"),
                                    ),
                                    Radio(
                                        value: selectedLeaveRadio,
                                        groupValue: 1,
                                        onChanged: (flag) {
                                          setState(() {
                                            selectedLeaveRadio = 1;
                                            showHalf = false;
                                          });
                                        }),
                                    Text(getTranslated(context, "FullDay"))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                        value: selectedLeaveRadio,
                                        groupValue: 2,
                                        onChanged: (flag) {
                                          setState(() {
                                            selectedLeaveRadio = 2;
                                            showHalf = true;
                                          });
                                        }),
                                    Text(getTranslated(context, "HalfDay"))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        showHalf
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Leave Start From : '),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Radio(
                                                  value:
                                                      selectedLeaveStartRadio,
                                                  groupValue: 1,
                                                  onChanged: (flag) {
                                                    setState(() {
                                                      selectedLeaveStartRadio =
                                                          1;
                                                    });
                                                  }),
                                              Text('First Half')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Radio(
                                                  value:
                                                      selectedLeaveStartRadio,
                                                  groupValue: 2,
                                                  onChanged: (flag) {
                                                    setState(() {
                                                      selectedLeaveStartRadio =
                                                          2;
                                                    });
                                                  }),
                                              Text('Second Half')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                            : Container(),
                        selectedLeaveRadio == 2
                            ? GestureDetector(
                                onTap: () async {
                                  final DateTime pickedDate =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now().subtract(Duration(days: 150)),
                                          firstDate: DateTime.now().subtract(Duration(days: 150)),
                                          lastDate: DateTime(
                                              DateTime.now().year + 1));
                                  if (pickedDate != null )
                                    setState(() {
                                      selecteddate = dateFormat.parse(pickedDate.toString());

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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Text(dateSelectedselect
                                        ? 'Selected Date: ${selecteddate.day}/${selecteddate.month}/${selecteddate.year}'
                                        : 'Select Date')),
                              )
                            : Container(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async{

                                      final DateTime pickedDate =  await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now().subtract(Duration(days: 150)),
                                      firstDate:DateTime.now().subtract(Duration(days: 150)),
                                      lastDate:DateTime.now().add(Duration(days: 120)));
                                      if (pickedDate != null)
                                      setState(() {
                                      strDate = dateFormat.parse(pickedDate.toString());
                                      endStartDate=strDate;

                                      });
                                      // dateTimeRangePicker();
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
                                        child: strDate==null? Text('Select Start Date'):Text('${strDate.day}/${strDate.month}/${strDate.year}')),
                                  ),

                                  GestureDetector(
                                    onTap: ()async {
                                      // dateTimeRangePicker();
                                      final DateTime pickedDate =  await showDatePicker(
                                          context: context,
                                          initialDate: endStartDate,
                                      firstDate: endStartDate,
                                      lastDate: DateTime(
                                          endStartDate.year + 1));
                                      if (pickedDate != null &&
                                      pickedDate != selecteddate)
                                      setState(() {
                                      endDate = dateFormat.parse(pickedDate.toString());
                                        selectedDateRange =
                                        '${strDate.day}/${strDate.month}/${strDate.year}  To  ${endDate.day}/${endDate.month}/${endDate.year}';

                                      });
                                      _onDateRangeSelect();
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
                                        child:endDate==null? Text('Select End Date'):Text('${endDate.day}/${endDate.month}/${endDate.year}')),
                                  ),

                                ],
                              ),
                            ),

                        selectedLeaveRadio == 2
                            ? Container()
                            : Container(
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
                                initialDate: selectedLeaveRadio == 1
                                    ?endDate.add(Duration(days: 1)):  dateFormat.parse( DateTime.now().toString()),
                                firstDate:selectedLeaveRadio == 1
                                    ?endDate.add(Duration(days: 1)):  dateFormat.parse( DateTime.now().toString()),
                                lastDate:dateFormat.parse( DateTime(DateTime.now().year + 1).toString()));
                            if (pickedDate != null && pickedDate != returndate)
                              setState(() {
                                returndate =dateFormat.parse(pickedDate.toString()) ;
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
                                  ? 'Return Date: ${returndate.day}/${returndate.month}/${returndate.year}'
                                  : getTranslated(
                                      context, "Returntoworkdate"))),
                        ),

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
                              labelText:
                                  getTranslated(context, "Selecttypeofleave"),
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
                                label:
                                    getTranslated(context, "Selecttypeofleave"),
                                titleStyle: TextStyle(color: Colors.black),
                                showSearchBox: false,
                                selectedValue: leaveLable,
                                items: leaveTypeList,
                                onChange: (String selected) {
                                  setState(() {
                                    leaveLable = (selected.isEmpty
                                        ? getTranslated(
                                            context, "Selecttypeofleave")
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
                              labelText: getTranslated(
                                  context, "SelectResponsiblePerson"),
                            ),
                            controller: responsiblePerController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return getTranslated(
                                    context, "SelectResponsiblePerson");
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              SelectItemDialog.showModal<String>(
                                context,
                                label: getTranslated(
                                    context, "SelectResponsiblePerson"),
                                titleStyle: TextStyle(color: Colors.black),
                                showSearchBox: false,
                                selectedValue: respPerLable,
                                items: resPerLsit,
                                onChange: (String selected) {
                                  setState(() {
                                    respPerLable = (selected.isEmpty
                                        ? getTranslated(
                                            context, "SelectResponsiblePerson")
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
                              labelText: getTranslated(context, "Reason"),
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
                                if (_fbKey.currentState.saveAndValidate()) {
                                  print(_fbKey.currentState.value);
                                  _placeRequests();
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

    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.GetLeaveType;
    print(uri);
    Map body = {"Tokenkey": token, "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2"};
    print("value" + body.toString());
    http.post(  Uri.parse(uri) , body: body).then((response) async {
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
          await GetToken().getToken().then((value) {
            getTypeOfLeave();
          });
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  Future<void> _placeRequests() async {
    setState(() {
      isLoading = true;
    });

    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.AddNewLeave;
    Map body = {
      "TokenKey": token,
      "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2",
      "LeaveTypeId": leaveId,
      "strDate": selectedLeaveRadio == 2
          ? '${selecteddate.year}-${selecteddate.month}-${selecteddate.day}'
          : '${strDate.year}-${strDate.month}-${strDate.day}',
      "endDate": selectedLeaveRadio == 2
          ? '${selecteddate.year}-${selecteddate.month}-${selecteddate.day}'
          : '${endDate.year}-${endDate.month}-${endDate.day}',
      "ReturnDate": '${returndate.year}-${returndate.month}-${returndate.day}',
      "TotalDays":selectedLeaveRadio == 2
              ? '0.5'
              : '$totalDays',
      "reasone": resoneController.text,
      "responsiblePersonID": respPerId,
      "LeaveFor": selectedLeaveRadio == 2 ? "half day" : "full day",
    };

    print('$body');
    http.post(  Uri.parse(uri) , body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      // MyRequests myRequest = new MyRequests.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        Toast.show("Leave Request Added Successfully!!!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print("j&&& $jsonResponse");

        Navigator.pushNamed(context, myRequestRoute);
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          await GetToken().getToken().then((value) {
            _placeRequests();
          });
          // Future<String> token = getToken();
        } else {
          Toast.show("Something went wrong, please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  // dateTimeRangePicker() async {
  //   DateTimeRange picked = await showDateRangePicker(
  //     initialEntryMode: DatePickerEntryMode.input,
  //     context: context,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(DateTime.now().year + 1),
  //     initialDateRange: DateTimeRange(
  //       end: DateTime(
  //           DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
  //       start: DateTime.now(),
  //     ),
  //   );
  //
  //   setState(() {
  //     selectedDateRange =
  //         '${picked.start.day}/${picked.start.month}/${picked.start.year}  To  ${picked.end.day}/${picked.end.month}/${picked.end.year}';
  //   });
  //
  //   // _onDateRangeSelect(picked);
  // }

  Future<void> getResponsiblePerson() async {
    setState(() {
      isLoading = true;
    });
    resPersonList.clear();
    resPerLsit.clear();
    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.GetResponsiblePer;
    Map body = {"Tokenkey": token, "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??"2"};
    http.post(  Uri.parse(uri) , body: body).then((response) async {
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
         await GetToken().getToken().then((value) {
            getResponsiblePerson();
          });
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }
}
