import 'dart:convert';
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
      print("j&&&jsonResponse $jsonResponse");

      if (jsonResponse["StatusCode"] == 200) {
        setState(() {
          isLoading = false;
        });
        newsLists = newsList.resultObject;
        //     for (int i = 0; i < newsLists.length; i++) {
        //       print(
        //           "j&&&&&&&&&&&&&&&&&&&&&&& ${newsLists[i].expDate.toString()}");
        //            DateTime tempDate1 =
        //     new DateFormat("MM/dd/yyyy hh:mm:ss a").parse(newsLists[i].expDate);

        // final startDate = tempDate1;
        //         newsLists.addAll({"startDate1":startDate});

        //     }

        var newsListData = json.decode(response.body);
        // newsListData = newsListData.map((dynamic newsList) {
        //   String newsID = newsListData['newsID'];
        //   String newsTitle = newsListData['newsTitle'];
        //   String newContent = newsListData['newContent'];
        //   String filePath = newsListData['file_path'];
        //   String newAttachedfile = newsListData['newAttachedfile'];

        //   var inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss a');
        //   var outputFormat = DateFormat('dd/MM/yy');
        //   var inputDate = inputFormat.parse(newsListData['expDate']);
        //   var expdate = outputFormat.format(inputDate);
        //   String expDate = expdate;

        //   Map<String, dynamic> toJson() {
        //     final Map<String, dynamic> data = new Map<String, dynamic>();
        //     data['newsID'] = newsID;
        //     data['newsTitle'] = newsTitle;
        //     data['newContent'] = newContent;
        //     data['file_path'] = filePath;
        //     data['newAttachedfile'] = newAttachedfile;
        //     data['expDate'] = expDate;
        //     return data;
        //   }

        //   print("newsListData: $newsListData");
        // }).toList();
      } else {
        print("ModelError: ${jsonResponse["ModelErrors"]}");
        if (jsonResponse["ModelErrors"] == 'Unauthorized') {
          GetToken();
          // _getNewsList();
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
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        // resizeToAvoidBottomPadding: true,
        body: Background(
            child: Container(
          child: ListView.builder(
              itemCount: newsLists.length,
              padding: EdgeInsets.only(top: 8),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int i) {
                DateTime tempDate =
                    new DateFormat('MM/dd/yyyy HH:mm:ss a', 'en_US')
                        .parse(newsLists[i].expDate);
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
                              _buildPopupDialog(context, newsLists[i]),
                        );
                      },
                      leading: Image.asset(
                        "lib/assets/images/unnamed.jpg",
                        fit: BoxFit.contain,
                        width: 35,
                      ),
                      title: Text(newsLists[i].newsTitle),
                      // subtitle: Text(newsLists[i].newContent),
                      subtitle: Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 12.0),
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: newsLists[i].newContent),
                        ),
                      ),
                      trailing: extDate != null ? Text(extDate) : Container()),
                );
              }),
        )));
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
