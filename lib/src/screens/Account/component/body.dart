import 'package:HRMNew/components/textWithIcon.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import './background.dart';
import 'dart:convert';
import 'dart:typed_data';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _username,
      _accessToken,
      _image,
      _department,
      _email,
      _phoneno,
      _company;
  Uint8List bytes;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    setState(() {
      _accessToken =
          (globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN) ?? "");
      // _userId =
      //     (globle.getInt(AppConstant.USER_ID.toString()) ?? "");
      _username = (globalMyLocalPrefes.getString(AppConstant.USERNAME) ?? "");
      _department =
          (globalMyLocalPrefes.getString(AppConstant.DEPARTMENT) ?? "");
      _image = (globalMyLocalPrefes.getString(AppConstant.IMAGE) ?? "");
      _email = (globalMyLocalPrefes.getString(AppConstant.EMAIL) ?? "");
      _phoneno = (globalMyLocalPrefes.getString(AppConstant.PHONENO) ?? "");
      _company = (globalMyLocalPrefes.getString(AppConstant.COMPANY) ?? "");
      print("CompanyL : $_company");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image != "") {
      bytes = Base64Codec().decode(_image);
    }
    return Background(
      child: SingleChildScrollView(
        child: Container(
          // color: Colors.blue,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // _image == ""
              //     ? new Container()
              //     : Container(
              //         width: 100.0,
              //         height: 100.0,
              //         margin: const EdgeInsets.all(20.0),
              //         child: new CircleAvatar(
              //             radius: 40,
              //             child: ClipOval(child: new Image.memory(bytes)))),
              Container(
                  padding: const EdgeInsets.only(left: 0.0, bottom: 10),
                  child: new CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    child: bytes != null
                        ? ClipOval(
                            child: new Image.memory(
                            bytes,
                            height: 150,
                          ))
                        : ClipOval(
                            child: Image.asset(
                              "lib/assets/images/profile.png",
                              height: 150,
                            ),
                          ),
                  )),
              TextWithIcon(
                  textIcon: Icons.person,
                  textValue: this._username,
                  iconColor: kPrimaryColor),
              TextWithIcon(
                  textIcon: Icons.email,
                  textValue: this._email,
                  iconColor: Colors.amber),
              TextWithIcon(
                  textIcon: Icons.assignment_ind,
                  textValue: this._department,
                  iconColor: Colors.blue[500]),
              TextWithIcon(
                  textIcon: Icons.business,
                  textValue: this._company,
                  iconColor: Colors.green),
              TextWithIcon(
                  textIcon: Icons.account_balance,
                  textValue: this._company,
                  iconColor: Colors.blue[800]),
              TextWithIcon(
                  textIcon: Icons.phone,
                  textValue: this._phoneno,
                  iconColor: Colors.red),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
