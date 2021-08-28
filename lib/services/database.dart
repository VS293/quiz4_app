import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

late final String? eMail = FirebaseAuth.instance.currentUser!.email;

class DatabaseService {
  final CollectionReference vsQuiz =
      FirebaseFirestore.instance.collection("quiz$eMail");
  Future<void> addQuizData(String quizId, Map<String, dynamic> quizMap) async {
    await vsQuiz
        .doc(quizId)
        .set(quizMap)
        .onError((error, stackTrace) => print(error.toString()));
  }

  Future addQuizQuestion(
      String quizId, String subid, Map<String, dynamic> options) async {
    await vsQuiz
        .doc(quizId)
        .collection("question and answer")
        .doc(subid)
        .set(options)
        .onError((error, stackTrace) => print(error.toString()));
  }
}
