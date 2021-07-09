import 'dart:convert';

import 'package:HRMNew/routes/custome_router.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:HRMNew/localization/localization_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization/demo_localization.dart';

SharedPreferences globalMyLocalPrefes;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  String screen;
  String ids;
  String clickAtion;
  String body;
  String title;
  String message;
  String status;

  ReceivedNotification(
      {this.screen,
      this.ids,
      this.clickAtion,
      this.body,
      this.title,
      this.message,
      this.status});

  ReceivedNotification.fromJson(Map<String, dynamic> json) {
    screen = json['screen'];
    ids = json['ids'];
    clickAtion = json['click_ation'];
    body = json['body'];
    title = json['title'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['screen'] = this.screen;
    data['ids'] = this.ids;
    data['click_ation'] = this.clickAtion;
    data['body'] = this.body;
    data['title'] = this.title;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

void _addBadge() {
  FlutterAppBadger.updateBadgeCount(1);
}

void _removeBadge() {
  FlutterAppBadger.removeBadge();
}

Future onSelectNotification(String payload) async {
  print("Payload: $payload");
  _removeBadge();
  ReceivedNotification noti =
      ReceivedNotification.fromJson(jsonDecode(payload));
  print("notiiiiiiiiiiiiiiiiiiiiiiiiiiii");
  print(noti);
  print('on note selected ${noti.ids}');
  // new MaterialPageRoute(
  //     builder: (context) => new RequestDetails(levReqDetailID: body["ids"]));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message $message");
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
  _addBadge();
  flutterLocalNotificationsPlugin.show(
      1,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          '1',
          'general',
          'This channel is used for important notifications.',
          icon: message.data['imageUrl'],
          styleInformation: BigTextStyleInformation(''),
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
      ),
      payload: message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  setLocale(Locale locale) async {
    if (_locale.languageCode.trim() == 'en') {
      await globalMyLocalPrefes.setString(AppConstant.LANG, '2').then((value) {
        setState(() {
          _locale = locale;
        });
      });
    } else {
      await globalMyLocalPrefes.setString(AppConstant.LANG, '1').then((value) {
        setState(() {
          _locale = locale;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initSharePref();
    initPlatformState();
    analytics.logAppOpen();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await Firebase.initializeApp();
      print('Got a message whilst in the foreground!');
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
      print('####message message : $message');
      _addBadge();
      flutterLocalNotificationsPlugin.show(
        1,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            '1',
            'general',
            'This channel is used for important notifications.',
            styleInformation: BigTextStyleInformation(''),
            importance: Importance.high,
            enableVibration: true,
            playSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    });

    super.initState();
  }

  initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
        print("supported");
      } else {
        print("not supported");
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      print("Failed to get badge support.");

      appBadgeSupported = 'Failed to get badge support.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _addBadge() {
    FlutterAppBadger.updateBadgeCount(1);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  initSharePref() async {
    globalMyLocalPrefes = await SharedPreferences.getInstance();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) async {
      if (locale.languageCode.trim() == 'en') {
        await globalMyLocalPrefes.setString(AppConstant.LANG, '2');
        await globalMyLocalPrefes.setString(AppConstant.LANG, '2');
        setState(() {
          _locale = locale;
        });
      } else {
        await globalMyLocalPrefes.setString(AppConstant.LANG, '1');
        await globalMyLocalPrefes.setString(AppConstant.LANG, '1');
        setState(() {
          _locale = locale;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800])),
        ),
      );
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Auth',
          theme: ThemeData(
            primaryColor: leaveCardcolor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white,
          ),
          locale: _locale,
          supportedLocales: [Locale("en", "US"), Locale("lo", "")],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorObservers: <NavigatorObserver>[observer],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          onGenerateRoute: CustomRouter.generatedRoute,
          initialRoute: landingRoute);
    }
  }
}
