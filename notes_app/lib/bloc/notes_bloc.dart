import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/notes_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository repository;
  String _query = '';

  NotesBloc(this.repository) : super(const NotesInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(const NotesLoading());
      await _fetch(emit);
    });
    on<SearchNotes>((event, emit) async {
      _query = event.query;
      await _fetch(emit);
    });
    on<AddNote>((event, emit) => _run(
            () => repository.addNote(event.title, event.content), emit));
    on<UpdateNote>((event, emit) => _run(
            () => repository.updateNote(event.note.id,
            title: event.title,
            content: event.content,
            pinned: event.note.pinned),
        emit));
    on<TogglePin>((event, emit) => _run(
            () => repository.updateNote(event.note.id,
            title: event.note.title,
            content: event.note.content,
            pinned: !event.note.pinned),
        emit));
    on<DeleteNote>(
            (event, emit) => _run(() => repository.deleteNote(event.id), emit));
  }

  Future<void> _fetch(Emitter<NotesState> emit) async {
    try {
      final notes = await repository.getNotes(search: _query);
      emit(NotesLoaded(notes, query: _query));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _run(
      Future<void> Function() action, Emitter<NotesState> emit) async {
    try {
      await action();
    } catch (e) {
      emit(NotesError(e.toString()));
      return;
    }
    await _fetch(emit);
  }
}