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
                  key: _fbKey,
                  // initialValue: {
                  //   'date': DateTime.now(),
                  //   'accept_terms': false,
                  // },
                  child: Column(
                    children: [
                      MyCustomTextField(
                          title: "News Title", attrName: 'AddNewsTitle'),
                      MyCustomDateRange(
                        title: "Select News Date Range",
                        attrName: 'AddpubishDate',
                        validator: (value) {
                          print("Selected date rangr $value");
                        },
                      ),
                      // MyCustomTextField(
                      //   title: "News Description",
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: 'AddNewsContrent',
                          minLines: 1,
                          maxLines: 5,
                          validators: [FormBuilderValidators.required()],
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'News Description',
                            hintStyle: TextStyle(color: Colors.grey),
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
                                top: 20, bottom: 2.0, left: 10.0, right: 10.0),
                            labelText: "News Description",
                          ),
                        ),
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
