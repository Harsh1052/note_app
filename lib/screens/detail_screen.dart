import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/bloc_task.dart';
import 'package:note_app/consatants.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/video_screen.dart';

import 'bottom_app_bar_screen.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String note;
  final String id;
  final String videoLink;
  final bool online;

  DetailScreen({this.title, this.note, this.id, this.videoLink, this.online});

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
                              title: title,
                              note: note,
                              id: id,
                              videoLink: videoLink,
                            )));
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
              child: videoLink == "no_video_link"
                  ? Column(
                      children: [
                        SelectableText(
                          note,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          SelectableText(
                            note,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15.0)),
                            child: InkWell(
                              child: Text(
                                videoLink,
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                online
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VideoScreen(
                                                  title: title,
                                                  videoLink: videoLink,
                                                )))
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                                "No Internet Connection")));
                              },
                            ),
                          )
                        ]),
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
                      BlocProvider.of<NoteBloc>(context, listen: false).add(
                          MoveToTrash(
                              title: title,
                              note: note,
                              id: id,
                              videoLink: videoLink));

                      online
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Moved Successfully")))
                          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("No Internet Connection")));

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

                                      online
                                          ? ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Deleted Successfully")))
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "No Internet Connection")));
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
