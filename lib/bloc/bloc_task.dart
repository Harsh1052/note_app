import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/model/firebase_events.dart';

class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NoteState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNote extends TaskEvent {
  final String title;
  final String note;
  final String videoLink;

  AddNote({this.title, this.note, this.videoLink});
}

class DeleteNote extends TaskEvent {
  final String id;

  DeleteNote({this.id});
}

class EditNote extends TaskEvent {
  final String title;
  final String note;
  final String id;
  final String videoLink;

  EditNote({this.id, this.note, this.title, this.videoLink});
}

class MoveToTrash extends TaskEvent {
  final String title;
  final String note;
  final String id;
  final String videoLink;

  MoveToTrash({this.title, this.note, this.id, this.videoLink});
}

class DeleteInTrash extends TaskEvent {
  final String id;

  DeleteInTrash({this.id});
}

class Restore extends TaskEvent {
  final String title;
  final String note;
  final String id;
  final String videoLink;

  Restore({this.title, this.note, this.id, this.videoLink});
}

class NoteBloc extends Bloc<TaskEvent, NoteState> {
  final FirebaseCRUD firebaseCRUD;

  NoteBloc({this.firebaseCRUD}) : super(null);
  @override
  Stream<NoteState> mapEventToState(TaskEvent event) async* {
    if (event is AddNote) {
      await firebaseCRUD.addNote(event.title, event.note, event.videoLink);
    } else if (event is EditNote) {
      await firebaseCRUD.editNote(
        event.title,
        event.note,
        event.videoLink,
        event.id,
      );
    } else if (event is DeleteNote) {
      await firebaseCRUD.delete(event.id);
    } else if (event is MoveToTrash) {
      await firebaseCRUD.moveToTrash(
        event.title,
        event.note,
        event.videoLink,
        event.id,
      );
    } else if (event is Restore) {
      await firebaseCRUD.restore(
          event.title, event.note, event.videoLink, event.id);
    } else if (event is DeleteInTrash) {
      await firebaseCRUD.deleteInTrash(event.id);
    }
  }
}
