import 'package:HRMNew/components/MyCustomDate.dart';
import 'package:HRMNew/components/MyCustomFileUpload.dart';
import 'package:HRMNew/components/MyCustomTextField.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import './background.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Body extends StatefulWidget {
  final String title;
  final ValueChanged<String> validator;

  Body({this.title, this.validator});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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

  ValueChanged _onDateTimeChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return Background(
        child: Column(
      children: [
        SafeArea(
            bottom: true,
            top: false,
            child: FormBuilder(
                key: _fbKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          MyCustomDate(
                            title: "Select OT Date ",
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderDateTimePicker(
                              attribute: 'OTStartTime',
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                border: _focusNode.hasFocus
                                    ? OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide:
                                            BorderSide(color: leaveCardcolor))
                                    : OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                filled: true,
                                contentPadding: EdgeInsets.only(
                                    bottom: 10.0, left: 10.0, right: 10.0),
                                labelText: 'OT Start From',
                              ),
                              onChanged: _onDateTimeChanged,
                              validators: [FormBuilderValidators.required()],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderDateTimePicker(
                              attribute: 'OTEndTime',
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                border: _focusNode.hasFocus
                                    ? OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide:
                                            BorderSide(color: leaveCardcolor))
                                    : OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                filled: true,
                                contentPadding: EdgeInsets.only(
                                    bottom: 10.0, left: 10.0, right: 10.0),
                                labelText: 'OT End On',
                              ),
                              onChanged: _onDateTimeChanged,
                              validators: [FormBuilderValidators.required()],
                            ),
                          ),
                          MyCustomTextField(
                              title: "Manager", attrName: 'manager'),
                          MyCustomTextField(
                              title: "Subject", attrName: 'subject'),
                          MyCustomTextField(
                              title: "Reason", attrName: 'reason'),
                          MyCustomFileUpload(),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.9,
                      height: 50,
                      child: RaisedButton(
                          color: leaveCardcolor,
                          textColor: kWhiteColor,
                          child: Text(
                            "Send",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              print(_fbKey.currentState.value);
                            }
                          }),
                    ),
                  ],
                ))),
      ],
    ));
  }
}
