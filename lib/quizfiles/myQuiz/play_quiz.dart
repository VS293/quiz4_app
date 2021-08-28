import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz4_app/quizfiles/createQuiz/addquestion.dart';
import 'package:quiz4_app/quizfiles/myQuiz/myquiz.dart';
import 'package:quiz4_app/quizfiles/myQuiz/score_card.dart';
import 'package:quiz4_app/shared/appbar.dart';
import 'package:quiz4_app/shared/constant.dart';
import 'package:quiz4_app/shared/loading.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  final String title;
  final String imgURL;
  final String eMail;
  final bool editting;
  PlayQuiz(
      {required this.quizId,
      required this.title,
      required this.imgURL,
      required this.eMail,
      required this.editting});
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  late int tq;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: widget.editting ? () async => false : () async => true,
      child: Scaffold(
        appBar: widget.editting
            ? AppBar(
                title: Text("Edit Mode"),
                centerTitle: true,
                automaticallyImplyLeading: false)
            : PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppbarBack("${widget.title} Quiz"),
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
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 150,
                  child: Center(
                    child: Image.network(
                      widget.imgURL,
                      width: MediaQuery.of(context).size.width - 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("quiz${widget.eMail}")
                          .doc(widget.quizId)
                          .collection("question and answer")
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> questionSnapshot) {
                        return questionSnapshot.data == null
                            ? Container(
                                child: Center(
                                  child: Loading(),
                                ),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tq =
                                    questionSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return QuizData(
                                    question: questionSnapshot.data!.docs[index]
                                        .get("question"),
                                    option1: questionSnapshot.data!.docs[index]
                                        .get("option1"),
                                    option2: questionSnapshot.data!.docs[index]
                                        .get("option2"),
                                    option3: questionSnapshot.data!.docs[index]
                                        .get("option3"),
                                    option4: questionSnapshot.data!.docs[index]
                                        .get("option4"),
                                    correctAns: questionSnapshot
                                        .data!.docs[index]
                                        .get("correctAns"),
                                    subid: questionSnapshot.data!.docs[index]
                                        .get("subid"),
                                    editting: widget.editting,
                                    eMail: widget.eMail,
                                    quizId: widget.quizId,
                                    tq: tq,
                                    questionIndex: index + 1,
                                  );
                                });
                      }),
                ),
                widget.editting
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: greybtn,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddQuestion(widget.quizId)));
                              },
                              child: Text("Add Question")),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              style: greybtn,
                              onPressed: () {
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyQuiz()));
                              },
                              child: Text("Submit Changes"))
                        ],
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: greybtn,
                            onPressed: () {
                              int cor = QuizDataState.cor;
                              int incor = QuizDataState.incor;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Scorecard(
                                          totalQuestion: tq,
                                          cor: cor,
                                          incor: incor)));
                            },
                            child: Text("View ScoreCard")),
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizData extends StatefulWidget {
  final String question,
      option1,
      option2,
      option3,
      option4,
      correctAns,
      subid,
      eMail,
      quizId;

  final bool editting;
  final int tq, questionIndex;
  QuizData({
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctAns,
    required this.subid,
    required this.editting,
    required this.eMail,
    required this.quizId,
    required this.tq,
    required this.questionIndex,
  });

  @override
  QuizDataState createState() => QuizDataState();
}

class QuizDataState extends State<QuizData> {
  late int corAns;
  late int optionChosen;
  List<Color> color = [Colors.blue, Colors.blue, Colors.blue, Colors.blue];
  Color ansColor = Colors.transparent;
  static int cor = 0;
  static int incor = 0;
  int notAttempted = 0;
  bool buttonLock = false;

  checkAns() {
    switch (widget.correctAns) {
      case "option1":
        {
          corAns = 0;
          break;
        }
      case "option2":
        {
          corAns = 1;
          break;
        }
      case "option3":
        {
          corAns = 2;
          break;
        }
      case "option4":
        {
          corAns = 3;
          break;
        }
    }
    setState(() {
      buttonLock = true;
      color[0] = color[1] = color[2] = color[3] = Colors.blue;
      ansColor = Colors.brown.shade200;
      if (corAns == optionChosen) {
        color[corAns] = Colors.green;
        ansColor = Colors.green;
        cor = cor + 1;
      }
      if (corAns != optionChosen) {
        color[corAns] = Colors.green;
        ansColor = Colors.red;
        color[optionChosen] = Colors.red;
        incor = incor + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Q.${widget.questionIndex} ${widget.question}",
            style: TextStyle(backgroundColor: ansColor, fontSize: 20),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(color[0])),
                    onPressed: widget.editting
                        ? null
                        : buttonLock
                            ? null
                            : () {
                                optionChosen = 0;
                                checkAns();
                              },
                    child: Text(
                      "${widget.option1}",
                      style: TextStyle(fontSize: 15),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(color[1])),
                    onPressed: widget.editting
                        ? null
                        : buttonLock
                            ? null
                            : () {
                                optionChosen = 1;
                                checkAns();
                              },
                    child: Text("${widget.option2}",
                        style: TextStyle(fontSize: 15))),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(color[2])),
                    onPressed: widget.editting
                        ? null
                        : buttonLock
                            ? null
                            : () {
                                optionChosen = 2;
                                checkAns();
                              },
                    child: Text("${widget.option3}",
                        style: TextStyle(fontSize: 15))),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(color[3])),
                    onPressed: widget.editting
                        ? null
                        : buttonLock
                            ? null
                            : () {
                                optionChosen = 3;
                                checkAns();
                              },
                    child: Text("${widget.option4}",
                        style: TextStyle(fontSize: 15))),
                SizedBox(
                  height: 10,
                ),
                widget.editting
                    ? ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red.shade800)),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("quiz${widget.eMail}")
                              .doc(widget.quizId)
                              .collection("question and answer")
                              .doc(widget.subid)
                              .delete();
                        },
                        icon: Icon(Icons.delete_sharp),
                        label: Text("Delete Question"))
                    : Container(),
                SizedBox(
                  height: 15,
                ),
              ],
            )),
      ]),
    );
  }
}
