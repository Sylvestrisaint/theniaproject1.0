import 'package:hive/hive.dart';
import 'package:nia/models/note.dart';

class HiveDatabase {
  //reference our hive box
  final _mybox = Hive.box('note_database');

  //load notes
  List<Note> loadNotesJson() {
    List<Note> savedNotesFormatted = [];

    //if there exist notes return that, otherwise return empty list
    if (_mybox.get("ALL_NOTES") != null) {
      List<dynamic> savedNotes = _mybox.get("ALL_NOTES");
      for (int i = 0; i < savedNotes.length; i++) {
        //create individual note
        Note individualNote =
            Note(id: savedNotes[i][0], text: savedNotes[i][1]);

        //add to list
        savedNotesFormatted.add(individualNote);
      }
    }
    return savedNotesFormatted;
  }

  //save notes
  void savedNotes(List<Note> allNotes) {
    List<List<dynamic>> allNotesFormatted = [];

    //each note has an id and text
    for (var note in allNotes) {
      int id = note.id;
      String text = note.text;
      allNotesFormatted.add([id, text]);
    }

    //then store into hive
    _mybox.put("ALL_NOTES", allNotesFormatted);
  }
}
