import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/notes.dart';
import '../repository/app_database.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  AppDatabase db;
  NotesBloc({required this.db}) : super(NotesInitialState()) {
    on<NotesInitialEvent>(notesInitialEvent);
    on<NotesAddEvent>(notesAddEvent);
    on<NotesUpdateEvent>(notesUpdateEvent);
    on<NotesDeleteEvent>(notesDeleteEvent);
    on<NotesSearchEvent>(notesSearchEvent);
  }

  FutureOr<void> notesInitialEvent(
      NotesInitialEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingSate());
    var notes = await db.fetchAllNotes(user_id: event.user_id.toString());
    emit(NotesLoadedSate(notes: notes));
  }

  FutureOr<void> notesAddEvent(
      NotesAddEvent event, Emitter<NotesState> emit) async {
    bool isNoteCreated = await db.addNotes(notes: event.notes);
    emit(NotesAddedState(isNoteCreated: isNoteCreated));
    add(NotesInitialEvent(user_id: event.notes.user_id));
  }

  FutureOr<void> notesUpdateEvent(
      NotesUpdateEvent event, Emitter<NotesState> emit) async {
    var isNoteUpdated = await db.updateNote(event.notes);
    emit(NotesUpdatedState(isNoteUpdated: isNoteUpdated));
    add(NotesInitialEvent(user_id: event.notes.user_id));
  }

  FutureOr<void> notesDeleteEvent(
      NotesDeleteEvent event, Emitter<NotesState> emit) async {
    var isNoteDelete = await db.deleteNote(event.id);
    emit(NotesDeletedState(isNoteDeleted: isNoteDelete));
    add(NotesInitialEvent(user_id: event.user_id));
  }

  FutureOr<void> notesSearchEvent(
      NotesSearchEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingSate());
    var notes = await db.searchNotes(keyword: event.keyword);
    emit(NotesLoadedSate(notes: notes));
  }
}
