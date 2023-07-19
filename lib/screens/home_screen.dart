import 'package:flutter/material.dart';
import 'package:note_app/database/todo_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screens/new_note.dart';
import 'package:note_app/widgets/list_note_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  var isFocus = false;
  var note = NoteModel('Morning', 'Things Todo morning', DateTime.now());
  Future<List<NoteModel>> notesList = Future<List<NoteModel>>.value([]);
  final database = TodoDB();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notesList = database.getAllNotes();
  }

  void _refreshNotesList() async {
    setState(() {
      notesList = database.getAllNotes();
    });
  }

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
                  builder: (context) =>
                      NewNote(refreshCallback: _refreshNotesList),
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
              FutureBuilder<List<NoteModel>>(
                future: notesList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Đã xảy ra lỗi: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('Không có data', style: TextStyle(color: Colors.black,fontSize: 49),);
                  } else {
                    List<NoteModel> notes = snapshot.data!;
                    return Expanded(
                      child: ListNoteItem(noteList: notes),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
