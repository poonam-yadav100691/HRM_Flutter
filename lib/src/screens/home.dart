import 'package:HRMNew/classes/language.dart';
import 'package:HRMNew/components/LogoutOverlay.dart';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  SharedPreferences sharedPreferences;

  String _username;
  String firstName, lastName, username, department, image;
  @override
  void initState() {
    super.initState();
    _register();
    _fabHeight = _initFabHeight;
  }

  Future _register() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      String accessToken =
          sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
      print("token 1" + accessToken);
      int userId = sharedPreferences.getInt(AppConstant.USER_ID.toString());
      print("token2 $userId");
      username = sharedPreferences.getString(AppConstant.USERNAME);
      print("token3 $username");

      department = sharedPreferences.getString(AppConstant.DEPARTMENT);
      print("token5 $department");

      image = sharedPreferences.getString(AppConstant.IMAGE);
      print("token6 $image");
    });
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .65;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          getTranslated(context, 'MyDetails'),
          style:
              TextStyle(fontFamily: "sf-ui-text", fontWeight: FontWeight.bold),
        ),
        backgroundColor: leaveCardcolor1,
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
            minHeight: 85,
            parallaxEnabled: true,
            parallaxOffset: .5,
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
  }

  Widget _panel(ScrollController sc, BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('E, dd MMM yyyy');
    String formattedDate = formatter.format(now);
    Uint8List bytes = Base64Codec().decode(image);
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
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
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
                              topRight: Radius.circular(12.0))),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 1.0,
                // ),
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
                        child: ClipOval(
                          child: new Image.memory(
                            bytes,
                            height: 75,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
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
              padding:
                  EdgeInsets.only(left: 10, bottom: 50, right: 10, top: 16),
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

                  // _cardList(
                  //     "ADD REQUEST",
                  //     "lib/assets/images/calendar.png",
                  //     "Allow to add new leave/OT application",
                  //     Icons.arrow_forward_ios,
                  //     addRequestRoute),
                  // _cardList(
                  //     "VIEW REQUESTS",
                  //     "lib/assets/images/weekly-calendar.png",
                  //     "Check your application status",
                  //     Icons.arrow_forward_ios,
                  //     myRequestRoute),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //         color: Colors.pink,
                  //         width: MediaQuery.of(context).size.width * .35,
                  //         height: 2,
                  //         child: Text("")),
                  //     Container(
                  //         child: Text(
                  //       "Official Things",
                  //       style: TextStyle(fontWeight: FontWeight.w500),
                  //     )),
                  //     Container(
                  //         color: Colors.pink,
                  //         width: MediaQuery.of(context).size.width * .35,
                  //         height: 2,
                  //         child: Text("")),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  // _cardList(
                  //     "ADD DELEGATES",
                  //     "lib/assets/images/exchange.png",
                  //     "Transfer your job to other person",
                  //     Icons.arrow_forward_ios,
                  //     addDelegatesRoute),
                  // _cardList(
                  //     "EMP PENDING REQUEST",
                  //     "lib/assets/images/email.png",
                  //     "Get list of pending requests of your team",
                  //     Icons.arrow_forward_ios,
                  //     empRequestRoute),
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
        ));
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800],
              spreadRadius: 4,
              blurRadius: 8,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        alignment: AlignmentDirectional(0.0, 0.0),
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Container(
              //     color: Colors.green,
              //     constraints: BoxConstraints(
              //         maxHeight: 30.0,
              //         maxWidth: 30.0,
              //         minWidth: 10.0,
              //         minHeight: 10.0)),
              countTxt == null
                  ? Visibility(
                      child: Text("Gone"),
                      visible: false,
                    )
                  : Container(
                      // margin: EdgeInsets.only(bottom: 20),
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
              Image.asset(img, fit: BoxFit.contain, width: 52, height: 50),

              countTxt == null
                  ? Padding(padding: EdgeInsets.only(top: 10))
                  : Padding(padding: EdgeInsets.only(top: 3)),
              Text(
                title,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Padding(padding: EdgeInsets.only(top: 5))
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

        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     gradient: LinearGradient(
        //         begin: Alignment.topRight,
        //         end: Alignment.bottomLeft,
        //         stops: [0.2, 0.9],
        //         colors: [white, bgColor])),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "$leaveValues / $leaveTotal",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                title,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold),
              ),
            ]),
      ),
    );
  }

  Widget _body() {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: leaveCardcolor,
      child: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(
              // shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
              color: leaveCardcolor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[800], blurRadius: 4.0, spreadRadius: 1),
              ]),
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              // _homeSlider("TOTAL", "15", "25", Colors.pink[200]),
              _homeSlider("SICK", "3", "7", Colors.green[100]),
              _homeSlider("CASUAL", "2", "5", Colors.orange[100]),
              _homeSlider("PERSONAL", "1", "5", Colors.purple[100]),
              _homeSlider("ANNUAL", "5", "10", Colors.blue[100]),
            ],
          ),
        ),
        Container(
            height: size.height * 0.90,
            // flex: 2,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              crossAxisCount: 3,
              children: <Widget>[
                _homeGrid("News", "lib/assets/images/news12.jpg",
                    notificationRoute, '20'),
                _homeGrid(
                    "Tasks", "lib/assets/images/task.png", taskRoute, '3'),
                _homeGrid("Emp Request", "lib/assets/images/empReuest.png",
                    empRequestRoute, '2'),
                // _homeGrid("Request", "lib/assets/images/download.png",
                //     addRequestRoute, '9'),
                _homeGrid("Delegates", "lib/assets/images/transfer_teacher.jpg",
                    addDelegatesRoute, '6'),

                _homeGrid("My Request", "lib/assets/images/images.png",
                    myRequestRoute, '4'),
                _homeGrid("Attendance", "lib/assets/images/attendance.png",
                    attendanceRoute, null),

                // _homeGrid("Notifications",  "lib/assets/images/unnamed.jpg",notificationRoute),

                _homeGrid(
                    "Loans", "lib/assets/images/loan.png", loansRoute, null),
                _homeGrid("Insurance", "lib/assets/images/insurance.png",
                    insuranceRoute, null),
                _homeGrid("Payslip", "lib/assets/images/payslip.png",
                    payslipRoute, null),
                _homeGrid("Holiday", "lib/assets/images/holiday-icon.png",
                    calendarViewRoute, null),
                // _homeGrid("Check-In",  "lib/assets/images/XSgklyxE.jpg",''),
              ],
            )),
      ]),
    );
  }
}
