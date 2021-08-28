import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz4_app/quizfiles/myQuiz/play_quiz.dart';
import 'package:quiz4_app/shared/appbar.dart';
import 'package:quiz4_app/shared/constant.dart';

class TakeQuiz extends StatefulWidget {
  const TakeQuiz({Key? key}) : super(key: key);

  @override
  _TakeQuizState createState() => _TakeQuizState();
}

class _TakeQuizState extends State<TakeQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String eMail, quizId;
  late DocumentSnapshot dataSnapshot;
  late String quizTitle, imgURL;
  bool editting = false;

  onClick() {
    bool editting = false;
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection("quiz$eMail")
          .doc(quizId)
          .get()
          .then((value) {
        setState(() {
          dataSnapshot = value;
          imgURL = dataSnapshot.get("quizImageURL");
          quizTitle = dataSnapshot.get("quizTitle");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayQuiz(
                        quizId: quizId,
                        title: quizTitle,
                        imgURL: imgURL,
                        eMail: eMail,
                        editting: editting,
                      )));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppbarBack("Take quiz"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.gif"),
                fit: BoxFit.cover)),
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Column(
              children: [
                TextFormField(
                  validator: (val) => val!.isEmpty ? "No Email Found" : null,
                  decoration:
                      newtextInputDecoration.copyWith(hintText: "Email Id"),
                  onChanged: (val) {
                    eMail = val;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "No Quiz Id Found" : null,
                  decoration:
                      newtextInputDecoration.copyWith(hintText: "Quiz Id"),
                  onChanged: (val) {
                    quizId = val;
                  },
                ),
                Spacer(),
                Padding(padding: EdgeInsets.all(30)),
                Padding(padding: EdgeInsets.only(right: 40, left: 40)),
                ElevatedButton(
                    style: btnStyle, onPressed: onClick, child: Text("Start")),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
