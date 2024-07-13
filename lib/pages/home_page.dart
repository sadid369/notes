// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    // BlocProvider.of<NotesBloc>(context)
    //     .add(NotesInitialEvent(user_id: user_id!));
    context.read<NotesBloc>().add(NotesInitialEvent(user_id: user_id!));
  }

  void searchNotes({required String keyword}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user_id = preferences.getString('user_id');
    if (keyword.isEmpty) {
      context.read<NotesBloc>().add(NotesInitialEvent(user_id: user_id!));
    } else {
      context.read<NotesBloc>().add(NotesSearchEvent(keyword: keyword));
    }
  }

  bool isFavVisible = false;
  bool typing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.backGroundColor,
        floatingActionButton: !isFavVisible
            ? FloatingActionButton.large(
                tooltip: "Add Note",
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
              )
            : null,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Constants.backGroundColor,
                floating: true,
                snap: true,
                title: !typing
                    ? Text(
                        "Notes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      )
                    : Container(
                        height: 40,
                        width: 400,
                        alignment: Alignment.centerRight,
                        color: Colors.white,
                        child: TextField(
                          cursorColor: Constants.textColor,
                          cursorWidth: 4,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            searchNotes(keyword: value);
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Constants.backGroundColor,
                            hintText: "Search Notes",
                            hintStyle: TextStyle(
                              color: Constants.textColor,
                              fontSize: 30,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        typing = !typing;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Constants.tabColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ];
          },
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
                              Expanded(
                                child: NotificationListener<
                                    UserScrollNotification>(
                                  onNotification: (notification) {
                                    if (notification.direction ==
                                        ScrollDirection.forward) {
                                      setState(() {
                                        isFavVisible = false;
                                      });
                                    } else if (notification.direction ==
                                        ScrollDirection.reverse) {
                                      setState(() {
                                        isFavVisible = true;
                                      });
                                    }
                                    return true;
                                  },
                                  child: GridView.custom(
                                    gridDelegate: SliverStairedGridDelegate(
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      pattern: [
                                        const StairedGridTile(0.5, 1),
                                        const StairedGridTile(0.5, 1),
                                        const StairedGridTile(1.0, 10 / 4),
                                      ],
                                    ),
                                    childrenDelegate:
                                        SliverChildBuilderDelegate(
                                      childCount: state.notes.length,
                                      (context, index) => MyGridTile(
                                        notes: state.notes[index],
                                        index: index,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No Notes',
                            style: TextStyle(
                                color: Constants.textColor, fontSize: 80),
                          ),
                        );
            },
          ),
        ));
  }
}
