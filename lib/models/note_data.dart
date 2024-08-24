import 'package:flutter/cupertino.dart';
import 'package:nia/database/hive_database.dart';
import 'package:nia/models/note.dart';

class NoteData extends ChangeNotifier {
  //hive database
  final db = HiveDatabase();

  //overall list of notes
  List<Note> allNotes = [];

  //initialize list
  void initializeNotes() {
    allNotes = db.loadNotesJson(); //checkpoint
  }

  //get notes
  List<Note> getAllNotes() {
    return allNotes;
  }

  //add a new note
  void addNewNote(Note note) {
    allNotes.add(note);
    db.savedNotes(allNotes);
    notifyListeners();
  }

  //update note
  void updateNote(Note note, String text) {
    //go through list of all notes
    for (int i = 0; i < allNotes.length; i++) {
      //find the relevant note
      if (allNotes[i].id == note.id) {
        allNotes[i].text = text;
      }
    }
    db.savedNotes(allNotes);
    notifyListeners();
  }

  //delete note
  void deleteNote(Note note) {
    allNotes.remove(note);
    db.savedNotes(allNotes);
    notifyListeners();
  }
}
