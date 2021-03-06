import 'package:agriglance_admin/Constants/job_card.dart';
import 'package:agriglance_admin/Screens/Jobs/add_jobs.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobHome extends StatefulWidget {
  @override
  _JobHomeState createState() => _JobHomeState();
}

class _JobHomeState extends State<JobHome> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .orderBy('postedAt')
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot jobs = snapshot.data.documents[index];
                        return JobCard(
                          jobDesc: jobs['jobSelectionProcedure'],
                          jobPosts: jobs['noOfPosts'],
                          jobSkills: jobs['qualificationsRequired'],
                          jobSubject: jobs['jobSubject'],
                          jobType: jobs['jobType'],
                          orgLink: jobs['organizationLink'],
                          orgName: jobs['organizationName'],
                          salary: jobs['jobSalary'],
                          postedByName: jobs['postedByName'],
                          postedBy: jobs['postedBy'],
                          isApprovedByAdmin: jobs['isApprovedByAdmin'],
                          index: index,
                          jobId: jobs.id,
                        );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddJobs(
                    uid: auth.currentUser.uid,
                    uName: auth.currentUser.displayName))),
        child: Icon(Icons.add),
      ),
    );
  }
}
