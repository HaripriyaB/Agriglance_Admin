import 'package:agriglance_admin/Screens/Videos/submit_video.dart';
import 'package:agriglance_admin/Services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/foundation.dart';

class VideosHome extends StatefulWidget {
  @override
  _VideosHomeState createState() => _VideosHomeState();
}

class _VideosHomeState extends State<VideosHome> {
  final TextStyle linkStyle = TextStyle(color: Colors.blue, fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SubmitVideo())),
      ),
      appBar: AppBar(title: Text("Learning Videos"), centerTitle: true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Videos")
            .orderBy('isApprovedByAdmin', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot videos = snapshot.data.docs[index];
              var url = videos['videoUrl'];
              return Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 2.0)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: width / 1,
                          child: (!kIsWeb)
                              ? YoutubePlayerBuilder(
                                  player: YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId:
                                          YoutubePlayer.convertUrlToId(url),
                                      flags: YoutubePlayerFlags(
                                          controlsVisibleAtStart: true,
                                          autoPlay: false,
                                          mute: false,
                                          disableDragSeek: false,
                                          loop: false,
                                          isLive: false,
                                          forceHD: false),
                                    ),
                                    showVideoProgressIndicator: true,
                                    liveUIColor: Colors.redAccent,
                                    bottomActions: [
                                      FullScreenButton(
                                        color: Colors.amber[700],
                                      ),
                                      CurrentPosition(),
                                      PlaybackSpeedButton(),
                                    ],
                                  ),
                                  builder: (context, player) {
                                    return Column(
                                      children: [
                                        Text(
                                          videos['lectureTitle']
                                              .toString()
                                              .toUpperCase(),
                                          style: GoogleFonts.notoSans(
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        player,
                                        if (!videos['isApprovedByAdmin'])
                                          RaisedButton(
                                            color: Colors.green,
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("Videos")
                                                  .doc(videos.id)
                                                  .update({
                                                'isApprovedByAdmin': true,
                                              });
                                              await context
                                                  .read<AuthenticationService>()
                                                  .addPoints(
                                                      videos['postedBy'], 5)
                                                  .then((value) => print(
                                                      "**********************$value****************"));
                                            },
                                            child: Text("Approve"),
                                          ),
                                        RaisedButton(
                                          color: Colors.red,
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("Videos")
                                                .doc(videos.id)
                                                .delete();
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Column(
                                  children: [
                                    Text(
                                      videos['lectureTitle']
                                          .toString()
                                          .toUpperCase(),
                                      style: GoogleFonts.notoSans(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _launchURL(url);
                                      },
                                      child: Text(
                                        "Link to the video",
                                        style: linkStyle,
                                      ),
                                    ),
                                    if (!videos['isApprovedByAdmin'])
                                      RaisedButton(
                                        color: Colors.green,
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("Videos")
                                              .doc(videos.id)
                                              .update({
                                            'isApprovedByAdmin': true,
                                          });
                                          await context
                                              .read<AuthenticationService>()
                                              .addPoints(videos['postedBy'], 5)
                                              .then((value) => print(
                                                  "**********************$value****************"));
                                        },
                                        child: Text("Approve"),
                                      ),
                                    RaisedButton(
                                      color: Colors.red,
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("Videos")
                                            .doc(videos.id)
                                            .delete();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                )),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _launchURL(url) async => await canLaunch(url)
      ? await launch(url)
      : Fluttertoast.showToast(msg: 'Could not launch $url');
}
