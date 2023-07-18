import 'package:flutter/material.dart';
import 'package:note_app/data/dummy_data.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screens/new_note.dart';
import 'package:note_app/widgets/list_note_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isFocus = false;
  var note = NoteModel('Morning', 'Things Todo morning', DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sticky Notes',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewNote(),
                ),
              );
            },
            icon: const Icon(Icons.note_add, size: 30),
            color: Colors.black,
          )
        ],
      ),
      body: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    isFocus = false;
                  });
                },
                onTap: () {
                  setState(() {
                    isFocus = true;
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                      color: isFocus ? Colors.grey[500] : Colors.grey[700]),
                  fillColor: Colors.grey[300],
                  filled: true,
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
                cursorColor: Colors.black,
                cursorWidth: 1.0,
              ),
              const SizedBox(height: 20),
              Expanded(child: ListNoteItem(noteList: availableNotes)),
            ],
          ),
        ),
      ),
    );
  }
}
