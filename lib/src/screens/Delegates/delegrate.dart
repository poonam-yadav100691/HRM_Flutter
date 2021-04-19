import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:HRMNew/src/screens/Delegates/component/body.dart';

class Delegate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'Delegates')),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: leaveCardcolor,
      ),
      body: Body(),
      floatingActionButton: getPermissionObject('Delegates').app_add=="1"?FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacementNamed(context, addDelegateRoute);
          // Add your onPressed code here!
        },
        elevation: 4,
        label: Text('Delegates'),
        icon: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.pink,
      ):null,
    );
  }
}
