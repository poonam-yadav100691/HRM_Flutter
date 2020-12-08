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
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .15), blurRadius: 16.0)
                    ],
                  ),
                  margin: EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "lib/assets/logo/tk.png",
                            height: 77,
                            // width: 90,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 0.0, top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("TK Supports Sole Co., Ltd ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "3/33 Ban Simuang, Samsenthai Road, Sisattanak district, Vientiane, Vientiane, Postal code: 01000",
                                          style: TextStyle(fontSize: 13.0)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 24),
                                // color: Colors.pink,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Salary Month",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text("Nov,2020",
                                          style: TextStyle(fontSize: 13.0)),
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
                ),
                Container(
                  width: size.width * .9,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "Earnings",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Column(
                      children: [
                        _itemBuilder("Basic Salary", "\$5000"),
                        _itemBuilder("House Rent Allowance", "\$50"),
                        _itemBuilder("Other Allowance", "\$55"),
                        _itemBuilder("Total Earnings", "\$55"),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width * .9,
                  child: Text(
                    "Deductions",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Column(
                      children: [
                        _itemBuilder("Tax Deducted", "\$0"),
                        _itemBuilder("Provident Fund", "\$0"),
                        _itemBuilder("Loan", "\$550"),
                        _itemBuilder("Total Deductions", "\$53935"),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width * .9,
                  color: Colors.white,
                  child: new RichText(
                    text: new TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: "Net Salary: \$53935 ",
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(
                          text:
                              ' (Fifty three thousand nine hundred and thirty five only)',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(label, textValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            textAlign: TextAlign.left,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            textValue,
            style: new TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
