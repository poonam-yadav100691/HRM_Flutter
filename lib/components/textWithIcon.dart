import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  final IconData textIcon;
  final String textValue;
  final Color iconColor;
  TextWithIcon({this.textIcon, this.textValue, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: TextField(
          autocorrect: true,
          enabled: false,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: textValue,
              prefixIcon: Icon(
                textIcon,
                color: iconColor,
                size: 25,
              ),
              hintStyle: TextStyle(color: Colors.black, fontSize: 18),
              filled: true,
              fillColor: Colors.white,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.grey[350], width: 1),
              ))),
    );
  }
}
