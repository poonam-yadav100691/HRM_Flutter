import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: Column(
      children: [
        new Container(
            height: 100.0,
            margin: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 4.0,
            ),
            child: new Stack(
              children: <Widget>[
                planetCard(context),
                planetThumbnail,
              ],
            )),
      ],
    ));
  }

  final planetThumbnail = new Container(
    margin: new EdgeInsets.symmetric(vertical: 15.0),
    // color: Colors.pink,
    alignment: FractionalOffset.centerLeft,
    child: new Image(
      image: new AssetImage("lib/assets/images/checked.png"),
      height: 52.0,
      width: 52.0,
    ),
  );
  Widget planetCard(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width * 0.88,
      margin: new EdgeInsets.only(left: 30.0),
      decoration: new BoxDecoration(
        color: kWhiteColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: kGreyLightColor,
            blurRadius: 5.0,
            offset: new Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PERSONAL LEAVE : ',
                              style: new TextStyle(
                                  color: kRedColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Full Day',
                              style: new TextStyle(),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '2.0 days ',
                        style: new TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: [
                        Text(
                          '13 Mar 20 - 14 Mar 20',
                          style: new TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'Date Of Reply :',
                          style: new TextStyle(),
                        ),
                        Text(
                          '13 Mar 20',
                          style: new TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Manager :',
                        style: new TextStyle(),
                      ),
                      Text(
                        'Ta Manager',
                        style: new TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
