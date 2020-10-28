import 'package:HRMNew/components/MyCustomDate.dart';
import 'package:HRMNew/components/MyCustomDateRange.dart';
import 'package:HRMNew/components/MyCustomDropDown.dart';
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

  ValueChanged _onRadioChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return Background(
        child: Column(
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                FormBuilder(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderRadioGroup(
                          attribute: 'LeaveApplyFor',
                          decoration: new InputDecoration(
                            fillColor: Colors.white,
                            border: _focusNode.hasFocus
                                ? OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide:
                                        BorderSide(color: leaveCardcolor))
                                : OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                bottom: 3.0, left: 3.0, right: 3.0),
                            labelText: 'Leave Apply For ',
                          ),
                          onChanged: _onRadioChanged,
                          validators: [FormBuilderValidators.required()],
                          options: ["Full Day", "Half Day"]
                              .map((lang) => FormBuilderFieldOption(
                                    value: lang,
                                    child: Text('$lang'),
                                  ))
                              .toList(growable: false),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderRadioGroup(
                          attribute: 'LeaveApplyFrom',
                          decoration: new InputDecoration(
                            fillColor: Colors.white,
                            border: _focusNode.hasFocus
                                ? OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide:
                                        BorderSide(color: leaveCardcolor))
                                : OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                bottom: 3.0, left: 3.0, right: 3.0),
                            labelText: 'Leave Start From',
                          ),
                          onChanged: _onRadioChanged,
                          validators: [FormBuilderValidators.required()],
                          options: ["First Half", "Second Half"]
                              .map((lang) => FormBuilderFieldOption(
                                    value: lang,
                                    child: Text('$lang'),
                                  ))
                              .toList(growable: false),
                        ),
                      ),
                      MyCustomDateRange(
                        title: "Select Leave Date Range",
                        validator: (value) {
                          print("Selected date rangr $value");
                        },
                      ),
                      MyCustomTextField(
                        title: "Total Days",
                      ),
                      MyCustomDate(
                        title: "Return to work on",
                      ),
                      MyCustomDropDown(
                        title: "Select Type of leave",
                      ),
                      MyCustomDropDown(
                        title: "Select Responsible Person",
                      ),
                      MyCustomTextField(
                        title: "Total Days",
                      ),
                      MyCustomTextField(
                        title: "Subject",
                      ),
                      MyCustomTextField(
                        title: "Reason",
                      ),
                      MyCustomFileUpload(),
                      Container(
                        width: size.width * 0.9,
                        height: 50,
                        margin: EdgeInsets.only(bottom: 30, top: 20),
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
                  ),
                ),
              ]))),
        ),
      ],
    ));
  }
}
