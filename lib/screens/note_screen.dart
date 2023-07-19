import 'package:flutter/material.dart';
import 'package:note_app/data/dummy_data.dart';
import 'package:note_app/database/todo_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/widgets/color_table.dart';

class NoteScreen extends StatefulWidget {
  NoteScreen({super.key, this.refreshCallback, required this.mode, this.note});

  Function? refreshCallback;
  final String mode;
  NoteModel? note;

  @override
  State<StatefulWidget> createState() => _NewNote();
}

class _NewNote extends State<NoteScreen> {
  final _noteContentController = TextEditingController();
  String noteTitle = "";
  String noteBody = "";
  Color colorAppBar = colorsAppBar[0];
  Color colorBody = colorsBody[0];
  final database = TodoDB();

  @override
  void initState() {
    super.initState();
    if (widget.mode == "edit" && widget.note != null) {
      _noteContentController.text = widget.note!.noteBody;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppBar,
        actions: widget.mode == "edit"
            ? [
                IconButton(
                    onPressed: () {
                      database.deleteNote(widget.note!);
                      widget.refreshCallback!();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete))
              ]
            : null,
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
    // Add Note Data
    if (widget.mode == "new") {
      var newNote = NoteModel(null, noteTitle, noteContent, DateTime.now());
      database.insertNotes(
          newNote.title, newNote.noteBody, newNote.dateTimeDay);
    } else {
      database.updateNoteById(widget.note!.id!, noteTitle, noteContent);
    }
    widget.refreshCallback!();
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
