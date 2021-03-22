import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCRUD {
  final _noteFireStore =
      FirebaseFirestore.instance.collection("notesCollection");
  final _trashNoteFireStore =
      FirebaseFirestore.instance.collection("trashNoteCollection");

  Future<void> addNote(String title, String note, String videoLink) async {
    await _noteFireStore
        .add({"title": title, "note": note, "video_link": videoLink}).then(
            (value) async {
      await _noteFireStore
          .doc(value.id)
          .update({"noteId": value.id}).whenComplete(() {});
    });
  }

  Future<void> delete(String id) async {
    await _noteFireStore.doc(id).delete().whenComplete(() {});
  }

  Future<void> deleteInTrash(String id) async {
    await _trashNoteFireStore.doc(id).delete().whenComplete(() {});
  }

  Future<void> moveToTrash(
      String title, String note, String videoLink, String id) async {
    await _trashNoteFireStore
        .add({"title": title, "note": note, "video_link": videoLink}).then(
            (value) async {
      await _trashNoteFireStore
          .doc(value.id)
          .update({"noteId": value.id}).whenComplete(() async {
        await _noteFireStore.doc(id).delete();
      });
    });
  }

  Future<void> restore(
      String title, String note, String videoLink, String id) async {
    await _noteFireStore
        .add({"title": title, "note": note, "video_link": videoLink}).then(
            (value) async {
      await _noteFireStore
          .doc(value.id)
          .update({"noteId": value.id}).whenComplete(() async {
        print("trash Id:$id");
        await _trashNoteFireStore.doc(id).delete().whenComplete(() {});
      });
    });
  }

  Future<void> editNote(
      String title, String note, String videoLink, String id) async {
    await _noteFireStore.doc(id).update({
      "title": title,
      "note": note,
      "video_link": videoLink
    }).whenComplete(() {});
  }
}
