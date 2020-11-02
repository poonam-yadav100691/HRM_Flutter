import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/EmpRequest/EmpLeaveRequest/empLeaveRequest.dart';
import 'package:HRMNew/src/screens/EmpRequest/EmpOTRequest/empOtRequest.dart';
import 'package:flutter/material.dart';

class EmpRequest extends StatefulWidget {
  // final TabController tabBar;
  EmpRequest();

  @override
  _EmpRequestState createState() => _EmpRequestState();
}

class _EmpRequestState extends State<EmpRequest> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft, // and bottomLeft
        child: SafeArea(
            bottom: true,
            top: false,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Employees Requests'),
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
                // floatingActionButton: FloatingActionButton.extended(
                //   onPressed: () {
                //     Navigator.pushNamed(context, addRequestRoute);
                //     // Add your onPressed code here!
                //   },
                //   elevation: 4,
                //   label: Text('Request'),
                //   icon: Icon(
                //     Icons.add,
                //   ),
                //   backgroundColor: Colors.pink,
                // ),
                body: TabBarView(
                  children: [EmpLeaveRequest(), EmpOTRequest()],
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
