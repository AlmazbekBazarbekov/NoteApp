import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../data/models/note.dart';
import 'note_editor_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  void _openEditor(BuildContext context, {Note? note}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<NotesBloc>(),
          child: NoteEditorScreen(note: note),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  context.read<NotesBloc>().add(SearchNotes(value)),
            ),
          ),
          Expanded(
            child: BlocConsumer<NotesBloc, NotesState>(
              listener: (context, state) {
                if (state is NotesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Something went wrong')),
                  );
                }
              },
              builder: (context, state) {
                if (state is NotesLoading || state is NotesInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NotesError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Failed to load notes'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<NotesBloc>().add(const LoadNotes()),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                final notes = (state as NotesLoaded).notes;
                if (notes.isEmpty) {
                  return const Center(child: Text('No notes yet'));
                }
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, i) {
                    final note = notes[i];
                    return Dismissible(
                      key: ValueKey(note.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) =>
                          context.read<NotesBloc>().add(DeleteNote(note.id)),
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(note.pinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined),
                          onPressed: () =>
                              context.read<NotesBloc>().add(TogglePin(note)),
                        ),
                        onTap: () => _openEditor(context, note: note),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}