import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/component/body.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/PODO/myRequest.dart';
import 'package:flutter/material.dart';

class MyLeaveRequest extends StatelessWidget {
  // final List data;
  final List<ResultObject> data;
  MyLeaveRequest({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests'),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: leaveCardcolor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Body(leaveList: data),
      resizeToAvoidBottomPadding: true,
    );
  }
}
