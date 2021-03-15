import 'dart:convert';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Network.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/constants/select_single_item_dialog.dart';
import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/PODO/GetLeaveType.dart';
import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/PODO/GetResponsiblePerson.dart';
import 'package:HRMNew/src/screens/Login/PODO/loginResponse.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import './background.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:HRMNew/src/screens/home.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<dynamic> animation;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SharedPreferences sharedPreferences;
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
  // String endDate;

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
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
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

  DateTime strDate,endDate;
  void _onDateRangeSelect(val) {
     strDate = val[0];
     endDate = val[1];

     print('$strDate  $endDate ');
    final difference = this.endDate.difference(strDate).inDays;
    setState(() {
      totalDays = difference;
    });
    print(difference);
  }


  int selectedLeaveRadio=1;
  int selectedLeaveStartRadio=1;
DateTime returnDate;
  void _onReturnDateSelect(val) {
    returnDate=val;

  }

  ValueChanged _onhalfChanged = (val) => print(val);
  ValueChanged _onLeaveChanged = (val){



  };
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
                          // child: FormBuilderRadioGroup(
                          //   attribute: 'LeaveApplyFor',
                          //   decoration: new InputDecoration(
                          //     fillColor: Colors.white,
                          //     border: _focusNode.hasFocus
                          //         ? OutlineInputBorder(
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(5.0)),
                          //             borderSide:
                          //                 BorderSide(color: leaveCardcolor))
                          //         : OutlineInputBorder(
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(5.0)),
                          //             borderSide:
                          //                 BorderSide(color: Colors.grey)),
                          //     filled: true,
                          //     contentPadding: EdgeInsets.only(
                          //         bottom: 3.0, left: 3.0, right: 3.0),
                          //     labelText: 'Leave Apply For ',
                          //   ),
                          //   // onChanged: _onRadioChanged,
                          //   onChanged: _onLeaveChanged,//(val) {
                          //     // New <----------
                          //     // if (value == "Yes") {
                          //     //   setState((){
                          //     //     isVisible = true;
                          //     //   });
                          //     // } else {
                          //     //   setState(() {
                          //     //     isVisible = false;
                          //     //   });
                          //     // }
                          //     // print(val);
                          //     // if (val == "Half Day") {
                          //     //   setState(() {
                          //     //     showHalf = true;
                          //     //   });
                          //     // } else {
                          //     //   setState(() {
                          //     //     showHalf = false;
                          //     //   });
                          //     // }
                          //   //},
                          //   validators: [FormBuilderValidators.required()],
                          //   options: ["Full Day", "Half Day"]
                          //       .map((lang) => FormBuilderFieldOption(
                          //             value: lang,
                          //             child: Text('$lang'),
                          //           ))
                          //       .toList(growable: false),
                          //
                          // )

                         child:Container(
                           width: MediaQuery.of(context).size.width,
                           padding: EdgeInsets.symmetric(horizontal: 8),
                           decoration: BoxDecoration(
                               border: Border.all(
                                 color: Colors.grey,
                               ),
                               shape: BoxShape.rectangle,
                               borderRadius: BorderRadius.all(Radius.circular(8))

                           ),
                           child: Row(
                             children: [
                               Row(
                                 children: [
                                   Text('Leave Apply For'),
                                   Radio(value: selectedLeaveRadio, groupValue: 1, onChanged:(flag){
                                     setState(() {
                                                selectedLeaveRadio=1;
                                                showHalf = false;
                                              });


                                   }),
                                   Text('Full Day')
                                 ],
                               ),
                               Row(
                                 children: [
                                   Radio(value: selectedLeaveRadio, groupValue: 2, onChanged:(flag){
                                     setState(() {
                                       selectedLeaveRadio=2;
                                       showHalf = true;
                                     });
                                   }),
                                   Text('Half Day')
                                 ],
                               ), ],
                           ),
                         )
                          ,
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
                                      borderRadius: BorderRadius.all(Radius.circular(8))

                                  ),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text('Leave Start From'),
                                          Radio(value: selectedLeaveStartRadio, groupValue: 1, onChanged:(flag){
                                            setState(() {
                                              selectedLeaveStartRadio=1;
                                            });


                                          }),
                                          Text('First Half')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(value: selectedLeaveStartRadio, groupValue: 2, onChanged:(flag){
                                            setState(() {
                                              selectedLeaveStartRadio=2;
                                            });
                                          }),
                                          Text('Second Half')
                                        ],
                                      ), ],
                                  ),
                                )

                                // FormBuilderRadioGroup(
                                //   attribute: 'LeaveStartFrom',
                                //   decoration: new InputDecoration(
                                //     fillColor: Colors.white,
                                //     border: _focusNode.hasFocus
                                //         ? OutlineInputBorder(
                                //             borderRadius: BorderRadius.all(
                                //                 Radius.circular(5.0)),
                                //             borderSide: BorderSide(
                                //                 color: leaveCardcolor))
                                //         : OutlineInputBorder(
                                //             borderRadius: BorderRadius.all(
                                //                 Radius.circular(5.0)),
                                //             borderSide:
                                //                 BorderSide(color: Colors.grey)),
                                //     filled: true,
                                //     contentPadding: EdgeInsets.only(
                                //         bottom: 3.0, left: 3.0, right: 3.0),
                                //     labelText: 'Leave Start From',
                                //   ),
                                //   onChanged: _onhalfChanged,
                                //   validators: [
                                //     FormBuilderValidators.required()
                                //   ],
                                //   options: ["First Half", "Second Half"]
                                //       .map((lang) => FormBuilderFieldOption(
                                //             value: lang,
                                //             child: Text('$lang'),
                                //           ))
                                //       .toList(growable: false),
                                // ),
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

                        selectedLeaveRadio==2?Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderDateTimePicker(
                            attribute: "returnDate",
                            controller: leaveDateSelected,
                            onChanged: _onReturnDateSelect,
                            inputType: InputType.date,
                            firstDate: DateTime.now(),
                            format: DateFormat("dd-MM-yyyy"),
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
                              labelText: "Select Date",
                            ),
                          ),
                        ): Container(
                          padding: const EdgeInsets.all(9),
                          child: FormBuilderDateRangePicker(
                            controller: rangeDateSelected,
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


                        selectedLeaveRadio==2?Container():  Container(
                          width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(8))

                            ),
                            child: Text( 'Applying for  ${totalDays.toString()} days' )),

                        // MyCustomTextField(
                        //     title: totalDays.toString(),
                        //     attrName: 'total_days'),
                        // Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: FormBuilderDateTimePicker(
                        //       // attribute: "date",
                        //       inputType: InputType.date,
                        //       firstDate: DateTime.now(),
                        //       format: DateFormat("dd-MM-yyyy"),
                        //       // initialValue: DateTime.now(),

                        //       autocorrect: false,
                        //       focusNode: _focusNode,
                        //       style: TextStyle(color: Colors.black),
                        //     )),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FormBuilderDateTimePicker(
                            attribute: "returnDate",
                             controller: returnDateSelected,
                             onChanged: _onReturnDateSelect,
                            inputType: InputType.date,
                            firstDate: DateTime.now(),
                            format: DateFormat("dd-MM-yyyy"),
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
                          ),
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
                        // MyCustomTextField(title: "Reason", attrName: 'reason'),

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
          GetToken().getToken();
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


  Future<void> _placeRequests() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.AddNewLeave;
    Map body = {
                "TokenKey": token,
                "lang": '2',
                "LeaveTypeId": leaveId,
                 "strDate":selectedLeaveStartRadio==2?leaveController.text:strDate.toString(),
                "endDate": endDate.toString(),
                "ReturnDate": returnDate.toString(),
                "TotalDays": totalDays.toString(),
                "reasone": resoneController.text,
                "responsiblePersonID": respPerId,
                "LeaveFor": "",
    };

    print('$body');
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
