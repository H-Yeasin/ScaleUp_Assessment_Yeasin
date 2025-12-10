import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskdirectory/task/task3_notes/data/models/note_model.dart';

abstract class NoteRemoteSource {
  Future<bool> createNote(NoteModel note);
}

class NoteRemoteSourceImpl implements NoteRemoteSource {
  final http.Client client;
  NoteRemoteSourceImpl({required this.client});
  @override
  Future<bool> createNote(NoteModel note) async {
    final response = await client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      body: json.encode(note.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    // Status 201 means "Created" successfully
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
