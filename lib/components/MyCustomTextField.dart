import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';

class MyCustomTextField extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  MyCustomTextField({this.title, this.validator});

  @override
  _MyCustomTextFieldState createState() => _MyCustomTextFieldState();
}

class _MyCustomTextFieldState extends State<MyCustomTextField> {
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

  ValueChanged _onChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autocorrect: false,
        focusNode: _focusNode,
        style: TextStyle(color: Colors.black),
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
        validator: widget.validator,
        onChanged: _onChanged,
        onSaved: (String newValue) {
          print(newValue);
        },
      ),
    );
  }
}
