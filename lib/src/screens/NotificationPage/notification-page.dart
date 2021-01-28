import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/routes/route_names.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, addNewsRoute);
          // Add your onPressed code here!
        },
        elevation: 4,
        label: Text('News'),
        icon: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
