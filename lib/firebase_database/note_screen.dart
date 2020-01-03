import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps/firebase_database/note.dart';

class NoteScreen extends StatefulWidget {
  final Note note;

  NoteScreen(this.note);

  @override
  State<StatefulWidget> createState() => new _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _totalController;

  final notesReference = FirebaseDatabase.instance.reference().child('notes');

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.note.title);
    _descriptionController = new TextEditingController(text: widget.note.description);
    _totalController = new TextEditingController(text: widget.note.total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Notes')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title', border: OutlineInputBorder()),
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: _totalController,
              decoration: InputDecoration(
                  labelText: 'Total', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (widget.note.id != null) {
            await notesReference.child(widget.note.id).set({
              'title': _titleController.text,
              'description': _descriptionController.text,
              'total': _totalController.text
            });
            Navigator.pop(context);
          } else {
            await notesReference.push().set({
              'title': _titleController.text,
              'description': _descriptionController.text,
              'total': _totalController.text
            });
            Navigator.pop(context, true);
          }
        },
        child: Container(
          height: 45.0,
          color: Colors.blue,
          child: Center(
              child: Text(
            widget.note.id != null ? 'Update' : 'Add',
          )),
        ),
      ),
    );
  }
}
