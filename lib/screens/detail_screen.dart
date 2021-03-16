import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/bloc_task.dart';
import 'package:note_app/consatants.dart';
import 'package:note_app/screens/add_note_screen.dart';

import 'bottom_app_bar_screen.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String note;
  final String id;

  DetailScreen({this.title, this.note, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.red,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewTaskScreen(
                            title: title, note: note, id: id)));
              })
        ],
        title: Hero(
          tag: "hero_tag${id}",
          child: Text(
            title,
            style: TextStyle(
                color: Colors.red, fontSize: 25.0, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: EdgeInsets.only(right: 10.0, left: 10.0),
            child: SingleChildScrollView(
              child: SelectableText(
                note,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: kButtonStyle.copyWith(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellow[900]),
                    ),
                    onPressed: () async {
                      BlocProvider.of<NoteBloc>(context, listen: false)
                          .add(MoveToTrash(title: title, note: note, id: id));

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Moved to Trash Successfully")));

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNayBar()));
                    },
                    child: Row(
                      children: [Text("Move to Trash"), Icon(Icons.delete)],
                    )),
                ElevatedButton(
                    style: kButtonStyle,
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are You Sure?"),
                              content:
                                  Text("This Note Will Be Permanently Delete"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      BlocProvider.of<NoteBloc>(context,
                                              listen: false)
                                          .add(DeleteNote(id: id));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Deleted Successfully")));

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNayBar()));
                                    },
                                    child: Text("Ok"))
                              ],
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Text("Delete Forever"),
                        Icon(
                          Icons.delete_forever,
                          semanticLabel: "Permanently Delete",
                        )
                      ],
                    )),
              ],
            );
          }),
        ),
      ),
    );
  }
}
