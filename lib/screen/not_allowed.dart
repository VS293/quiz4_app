import 'package:flutter/material.dart';
import 'package:quiz4_app/shared/appbar.dart';

class NotAllowed extends StatelessWidget {
  const NotAllowed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppbarBack("Not Allowed"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.gif"),
                fit: BoxFit.cover)),
        child: Column(children: [
          Align(
            alignment: Alignment.center,
          ),
          Text(
            "This Feature Is Available For Registered User Only",
            style: TextStyle(
              color: Colors.yellow[200],
              fontSize: 25,
              letterSpacing: 2,
            ),
          ),
        ]),
      ),
    );
  }
}
