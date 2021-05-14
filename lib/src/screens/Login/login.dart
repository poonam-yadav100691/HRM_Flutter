import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Network.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/Login/PODO/loginResponse.dart';
import 'package:HRMNew/utils/App_theme.dart';
import 'package:HRMNew/utils/UIhelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autovalidate = false;
  String _email, _password;
  String _errorMessage = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//====================================

  // SharedPreferences sharedPreferences;
  final _minimumPadding = 5.0;
  bool invisible = true;
  bool _obscureText = true;
  bool isLoading = true;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    buttonText = 'LOGIN';
    // _register();
    generateTocken();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  var widgeterror = '';
  final focus = FocusNode();
  var buttonText = '';

  var _state = 0;

  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //----------------------------------------//

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: 120,
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  Future<void> _handleSubmitted() async {
    if (_formKey.currentState.validate()) {
      UIhelper.dismissKeyboard(context);

      getToken();
    } else {
      setState(() {
        _state = 3;
        buttonText = 'RETRY';
      });
    }
  }

  Future<void> getToken() async {
    Network().check().then((intenet) async {
      if (intenet != null && intenet) {
        // sharedPreferences = await SharedPreferences.getInstance();
        setState(() {
          _state = 1;
          buttonText = 'LOADING..';
        });

        try {
          final uri = Services.LOGIN;
          Map body = {
            "PassKey": "a486f489-76c0-4c49-8ff0-d0fdec0a162b",
            "UserName": usernameController.text.trim(),
            "UserPassword": passwordController.text.trim(),
            "Device_token": token,
          };

          print('token body $token');
          http.post(Uri.parse(uri), body: body).then((response) async {
            if (response.statusCode == 200) {
              var jsonResponse = jsonDecode(response.body);
              print("Reponse---2 : $jsonResponse");
              if (jsonResponse["StatusCode"] == 200) {
                LoginResponse login =
                    new LoginResponse.fromJson(jsonResponse["ResultObject"][0]);
                // print(login.toString());
                print("login.tokenKey: ${login.tokenKey}");
                print("userId---3 : ${login.userId}");

                await globalMyLocalPrefes.setInt(
                    AppConstant.USER_ID.toString(), login.userId);

                await globalMyLocalPrefes.setString(
                    AppConstant.ACCESS_TOKEN, login.tokenKey);
                await globalMyLocalPrefes.setString(
                    AppConstant.USERNAME, login.eng_fullname);
                await globalMyLocalPrefes.setString(
                    AppConstant.IMAGE, login.emp_photo??"");
                await globalMyLocalPrefes.setString(
                    AppConstant.PHONENO, login.emp_mobile);
                await globalMyLocalPrefes.setString(
                    AppConstant.EMAIL, login.userEmail);
                await globalMyLocalPrefes.setString(
                    AppConstant.DEPARTMENT, login.emp_dep);

                await globalMyLocalPrefes.setString(
                    AppConstant.COMPANY, login.emp_company);

                await globalMyLocalPrefes.setString(
                    AppConstant.LoginGmailID, usernameController.text.trim());
                await globalMyLocalPrefes.setString(
                    AppConstant.PASSWORD, passwordController.text.trim());

                await globalMyLocalPrefes.setString(
                    AppConstant.EMP_ID, login.emp_no);
                print(
                    "Ge ${globalMyLocalPrefes.getInt(AppConstant.USER_ID.toString())}");
                print(
                    "EMP_ID ${globalMyLocalPrefes.getString(AppConstant.EMP_ID.toString())}");

                setState(() {
                  _state = 2;
                  buttonText = 'Success';
                  animateButton();
                });
                Navigator.pushNamedAndRemoveUntil(
                    context, homeRoute, ModalRoute.withName(homeRoute));
              } else {
                setState(() {
                  _state = 3;
                  buttonText = 'RETRY';
                });
                _scaffoldKey.currentState.showSnackBar(UIhelper.showSnackbars(
                    "Something wnet wrong.. Please try again later."));
              }
            } else {
              print("response.statusCode.." + response.statusCode.toString());
              setState(() {
                _state = 3;
                buttonText = 'RETRY';
              });
              _scaffoldKey.currentState.showSnackBar(UIhelper.showSnackbars(
                  "Something wnet wrong.. Please try again later."));
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage('lib/assets/images/back.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("TK-HRMS",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Bold",
                                      color: leaveCardcolor,
                                      fontSize:
                                          40,
                                      letterSpacing: .6,
                                      fontWeight: FontWeight.bold)),
                              Text("Human Resource Management System",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Bold",
                                      color: leaveCardcolor1,
                                      fontSize:
                                          24,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.09,
                      width: size.width,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 28.0, right: 28.0),
                      child: formCard(),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: 164.0,
                          height: 55.0,
                          child: RaisedButton(
                            color: getColor(),
                            textColor: Colors.white,
                            elevation: 2.0,
                            child: getButtonChild(),
                            onPressed: () {
                              _handleSubmitted();
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text("Other Options",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                fontFamily: "Poppins-Medium")),
                        horizontalLine()
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have Login Details? ",
                          style: TextStyle(fontFamily: "Poppins-Medium"),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text("Contact Admin",
                              style: TextStyle(
                                  color: splashScreenColorTop,
                                  fontFamily: "Poppins-Bold",
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formCard() {
    return new Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              SizedBox(
                height:30,
              ),
              Container(
                height: 55,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  maxLength: 30,
                  controller: usernameController,
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dashBoardColor),
                      ),
                      icon: Icon(
                        Icons.person,
                        color: dashBoardColor,
                      ),
                      hintText: "Employee ID",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0)),
                  validator: (value) =>
                      value.isEmpty ? 'Email Id can\'t be empty' : null,
                  onSaved: (value) => _email = value.trim(),
                ),
              ),
              Container(
                height: 55,
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  autofocus: true,
                  maxLength: 20,
                  focusNode: focus,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dashBoardColor),
                      ),
                      icon: Icon(
                        Icons.lock,
                        color: dashBoardColor,
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0)),
                  validator: (value) =>
                      value.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) => _password = value,
                ),
              ),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: dashBoardColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins-Medium",
                          fontSize: 24),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getButtonChild() {
    if (_state == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_state == 1) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(
              width: 2,
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppConstant.LOGIN_BUTTON_SIZE,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_state == 2) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check, color: Colors.white),
            SizedBox(
              width: 4,
            ),
            Text(
              buttonText,
              style: const TextStyle(
                  color: Colors.white, fontSize: AppConstant.LOGIN_BUTTON_SIZE),
            ),
          ],
        ),
      );
    } else if (_state == 3) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.close, color: Colors.white),
            SizedBox(
              width: 4,
            ),
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: AppConstant.LOGIN_BUTTON_SIZE,
              ),
            ),
          ],
        ),
      );
    }
  }

  void animateButton() {
    UIhelper.dismissKeyboard(context);
    Timer(Duration(milliseconds: 300), () {
      // navigateToSubPage(context);
    });
  }

  String token = '';
  void generateTocken() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
  }

  Color getColor() {
    if (_state == 0) {
      return AppTheme.buttonAccessColor;
    } else if (_state == 1) {
      return Color(0xFF6078ea);
    } else if (_state == 2) {
      return Colors.green;
    } else if (_state == 3) {
      return Colors.red;
    }
    return AppTheme.buttonAccessColor;
  }
}
