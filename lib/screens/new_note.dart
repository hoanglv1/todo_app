import 'package:flutter/material.dart';
import 'package:note_app/widgets/color_table.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<StatefulWidget> createState() => _NewNote();
}

class _NewNote extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 242, 171),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: const Color.fromARGB(255, 255, 247, 209),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nhập ghi chú....',
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 255, 247, 209),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          child :SizedBox(
                              width: double.maxFinite, child: ColorTable()),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.color_lens_sharp, size: 30)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.done, size: 30)),
            ],
          ),
        )
      ]),
    );
  }
}
