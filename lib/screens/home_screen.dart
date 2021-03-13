import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/consatants.dart';
import 'package:note_app/model/noteData.dart';
import 'package:note_app/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _noteFireStore =
      FirebaseFirestore.instance.collection("notesCollection").snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: StreamBuilder(
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

              return ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: OpenContainer(
                      closedBuilder: (context, action) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Text(noteList[index].title,
                              style: kTitleTextStyle),
                        );
                      },
                      openBuilder: (context, action) {
                        return DetailScreen(
                          title: noteList[index].title,
                          note: noteList[index].note,
                          id: noteList[index].noteId,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.grey[300])),
                    ),
                  );
                },
                itemCount: noteList.length,
              );
            }
          },
          stream: _noteFireStore,
        ),
      ),
    );
  }
}
