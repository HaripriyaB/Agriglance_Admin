import 'package:agriglance_admin/Constants/poll_card.dart';
import 'package:agriglance_admin/Screens/Polls/add_polls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PollHome extends StatefulWidget {
  @override
  _PollHomeState createState() => _PollHomeState();
}

class _PollHomeState extends State<PollHome> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Polls"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("polls")
              .orderBy('createdOn')
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot p = snapshot.data.documents[index];
                      return PollCard(
                        voters: p['voters'],
                        question: p['question'],
                        option1: p['option1'],
                        option2: p['option2'],
                        option3: p['option3'],
                        option4: p['option4'],
                        totalVotesOnOption1: p['totalVotesOnOption1'],
                        totalVotesOnOption2: p['totalVotesOnOption2'],
                        totalVotesOnOption3: p['totalVotesOnOption3'],
                        totalVotesOnOption4: p['totalVotesOnOption4'],
                        postedByName: p['postedByName'],
                        postedBy: p['postedBy'],
                        approved: p['isApprovedByAdmin'],
                        index: index,
                        pollID: p.id,
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddPoll())),
        child: Icon(Icons.add),
      ),
    );
  }
}
