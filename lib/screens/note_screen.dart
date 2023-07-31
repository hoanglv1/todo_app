import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app/data/dummy_data.dart';
import 'package:note_app/database/todo_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/notification/NoteNotification.dart';
import 'package:note_app/utils/DateTimeUtils.dart';
import 'package:note_app/widgets/color_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// ignore: must_be_immutable
class NoteScreen extends StatefulWidget {
  NoteScreen({super.key, this.refreshCallback, required this.mode, this.note});

  Function? refreshCallback;
  final String mode;
  NoteModel? note;

  @override
  State<StatefulWidget> createState() => _NewNote();
}

class _NewNote extends State<NoteScreen> {
  final database = TodoDB();
  final _noteContentController = TextEditingController();
  var colorPosition = 0;
  String noteTitle = "";
  String noteBody = "";
  var noteColor = 0;
  Color colorAppBar = colorsAppBar[0];
  Color colorBody = colorsBody[0];
  DateTime dateNotify = DateTime.now();
  int isNotifySet = 1;

  @override
  void initState() {
    super.initState();
    if (widget.mode == "edit" && widget.note != null) {
      _noteContentController.text = widget.note!.noteBody;
      noteColor = widget.note!.noteColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.mode == "edit"
                ? widget.note!.dateTimeDayFormat
                : "Creating New Note",
            style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor:
            widget.mode == "edit" ? colorsAppBar[noteColor] : colorAppBar,
        actions: [
          IconButton(
              onPressed: () {
                if (widget.mode == "edit") {
                  _deleteNote();
                }
              },
              icon: Icon(Icons.delete,
                  color: widget.mode == "edit" ? Colors.black : Colors.grey))
        ],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: widget.mode == "edit" ? colorsBody[noteColor] : colorBody,
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
          height: 80,
          color: widget.mode == "edit" ? colorsBody[noteColor] : colorBody,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    _changeNoteColorBackground();
                  },
                  icon: const Icon(Icons.color_lens_sharp, size: 40)),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    if (widget.mode == "edit") {
                      _exportToPdf();
                    }
                  },
                  icon: Icon(Icons.picture_as_pdf_outlined,
                      size: 40,
                      color: widget.mode == 'new' ? Colors.grey : null)),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    _setDateTimeNotify();
                  },
                  icon: const Icon(Icons.alarm_outlined, size: 40)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    _submitNote();
                  },
                  icon: const Icon(Icons.done, size: 40)),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ]),
    );
  }

  _deleteNote() {
    database.deleteNote(widget.note!);
    widget.refreshCallback!();
    Navigator.pop(context);
  }

  _submitNote() async {
    // Handle Note Data
    String noteContent = _noteContentController.text.trim();
    if (noteContent.isEmpty) {
      Navigator.pop(context);
      return;
    }
    List<String> noteLines = noteContent.split('\n');
    var noteTitle = noteLines.first;
    // Add Note Data
    if (widget.mode == "new") {
      var noteID = await database.getLastNoteId();
      var newNote = NoteModel(noteID, noteTitle, noteContent, DateTime.now(),
          colorPosition, dateNotify,
          isDateNotifySet: isNotifySet);
      database.insertNotes(
          newNote.title,
          newNote.noteBody,
          newNote.dateTimeDayFormat,
          newNote.noteColor,
          newNote.dateNotifyFormat,
          isNotifySet: newNote.isDateNotifySet);
      if (newNote.isDateNotifySet == 0) {
        NoteNotfication().showNotificationByTimeSet(newNote, dateNotify);
      }
    }
    else {
      database.updateNoteById(
          widget.note!.id!, noteTitle, noteContent, noteColor,dateNotify);

    }
    widget.refreshCallback!();
    Navigator.pop(context);
  }

  _setDateTimeNotify() async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );
      if (pickedTime != null) {
        // Nếu giờ đã chọn, kết hợp ngày và giờ để tạo ra DateTime hoàn chỉnh
        setState(() {
          isNotifySet = 0;
            dateNotify = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
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
        if (widget.mode == "edit") {
          noteColor = result;
        } else {
          colorPosition = result;
        }
      });
    }
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();

    // Get the text from the TextField
    String text = _noteContentController.text;

    // Create a paragraph with the text
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('Title',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 24)),
                pw.SizedBox(height: 10),
                pw.Container(
                    width: double.infinity,
                    height: 1,
                    color: PdfColor.fromInt(Colors.black.value)),
                pw.SizedBox(height: 10),
                pw.Text(text)
              ]);
        },
      ),
    );
    // Create the PDF file
    savePDFFile(pdf);
  }

  Future<void> savePDFFile(pw.Document pdf) async {
    Directory? appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir!.path;
    String fileName = '${DateTimeUtils().getCurrentTimeInMilli()}.pdf';
    String fileLocation = '$appDocPath/$fileName';
    File file = File(fileLocation);
    await file.writeAsBytes(await pdf.save());
    showExportPDFDialog(fileLocation);
  }

  Future<void> showExportPDFDialog(String fileLocation) async {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Export to PDF"),
            content: Text("PDF file saved to: $fileLocation"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
