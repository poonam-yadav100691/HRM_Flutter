import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class MyCustomDateRange extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  MyCustomDateRange({this.title, this.validator});

  @override
  _MyCustomDateRangeState createState() => _MyCustomDateRangeState();
}

class _MyCustomDateRangeState extends State<MyCustomDateRange> {
  var _focusNode = new FocusNode();

  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilderDateRangePicker(
          firstDate: DateTime.now().subtract(Duration(days: 356)),
          lastDate: DateTime.now().add(Duration(days: 356)),
          format: DateFormat('dd MMM yyyy'),
          attribute: widget.title,
          decoration: new InputDecoration(
            fillColor: Colors.white,
            border: _focusNode.hasFocus
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: leaveCardcolor))
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey)),
            filled: true,
            contentPadding:
                EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            labelText: widget.title,
          ),
          autocorrect: false,
          focusNode: _focusNode,
          style: TextStyle(color: Colors.black),
        ));
  }
}
