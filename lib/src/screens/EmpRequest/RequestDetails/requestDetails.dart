import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/EmpRequest/RequestDetails/component/body.dart';
import 'package:flutter/material.dart';

class RequestDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, addRequestRoute);
          // Add your onPressed code here!
        },
        elevation: 4,
        child: Icon(
          Icons.calendar_today,
        ),
        backgroundColor: Colors.pink,
      ),
      body: Body(),
    );
  }

  //  Future<T> _onBackPressed<T>(BuildContext context, Widget page) {

}
