import 'dart:convert';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/Delegates/component/PODO.dart';
import 'package:HRMNew/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './background.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;

  List<ResultObject> delegates = new List();
  bool invisible = true;

  String extDate;
  @override
  void initState() {
    _getNewsList();
    super.initState();
  }

  Future<void> _getNewsList() async {
    final uri = Services.DelegateList;
    delegates.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);

    Map body = {"Tokenkey": token};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      DelegateList delegate = new DelegateList.fromJson(jsonResponse);
      print("j&&&jsonResponse $jsonResponse");

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        delegates = delegate.resultObject;
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken();
          // _getNewsList();
          // Future<String> token = getToken();
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

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          // resizeToAvoidBottomPadding: true,
          body: Background(
              child: ListView.builder(
                  itemCount: delegates.length,
                  padding: EdgeInsets.only(top: 8),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int i) {
                    DateTime tempDate =
                        new DateFormat('dd/MM/yyyy HH:mm:ss a', 'en_US')
                            .parse(delegates[i].endDate);
                    extDate = DateFormat("dd/MM/yy").format(tempDate);

                    return Container(
                      margin: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                      //  margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[200]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, delegates[i]),
                            );
                          },
                          leading: Image.asset(
                            "lib/assets/images/exchange.png",
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          title: Text(delegates[i].delegatesByName),
                          // subtitle: Text(delegates[i].newContent),
                          subtitle:  RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 12.0),
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text: delegates[i].noted),
                            ),
                          
                          trailing:
                              extDate != null ? Text(extDate) : Container()),
                    );
                  })));
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }

  Widget _buildPopupDialog(BuildContext context, data) {
    return new AlertDialog(
      title: const Text('Delegates Details'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              "Title : " + data.delegatesByName,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Text("Start Date : " + data.startDate),
          Text("End Date : " + data.endDate),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Text("Content responseName: " + data.noted),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Text("Response Name: " + data.responseName),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
