import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/bloc_task.dart';

import 'bottom_app_bar_screen.dart';

class AddNewTaskScreen extends StatelessWidget {
  final String title;
  final String note;
  final String id;

  AddNewTaskScreen({this.note = "", this.title = "", this.id = ""});

  final _titleController = TextEditingController();

  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.red,
          ),
        ),
        title: Text(
          "New Task",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: IconButton(
                  icon: Icon(
                    Icons.done,
                    size: 30.0,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    if (note == "" && title == "" && id == "") {
                      BlocProvider.of<NoteBloc>(context, listen: false).add(
                          AddNote(
                              title: _titleController.text,
                              note: _noteController.text));

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added Successfully")));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNayBar()));
                    } else {
                      BlocProvider.of<NoteBloc>(context, listen: false).add(
                          EditNote(
                              title: _titleController.text,
                              note: _noteController.text,
                              id: id));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Edited Successfully")));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNayBar()));
                    }
                  },
                ));
          })
        ],
      ),
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _titleController..text = title,
                textInputAction: TextInputAction.newline,
                autofocus: true,
                style: TextStyle(
                  fontSize: 30.0,
                ),
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.red[300]),
                  border: InputBorder.none,
                ),
                cursorHeight: 30.0,
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Divider(
              thickness: 0.3,
              color: Colors.red[200],
            ),
            SizedBox(
              height: 2.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _noteController..text = note,
                textInputAction: TextInputAction.newline,
                autofocus: true,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 99999,
                decoration: InputDecoration(
                  hintText: "Note",
                  hintStyle: TextStyle(color: Colors.red[300]),
                  border: InputBorder.none,
                ),
                cursorHeight: 20.0,
              ),
            ),
          ],
        )),
      ]),
    );
  }
}
