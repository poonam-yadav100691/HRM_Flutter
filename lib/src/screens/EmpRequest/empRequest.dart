import 'dart:async';
import 'dart:convert';
import 'package:HRMNew/src/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/EmpRequest/EmpLeaveRequest/empLeaveRequest.dart';
import 'package:HRMNew/src/screens/EmpRequest/EmpOTRequest/empOtRequest.dart';
import 'package:HRMNew/src/screens/EmpRequest/empRequestPODO.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpRequest extends StatefulWidget {
  // final TabController tabBar;
  EmpRequest();

  @override
  _EmpRequestState createState() => _EmpRequestState();
}

class _EmpRequestState extends State<EmpRequest> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ResultObject> empRequestList = new List();
  List<ResultObject> empLeaveReqList = new List();
  List<ResultObject> empOtReqList = new List();
  AnimationController animationController;
  Animation<dynamic> animation;
  bool isLoading = false;
  @override
  void initState() {
    _getEmpRequests();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

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
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                body: TabBarView(
                  children: [
                    empLeaveReqList.isNotEmpty
                        ? EmpLeaveRequest(data: empLeaveReqList)
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: CircularProgressIndicator())),
                    empLeaveReqList.isNotEmpty
                        ? EmpOTRequest(data: empOtReqList)
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: CircularProgressIndicator()))
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
            )));
  }

  Future<void> _getEmpRequests() async {
    // setState(() {
    //   isLoading = true;
    // });
    empRequestList.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.EmpRequest;
    Map body = {"Tokenkey": token, "lang": '2'};
        print("j&&&body: $body");
        print("uri::: $uri");
    http.post(uri, body: body).then((response) async {
      var jsonResponse = jsonDecode(response.body);
      EmpRequestList myRequest = new EmpRequestList.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        empRequestList = myRequest.resultObject;
        for (int i = 0; i < empRequestList.length; i++) {
          if (empRequestList[i].requestType == 'Leave') {
            empLeaveReqList.add(empRequestList[i]);
          } else {
            empOtReqList.add(empRequestList[i]);
          }
        }
        setState(() {
          isLoading = false;
        });
        // print("DDDDDDDDDDDDDDDDDDDDD--->>>${empRequestList.toString()}");
        // print("FFFFFFFFFFFFFFFFFFFFF--->>>>${empLeaveReqList.toString()}");
        // print("CCCCCCCCCCCCCCCCCCCCF--->>>>${empOtReqList.toString()}");
      } else {
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          print("ModelError: ${jsonResponse["ModelErrors"]}");
          await GetToken().getToken();
          print("token new token:: $token");
          _getEmpRequests();
          // Future<String> token = getToken();
        } else {
             setState(() {
          isLoading = false;
        });
            print("ModelError: ${jsonResponse["ModelErrors"]}");
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }
}
