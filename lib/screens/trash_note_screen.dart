import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/bloc_task.dart';
import 'package:note_app/consatants.dart';
import 'package:note_app/model/noteData.dart';

class TrashTaskScreen extends StatelessWidget {
  final _trashNoteFireStore =
      FirebaseFirestore.instance.collection("trashNoteCollection");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  noteId: note.data()["noteId"],
                  videoLink: note.data()["video_link"]));
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
                      child: BlocBuilder<NoteBloc, NoteState>(
                          builder: (context, state) {
                        return ListTile(
                          title: Text(noteTrash[index].title,
                              style: kTitleTextStyle),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.restore,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                BlocProvider.of<NoteBloc>(context,
                                        listen: false)
                                    .add(Restore(
                                        title: noteTrash[index].title,
                                        note: noteTrash[index].note,
                                        videoLink: noteTrash[index].videoLink,
                                        id: noteTrash[index].noteId));

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Restored Successfully")));
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
                                            BlocProvider.of<NoteBloc>(context,
                                                    listen: false)
                                                .add(DeleteInTrash(
                                                    id: noteTrash[index]
                                                        .noteId));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Deleted Successfully")));
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ok"))
                                    ],
                                  );
                                });
                          },
                        );
                      }),
                    ),
                  );
                }, childCount: noteTrash.length))
              ],
            );
          }
        },
        stream: _trashNoteFireStore.snapshots(),
      ),
    );
  }
}
