import 'dart:developer';

import 'package:HRMNew/classes/language.dart';
import 'package:HRMNew/components/LogoutOverlay.dart';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/models/permission.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Network.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/models/balancePodo.dart';
import 'package:HRMNew/src/screens/Login/PODO/loginResponse.dart';
import 'package:HRMNew/utils/UIhelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:toast/toast.dart';


List<Permission> listOfPermission=[];

Permission getPermissionObject(String type){
Permission _permission;
  listOfPermission.forEach((element) {
    if(element.app_permissionName==type){
      _permission= element;
    }
  });

  return _permission;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double _initFabHeight = 120.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  SharedPreferences sharedPreferences;
  String _username, firstName, lastName, username, department, image;
  Uint8List bytes;

  bool isLoading = true;
  var _color = [
    Colors.pink[200],
    Colors.green[100],
    Colors.orange[100],
    Colors.purple[100],
    Colors.blue[100],
    Colors.pink[200],
    Colors.green[100],
    Colors.orange[100],
    Colors.purple[100],
  ];

  List<ResultObject1> balanceList = new List();
  @override
  void initState() {
    super.initState();
    _register();
    _fabHeight = _initFabHeight;
  }

  Future _register() async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    print("Token Access: $token");
    try {
      final uri = Services.GetPermissions;
      Map body = {
        "Tokenkey": token,
      };

      http.post(uri, body: body).then((response) {
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          print('permission response  $jsonResponse');

          if (jsonResponse["StatusCode"] == 200) {
            // sharedPreferences.setString(
            //     AppConstant.PERMISSIONS, jsonResponse['ResultObject']);
            final List parsed = jsonResponse['ResultObject'];
            List<Permission> _permissions =[];

               parsed.forEach((element) {
                 _permissions.add(Permission.fromJson(element));
               });

               setState(() {
                 listOfPermission=_permissions;

               });

            // print("%%%%%%%%%%%%%%%%%%% ${_permissions[0].roleName}");
            getLeaveCounts();
          } else {
            setState(() {
              isLoading = false;
            });
            print("ModelError: ${jsonResponse["ModelErrors"]}");
            if (jsonResponse["ModelErrors"] == 'Unauthorized') {
              GetToken().getToken().then((value) {
                _register();
              });
            } else {
              _scaffoldKey.currentState.showSnackBar(
                  UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
            }
          }
        } else {
          print("response.statusCode.." + response.statusCode.toString());
          _scaffoldKey.currentState.showSnackBar(UIhelper.showSnackbars(
              "Something wnet wrong.. Please try again later."));
        }
      });
    } catch (e) {
      print("Error: $e");
      return (e);
    }
  }

  Future<void> getLeaveCounts() async {
    balanceList.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.LeaveBalance;

    setState(() {
      isLoading = true;
    });
    Map body = {"Tokenkey": token, "lang": '2'};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("j&&&&&&&&&&&&&&&&&&&&&&&" + jsonResponse.toString());
      GetBalance balance = new GetBalance.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        balanceList = balance.resultObject;

        // for (int i = 0; i < balanceList.length; i++) {
        //   leaveTypeList.add(balanceList[i]);
        // }
        // });
        print(balanceList.toString());
        setState(() {
          isLoading = false;
          username = sharedPreferences.getString(AppConstant.USERNAME);
          department = sharedPreferences.getString(AppConstant.DEPARTMENT);
          image = sharedPreferences.getString(AppConstant.IMAGE);
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            getLeaveCounts();
          });
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .70;
    if (!isLoading) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            getTranslated(context, 'TKGroupHRMS'),
            style: TextStyle(
                fontFamily: "sf-ui-text", fontWeight: FontWeight.bold),
          ),
          // backgroundColor: leaveCardcolor1,
          shadowColor: Colors.transparent,
          centerTitle: true,
          // leading: IconButton(
          //     icon: Icon(Icons.notifications),
          //     color: Colors.white,
          //     onPressed: () {
          //       Navigator.pushNamed(context, notificationRoute);
          //     }),
          actions: <Widget>[
            Padding(
              // margin: EdgeInsets.only(left: 0),
              padding: const EdgeInsets.all(8.0),
              // width: 50,
              // color: Colors.pink,
              child: DropdownButton<Language>(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                onChanged: (Language language) {
                  _changeLanguage(language);
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              e.flag,
                              height: 25,
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(e.name)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              backdropEnabled: true,
              maxHeight: _panelHeightOpen,
              minHeight: 90,
              parallaxEnabled: true,
              parallaxOffset: .3,
              body: _body(),
              panelBuilder: (sc) => _panel(sc, context),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              }),
            ) //the SlidingUpPanel Title
          ],
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }

  Widget _panel(ScrollController sc, BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('E, dd MMM yyyy');
    String formattedDate = formatter.format(now);
    if (image != null) {
      bytes = Base64Codec().decode(image);
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
              ],
            ),
            child: Column(children: <Widget>[
              SizedBox(
                height: 3.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 5.0,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: new CircleAvatar(
                        radius: 35,
                        child: bytes != null
                            ? ClipOval(
                                child: new Image.memory(
                                bytes,
                                height: 75,
                              ))
                            : ClipOval(
                                child: Image.asset(
                                  "lib/assets/images/profile.jpg",
                                  height: 75,
                                  // width: 90,
                                ),
                              ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username??"",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 6)),
                          Text(department, style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.logout),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => LogoutOverlay(),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 7.0,
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _cardList(
                    "PROFILE",
                    "lib/assets/images/viewProfile.png",
                    "View your profile details",
                    Icons.arrow_forward_ios,
                    accountRoute),
                _cardList(
                    "FY 2020 Holiday Sheet",
                    "lib/assets/images/vector-holiday.jpg",
                    "Get holidays list of this finalcial year",
                    Icons.arrow_forward_ios,
                    calendarViewRoute),
                _cardList(
                    "NOTES / RULES",
                    "lib/assets/images/rules.png",
                    "Get list of all notes/rule of company",
                    Icons.arrow_forward_ios,
                    rulesRoute),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardList(
      String title, String img, String subtitle, IconData icon, String pagNav) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, pagNav);
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListTile(
                leading: Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[700]),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
                trailing: Icon(
                  icon,
                  size: 15,
                ),
                title: Text(title),
                subtitle: Text(subtitle,
                    style: TextStyle(color: Color(0xFF797777), fontSize: 12.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeGrid(String title, String img, String pagNav, String countTxt) {
    return new GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, pagNav);
      },
      child: Container(
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(15),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey[400],
        //       spreadRadius: 3,
        //       blurRadius: 5,
        //       offset: Offset(0, 1), // changes position of shadow
        //     ),
        //   ],
        // ),
        alignment: AlignmentDirectional(0.0, 0.0),
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              countTxt == null
                  ? Container()
                  : Container(
                      // color: Colors.pink,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          child: Center(
                              child: Text(countTxt,
                                  style: TextStyle(color: Colors.white))),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.red[400], spreadRadius: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
              countTxt == null
                  ? Padding(padding: EdgeInsets.only(top: 10))
                  : Padding(padding: EdgeInsets.only(bottom: 0)),
<<<<<<< HEAD
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500],
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    img,
                    fit: BoxFit.contain,
                    height: 45,
                  ),
                ),
              ),
              countTxt == null
                  ? Padding(padding: EdgeInsets.only(bottom: 7))
                  : Padding(padding: EdgeInsets.only(bottom: 7)),
