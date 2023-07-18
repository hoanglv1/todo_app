import 'package:flutter/cupertino.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/widgets/note_item.dart';

class ListNoteItem extends StatelessWidget {
  const ListNoteItem({super.key, required this.noteList});

  final List<NoteModel> noteList;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: NoteItem(
          noteModel: noteList[index],
        ),
      ),
    );
  }
}
