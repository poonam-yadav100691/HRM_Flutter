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
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, .15), blurRadius: 16.0)
              ],
            ),
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _itemBuilder('Leave Type : ', 'PERSONAL LEAVE'),
                  SizedBox(
                    width: size.width,
                    height: 1.0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  _itemBuilder('Period : ', '13 Mar 20 - 14 Mar 20'),
                  SizedBox(
                    width: size.width,
                    height: 1.0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  _itemBuilder('Duration : ', '2.0 days'),
                  SizedBox(
                    width: size.width,
                    height: 1.0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  _itemBuilder(
                      'Note : ', "Attendance brother-in-law'\s marriage"),
                  SizedBox(
                    width: size.width,
                    height: 1.0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  _itemBuilder('Manager : ', 'Ta Manager'),
                  SizedBox(
                    width: size.width,
                    height: 1.0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  _itemBuilder('Leave Entry At : ', '12 Mar 2020 - 11:04 AM'),
                  SizedBox(
                    width: size.width,
                    height: 1.0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                  _itemBuilder(
                      'Approve/Reject At : ', '12 Mar 2020 - 11:06 AM'),
                ],
              ),
            )),
      ],
    ));
  }

  Widget _itemBuilder(label, textValue) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15),
            child: Row(
              children: [
                Text(
                  label,
                  style: new TextStyle(fontWeight: FontWeight.w400),
                ),
                Text(
                  textValue,
                  style: new TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
