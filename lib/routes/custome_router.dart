import 'package:HRMNew/components/calendarView.dart';
import 'package:HRMNew/src/screens/Account/account.dart';
import 'package:HRMNew/src/screens/AddDelegates/addDelegates.dart';
import 'package:HRMNew/src/screens/AddRequest/addRequest.dart';
import 'package:HRMNew/src/screens/EmpRequest/RequestDetails/requestDetails.dart';
import 'package:HRMNew/src/screens/MyRequest/myRequest.dart';
import 'package:HRMNew/src/screens/MyRequest/MyLeaveRequest/myLeaveRequest.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOtRequest/myOtRequest.dart';

import 'package:HRMNew/src/screens/EmpRequest/EmpRequest.dart';
import 'package:HRMNew/src/screens/EmpRequest/EmpLeaveRequest/EmpLeaveRequest.dart';
import 'package:HRMNew/src/screens/EmpRequest/EmpOtRequest/EmpOtRequest.dart';

import 'package:HRMNew/src/screens/Dashboard/approveHome/approve-home.dart';
import 'package:HRMNew/src/screens/Dashboard/pendingHome/pending-home.dart';
import 'package:HRMNew/src/screens/Dashboard/rejectHome/component/reject-home.dart';
import 'package:HRMNew/src/screens/NotificationPage/notification-page.dart';
import 'package:HRMNew/src/screens/RulesPage/rulesPage.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:HRMNew/src/screens/landing.dart';
import 'package:HRMNew/src/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:HRMNew/routes/route_names.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case accountRoute:
        return MaterialPageRoute(builder: (_) => Account());
      case landingRoute:
        return MaterialPageRoute(builder: (_) => Landing());
      case pendingHomeRoute:
        return MaterialPageRoute(builder: (_) => PendingHome());
      case approveHomeRoute:
        return MaterialPageRoute(builder: (_) => ApproveHome());
      case rejectHomeRoute:
        return MaterialPageRoute(builder: (_) => RejectHome());
      case addRequestRoute:
        return MaterialPageRoute(builder: (_) => AddRequest());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => Login());
      case notificationRoute:
        return MaterialPageRoute(builder: (_) => NotificationPage());
      case addDelegatesRoute:
        return MaterialPageRoute(builder: (_) => AddDelegates());
      case myRequestRoute:
        return MaterialPageRoute(builder: (_) => MyRequest());
      case myOtRequestRoute:
        return MaterialPageRoute(builder: (_) => MyLeaveRequest());
      case myLeaveRequestRoute:
        return MaterialPageRoute(builder: (_) => MyOTRequest());
      case empRequestRoute:
        return MaterialPageRoute(builder: (_) => EmpRequest());
      case empOtRequestRoute:
        return MaterialPageRoute(builder: (_) => EmpLeaveRequest());
      case empLeaveRequestRoute:
        return MaterialPageRoute(builder: (_) => EmpOTRequest());
      case requestDetailsRoute:
        return MaterialPageRoute(builder: (_) => RequestDetails());
      case calendarViewRoute:
        return MaterialPageRoute(builder: (_) => CalendarView());

      case rulesRoute:
        return MaterialPageRoute(builder: (_) => RulesPage());
    }
    return MaterialPageRoute(builder: (_) => Landing());
  }
}
