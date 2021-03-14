import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:note_app/consatants.dart';
import 'package:note_app/model/firebase_events.dart';
import 'package:note_app/model/noteData.dart';

class TrashTaskScreen extends StatefulWidget {
  @override
  _TrashTaskScreenState createState() => _TrashTaskScreenState();
}

class _TrashTaskScreenState extends State<TrashTaskScreen> {
  final _trashNoteFireStore =
      FirebaseFirestore.instance.collection("trashNoteCollection");
  bool loading = false;

  final _noteFirebase = FirebaseCRUD();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: SafeArea(
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<NoteData> noteTrash = [];
              final notes = snapshot.data.docs;
              for (var note in notes) {
                noteTrash.add(NoteData(
                    note: note.data()["note"],
                    title: note.data()["title"],
                    noteId: note.data()["noteId"]));
              }

              if (noteTrash.length == 0) {
                return Center(
                  child: Text("No Note Added in Trash"),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(
                      "Trash Notes",
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
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      child: Card(
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            )),
                        child: ListTile(
                          title: Text(noteTrash[index].title,
                              style: kTitleTextStyle),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.restore,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                await _noteFirebase.restore(
                                    noteTrash[index].title,
                                    noteTrash[index].note,
                                    noteTrash[index].noteId,
                                    context);
                                setState(() {
                                  loading = false;
                                });
                              }),
                          onLongPress: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Are You Sure?"),
                                    content: Text(
                                        "This Note Will Be Permanently Delete"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            await _noteFirebase.deleteInTrash(
                                                noteTrash[index].noteId,
                                                context);

                                            Navigator.pop(context);
                                          },
                                          child: Text("Ok"))
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    );
                  }, childCount: noteTrash.length))
                ],
              );
            }
          },
          stream: _trashNoteFireStore.snapshots(),
        ),
      ),
    );
  }
}
