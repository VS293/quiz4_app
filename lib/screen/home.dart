import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz4_app/quizfiles/createQuiz/createquiz.dart';
import 'package:quiz4_app/quizfiles/myQuiz/myquiz.dart';
import 'package:quiz4_app/quizfiles/takeQuiz/takequiz.dart';
import 'package:quiz4_app/screen/not_allowed.dart';
import 'package:quiz4_app/shared/appbar.dart';
import 'package:quiz4_app/shared/constant.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  String? eMail = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    if (eMail == null || eMail == "") {
      eMail = "Anonymous";
    }
    super.initState();
  }

  crt() {
    if (eMail == "Anonymous") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new NotAllowed()));
    } else {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new CreateQuiz()));
    }
  }

  mq() {
    if (eMail == "Anonymous") {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new NotAllowed()));
    } else {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new MyQuiz()));
    }
  }

  tq() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new TakeQuiz()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppbarLogout("VS Quiz"),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.gif"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Image.asset("assets/images/quiz.gif"),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    "Welcome $eMail",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.yellow[200],
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 25, top: 25)),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: crt,
                    child: Text(
                      "Create Quiz",
                      style: TextStyle(fontSize: 25),
                    ),
                    style: mainbtnStyle,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 25, top: 25)),
                SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                        style: mainbtnStyle,
                        onPressed: mq,
                        child:
                            Text("My Quiz", style: TextStyle(fontSize: 25)))),
                Padding(padding: EdgeInsets.only(bottom: 25, top: 25)),
                SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                        style: mainbtnStyle,
                        onPressed: tq,
                        child:
                            Text("Take Quiz", style: TextStyle(fontSize: 25)))),
                Padding(padding: EdgeInsets.only(top: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
