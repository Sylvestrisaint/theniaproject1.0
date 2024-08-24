import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nia/components/my_drawer.dart';
import 'package:nia/models/note.dart';
import 'package:nia/models/note_data.dart';
import 'package:nia/pages/editing_note_page.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteData>(context, listen: false).initializeNotes();
  }

  //create a new note
  void createNewNote() {
    //create a black note
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;

    //create a blank note
    Note newNote = Note(
      id: id,
      text: r'[{"insert": "\n"}]',
    );

    //go to edit the note
    goToNotePage(newNote, true);
  }

  //go to edit the note
  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditingNotePage(note: note, isNewNote: isNewNote)),
    );
  }

  //delete note
  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, value, child) => Scaffold(
        drawer: const MyDrawer(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: FloatingActionButton(
          onPressed: createNewNote,
          elevation: 0,
          shape: const CircleBorder(
            eccentricity: 0,
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          foregroundColor: Colors.grey.shade900,
          child: const Icon(Icons.edit),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
          title: const Center(
            child: Text(
              "Notes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //list of notes
            value.getAllNotes().isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: Text("No note yet...",
                          style: TextStyle(color: Colors.grey.shade400)),
                    ))
                : CupertinoListSection.insetGrouped(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    children: List.generate(
                        value.getAllNotes().length,
                        (index) => CupertinoListTile(
                            onTap: () =>
                                goToNotePage(value.getAllNotes()[index], false),
                            trailing: IconButton(
                                onPressed: () =>
                                    deleteNote(value.getAllNotes()[index]),
                                icon: const Icon(Icons.delete)),
                            title: Text(
                              jsonDecode(value.getAllNotes()[index].text)[0]
                                  ["insert"],
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                            ))),
                  ),
          ],
        ),
      ),
    );
  }
}
