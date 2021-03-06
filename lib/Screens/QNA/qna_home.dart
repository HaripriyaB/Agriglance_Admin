import 'package:agriglance_admin/Constants/qna_card.dart';
import 'package:agriglance_admin/Screens/QNA/add_question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QNAHome extends StatefulWidget {
  @override
  _QNAHomeState createState() => _QNAHomeState();
}

class _QNAHomeState extends State<QNAHome> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("qna")
              .orderBy("askedOn")
              .snapshots(),
          builder: (context, snapshot) {
            return (!snapshot.hasData)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot q = snapshot.data.documents[index];
                      return QnaCard(
                        category: q['categoryType'],
                        question: q['question'],
                        description: q['questionDesc'],
                        postedBy: q['postedByName'],
                        index: index,
                        qid: q.id,
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddQuestionScreen(
                    uid: auth.currentUser.uid,
                    uName: auth.currentUser.displayName))),
      ),
    );
  }
}
