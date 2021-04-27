import 'package:HRMNew/localization/localization_constants.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/PODO/myRequest.dart';
import 'package:HRMNew/src/screens/MyRequest/MyOTRequest/component/myOtRequest.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatefulWidget {
  Body(this.leaveList);
  List<ResultObject> leaveList;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // List<ResultObject> leaveList;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < widget.leaveList.length; i++) {
      children.add(
        new GestureDetector(
          onTap: () {
            print("leaveList[i].requestID:: ${widget.leaveList[i].requestID}");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyOTReqDetails(
                    levReqDetailID: widget.leaveList[i].requestID),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: new Stack(
              children: <Widget>[
                planetCard(context, widget.leaveList[i]),
                planetThumbnail(
                    context, widget.leaveList[i].statusText.toLowerCase()),
              ],
            ),
          ),
        ),
      );
    }

    return Background(child: ListView(children: children));
  }

  Widget planetThumbnail(BuildContext context, String statusText) {
    // _onDateRangeSelect(leaveList.strDate, leaveList.endDate);

    return Container(
      child: new Image(
        image: new AssetImage(
            "lib/assets/images/${statusText[0].toLowerCase()}${statusText.substring(1)}.png"),
        height: 40.0,
        width: 40.0,
      ),
    );
  }

  Widget planetCard(BuildContext context, ResultObject object) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.88,
      margin: new EdgeInsets.only(left: 26.0),
      decoration: new BoxDecoration(
        color: kWhiteColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: kGreyLightColor,
            blurRadius: 5.0,
            offset: new Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${object.submitDate} ',
                        style: new TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${object.statusText} ',
                              style: new TextStyle(
                                  color: kRedColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        getTranslated(context, 'manager'),
                        style: new TextStyle(),
                      ),
                      Text(
                        ' : ${object.managerName}',
                        style: new TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
