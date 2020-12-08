import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIhelper extends StatefulWidget {
  @override
  _UIhelperState createState() => _UIhelperState();

  static Widget showSnackbars(String text) {
    return SnackBar(
      content: Text(
        '$text',
        style: TextStyle(),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget showSpinner(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(),
    );

    /*   ProgressDialog pr;
    pr = ProgressDialog(context);
    pr.style(
        message: 'Please Wait',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 5.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600));
    pr.show();

    print('Spinner is showing');*/
  }

  static void hideSpinner(BuildContext context) {
    /*   ProgressDialog pr;
    pr = new ProgressDialog(context);
    pr.hide();
 */
  }

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static Future<Null> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
//      setState(() {
      selectedDate = picked;
    print("${selectedDate.toLocal()}".split(' ')[0]);
//      };
  }

  static Future showScaleAlertBox({
    @required BuildContext context,
    @required Widget yourWidget,
//    Widget icon,
    Widget title,
    @required Widget firstButton,
    Widget secondButton,
  }) {
    assert(context != null, "context is null!!");
    assert(yourWidget != null, "yourWidget is null!!");
    assert(firstButton != null, "button is null!!");
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: title,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
//                    icon,
                    yourWidget
                  ],
                ),
                actions: <Widget>[
                  firstButton,
                  secondButton,
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 250),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  static Future showImageAlertBox({
    @required BuildContext context,
    @required Widget yourWidget,
//    Widget icon,
    @required Widget firstButton,
    Widget divider,
    Widget secondButton,
    Widget divider1,
    Widget thirdButton,
  }) {
    assert(context != null, "context is null!!");
    assert(yourWidget != null, "yourWidget is null!!");
    assert(firstButton != null, "button is null!!");
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: CupertinoAlertDialog(
//                shape: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(15.0)),
                content: Column(
                  children: <Widget>[yourWidget],
                ),
                actions: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        firstButton,
                        divider,
                        secondButton,
                        divider1,
                        Flexible(child: thirdButton),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 250),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  static Future showSerialNoDialog({
    @required BuildContext context,
    @required Widget yourWidget,
    Widget title,
    @required Widget firstButton,
    Widget secondButton,
  }) {
    assert(context != null, "context is null!!");
    assert(yourWidget != null, "yourWidget is null!!");
    assert(firstButton != null, "button is null!!");
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: title,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
//                    icon,
                    yourWidget
                  ],
                ),
                actions: <Widget>[
                  firstButton,
                  secondButton,
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 250),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  static Future showFullImageDialog({
    @required BuildContext context,
    @required Widget yourWidget,
  }) {
    assert(context != null, "context is null!!");
    assert(yourWidget != null, "yourWidget is null!!");
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0.0),
                /* shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0)),*/
                content: yourWidget,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 250),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}

class _UIhelperState extends State<UIhelper> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }
}
