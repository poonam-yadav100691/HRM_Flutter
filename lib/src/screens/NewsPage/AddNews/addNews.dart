import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/NewsPage/AddNews/component/body.dart';
import 'package:flutter/material.dart';

class AddNews extends StatelessWidget {
  AddNews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add News'),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: leaveCardcolor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Body(),
      resizeToAvoidBottomPadding: true,
    );
  }
}
