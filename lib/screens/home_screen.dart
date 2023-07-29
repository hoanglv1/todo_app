import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:note_app/database/todo_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/notification/NoteNotification.dart';
import 'package:note_app/screens/note_screen.dart';
import 'package:note_app/widgets/list_note_item.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchCondition = TextEditingController();
  var isFocus = false;
  Future<List<NoteModel>> notesList = Future<List<NoteModel>>.value([]);
  final database = TodoDB();

  @override
  void initState() {
    super.initState();
    notesList = database.getAllNotes();
  }

  void _refreshNotesList() async {
    setState(() {
      notesList = database.getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    _requestNotificationPermissionIfNeed();
    NoteNotfication().configureLocalTimeZone();
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
                  builder: (context) => NoteScreen(
                      refreshCallback: _refreshNotesList, mode: "new"),
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
                controller: searchCondition,
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
                onChanged: (value) {
                  setState(() {
                    notesList = database.getAllNoteWithSearchedTitle(value);
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
                  } else if (snapshot.data!.isEmpty) {
                    return Column(children: [
                      const SizedBox(height: 100),
                      Image.asset('assets/note_image.png',
                          width: 200, height: 200),
                      const SizedBox(height: 20),
                      const Text('Note is Empty',
                          style: TextStyle(fontSize: 24, color: Colors.black))
                    ]);
                  } else {
                    List<NoteModel> notes = snapshot.data!;
                    return Expanded(
                      child: ListNoteItem(
                          noteList: notes, refreshCallback: _refreshNotesList),
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

  _requestNotificationPermissionIfNeed() async {
    if (await Permission.notification.isDenied) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
    NoteNotfication().initNotification();
  }
}
