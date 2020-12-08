import 'package:HRMNew/src/constants/colors.dart';
import 'package:HRMNew/src/screens/Payslip/PayslipDesc/component/body.dart';
import 'package:flutter/material.dart';

class PayslipDesc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payslip #48599'),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: leaveCardcolor,
      ),
      body: Body(),
    );
  }
}
