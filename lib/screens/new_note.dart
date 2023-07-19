import 'package:flutter/material.dart';
import 'package:note_app/data/dummy_data.dart';
import 'package:note_app/database/todo_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/widgets/color_table.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key, required this.refreshCallback});

  final Function refreshCallback;

  @override
  State<StatefulWidget> createState() => _NewNote();
}

class _NewNote extends State<NewNote> {
  final _noteContentController = TextEditingController();
  String noteTitle = "";
  String noteBody = "";
  Color colorAppBar = colorsAppBar[0];
  Color colorBody = colorsBody[0];
  final database = TodoDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppBar,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: colorBody,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _noteContentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nhập ghi chú....',
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: colorBody,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_bold, size: 30)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_italic, size: 30)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_underline_outlined, size: 30)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_list_bulleted, size: 30)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.image, size: 30)),
              IconButton(
                  onPressed: () {
                    _changeNoteColorBackground();
                  },
                  icon: const Icon(Icons.color_lens_sharp, size: 30)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    _submitNote(noteTitle, noteBody);
                  },
                  icon: const Icon(Icons.done, size: 30)),
            ],
          ),
        )
      ]),
    );
  }



  _submitNote(String noteTitle, String noteBody) {
    // Handle Note Data
    String noteContent = _noteContentController.text.trim();
    if (noteContent.isEmpty) {
      Navigator.pop(context);
      return;
    }
    List<String> noteLines = noteContent.split('\n');
    noteTitle = noteLines.first;
    noteBody = (noteLines.length > 1) ? noteLines.sublist(1).join('\n') : '';
    // Add Note Data
    var newNote = NoteModel(noteTitle, noteBody, DateTime.now());
    database.insertNotes(newNote.title, newNote.noteBody, newNote.dateTimeDay);
    widget.refreshCallback();
    Navigator.pop(context);
  }

  _changeNoteColorBackground() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: SizedBox(width: double.maxFinite, child: ColorTable()),
        );
      },
    );
    // After picking color
    if (result != null) {
      setState(() {
        colorAppBar = colorsAppBar[result];
        colorBody = colorsBody[result];
      });
    }
  }
}
