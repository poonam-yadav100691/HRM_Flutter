import 'package:HRMNew/src/screens/EmpRequest/EmpOTRequest/component/body.dart';
import 'package:flutter/material.dart';

import '../empRequestPODO.dart';

class EmpOTRequest extends StatelessWidget {
  final List<ResultObject> data;
  EmpOTRequest({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Body(empOtList: data);
  }
}
