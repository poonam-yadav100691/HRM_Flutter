import 'package:HRMNew/classes/language.dart';
import 'package:HRMNew/components/LogoutOverlay.dart';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/Dashboard/approveHome/approve-home.dart';
import 'package:HRMNew/src/screens/Dashboard/pendingHome/pending-home.dart';
import 'package:HRMNew/src/screens/Dashboard/rejectHome/component/reject-home.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  // _loadUserInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _username = (prefs.getString('username') ?? "");
  // }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .90;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          getTranslated(context, 'MyDetails'),
          style:
              TextStyle(fontFamily: "sf-ui-text", fontWeight: FontWeight.bold),
        ),
        backgroundColor: leaveCardcolor,
        shadowColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, notificationRoute);
            }),
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
            minHeight: _panelHeightClosed,
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
                  height: 6.0,
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
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 10.0,
                    ),
                    // Icon(Icons.arrow_back_ios),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: ClipOval(
                        child: Image.asset(
                          "lib/assets/images/profile.jpg",
                          height: 70,
                          // width: 90,
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
                            Text("Poonam Yadav",
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Mobile Developer",
                                style: TextStyle(fontSize: 14.0)),
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
                  height: 17.0,
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
                  _cardList(
                      "ADD REQUEST",
                      "lib/assets/images/calendar.png",
                      "Allow to add new leave/OT application",
                      Icons.arrow_forward_ios,
                      addRequestRoute),
                  _cardList(
                      "VIEW REQUESTS",
                      "lib/assets/images/weekly-calendar.png",
                      "Check your application status",
                      Icons.arrow_forward_ios,
                      myRequestRoute),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          color: Colors.pink,
                          width: MediaQuery.of(context).size.width * .35,
                          height: 2,
                          child: Text("")),
                      Container(
                          child: Text(
                        "Official Stuff",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      Container(
                          color: Colors.pink,
                          width: MediaQuery.of(context).size.width * .35,
                          height: 2,
                          child: Text("")),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _cardList(
                      "ADD DELEGATES",
                      "lib/assets/images/exchange.png",
                      "Transfer your job to other person",
                      Icons.arrow_forward_ios,
                      addDelegatesRoute),
                  _cardList(
                      "EMP PENDING REQUEST",
                      "lib/assets/images/email.png",
                      "Get list of pending requests of your team",
                      Icons.arrow_forward_ios,
                      empRequestRoute),
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

  Widget _body() {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      Container(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 120.0,
              color: leaveCardcolor1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "SICK LEAVE",
                      style: TextStyle(fontSize: 13, color: white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "3.0 / 5.0",
                        style: TextStyle(fontSize: 13, color: white),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              width: 0.5,
              child: Container(
                color: Colors.grey,
              ),
            ),
            Container(
              width: 120.0,
              color: leaveCardcolor1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "CASUAL LEAVE",
                      style: TextStyle(fontSize: 13, color: white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "3.0 / 5.0",
                        style: TextStyle(fontSize: 13, color: white),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              width: 0.5,
              child: Container(
                color: Colors.grey,
              ),
            ),
            Container(
              width: 120.0,
              color: leaveCardcolor1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "PERSONAL LEAVE",
                      style: TextStyle(fontSize: 13, color: white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "3.0 / 5.0",
                        style: TextStyle(fontSize: 13, color: white),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              width: 0.5,
              child: Container(
                color: Colors.grey,
              ),
            ),
            Container(
              width: 120.0,
              color: leaveCardcolor1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "ANNUAL LEAVE",
                      style: TextStyle(fontSize: 13, color: white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "3.0 / 5.0",
                        style: TextStyle(fontSize: 13, color: white),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              width: 0.5,
              child: Container(
                color: Colors.grey,
              ),
            ),
            Container(
              width: 120.0,
              color: leaveCardcolor1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "SICK LEAVE",
                      style: TextStyle(fontSize: 13, color: white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "3.0 / 5.0",
                        style: TextStyle(fontSize: 13, color: white),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
      Container(
        height: size.height * 0.70,
        // flex: 2,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 50),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .15), blurRadius: 16.0)
                  ],
                ),
                child: TabBar(
                  indicatorColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      icon: Text(
                        "PENDING",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Tab(
                      icon: Text(
                        "APPROVED",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Tab(
                      icon: Text(
                        "REJECTED",
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                content: Text(getTranslated(context, 'Tapbackagaintoleave')),
              ),
              child: TabBarView(
                children: [PendingHome(), ApproveHome(), RejectHome()],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
