// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_string_interpolations, file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/notes_bloc.dart';
import '../constant.dart';
import '../model/notes.dart';
import '../pages/note_display_page.dart';

class MyGridTile extends StatelessWidget {
  final Notes notes;
  final int index;

  const MyGridTile({
    super.key,
    required this.notes,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return NoteDisplayPage(index: index);
          },
        ));
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Constants.listColors[index % Constants.listColors.length],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 45,
                    left: 5,
                    right: 5,
                  ),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      '''${notes.title.toString()}''',
                      style: const TextStyle(
                        letterSpacing: 1,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Align(
                    child: Text(
                      DateFormat.yMMMMd().format(notes.dateTime),
                      style: TextStyle(
                        color: Constants.backGroundColor.withOpacity(0.3),
                        // fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Constants.backGroundColor,
                        content: const Text(
                          'Delete This Note!!!!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              BlocProvider.of<NotesBloc>(context)
                                  .add(NotesDeleteEvent(
                                id: notes.note_id!,
                              ));
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Yes',
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
                },
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: Constants.tabColor,
                  size: 35,
                )),
          ),
        ],
      ),
    );
  }
}
