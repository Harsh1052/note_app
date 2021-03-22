import 'package:note_app/model/noteData.dart';
import 'package:sqflite/sqflite.dart';

final String noteTable = "Note";
final String columnId = "id";
final String columnTitle = "noteTitle";
final String columnNote = "noteData";
final String columnVideoLink = "noteVideoLink";

class NoteDatabase {
  static Database database;
  static NoteDatabase noteDatabase;

  Future<Database> get databse async {
    if (database == null) {
      database = await initializeDatabase();
    }

    return database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "note.db";

    var _database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $noteTable ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnNote TEXT, $columnVideoLink TEXT)');
    });

    return _database;
  }

  insertData(NoteData noteData) async {
    Database db = await this.databse;

    await db.insert(noteTable, noteData.toMap());
  }

  deleteDatabase() async {
    Database db = await this.databse;

    await db.delete(noteTable);

    print("Deleted Database");
  }

  Future<List<NoteData>> getDatabase() async {
    Database db = await this.databse;

    var noteMapList = await db.query(noteTable);
    final List<NoteData> _noteList = [];

    for (int i = 0; i < noteMapList.length; i++) {
      _noteList.add(NoteData.fromMapObject(noteMapList[i]));
    }

    return _noteList;
  }
}
