import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/PODO/myRequest.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/component/body.dart';
import 'package:flutter/material.dart';

class MyOTRequest extends StatelessWidget {
  MyOTRequest(this.data);
  List<ResultObject> data;
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'MyOTRequest')),
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
      body: (data.isNotEmpty)
          ? Body(data)
          : Center(
              child: Text('No Data Dound'),
            ),
    );
  }
}
