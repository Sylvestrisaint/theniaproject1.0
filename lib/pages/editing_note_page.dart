import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:nia/models/note.dart';
import 'package:nia/models/note_data.dart';
import 'package:provider/provider.dart';

class EditingNotePage extends StatefulWidget {
  final Note note;
  final bool isNewNote;
  const EditingNotePage({
    super.key,
    required this.note,
    required this.isNewNote,
  });

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  //load existing note
  void loadExistingNote() {
    //load json string from storage
    String savedJson = widget.note.text;
    //create a delta object from json data
    Delta delta = Delta.fromJson(jsonDecode(savedJson));

    if (delta.isNotEmpty) {
      final doc = Document.fromJson(delta.toJson());
      setState(() {
        _controller = QuillController(
            document: doc,
            selection: const TextSelection.collapsed(
              offset: 0,
            ));
      });
    } else {
      final doc = Document()..insert(0, "New note...");
      setState(() {
        _controller = QuillController(
            document: doc,
            selection: const TextSelection.collapsed(
              offset: 0,
            ));
      });
    }
  }

  //add new note
  void addNewNote() {
    //get new id
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    //get text from editor
    String text = jsonEncode(_controller.document.toDelta().toJson());
    //add the new note
    Provider.of<NoteData>(context, listen: false)
        .addNewNote(Note(id: id, text: text));
  }

  //update existing note
  void updateNote() {
    //get text from editor
    String text = jsonEncode(_controller.document.toDelta().toJson());
    //update note
    Provider.of<NoteData>(context, listen: false).updateNote(widget.note, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //it's a new note
            if (widget.isNewNote && !_controller.document.isEmpty()) {
              addNewNote();
            }
            //it's an existing note
            else {
              updateNote();
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          QuillToolbar.simple(
            controller: _controller,
            configurations: const QuillSimpleToolbarConfigurations(
                showDividers: true,
                showFontFamily: true,
                showFontSize: true,
                showBoldButton: true,
                showItalicButton: true,
                showSmallButton: false,
                showUnderLineButton: true,
                showStrikeThrough: false,
                showInlineCode: false,
                showColorButton: false,
                showBackgroundColorButton: true,
                showClearFormat: false,
                showAlignmentButtons: true,
                showLeftAlignment: false,
                showCenterAlignment: false,
                showRightAlignment: false,
                showJustifyAlignment: false,
                showHeaderStyle: true,
                showListNumbers: true,
                showListBullets: true,
                showListCheck: true,
                showCodeBlock: false,
                showQuote: false,
                showIndent: false,
                showLink: false,
                showUndo: true,
                showRedo: true,
                showDirection: false,
                showSearchButton: false,
                showSubscript: false,
                showSuperscript: false,
                sharedConfigurations:
                    QuillSharedConfigurations(locale: Locale('en'))),
          ),

          //editor
          Expanded(
              child: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).colorScheme.secondary,
            ),
            padding: const EdgeInsets.all(25.0),
            child: QuillEditor.basic(
              controller: _controller,
              focusNode: FocusNode(),
              configurations: const QuillEditorConfigurations(
                  sharedConfigurations:
                      QuillSharedConfigurations(locale: Locale('en'))),
            ),
          ))
        ],
      ),
    );
  }
}
