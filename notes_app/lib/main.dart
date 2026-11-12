import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants.dart';
import 'data/repositories/notes_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  final repo = NotesRepository(Supabase.instance.client);
  debugPrint('Notes from server: ${await repo.getNotes()}');

  runApp(const MaterialApp(
    home: Scaffold(body: Center(child: Text('Notes App'))),
  ));
}