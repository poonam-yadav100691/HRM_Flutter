import 'package:HRMNew/src/screens/AddRequest/LeaveRequest/leaveRequest.dart';
import 'package:HRMNew/src/screens/AddRequest/OTRequest/otRequest.dart';
import 'package:flutter/material.dart';

class AddRequest extends StatefulWidget {
  // final TabController tabBar;
  AddRequest();

  @override
  _AddRequestState createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: TabBarView(
          children: [
            new LeaveRequest(),
            new OTRequest(),
          ],
        ),
        bottomNavigationBar: new TabBar(
          tabs: [
            Tab(
              text: 'LEAVE REQUEST',
              // icon: new Icon(Icons.home),
            ),
            Tab(
              text: 'OT REQUEST',
              // icon: new Icon(Icons.rss_feed),
            ),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(1.0),
          indicatorColor: Colors.red,
          indicator: BoxDecoration(
            color: Colors.white,

            // borderRadius: BorderRadius.circular(15.0),
            boxShadow: [BoxShadow(color: Colors.red, blurRadius: 3.0)],
          ),
        ),
        // backgroundColor: Colors.black,
      ),
    );
  }
}
