import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseCRUD {
  final _noteFireStore =
      FirebaseFirestore.instance.collection("notesCollection");
  final _trashNoteFireStore =
      FirebaseFirestore.instance.collection("trashNoteCollection");

  Future<void> addNote(String title, String note, BuildContext context) async {
    try {
      await _noteFireStore
          .add({"title": title, "note": note}).then((value) async {
        await _noteFireStore
            .doc(value.id)
            .update({"noteId": value.id}).whenComplete(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Task Added Successfully")));
        });
      });
    } catch (FirebaseException) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Some Thing Went Wrong")));

      print(FirebaseException);
    }
  }

  Future<void> delete(String id, BuildContext context) async {
    try {
      await _noteFireStore.doc(id).delete().whenComplete(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Task Deleted Successfully")));
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong!")));
    }
  }

  Future<void> deleteInTrash(String id, BuildContext context) async {
    try {
      await _trashNoteFireStore.doc(id).delete().whenComplete(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Task Deleted Successfully")));
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong!")));
    }
  }

  Future<void> moveToTrash(
      String title, String note, String id, BuildContext context) async {
    try {
      await _trashNoteFireStore
          .add({"title": title, "note": note}).then((value) async {
        await _trashNoteFireStore
            .doc(value.id)
            .update({"noteId": value.id}).whenComplete(() async {
          await _noteFireStore.doc(id).delete().whenComplete(() =>
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Moved In Trash Successfully"))));
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong!")));
    }
  }

  Future<void> restore(
      String title, String note, String id, BuildContext context) async {
    try {
      await _noteFireStore
          .add({"title": title, "note": note}).then((value) async {
        await _noteFireStore
            .doc(value.id)
            .update({"noteId": value.id}).whenComplete(() async {
          print("trash Id:$id");
          await _trashNoteFireStore.doc(id).delete().whenComplete(() {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Restore Successfully")));
          });
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
    }
  }

  Future<void> editNote(
      String title, String note, String id, BuildContext context) async {
    await _noteFireStore
        .doc(id)
        .update({"title": title, "note": note}).whenComplete(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully Edited")));
    });
  }
}
