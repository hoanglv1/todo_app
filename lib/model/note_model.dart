import 'dart:core';

import 'package:intl/intl.dart';

class NoteModel {
  final int? id;
  final String title;
  final String noteBody;
  final DateTime dateCreated;
  final int noteColor;
  final DateTime? dateNotify;
  final int isDateNotifySet;

  NoteModel(this.id, this.title, this.noteBody, this.dateCreated,
      this.noteColor, this.dateNotify,
      {this.isDateNotifySet = 1});

  String get dateTimeDayFormat {
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateCreated);
    return formattedDate;
  }

  String get dateNotifyFormat {
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateNotify!);
    return formattedDate;
  }
}
