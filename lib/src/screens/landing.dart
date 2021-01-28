import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      _loadUserInfo();
    });
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(AppConstant.ACCESS_TOKEN);

    print("token 345 $token");
    if (token == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else if (token != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "lib/assets/logo/HRMS.png",
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: SpinKitThreeBounce(
                color: Colors.purple,
                size: 30.0,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
