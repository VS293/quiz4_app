import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz4_app/quizfiles/myQuiz/play_quiz.dart';

import 'package:quiz4_app/shared/appbar.dart';
import 'package:quiz4_app/shared/constant.dart';
import 'package:quiz4_app/shared/loading.dart';
import 'package:share_plus/share_plus.dart';

class MyQuiz extends StatefulWidget {
  @override
  _MyQuizState createState() => _MyQuizState();
}

class _MyQuizState extends State<MyQuiz> {
  final String? eMail = FirebaseAuth.instance.currentUser!.email;
  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("quiz$eMail").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          return streamSnapshot.data == null
              ? Container(
                  child: Center(
                    child: Loading(),
                  ),
                )
              : ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return QuizTitle(
                      imgURL:
                          streamSnapshot.data!.docs[index].get("quizImageURL"),
                      title: streamSnapshot.data!.docs[index].get("quizTitle"),
                      desc: streamSnapshot.data!.docs[index]
                          .get("quizDescription"),
                      quizId: streamSnapshot.data!.docs[index].get("quizId"),
                      eMail: streamSnapshot.data!.docs[index].get("eMail"),
                    );
                  });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppbarBack("My Quiz"),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.gif"),
                  fit: BoxFit.cover)),
          child: quizList()),
    );
  }
}

class QuizTitle extends StatefulWidget {
  final String imgURL, title, desc, quizId, eMail;

  QuizTitle({
    required this.imgURL,
    required this.title,
    required this.desc,
    required this.quizId,
    required this.eMail,
  });

  @override
  _QuizTitleState createState() => _QuizTitleState();
}

class _QuizTitleState extends State<QuizTitle> {
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("quiz${widget.eMail}")
        .doc(widget.quizId)
        .collection("question and answer")
        .get()
        .then((value) {
      setState(() {
        questionSnapshot = value;
      });
    });
  }

  bool editting = false;
  late QuerySnapshot questionSnapshot;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        editting = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayQuiz(
                      quizId: widget.quizId,
                      title: widget.title,
                      imgURL: widget.imgURL,
                      eMail: widget.eMail,
                      editting: editting,
                    )));
      },
      child: SizedBox(
        height: 215,
        child: Column(children: [
          Container(
            height: 150,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.imgURL,
                    width: MediaQuery.of(context).size.width - 48,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black38,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.desc,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  style: btnStyle,
                  onPressed: () {
                    Share.share(
                        "Email: ${widget.eMail} And Quiz Id: ${widget.quizId}");
                  },
                  icon: Icon(Icons.share),
                  label: Text("Share")),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                  style: btnStyle,
                  onPressed: () {
                    editting = true;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayQuiz(
                                  quizId: widget.quizId,
                                  title: widget.title,
                                  imgURL: widget.imgURL,
                                  eMail: widget.eMail,
                                  editting: editting,
                                )));
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Edit")),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                  style: btnStyle,
                  onPressed: () {
                    int totalQuestion = questionSnapshot.docs.length;
                    int index;
                    for (index = 0; index < totalQuestion; index++) {
                      String subid = questionSnapshot.docs[index].get("subid");

                      FirebaseFirestore.instance
                          .collection("quiz${widget.eMail}")
                          .doc(widget.quizId)
                          .collection("question and answer")
                          .doc(subid)
                          .delete();
                    }

                    FirebaseFirestore.instance
                        .collection("quiz${widget.eMail}")
                        .doc(widget.quizId)
                        .delete();
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete"))
            ],
          ),
        ]),
      ),
    );
  }
}
