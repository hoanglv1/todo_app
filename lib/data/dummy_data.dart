import 'package:flutter/material.dart';
import 'package:note_app/model/note_model.dart';

var availableNotes = [
  NoteModel('Morning', 'Things Todo morning', DateTime.now()),
  NoteModel('Afternoon', 'Things Todo afternoon', DateTime.now()),
  NoteModel(' Night', 'Things Todo night', DateTime.now()),
];

const colorsAppBar = [
  Color.fromARGB(255, 255, 242, 171),
  Color.fromARGB(255, 181, 197, 178),
  Color.fromARGB(255, 255, 175, 223),
  Color.fromARGB(255, 231, 207, 255),
  Color.fromARGB(255, 205, 233, 255),
  Color.fromARGB(255, 225, 223, 221),
];

const colorsBody = [
  Color.fromARGB(255, 255, 230, 110),
  Color.fromARGB(255, 203, 241, 196),
  Color.fromARGB(255, 255, 204, 229),
  Color.fromARGB(255, 215, 175, 255),
  Color.fromARGB(255, 158, 223, 255),
  Color.fromARGB(255, 224, 224, 224),
];
