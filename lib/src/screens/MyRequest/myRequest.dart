import 'dart:async';
import 'dart:convert';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveRequest.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/PODO/myRequest.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/myOtRequest.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRequest extends StatefulWidget {
  // final TabController tabBar;
  MyRequest();

  @override
  _MyRequestState createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ResultObject> myRequestList = new List();
  List<ResultObject> leaveReqList = new List();
  List<ResultObject> otReqList = new List();
  AnimationController animationController;
  Animation<dynamic> animation;
  bool isLoading = true;

  @override
  void initState() {
    _getRequests();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    var screenWidth = _mediaQueryData.size.width;
    var screenHeight = _mediaQueryData.size.height;
    if (!isLoading) {
      return Align(
          alignment: Alignment.bottomLeft, // and bottomLeft
          child: SafeArea(
              bottom: true,
              top: false,
              child: DefaultTabController(
                length: 2,
                child: new Scaffold(
                  // appBar: AppBar(
                  //   title: Text('My Request'),
                  //   shadowColor: Colors.transparent,
                  //   centerTitle: true,
                  //   backgroundColor: leaveCardcolor,
                  //   automaticallyImplyLeading: false,
                  //   leading: IconButton(
                  //       icon: Icon(Icons.arrow_back_ios),
                  //       color: Colors.white,
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       }),
                  // ),

                  floatingActionButton:
                      getPermissionObject('My Request').app_add == "1"
                          ? FloatingActionButton.extended(
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
                            )
                          : null,
                  body: TabBarView(
                    children: [
                      isLoading
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Center(child: CircularProgressIndicator()))
                          : (leaveReqList ?? []).isNotEmpty
                              ? MyLeaveRequest(data: leaveReqList)
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(child: Text('No Data Found'))),
                      isLoading
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Center(child: CircularProgressIndicator()))
                          : (otReqList ?? []).isNotEmpty
                              ? MyOTRequest(otReqList)
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(child: Text('No Data Found'))),
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
                      boxShadow: [
                        BoxShadow(color: Colors.red, blurRadius: 3.0)
                      ],
                    ),
                  ),
                  // backgroundColor: Colors.black,
                ),
              )));
      // } else {
      //   return Container(child: Center(child: CircularProgressIndicator()));
      // }
    }
  }

  Future<void> _getRequests() async {
    setState(() {
      isLoading = true;
    });
    myRequestList.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.MyRequest;
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      MyRequests myRequest = new MyRequests.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        print("j&&& $myRequest");
        myRequestList = myRequest.resultObject;
        for (int i = 0; i < myRequestList.length; i++) {
          print("j& ${myRequestList[i].requestType.toString()}");
          if (myRequestList[i].requestType == 'Leave') {
            leaveReqList.add(myRequestList[i]);
          } else {
            otReqList.add(myRequestList[i]);
          }
        }

        setState(() {
          isLoading = false;
        });
        // print(myRequestList.toString());
        print(leaveReqList.length);
        print(otReqList.toString());
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _getRequests();
          });
        } else {
          setState(() {
            isLoading = false;
          });
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }
}
