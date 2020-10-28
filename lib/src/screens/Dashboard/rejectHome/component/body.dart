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
    return Background(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: new Card(
              child: new InkWell(
                onTap: () {},
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .15), blurRadius: 16.0)
                    ],
                  ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Period : ',
                                    style: new TextStyle(),
                                  ),
                                  Text(
                                    '13 Mar 20 - 14 Mar 20',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Note :',
                                    style: new TextStyle(),
                                  ),
                                  Text(
                                    'Text Text Text Text..',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500),
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
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
