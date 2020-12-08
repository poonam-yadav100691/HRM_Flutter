import 'package:HRMNew/components/textWithIcon.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 100.0,
                height: 100.0,
                margin: const EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("lib/assets/images/XSgklyxE.jpg")))),

            Container(
                // color: Colors.pink,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                    "Make sure you are in your geofance area tomake attandance. Please note your location is recorded for this attesndance.",
                    style: TextStyle(color: Colors.grey[800]))),

            Container(
                child: RaisedButton(
                    onPressed: () {},
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Check-In',
                          style: TextStyle(fontSize: 20)),
                    ))),

            // SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