=======
              Image.asset(
                img,
                fit: BoxFit.contain,
                height: 55,
              ),
              countTxt == null
                  ? Padding(padding: EdgeInsets.only(bottom: 10))
                  : Padding(padding: EdgeInsets.only(bottom: 3)),
>>>>>>> 2b50d07dce896c8c1d760cb9aeff9945b14fb5bd
              Text(
                title,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              // Padding(padding: EdgeInsets.only(top: 5))
            ]),
      ),
    );
  }

  Widget _homeSlider(
      String title, String leaveValues, String leaveTotal, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        // shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
        color: leaveCardcolor1,
      ),
      padding: EdgeInsets.all(7),
      child: Container(
        width: 90,
        height: 70,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "$leaveValues / $leaveTotal",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(top: 6)),
              Container(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget _body() {
    print("in body---");
    Size size = MediaQuery.of(context).size;
    return Container(
      color: leaveCardcolor,
      child: Column(children: [
        Container(
          height: size.height * 0.11,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(
              // shape: BoxShape.circle, 
              // BoxShape.circle or BoxShape.retangle
              color: leaveCardcolor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[800], blurRadius: 4.0, spreadRadius: 1),
              ],
              ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              for (var i = 0; i < balanceList.length; i++)
                _homeSlider(balanceList[i].leaveName, balanceList[i].leaveUse,
                    balanceList[i].leaveTotal, _color[i])
            ],
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: size.height,
            child: GridView.count(
              primary: false,
              // padding: const EdgeInsets.all(10),
              // crossAxisSpacing: 15,
              // mainAxisSpacing: 15,
              crossAxisCount: 3,
              children:getChildren(),
            ),
          ),
        ),
      ]),
    );
  }


  List<Widget> getChildren(){

    List<Widget> list=[];


    if(getPermissionObject('News')?.app_view=='1'){
    list.add(_homeGrid("News", "lib/assets/images/news12.jpg",
    newsList,getPermissionObject('News')?.CountItem??'0'));
    }

    if(getPermissionObject('Tasks')?.app_view=='1'){
    list.add( _homeGrid(
    "Tasks", "lib/assets/images/task.png", taskRoute, getPermissionObject('Tasks')?.CountItem??'0'));
    }

    if(getPermissionObject('Emp Request')?.app_view=='1'){
    list.add( _homeGrid("Emp Request", "lib/assets/images/empReuest.png",
    empRequestRoute, getPermissionObject('Emp Request')?.CountItem??'0'));
    }

    if(getPermissionObject('Delegates')?.app_view=='1'){
    list.add( _homeGrid("Delegates", "lib/assets/images/transfer_teacher.jpg",
    delegateRoute,getPermissionObject('Delegates')?.CountItem??'0'));
    }


    print('my rew appview  ${getPermissionObject('My Request')?.app_view}');
    if(getPermissionObject('My Request')?.app_view=='1'){
    list.add( _homeGrid("My Request", "lib/assets/images/images.png",
    myRequestRoute,getPermissionObject('My Request')?.CountItem??'0'));
    }


    if(getPermissionObject('Attendance')?.app_view=='1'){
    list.add( _homeGrid("Attendance", "lib/assets/images/attendance.png",
    attendanceRoute, null));
    }

    if(getPermissionObject('Loans')?.app_view=='1'){
    list.add( _homeGrid(
    "Loans", "lib/assets/images/loan.png", loansRoute, null));
    }

    if(getPermissionObject('Insurance')?.app_view=='1'){
    list.add(  _homeGrid("Insurance", "lib/assets/images/insurance.png",
    insuranceRoute, null));
    }

    if(getPermissionObject('Payslip')?.app_view=='1'){
    list.add(  _homeGrid("Payslip", "lib/assets/images/payslip.png",
    payslipRoute, null));
    }

    if(getPermissionObject('Holiday')?.app_view=='1'){
    list.add(_homeGrid("Holiday", "lib/assets/images/holiday-icon.png",
    calendarViewRoute, null));
    }
    return list;
  }

}



