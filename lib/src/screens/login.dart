import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autovalidate = false;
  String _email, _password;
  String _errorMessage = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      if (_password == "password") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("username", _email);
        Navigator.pushNamedAndRemoveUntil(
            context, homeRoute, ModalRoute.withName(homeRoute));
      } else {
        //  showInSnackBar('Incorrect credentials');
        _errorMessage = 'Incorrect credentials';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
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
                          width: ScreenUtil.getInstance().setWidth(40),
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
                                          ScreenUtil.getInstance().setSp(90),
                                      letterSpacing: .6,
                                      fontWeight: FontWeight.bold)),
                              Text("Human Resource Management System",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Bold",
                                      color: leaveCardcolor1,
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(30),
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
                        InkWell(
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(330),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  splashScreenColorBottom,
                                  Color(0xFF6078ea)
                                ]),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _handleSubmitted,
                                child: Center(
                                  child: Text("LOGIN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins-Bold",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0)),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
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
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
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
      // height: 250,
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
                      fontSize: ScreenUtil.getInstance().setSp(40),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Container(
                height: 55,
                child: TextFormField(
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
                      value.isEmpty ? 'Username can\'t be empty' : null,
                  onSaved: (value) => _email = value.trim(),
                ),
              ),
              Container(
                height: 55,
                child: TextFormField(
                  obscureText: true,
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
                          fontSize: ScreenUtil.getInstance().setSp(28)),
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
}
