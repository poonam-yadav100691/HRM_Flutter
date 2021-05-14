import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MyCustomDropDown extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  MyCustomDropDown({this.title, this.validator});

  @override
  _MyCustomDropDownState createState() => _MyCustomDropDownState();
}

class _MyCustomDropDownState extends State<MyCustomDropDown> {
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
      child: FormBuilderDropdown(
        name: "gender",

        // initialValue: 'Male',
        // hint: Text('Select Responsible Person..'),
        // validator: [FormBuilderValidators.required()],
        items: ['Male', 'Female', 'Other']
            .map((gender) =>
                DropdownMenuItem(value: gender, child: Text("$gender")))
            .toList(),

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
        onSaved: (String newValue) {},
      ),
    );
  }
}
