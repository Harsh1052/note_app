import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/consatants.dart';
import 'package:note_app/model/noteData.dart';

import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _noteFireStore =
      FirebaseFirestore.instance.collection("notesCollection").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<NoteData> noteList = [];
            final notes = snapshot.data.docs;
            for (var note in notes) {
              noteList.add(NoteData(
                  note: note.data()["note"],
                  title: note.data()["title"],
                  noteId: note.data()["noteId"]));
            }

            if (noteList.length == 0) {
              return Center(
                child: Text("No Note Added"),
              );
            }

            return CustomScrollView(slivers: [
              SliverAppBar(
                title: Text(
                  "Notes",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Hero(
                  tag: "hero_tag${noteList[index].noteId}",
                  flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) {
                    return DefaultTextStyle(
                      style: DefaultTextStyle.of(toHeroContext).style,
                      child: toHeroContext.widget,
                    );
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                      title: noteList[index].title,
                                      note: noteList[index].note,
                                      id: noteList[index].noteId,
                                    )));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey[700],
                              width: 0.5,
                            )),
                        child:
                            Text(noteList[index].title, style: kTitleTextStyle),
                      ),
                    ),
                  ),
                );
              }, childCount: noteList.length)),
            ]);
          }
        },
        stream: _noteFireStore,
      ),
    );
  }
}
