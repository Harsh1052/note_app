import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCRUD {
  final _noteFireStore =
      FirebaseFirestore.instance.collection("notesCollection");
  final _trashNoteFireStore =
      FirebaseFirestore.instance.collection("trashNoteCollection");

  Future<void> addNote(
    String title,
    String note,
  ) async {
    try {
      await _noteFireStore
          .add({"title": title, "note": note}).then((value) async {
        await _noteFireStore
            .doc(value.id)
            .update({"noteId": value.id}).whenComplete(() {});
      });
    } catch (FirebaseException) {
      print(FirebaseException);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _noteFireStore.doc(id).delete().whenComplete(() {});
    } catch (e) {}
  }

  Future<void> deleteInTrash(String id) async {
    try {
      await _trashNoteFireStore.doc(id).delete().whenComplete(() {});
    } catch (e) {}
  }

  Future<void> moveToTrash(String title, String note, String id) async {
    try {
      await _trashNoteFireStore
          .add({"title": title, "note": note}).then((value) async {
        await _trashNoteFireStore
            .doc(value.id)
            .update({"noteId": value.id}).whenComplete(() async {
          await _noteFireStore.doc(id).delete();
        });
      });
    } catch (e) {}
  }

  Future<void> restore(String title, String note, String id) async {
    try {
      await _noteFireStore
          .add({"title": title, "note": note}).then((value) async {
        await _noteFireStore
            .doc(value.id)
            .update({"noteId": value.id}).whenComplete(() async {
          print("trash Id:$id");
          await _trashNoteFireStore.doc(id).delete().whenComplete(() {});
        });
      });
    } catch (e) {}
  }

  Future<void> editNote(String title, String note, String id) async {
    try {
      await _noteFireStore
          .doc(id)
          .update({"title": title, "note": note}).whenComplete(() {});
    } catch (e) {}
  }
}
