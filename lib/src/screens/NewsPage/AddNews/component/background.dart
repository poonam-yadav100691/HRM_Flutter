import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    "lib/assets/images/icons/Logo-splash.png",
                    width: size.width,
                  ),
                ),
              ]),
          child,
        ],
      ),

      // constraints: BoxConstraints.tightFor(height: 10.0, width: 10.0),
    );
  }
}