class GetToken {
  SharedPreferences sharedPreferences;
  Future<void> getToken() async {
    Network().check().then((intenet) async {
      if (intenet != null && intenet) {
        sharedPreferences = await SharedPreferences.getInstance();
        String username = sharedPreferences.getString(AppConstant.LoginGmailID);
        String password = sharedPreferences.getString(AppConstant.PASSWORD);
        String urname = sharedPreferences.getString(AppConstant.USERNAME);

        print("Here--In Token-----$username");
        try {
          final uri = Services.LOGIN;
          Map body = {
            "PassKey": "a486f489-76c0-4c49-8ff0-d0fdec0a162b",
            "UserName": username,
            "UserPassword": password
          };
          print("Here--In Token-----$body");

          http.post(uri, body: body).then((response) {
            if (response.statusCode == 200) {
              var jsonResponse = jsonDecode(response.body);
              print("Here--In Token-----$jsonResponse");
              if (jsonResponse["StatusCode"] == 200) {

                LoginResponse login =
                    new LoginResponse.fromJson(jsonResponse["ResultObject"][0]);

                sharedPreferences.setInt(
                    AppConstant.USER_ID.toString(), login.userId);
                sharedPreferences.setString(AppConstant.EMP_ID, login.emp_no);
                sharedPreferences.setString(
                    AppConstant.ACCESS_TOKEN, login.tokenKey);
                print("New token : ${login.tokenKey}");
                sharedPreferences.setString(
                    AppConstant.USERNAME, login.eng_fullname);
                sharedPreferences.setString(AppConstant.IMAGE, login.emp_photo);
                sharedPreferences.setString(
                    AppConstant.PHONENO, login.emp_mobile);
                sharedPreferences.setString(AppConstant.EMAIL, login.userEmail);
                sharedPreferences.setString(
                    AppConstant.DEPARTMENT, login.emp_dep);
                sharedPreferences.setString(
                    AppConstant.COMPANY, login.emp_company);
                return login.tokenKey;
              } else {
                return "Something wnet wrong.. Please try again later.";
              }
            } else {
              print("response.statusCode.." + response.statusCode.toString());

              return "Something wnet wrong.. Please try again later.";
            }
          });
        } catch (e) {
          print("Error: $e");
          return (e);
        }
      } else {
        return "Please check internet connection";
      }
    });
  }
}
