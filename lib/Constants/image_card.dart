import 'package:agriglance_admin/Services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageCard extends StatefulWidget {
  String title;
  String description;
  String imageUrl;
  String fileName;
  String postedByName;
  String postedBy;
  String imageId;
  bool approved;
  int index;

  ImageCard(
      {this.title,
      this.description,
      this.imageUrl,
      this.fileName,
      this.postedByName,
      this.postedBy,
      this.imageId,
      this.approved,
      this.index});

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF3E83C3), width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.title}".toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
              ),
              Image.network(
                widget.imageUrl,
              ),
              Text(
                "Description: " + widget.description,
                style: TextStyle(fontSize: 12.0),
              ),
              Text(
                (widget.postedByName != null && widget.postedByName != "")
                    ? "Posted By: " + widget.postedByName
                    : "Posted By: Anonymous",
                style: TextStyle(fontSize: 12.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth / 20),
                    child: Text(
                      "Click to view Options",
                      style: TextStyle(fontSize: 8.0),
                    ),
                  ),
                  Text(
                    ((widget.approved == true)
                        ? "Approved by Admin"
                        : "Waiting for approval"),
                    style: TextStyle(fontSize: 8.0),
                  ),
                  if (!widget.approved)
                    RaisedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("images")
                            .doc(widget.imageId)
                            .update({
                          'isApprovedByAdmin': true,
                        });
                        await context
                            .read<AuthenticationService>()
                            .addPoints(widget.postedBy, 5)
                            .then((value) => print(
                                "**********************$value****************"));
                      },
                      child: Text("Approve"),
                    ),
                  SizedBox(
                    height: 5.0,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("images")
                          .doc(widget.imageId)
                          .delete();
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
