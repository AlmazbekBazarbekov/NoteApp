import 'package:equatable/equatable.dart';
import '../data/models/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {
  const LoadNotes();
}

class SearchNotes extends NotesEvent {
  final String query;
  const SearchNotes(this.query);
  @override
  List<Object?> get props => [query];
}

class AddNote extends NotesEvent {
  final String title;
  final String content;
  const AddNote(this.title, this.content);
  @override
  List<Object?> get props => [title, content];
}

class UpdateNote extends NotesEvent {
  final Note note;
  final String title;
  final String content;
  const UpdateNote(this.note, this.title, this.content);
  @override
  List<Object?> get props => [note, title, content];
}

class TogglePin extends NotesEvent {
  final Note note;
  const TogglePin(this.note);
  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String id;
  const DeleteNote(this.id);
  @override
  List<Object?> get props => [id];
}