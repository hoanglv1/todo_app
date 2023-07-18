import 'package:flutter/material.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screens/new_note.dart';
import 'package:note_app/widgets/triangle_conner.dart';

class NoteItem extends StatefulWidget {
  const NoteItem({super.key, required this.noteModel});

  final NoteModel noteModel;

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: double.infinity,
        height: 100,
        color: const Color.fromARGB(255, 255, 247, 209),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.noteModel.title,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(widget.noteModel.noteBody,
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
