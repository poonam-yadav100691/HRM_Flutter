import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/NotificationPage/component/body.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'News')),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: leaveCardcolor,
      ),
      body: Body(),
    );
  }
}
