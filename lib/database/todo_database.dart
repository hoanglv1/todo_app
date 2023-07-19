import 'package:intl/intl.dart';
import 'package:note_app/database/database_service.dart';
import 'package:note_app/model/note_model.dart';
import 'package:sqflite/sqflite.dart';

class TodoDB {
  final tableName = 'todo';
  final String createTableQuery = '''CREATE TABLE notes (
  note_id INTEGER PRIMARY KEY AUTOINCREMENT,
  note_title TEXT,
  note_content TEXT,
  note_date TEXT
  )''';

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  Future<void> createTable(Database database) async {
    await database.execute(createTableQuery);
  }

  Future<void> insertNotes(
      String noteTitle, String noteContent, String noteDate) async {
    final database = await DBService().database;
    const String insertQuery =
        '''INSERT INTO notes (note_title, note_content, note_date) VALUES (?, ?, ?)''';

    final List<dynamic> values = [noteTitle, noteContent, noteDate];
    await database.rawInsert(insertQuery, values);
  }

  Future<void> deleteNote(NoteModel note) async {
    final database = await DBService().database;
    await database.delete(
      'notes',
      where: 'note_id = ?',
      whereArgs: [note.id],
    );
  }

  void updateNoteById(int id, String noteTitle, String noteBody) async {
    final database = await DBService().database;
    await database.update(
      'notes',
      {'note_title': noteTitle, 'note_content': noteBody},
      where: 'note_id = ?',
      whereArgs: [id],
    );
  }

  Future<List<NoteModel>> getAllNotes() async {
    final database = await DBService().database;
    final List<Map<String, dynamic>> results = await database.query('notes');
    final List<NoteModel> notes = results.map((note) {
      return NoteModel(
        note['note_id'],
        note['note_title'],
        note['note_content'],
        formatter.parse(note['note_date']),
      );
    }).toList();
    return notes;
  }
}
