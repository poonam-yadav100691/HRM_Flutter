import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/NewsPage/component/body.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, homeRoute),
        ),
        title: Text(getTranslated(context, 'News')),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: leaveCardcolor,
      ),
      body: Body(),
    );
  }
}
