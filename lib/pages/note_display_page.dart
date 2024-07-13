// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes/bloc/notes_bloc.dart';

import '../constant.dart';
import 'note_update_page.dart';

class NoteDisplayPage extends StatefulWidget {
  final int index;
  const NoteDisplayPage({super.key, required this.index});

  @override
  _NoteDisplayPageState createState() => _NoteDisplayPageState();
}

class _NoteDisplayPageState extends State<NoteDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return state is NotesLoadedSate
            ? Scaffold(
                backgroundColor: Constants.backGroundColor,
                body: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return NoteUpdatePage(
                                          notes: state.notes[widget.index],
                                        );
                                      },
                                    ));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Text(
                        state.notes[widget.index].title!,
                        style: const TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        DateFormat.yMMMMd()
                            .format(state.notes[widget.index].dateTime),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        state.notes[widget.index].desc!,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
