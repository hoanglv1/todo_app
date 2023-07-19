import 'package:flutter/material.dart';
import 'package:note_app/data/dummy_data.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screens/note_screen.dart';
import 'package:note_app/widgets/triangle_conner.dart';

class NoteItem extends StatefulWidget {
  const NoteItem(
      {super.key, required this.noteModel, required this.refreshCallback});

  final Function refreshCallback;
  final NoteModel noteModel;

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    var noteId = widget.noteModel.id;
    var noteTitle = widget.noteModel.title;
    var noteBody = widget.noteModel.noteBody;
    var noteDate = widget.noteModel.date;
    var noteBackgroundColor = widget.noteModel.noteColor;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteScreen(
              refreshCallback: widget.refreshCallback,
              mode: 'edit',
              note: NoteModel(
                  noteId, noteTitle, noteBody, noteDate, noteBackgroundColor),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 100,
        color: colorsBody[widget.noteModel.noteColor],
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(noteTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                      noteBody.split('\n').length > 1
                          ? noteBody.split('\n')[1]
                          : "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 100, 98, 89))),
                ],
              ),
            ),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(widget.noteModel.dateTimeDay,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 100, 98, 89))),
                ),
              ),
              const Spacer(),
              const TriangleInCorner()
            ]),
          ],
        ),
      ),
    );
  }
}
