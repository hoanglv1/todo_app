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
  note_date TEXT,
  note_color INTEGER
  )''';

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  Future<void> createTable(Database database) async {
    await database.execute(createTableQuery);
  }

  Future<void> insertNotes(String noteTitle, String noteContent,
      String noteDate, int noteColor) async {
    final database = await DBService().database;
    const String insertQuery =
        '''INSERT INTO notes (note_title, note_content, note_date, note_color) VALUES (?, ?, ?, ?)''';

    final List<dynamic> values = [noteTitle, noteContent, noteDate, noteColor];
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

  void updateNoteById(
      int id, String noteTitle, String noteBody, int noteColor) async {
    final database = await DBService().database;
    await database.update(
      'notes',
      {
        'note_title': noteTitle,
        'note_content': noteBody,
        'note_color': noteColor
      },
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
        note['note_color'],
      );
    }).toList();
    return notes;
  }

  Future<List<NoteModel>> getAllNoteWithSearchedTitle(String title) async {
    final database = await DBService().database;
    final List<Map<String, dynamic>> results = await database.query(
      'notes',
      where: 'note_title LIKE ?',
      whereArgs: ['%$title%'],
    );
    final List<NoteModel> notes = results.map((note) {
      return NoteModel(
        note['note_id'],
        note['note_title'],
        note['note_content'],
        formatter.parse(note['note_date']),
        note['note_color'],
      );
    }).toList();
    return notes;
  }
}
