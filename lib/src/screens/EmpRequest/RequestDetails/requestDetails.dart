import 'package:HRMNew/src/screens/EmpRequest/RequestDetails/component/body.dart';
import 'package:flutter/material.dart';

class RequestDetails extends StatefulWidget {
  final String levReqDetailID;
  RequestDetails({Key key, @required this.levReqDetailID}) : super(key: key);
  @override
  _RequestDetailsState createState() => _RequestDetailsState(levReqDetailID);
}

class _RequestDetailsState extends State<RequestDetails> {
  String levReqDetailID;
  _RequestDetailsState(this.levReqDetailID);
  @override
  Widget build(BuildContext context) {
    // print("levReqDetailID ::: $levReqDetailID");
    return Body(data: levReqDetailID);
  }
}
