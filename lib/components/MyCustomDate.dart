import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class MyCustomDate extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  MyCustomDate({this.title, this.validator});

  @override
  _MyCustomDateState createState() => _MyCustomDateState();
}

class _MyCustomDateState extends State<MyCustomDate> {
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
        child: FormBuilderDateTimePicker(
          name: "date",
          inputType: InputType.date,
          format: DateFormat("dd-MM-yyyy"),
          // initialValue: DateTime.now(),
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
