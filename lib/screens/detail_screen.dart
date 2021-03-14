import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:note_app/consatants.dart';
import 'package:note_app/model/firebase_events.dart';
import 'package:note_app/screens/add_note_screen.dart';

import 'bottom_app_bar_screen.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String note;
  final String id;

  DetailScreen({@required this.title, @required this.note, @required this.id});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _noteFirebase = FirebaseCRUD();
  bool loading = false;

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
                            title: widget.title,
                            note: widget.note,
                            id: widget.id)));
              })
        ],
        title: Hero(
          tag: "hero_tag${widget.id}",
          child: Text(
            widget.title,
            style: TextStyle(
                color: Colors.red, fontSize: 25.0, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: SafeArea(
          child: Scrollbar(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0),
              child: SingleChildScrollView(
                child: SelectableText(
                  widget.note,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: kButtonStyle.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.yellow[900]),
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await _noteFirebase.moveToTrash(
                        widget.title, widget.note, widget.id, context);

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
                                    setState(() {
                                      loading = true;
                                    });
                                    _noteFirebase.delete(widget.id, context);

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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
