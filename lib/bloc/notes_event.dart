// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class NotesInitialEvent extends NotesEvent {
  final String user_id;
  NotesInitialEvent({
    required this.user_id,
  });
}

// ignore: must_be_immutable
class NotesAddEvent extends NotesEvent {
  Notes notes;
  NotesAddEvent({
    required this.notes,
  });
}

class NotesUpdateEvent extends NotesEvent {
  final Notes notes;

  NotesUpdateEvent({
    required this.notes,
  });
}

class NotesDeleteEvent extends NotesEvent {
  final int id;
  final String user_id;
  NotesDeleteEvent({
    required this.id,
    required this.user_id,
  });
}

class NotesSearchEvent extends NotesEvent {
  final String keyword;
  NotesSearchEvent({required this.keyword});
}
