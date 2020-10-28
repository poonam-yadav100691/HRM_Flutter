import 'package:HRMNew/routes/route_names.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: planetCard(context, "Juil", "Backend Developer", '29/09/2020'),
        ),
        Padding(
          padding: const EdgeInsets.only(
              bottom: 5.0, top: 5.0, left: 10.0, right: 10),
          child:
              planetCard(context, "Mike", "Front End Developer", '04/09/2020'),
        ),
      ],
    ));
  }

  Widget planetCard(BuildContext context, name, design, date) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        decoration: new BoxDecoration(
          color: kWhiteColor,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: kGreyLightColor,
              blurRadius: 5.0,
              offset: new Offset(0.5, 0.5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: 13,
                      height: 65.0,
                      // color: Colors.pink,
                      child: new Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0)),
                          color: Colors.green,
                        ),
                      )),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: ClipOval(
                            child: Image.asset(
                              "lib/assets/images/profile.jpg",
                              height: 47,
                              // width: 90,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: size.width * 0.70,
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      name,
                                      style: new TextStyle(
                                          color: kRedColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      date,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                design,
                                style: new TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, requestDetailsRoute);
      },
    );
  }
}
