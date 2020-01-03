import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:google_maps/firebase_database/note.dart';
import 'package:google_maps/firebase_database/note_screen.dart';

class ListViewNote extends StatefulWidget {
  @override
  _ListViewNoteState createState() => new _ListViewNoteState();
}

class _ListViewNoteState extends State<ListViewNote> {
  List<Note> notesList = new List();
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;

  final notesReference = FirebaseDatabase.instance.reference().child('notes');

  @override
  void initState() {
    super.initState();
    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription =
        notesReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('grokonez Firebase DB Demo'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
          itemCount: notesList.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            Note note = notesList[position];
            return Card(
              child: ListTile(
                title: Text('${note.title}'),
                subtitle: Text('${note.description} == ${note.total} '),
                isThreeLine: true,
                trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _deleteNote(context, note, position)),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 15.0,
                  child: Text('${position + 1}'),
                ),
                onTap: () => _navigateToNote(context, note),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createNewNote(context),
      ),
    );
  }

  void _onNoteAdded(Event event) {
    setState(() {
      notesList.add(new Note.fromSnapshot(event.snapshot));
    });
  }

  void _onNoteUpdated(Event event) {
    var oldNoteValue =
        notesList.singleWhere((note) => note.id == event.snapshot.key);
    setState(() {
      notesList[notesList.indexOf(oldNoteValue)] =
          new Note.fromSnapshot(event.snapshot);
    });
  }

  void _deleteNote(BuildContext context, Note note, int position) async {
    await notesReference.child(note.id).remove();
    setState(() {
      notesList.removeAt(position);
    });
  }

  void _navigateToNote(BuildContext context, Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }

  void _createNewNote(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteScreen(Note(null, '', '', ''))),
    );
    if (result) {
      setState(() {});
    }
  }
}
