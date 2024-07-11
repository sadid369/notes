// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/gridTile.dart';
import '../bloc/notes_bloc.dart';
import '../constant.dart';
import 'note_add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getAllNotes();
  }

  void getAllNotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user_id = preferences.getString('user_id');
    BlocProvider.of<NotesBloc>(context)
        .add(NotesInitialEvent(user_id: user_id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.backGroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Constants.backGroundColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const NoteAddPage();
                },
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: BlocConsumer<NotesBloc, NotesState>(
          listener: (context, state) {},
          builder: (context, state) {
            return state is NotesLoadingSate
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state is NotesLoadedSate && state.notes.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                top: 60,
                                bottom: 20,
                              ),
                              height: 45,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Notes',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Constants.tabColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: GridView.custom(
                                gridDelegate: SliverStairedGridDelegate(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  // startCrossAxisDirectionReversed: true,
                                  pattern: [
                                    const StairedGridTile(0.5, 1),
                                    const StairedGridTile(0.5, 1),
                                    const StairedGridTile(1.0, 10 / 4),
                                  ],
                                ),
                                childrenDelegate: SliverChildBuilderDelegate(
                                  childCount: state.notes.length,
                                  (context, index) => MyGridTile(
                                    notes: state.notes[index],
                                    index: index,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('No Notes'),
                      );
          },
        ));
  }
}
