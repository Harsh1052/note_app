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

  AddNote({this.title, this.note});
}

class DeleteNote extends TaskEvent {
  final String id;

  DeleteNote({this.id});
}

class EditNote extends TaskEvent {
  final String title;
  final String note;
  final String id;

  EditNote({this.id, this.note, this.title});
}

class MoveToTrash extends TaskEvent {
  final String title;
  final String note;
  final String id;

  MoveToTrash({this.title, this.note, this.id});
}

class DeleteInTrash extends TaskEvent {
  final String id;

  DeleteInTrash({this.id});
}

class Restore extends TaskEvent {
  final String title;
  final String note;
  final String id;

  Restore({this.title, this.note, this.id});
}

class NoteBloc extends Bloc<TaskEvent, NoteState> {
  final FirebaseCRUD _firebaseCRUD;

  NoteBloc(this._firebaseCRUD) : super(null);
  @override
  Stream<NoteState> mapEventToState(TaskEvent event) async* {
    if (event is AddNote) {
      await _firebaseCRUD.addNote(event.title, event.note);
    } else if (event is EditNote) {
      await _firebaseCRUD.editNote(event.title, event.note, event.id);
    } else if (event is DeleteNote) {
      await _firebaseCRUD.delete(event.id);
    } else if (event is MoveToTrash) {
      await _firebaseCRUD.moveToTrash(event.title, event.note, event.id);
    } else if (event is Restore) {
      await _firebaseCRUD.restore(event.title, event.note, event.id);
    } else if (event is DeleteInTrash) {
      await _firebaseCRUD.deleteInTrash(event.id);
    }
  }
}
