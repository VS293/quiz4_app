import 'package:flutter/material.dart';
import 'package:quiz4_app/screen/home.dart';
import 'package:quiz4_app/services/database.dart';
import 'package:quiz4_app/shared/appbar.dart';
import 'package:quiz4_app/shared/constant.dart';
import 'package:quiz4_app/shared/loading.dart';
import 'package:random_string/random_string.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;

  AddQuestion(
    this.quizId,
  );
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  void goToMainPage() {
    uploadQuestionData();

    if (_formKey.currentState!.validate()) {
      Navigator.pop(
          context, new MaterialPageRoute(builder: (context) => Home()));
    }
  }

  final _formKey = GlobalKey<FormState>();
  String optionChosen = "option1";

  String question = "",
      option1 = "",
      option2 = "",
      option3 = "",
      option4 = "",
      answer = "";
  bool _isloading = false;
  DatabaseService databaseService = new DatabaseService();

  uploadQuestionData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      String subid = randomAlpha(8);
      answer = optionChosen;
      Map<String, dynamic> options = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        "correctAns": answer,
        "subid": subid,
      };
      await databaseService
          .addQuizQuestion(widget.quizId, subid, options)
          .then((value) {
        setState(() {
          _isloading = false;
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
        child: AppbarBack("Add Quiz Questions"),
      ),
      body: _isloading
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
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.gif"),
                      fit: BoxFit.cover)),
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 65,
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "No Question Found" : null,
                            decoration: newtextInputDecoration.copyWith(
                                hintText: "Question"),
                            onChanged: (val) {
                              question = val;
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "No Option Found" : null,
                            decoration: newtextInputDecoration.copyWith(
                                hintText: "Option1"),
                            onChanged: (val) {
                              option1 = val;
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "No Option Found" : null,
                            decoration: newtextInputDecoration.copyWith(
                                hintText: "Option2"),
                            onChanged: (val) {
                              option2 = val;
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "No Option Found" : null,
                            decoration: newtextInputDecoration.copyWith(
                                hintText: "Option3"),
                            onChanged: (val) {
                              option3 = val;
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "No Option Found" : null,
                            decoration: newtextInputDecoration.copyWith(
                                hintText: "Option4"),
                            onChanged: (val) {
                              option4 = val;
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          height: 40,
                          child: Text(
                            "Correct Answer",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green[500],
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 120,
                            height: 50,
                            child: DropdownButtonFormField<String>(
                              iconEnabledColor: Colors.blue,
                              dropdownColor: Colors.blue,
                              value: optionChosen,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 40,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  optionChosen = newValue!;
                                });
                              },
                              items: <String>[
                                'option1',
                                'option2',
                                'option3',
                                'option4'
                              ].map<DropdownMenuItem<String>>((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: btnStyle,
                                onPressed: goToMainPage,
                                child: Text("Submit")),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                style: btnStyle,
                                onPressed: () async {
                                  await uploadQuestionData();
                                },
                                child: Text("Add Question")),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
