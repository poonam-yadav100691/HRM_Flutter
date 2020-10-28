import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<LogoutOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 180.0,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                //:const EdgeInsets.only(top: 30.0, left: 0.0, right: 0.0),
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin:
                        const EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                    child: Text(
                      getTranslated(context, "logoutConfirm"),
                      style: TextStyle(color: kPrimaryColor, fontSize: 20.0),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.red,
                          child: Text(
                            getTranslated(context, 'Logout'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                          onPressed: () => _handleLogout()),
                      RaisedButton(
                        color: Colors.green,
                        child: Text(
                          getTranslated(context, 'Cancel'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                      // )),
                    ],
                  ))
                ],
              )),
        ),
      ),
    );
  }
}
