import 'dart:convert';
import 'package:HRMNew/main.dart';
import 'package:HRMNew/models/calenderPodo.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class CalendarViewMain extends StatefulWidget {
  @override
  _CalendarViewMainState createState() => _CalendarViewMainState();
}

class _CalendarViewMainState extends State<CalendarViewMain>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  // List _selectedEvents;
  AnimationController _animationController;
  // CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _getRequests();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)):[]
    };
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // _calendarController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Holidays'),
      ),
      body:isLoading?LinearProgressIndicator(): SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: MonthViewSettings(
            showAgenda: true, numberOfWeeksInView: 6),
      ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];


    myRequestMain.resultObject.forEach((element) {
      element.Events.forEach((element2) {
            final DateTime today = DateFormat("MM/dd/yyyy").parse(element2.eventDate.split(" ")[0]);
            final DateTime startTime =
            DateTime(today.year, today.month, today.day, 9, 0, 0);
            final DateTime endTime = DateTime(
                today.year, today.month, today.day, 18, 0, 0);

            meetings.add(Meeting(
                element2.eventNoted, startTime, endTime, Colors.red, true));
          });

    });




    return meetings;
  }






  MyRequestsCalender myRequestMain;
  bool  isLoading = true;
  List<ResultObject> myRequestList = new List();
  Future<void> _getRequests() async {
    setState(() {
      isLoading = true;
    });
    myRequestList.clear();

    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    String token = globalMyLocalPrefes.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.PublicHolidays;

    Map body = {
      "Tokenkey": token,
      "lang": globalMyLocalPrefes.getString(AppConstant.LANG)??2,
      "yearView": dateParse.year.toString()
    };
    http.post(Uri.parse(uri), body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print(response.body);
      MyRequestsCalender myRequest =
          new MyRequestsCalender.fromJson(jsonResponse);
      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          myRequestMain = myRequest;
          isLoading = false;
        });
        // print(leaveReqList.toString());
        // print(otReqList.toString());
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _getRequests();
          });

        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }

      }
    });
  }


}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
