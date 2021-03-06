import 'package:agriglance_admin/Constants/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUser extends StatefulWidget {
  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot user = snapshot.data.documents[index];
                    bool admin;
                    if (user.data().containsKey('isAdmin')) {
                      admin = user['isAdmin'];
                      if (admin == null) {
                        admin = false;
                      }
                    } else {
                      admin = false;
                    }
                    bool banned;
                    if (user.data().containsKey('isBanned')) {
                      banned = user['isBanned'];
                      if (banned == null) {
                        banned = false;
                      }
                    } else {
                      banned = false;
                    }
                    return UserCard(
                      dob: user['dob'],
                      email: user['email'],
                      name: user['fullName'],
                      qualification: user['qualification'],
                      university: user['university'],
                      points: user['points'],
                      uid: user['id'],
                      isAdmin: admin,
                      isBanned: banned,
                    );
                  },
                );
        },
      ),
    ));
  }
}
