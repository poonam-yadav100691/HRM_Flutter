import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveRequest.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/myOtRequest.dart';
import 'package:flutter/material.dart';

class MyRequest extends StatefulWidget {
  // final TabController tabBar;
  MyRequest();

  @override
  _MyRequestState createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft, // and bottomLeft
        child: SafeArea(
            bottom: true,
            top: false,
            child: DefaultTabController(
              length: 2,
              child: new Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, addRequestRoute);
                    // Add your onPressed code here!
                  },
                  elevation: 4,
                  label: Text('Request'),
                  icon: Icon(
                    Icons.add,
                  ),
                  backgroundColor: Colors.pink,
                ),
                body: TabBarView(
                  children: [MyLeaveRequest(), MyOTRequest()],
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
            )));
  }
}
