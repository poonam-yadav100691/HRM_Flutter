import 'dart:convert';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/models/news.dart';
import 'package:HRMNew/src/screens/Login/PODO/loginResponse.dart';
import 'package:HRMNew/utils/UIhelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './background.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
//====================================
  List<dynamic> newsLists;
  bool invisible = true;
  @override
  void initState() {
    super.initState();
    // getNewToken();
  }

  Future getNewToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(AppConstant.LoginGmailID);
    String password = prefs.getString(AppConstant.PASSWORD);

    try {
      final uri = Services.LOGIN;
      Map body = {
        "PassKey": "a486f489-76c0-4c49-8ff0-d0fdec0a162b",
        "UserName": username,
        "UserPassword": password
      };

      http.post(uri, body: body).then((response) {
        if (response.statusCode == 200) {
          var myresponse = jsonDecode(response.body);
          print(myresponse.toString());

          loginResponse login = new loginResponse.fromJson(myresponse);
          print(login.toString());
          _getNewsList(login.tokenKey);
        } else {
          setState(() {
            isLoading = false;
          });
          print(jsonDecode(response.body));
          _scaffoldKey.currentState.showSnackBar(UIhelper.showSnackbars(
              "Some wnet wrong.. Please try again later."));
        }
      });
    } catch (e) {
      print("Error: $e");
      return (e);
    }
  }

  Future<void> _getNewsList(token) async {
    final uri = Services.GetNewsList;
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(AppConstant.ACCESS_TOKEN, token);
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    http.get(uri, headers: headers).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // loginResponse login = new loginResponse.fromJson(jsonResponse);

        setState(() {
          this.newsLists = jsonResponse;
          isLoading = false;
        });
        print("Reponse--- : $newsLists");
      } else {
        setState(() {
          isLoading = false;
        });
        print("response.statusCode.." + response.statusCode.toString());

        // getToken(username, password);
        _scaffoldKey.currentState.showSnackBar(UIhelper.showSnackbars(
            "Somethi wnet wrong.. Please try again later."));
      }
    });
  }

  String _age(Map<dynamic, dynamic> user) {
    return "Age: " + user['dob']['age'].toString();
  }

  Widget notiDetailCard(newsList) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
      child: new Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  Icon(
                    Icons.notification_important,
                    size: 20,
                    color: Colors.orange,
                  ),

                  // new Placeholder(),
                ],
              ),
            ),
            Container(
              // color: Colors.pink,
              width: size.width * 0.8,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          newsList['newsTitle'],
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          newsList['pubishDate'],
                          style: new TextStyle(fontSize: 14.0),
                        ), // new Placeholder(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          newsList['newsContrent'],
                          style: new TextStyle(fontSize: 14.0),
                        ),
                        // new Placeholder(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        // body: (newsLists.length != 0)
        //     ? Background(
        //         child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: newsLists.map((p) {
        //           return notiDetailCard(p);
        //         }).toList(),
        //       ))
        //     : Center(child: CircularProgressIndicator()),
        body: Background(
            child: Container(
          child: FutureBuilder<dynamic>(
            future: getNewToken(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(_age(snapshot.data[0]));
                return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            // ListTile(
                            //   leading: CircleAvatar(
                            //       radius: 30,
                            //       backgroundImage: NetworkImage(snapshot
                            //           .data[index]['picture']['large'])),
                            //   title: Text(_name(snapshot.data[index])),
                            //   subtitle: Text(_location(snapshot.data[index])),
                            //   trailing: Text(_age(snapshot.data[index])),
                            // )
                          ],
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        )));
  }
}
