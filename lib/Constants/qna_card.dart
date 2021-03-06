import 'package:agriglance_admin/Screens/QNA/qna_discussion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QnaCard extends StatefulWidget {
  final String category;
  final String question;
  final String description;
  final String postedBy;
  final int index;
  final String qid;
  QnaCard(
      {this.category,
      this.description,
      this.question,
      this.postedBy,
      this.index,
      this.qid});
  @override
  _QnaCardState createState() => _QnaCardState();
}

class _QnaCardState extends State<QnaCard> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange, width: 3.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.index + 1}. ${widget.question}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              (widget.postedBy != null && widget.postedBy != "")
                  ? Text(
                      "Posted By: " + widget.postedBy,
                      style: TextStyle(fontSize: 16.0),
                    )
                  : Text(
                      "Posted By : Anonymous",
                      style: TextStyle(fontSize: 16.0),
                    ),
              Row(
                children: [
                  Center(
                      child: RaisedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Discussion(
                                  question: widget.question,
                                  postedBy: widget.postedBy,
                                  description: widget.description,
                                  qid: widget.qid,
                                ))),
                    color: Colors.orangeAccent.shade100,
                    child: Text("Reply"),
                  )),
                  RaisedButton(
                  color: Colors.red,
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("qna")
                        .doc(widget.qid)
                        .delete();
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
