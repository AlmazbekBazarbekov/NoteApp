import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bloc/notes_bloc.dart';
import 'bloc/notes_event.dart';
import 'core/constants.dart';
import 'data/repositories/notes_repository.dart';
import 'presentation/notes_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NotesRepository(Supabase.instance.client),
      child: BlocProvider(
        create: (context) =>
        NotesBloc(context.read<NotesRepository>())..add(const LoadNotes()),
        child: MaterialApp(
          title: 'Notes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
          home: const NotesListScreen(),
        ),
      ),
    );
  }
}