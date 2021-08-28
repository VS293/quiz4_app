import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quiz4_app/shared/constant.dart';

import 'package:restart_app/restart_app.dart';

// ignore: must_be_immutable
class Scorecard extends StatefulWidget {
  int totalQuestion, cor, incor;
  int unanswered = 0;
  Scorecard(
      {required this.totalQuestion, required this.cor, required this.incor});

  @override
  ScorecardState createState() => ScorecardState();
}

class ScorecardState extends State<Scorecard> {
  @override
  void initState() {
    widget.unanswered = widget.totalQuestion - (widget.cor + widget.incor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Result"),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.gif"),
                    fit: BoxFit.cover)),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text("Toatl Questions: ${widget.totalQuestion}",
                      style: TextStyle(
                          backgroundColor: Colors.yellowAccent[100],
                          fontSize: 20)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Unanswered: ${widget.unanswered}",
                      style: TextStyle(
                          backgroundColor: Colors.black,
                          fontSize: 20,
                          color: Colors.white)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Correct: ${widget.cor}",
                      style: TextStyle(
                          backgroundColor: Colors.green, fontSize: 20)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Incorrect: ${widget.incor}",
                      style:
                          TextStyle(backgroundColor: Colors.red, fontSize: 20)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: 50)),
                      ElevatedButton(
                          style: btnStyle,
                          onPressed: () {
                            exit(0);
                          },
                          child: Text("Exit")),
                      SizedBox(
                        width: 100,
                      ),
                      ElevatedButton(
                          style: btnStyle,
                          onPressed: () async {
                            Restart.restartApp();
                          },
                          child: Text("Restart")),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
