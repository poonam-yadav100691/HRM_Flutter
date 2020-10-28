import 'package:HRMNew/components/textWithIcon.dart';
import 'package:HRMNew/src/constants/colors.dart';
import 'package:flutter/material.dart';
import './background.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 100.0,
                height: 100.0,
                margin: const EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("lib/assets/images/profile.jpg")))),

            TextWithIcon(
                textIcon: Icons.person,
                textValue: 'Poonam Yadav',
                iconColor: kPrimaryColor),
            TextWithIcon(
                textIcon: Icons.email,
                textValue: 'pooyadav052@gmail.com',
                iconColor: Colors.amber),

            TextWithIcon(
                textIcon: Icons.assignment_ind,
                textValue: 'Mobile App Dev',
                iconColor: Colors.blue[500]),
            TextWithIcon(
                textIcon: Icons.business,
                textValue: 'IT Department',
                iconColor: Colors.green),
            TextWithIcon(
                textIcon: Icons.account_balance,
                textValue: 'Headquarters',
                iconColor: Colors.blue[800]),
            TextWithIcon(
                textIcon: Icons.phone,
                textValue: '+856 20235467',
                iconColor: Colors.red),

            // SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
