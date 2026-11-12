import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note.dart';

class NotesRepository {
  final SupabaseClient _client;
  NotesRepository(this._client);

  Future<List<Note>> getNotes({String? search}) async {
    var query = _client.from('notes').select();
    final s = (search ?? '').trim().replaceAll(RegExp(r'[,()%]'), ' ');
    if (s.isNotEmpty) {
      query = query.or('title.ilike.%$s%,content.ilike.%$s%');
    }
    final data = await query
        .order('pinned', ascending: false)
        .order('updated_at', ascending: false);
    return data.map<Note>((e) => Note.fromJson(e)).toList();
  }

  Future<void> addNote(String title, String content) async {
    await _client.from('notes').insert({'title': title, 'content': content});
  }

  Future<void> updateNote(
      String id, {
        required String title,
        required String content,
        required bool pinned,
      }) async {
    await _client.from('notes').update({
      'title': title,
      'content': content,
      'pinned': pinned,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteNote(String id) async {
    await _client.from('notes').delete().eq('id', id);
  }
}