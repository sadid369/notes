import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/notes_bloc.dart';
import '../constant.dart';
import '../model/notes.dart';

class NoteUpdatePage extends StatefulWidget {
  final Notes notes;
  const NoteUpdatePage({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  State<NoteUpdatePage> createState() => _NoteUpdatePageState();
}

class _NoteUpdatePageState extends State<NoteUpdatePage> {
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.notes.title!;
    _descController.text = widget.notes.desc!;
  }

  void updateNotes(Notes note) async {
    BlocProvider.of<NotesBloc>(context).add(NotesUpdateEvent(notes: note));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.backGroundColor,
        body: BlocConsumer<NotesBloc, NotesState>(
          listenWhen: (previous, current) {
            return current is NotesUpdatedState;
          },
          listener: (context, state) {
            if (state is NotesUpdatedState) {
              if (state.isNoteUpdated) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Constants.backGroundColor,
                      content: const Text(
                        'Note Updated',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Constants.backGroundColor,
                      content: const Text(
                        'Some Thing is Wrong',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 60,
                      bottom: 20,
                    ),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 70,
                            height: 60,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Constants.tabColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Constants.tabColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (_titleController.text.isNotEmpty &&
                                  _descController.text.isNotEmpty) {
                                updateNotes(widget.notes.copyWith(
                                  title: _titleController.text.toString(),
                                  desc: _descController.text.toString(),
                                ));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Constants.backGroundColor,
                                      content: Text(
                                        _titleController.text.isEmpty &&
                                                _descController.text.isEmpty
                                            ? 'Please Add Note Title & Description'
                                            : _titleController.text.isEmpty
                                                ? 'Please Add Note Title'
                                                : "Please Add Note Description",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Ok',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text(
                              'Update',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    cursorColor: Constants.textColor,
                    cursorWidth: 4,
                    style: const TextStyle(
                      fontSize: 35,
                      color: Constants.textColor,
                    ),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Constants.textColor,
                        fontSize: 35,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    maxLines: 5,
                    cursorColor: Constants.textColor,
                    cursorWidth: 4,
                    style: const TextStyle(
                      fontSize: 35,
                      color: Constants.textColor,
                    ),
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText: "Type Something....",
                      hintStyle: TextStyle(
                        color: Constants.textColor,
                        fontSize: 35,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
