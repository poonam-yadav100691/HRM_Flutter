import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/component/body.dart';
import 'package:flutter/material.dart';

class LeaveRequest extends StatelessWidget {
  LeaveRequest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Leave'),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: leaveCardcolor,

        automaticallyImplyLeading: false,
        // title: Text(getTranslated(context, 'MyAccount')),
        // backgroundColor: leaveCardcolor,
        // shadowColor: Colors.transparent,
        // centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Body(),
      resizeToAvoidBottomPadding: true,
    );
  }
}
