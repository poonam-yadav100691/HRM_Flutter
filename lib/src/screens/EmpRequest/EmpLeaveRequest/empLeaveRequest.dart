import 'package:HRMNew/src/screens/EmpRequest/EmpLeaveRequest/component/body.dart';
import 'package:flutter/material.dart';

import '../empRequestPODO.dart';

class EmpLeaveRequest extends StatelessWidget {
  final List<ResultObject> data;
  EmpLeaveRequest({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Body(empLeaveList: data);
  }
}
