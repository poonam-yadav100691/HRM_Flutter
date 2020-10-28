import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:HRMNew/localization/localization_constants.dart';

class ApprovalAction extends StatefulWidget {
  final String actionText;

  ApprovalAction(this.actionText);
  @override
  State<StatefulWidget> createState() => ApprovalActionState();
}

class ApprovalActionState extends State<ApprovalAction>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

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
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, left: 0.0, right: 0.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: getTranslated(
                                        context, "AreYouSureYouWantTo")),
                                new TextSpan(
                                    text: '${widget.actionText}',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold)),
                                new TextSpan(
                                    text: getTranslated(context, "ThisOrder")),
                              ],
                            ),
                          ))),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ButtonTheme(
                            height: 35.0,
                            minWidth: 110.0,
                            child: RaisedButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              splashColor: leaveCardcolor.withAlpha(70),
                              child: Text(
                                getTranslated(context, 'No'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: ButtonTheme(
                              height: 35.0,
                              minWidth: 110.0,
                              child: RaisedButton(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                splashColor: Colors.white.withAlpha(40),
                                child: Text(
                                  getTranslated(context, 'Yes'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      backgroundColor: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                      context, empRequestRoute);
                                  // setState(() {
                                  //   /* Route route = MaterialPageRoute(
                                  //         builder: (context) => LoginScreen());
                                  //     Navigator.pushReplacement(context, route);
                                  //  */
                                  // }
                                  // );
                                },
                              ))),
                    ],
                  ))
                ],
              )),
        ),
      ),
    );
  }
}
