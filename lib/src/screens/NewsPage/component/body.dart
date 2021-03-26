import 'dart:convert';
import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/AppConstant.dart';
import 'package:HRMNew/src/constants/Services.dart';
import 'package:HRMNew/src/screens/NewsPage/component/PODO.dart';
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

  List<ResultObject> newsLists = new List();
  bool invisible = true;
  int userID;

  String extDate;
  @override
  void initState() {
    _getNewsList();
    super.initState();
  }

  Future<void> _getNewsList() async {
    final uri = Services.GetNewsList;
    newsLists.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);

    Map body = {"Tokenkey": token};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      News newsList = new News.fromJson(jsonResponse);

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {

          newsLists = newsList.resultObject;

          userID = sharedPreferences.getInt(AppConstant.USER_ID.toString());
          isLoading = false;
        });
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _getNewsList();
          });
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

  Future<void> _deleteNews(newsID) async {
    print("newsID:::$newsID");
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(AppConstant.ACCESS_TOKEN);
    final uri = Services.DelNews;
    Map body = {"Tokenkey": token, "newsID": newsID};
    http.post(uri, body: body).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("Reponse---44432222 : $jsonResponse");

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, newsList);
      } else {
        setState(() {
          isLoading = false;
        });
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken().getToken().then((value) {
            _deleteNews(newsID);
          });

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
    if (!isLoading) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        // resizeToAvoidBottomPadding: true,
        body: Background(
            child: ListView.builder(
                itemCount: newsLists.length,
                padding: EdgeInsets.only(top: 8),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int i) {
                  DateTime tempDate =
                      new DateFormat('MM/dd/yyyy HH:mm:ss a', 'en_US')
                          .parse(newsLists[i].expDate);
                  extDate = DateFormat("dd/MM/yy").format(tempDate);

                  return Stack(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10),
                      //  margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, newsLists[i]),
                            );
                          },
                          leading: Container(
                            color: Colors.pink,
                            child: Image.asset(
                              "lib/assets/images/unnamed.jpg",
                              fit: BoxFit.contain,
                              width: 30,
                            ),
                          ),
                          title: Text(newsLists[i].newsTitle),
                          // subtitle: Text(newsLists[i].newContent),
                          subtitle: Flex(direction: Axis.horizontal, children: [
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 12.0),
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    text: newsLists[i].newContent),
                              ),
                            )
                          ]),
                          trailing:
                              extDate != null ? Text(extDate) : Container()),
                    ),
                    (userID == newsLists[i].createBy)
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                //To show a snackbar with the UNDO button
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Are you sure?"),
                                    action: SnackBarAction(
                                        label: "Yes",
                                        onPressed: () {
                                          //To undo deletion
                                          _deleteNews(newsLists[i].newsID);
                                        })));
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : Container()
                  ]);
                })),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, addNewsRoute);
            // Add your onPressed code here!
          },
          elevation: 4,
          label: Text('News'),
          icon: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.pink,
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildPopupDialog(BuildContext context, data) {
    return new AlertDialog(
      title: const Text('News Details'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(
              "Title : " + data.newsTitle,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Text("Expire Date : " + data.expDate),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Text("Content : " + data.newContent),
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
