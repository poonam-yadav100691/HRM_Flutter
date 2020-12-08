import 'package:HRMNew/components/textWithIcon.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './background.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _username;
  @override
  void initState() {
    super.initState();

    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('username') ?? "");
    print(_username);
  }

  @override
  Widget build(BuildContext context) {
    String _base64 =
        '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';
    Uint8List bytes = Base64Codec().decode(_base64);
    return Background(
      child: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _base64 == null
                ? new Container()
                :
                // : Container(
                //     // padding: EdgeInsets.all(100),
                //     child: new CircleAvatar(
                //         radius: 40,
                //         child: ClipOval(child: new Image.memory(bytes)))),

                Container(
                    width: 100.0,
                    height: 100.0,
                    margin: const EdgeInsets.all(20.0),
                    child: new CircleAvatar(
                        radius: 40,
                        child: ClipOval(child: new Image.memory(bytes)))),

            TextWithIcon(
                textIcon: Icons.person,
                textValue: this._username,
                iconColor: kPrimaryColor),
            TextWithIcon(
                textIcon: Icons.email,
                textValue: 'pooyadav052@gmail.com',
                iconColor: Colors.amber),

            TextWithIcon(
                textIcon: Icons.assignment_ind,
                textValue: 'Mobile App Dev',
                iconColor: Colors.blue[500]),
            TextWithIcon(
                textIcon: Icons.business,
                textValue: 'IT Department',
                iconColor: Colors.green),
            TextWithIcon(
                textIcon: Icons.account_balance,
                textValue: 'Headquarters',
                iconColor: Colors.blue[800]),
            TextWithIcon(
                textIcon: Icons.phone,
                textValue: '+856 20235467',
                iconColor: Colors.red),

            // SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
