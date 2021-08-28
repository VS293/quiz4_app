import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:quiz4_app/quizfiles/createQuiz/addquestion.dart';

import 'package:quiz4_app/services/database.dart';
import 'package:quiz4_app/shared/appbar.dart';
import 'package:quiz4_app/shared/constant.dart';
import 'package:quiz4_app/shared/loading.dart';

import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  CreateQuizState createState() => CreateQuizState();
}

class CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageURL = "", quizTitle = "", quizDescription = "", quizId = "";

  Map<String, dynamic> quizMap = {};

  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  createQuizOnLine() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      quizId = randomAlphaNumeric(16);
      late final String? eMail = FirebaseAuth.instance.currentUser!.email;
      quizMap = {
        "quizImageURL": quizImageURL,
        "quizId": quizId,
        "quizDescription": quizDescription,
        "quizTitle": quizTitle,
        "eMail": eMail,
      };
      await databaseService.addQuizData(quizId, quizMap).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddQuestion(
                        quizId,
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
        child: AppbarBack("Create Quiz"),
      ),
      body: _isLoading
          ? Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.gif"),
                      fit: BoxFit.cover)),
              child: Center(
                child: Loading(),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.gif"),
                      fit: BoxFit.cover)),
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "No Quiz image URL" : null,
                        decoration: newtextInputDecoration.copyWith(
                            hintText: "Image URL"),
                        onChanged: (val) {
                          quizImageURL = val;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Title" : null,
                        decoration: newtextInputDecoration.copyWith(
                            hintText: "Quiz Title"),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "No Quiz Description" : null,
                        decoration: newtextInputDecoration.copyWith(
                            hintText: "Quiz Description"),
                        onChanged: (val) {
                          quizDescription = val;
                        },
                      ),
                      Spacer(),
                      ElevatedButton(
                          style: btnStyle,
                          onPressed: () async {
                            await createQuizOnLine();
                          },
                          child: Text("Create Quiz")),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
