import 'dart:core';

import 'package:intl/intl.dart';

class NoteModel {
  final String title;
  final String noteBody;
  final DateTime date;

  const NoteModel(this.title, this.noteBody, this.date);

  String get dateTimeDay {

    String formattedDate = DateFormat('dd-MM-yyyy').format(date);

    return formattedDate;
  }
}
