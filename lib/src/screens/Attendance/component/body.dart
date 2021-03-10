import 'dart:convert';
import 'dart:io';

import 'package:HRMNew/components/TakePictureScreen.dart';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './background.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position> _positionStreamSubscription;
  bool _isCheckinDisabled, _isCheckoutDisabled, _showSubmitBtn;
  String result1;
  Position position;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _isCheckinDisabled = false;
    _isCheckoutDisabled = true;
    _showSubmitBtn = false;
  }

  Future<void> _showMyDialog(serviceRequestText) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Take Photo!!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'For completion of check-in process, you have to click photo of your work place and submit.'),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Ok'),
              ),
            ],
          );
        }).then((exit1) {
      if (exit1 == null) return;

      if (exit1) {
        //  await Navigator.pop(context);
        getCamera(context, serviceRequestText);
        // user pressed Yes button
      } else {
        Navigator.pushNamed(context, homeRoute);
        // user pressed No button
      }
    });
  }

  getCamera(BuildContext context, serviceRequestText) async {
    result1 = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen()),
    );
    setState(() {});
    print("Result imgaeg : $result1");

    _showSubmitBtn = true;
  }

  Future _determinePosition(serviceRequestText) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
        // return Future.error(
        //     'Location permissions are denied (actual value: $permission).');
      }
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      _showMyDialog(serviceRequestText);
    }
    print("position%%%%%%%%%%::: ${position.latitude}");
    //  / return print(position); // return await Geolocator.getCurrentPosition();
  }

  Future<void> submitAttendance(checkinout) async {
    print("checkinout:::$checkinout");
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.MyAttendance;
    Map body = {
      "TokenKey": token,
      "CheckDataTime": new DateTime.now().toString(),
      "longitude": position.longitude,
      "latitude": position.latitude,
      "checkInOut": checkinout ? "checkin" : "checkout",
      "picture": result1
    };
    print("body : $body");
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("Reponse : $jsonResponse");

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, homeRoute);
      } else {
        setState(() {
          isLoading = false;
        });
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken();
          submitAttendance(checkinout);
          // Future<String> token = getToken();
        } else {
          // currentState.showSnackBar(
          //     UIhelper.showSnackbars(jsonResponse["ModelErrors"]));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Container(
            child: Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 100.0,
            height: 100.0,
            margin: const EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("lib/assets/images/XSgklyxE.jpg")))),
        Container(
            // color: Colors.pink,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
                "Make sure you are in your geofance area tomake attendance. Please note your location is recorded for this attendance.",
                style: TextStyle(color: Colors.grey[800]))),

        result1 != null
            ? Container(
                height: 170,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Image.file(
                  File(result1),
                  fit: BoxFit.cover,
                ),
              )
            : Container(),
        SizedBox(
          height: 50,
        ),

        _showSubmitBtn == true
            ? Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  color: leaveCardcolor,
                  onPressed: () {
                    print(" $_isCheckinDisabled $_isCheckoutDisabled = true");
                    if (_isCheckinDisabled) {
                      _isCheckinDisabled = false;
                      _isCheckoutDisabled = true;
                    } else {
                      _isCheckinDisabled = true;
                      _isCheckoutDisabled = false;
                    }
                    _showSubmitBtn = false;
                    result1 = null;
                    setState(() {});
                    submitAttendance(_isCheckinDisabled);
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Submit Check-In Now',
                      style: TextStyle(fontSize: 25)),
                ))
            : Container(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  color: leaveCardcolor,
                  onPressed: _isCheckinDisabled == false
                      ? () {
                          _determinePosition('Check-In');
                        }
                      : null,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Check-In', style: TextStyle(fontSize: 25)),
                )),
            Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  disabledColor: kGreyLightColor,
                  color: leaveCardcolor,
                  // onPressed: _isButtonDisabled ? _determinePosition : null,
                  onPressed: _isCheckoutDisabled == false
                      ? () {
                          _determinePosition('Check-Out');
                        }
                      : null,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  child:
                      const Text('Check-Out', style: TextStyle(fontSize: 25)),
                )),
          ],
        ),

        Expanded(
          child: ListView.builder(
            itemCount: _positionItems.length,
            itemBuilder: (context, index) {
              final positionItem = _positionItems[index];

              if (positionItem.type == _PositionItemType.permission) {
                return ListTile(
                  title: Text(positionItem.displayValue,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                );
              } else {
                return Card(
                  child: ListTile(
                    tileColor: leaveCardcolor,
                    title: Text(
                      positionItem.displayValue,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        // FloatingActionButton.extended(
        //   heroTag: "btn2",
        //   onPressed: () async {
        //     await Geolocator.getLastKnownPosition().then((value) => {
        //           print(value),
        //           _positionItems.add(_PositionItem(
        //               _PositionItemType.position, value.toString()))
        //         });

        //     setState(
        //       () {},
        //     );
        //   },
        //   label: Text("getLastKnownPosition"),
        // ),
        // Container(
        //     height: double.maxFinite,
        //     child: SingleChildScrollView(
        //       child: Stack(children: <Widget>[
        //         Positioned(
        //           bottom: 10.0,
        //           right: 10.0,
        //           child: FloatingActionButton.extended(
        //               onPressed: () async {
        //                 await Geolocator.getCurrentPosition().then((value) => {
        //                       _positionItems.add(_PositionItem(
        //                           _PositionItemType.position, value.toString()))
        //                     });

        //                 setState(
        //                   () {},
        //                 );
        //               },
        //               label: Text("getCurrentPosition")),
        //         ),
        //         Positioned(
        //           bottom: 150.0,
        //           right: 10.0,
        //           child: FloatingActionButton.extended(
        //             onPressed: _toggleListening,
        //             label: Text(() {
        //               if (_positionStreamSubscription == null) {
        //                 return "getPositionStream = null";
        //               } else {
        //                 return "getPositionStream ="
        //                     " ${_positionStreamSubscription.isPaused ? "off" : "on"}";
        //               }
        //             }()),
        //             backgroundColor: _determineButtonColor(),
        //           ),
        //         ),
        //         Positioned(
        //           bottom: 220.0,
        //           right: 10.0,
        //           child: FloatingActionButton.extended(
        //             onPressed: () => setState(_positionItems.clear),
        //             label: Text("clear positions"),
        //           ),
        //         ),
        //         Positioned(
        //           bottom: 290.0,
        //           right: 10.0,
        //           child: FloatingActionButton.extended(
        //             onPressed: () async {
        //               await Geolocator.checkPermission().then((value) => {
        //                     _positionItems.add(_PositionItem(
        //                         _PositionItemType.permission, value.toString()))
        //                   });
        //               setState(() {});
        //             },
        //             label: Text("getPermissionStatus"),
        //           ),
        //         ),
        //       ]),
        //     ))
      ],
    )));
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = Geolocator.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => setState(() => _positionItems.add(
          _PositionItem(_PositionItemType.position, position.toString()))));
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }
}

enum _PositionItemType {
  permission,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
