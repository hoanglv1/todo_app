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

    try {
      await database.rawInsert(insertQuery, values);
      print('insert thành công');
    } catch (e) {
      print('insert thất bại');
    }
  }

  Future<List<NoteModel>> getAllNotes() async {
    final database = await DBService().database;

    final List<Map<String, dynamic>> results = await database.query('notes');

    final List<NoteModel> notes = results.map((note) {
      return NoteModel(
        note['note_title'],
        note['note_content'],
        formatter.parse(note['note_date']),
      );
    }).toList();
    return notes;
  }
}
