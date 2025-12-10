import 'package:hive/hive.dart';
import 'package:taskdirectory/task/task3_notes/data/models/note_model.dart';

abstract class NoteLocalSource {
  Future<List<NoteModel>> getNotes();
  Future<void> cacheNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<void> updateNoteSyncStatus(String id, bool isSynced);
}

class NoteLocalSourceImpl implements NoteLocalSource {
  final String boxName = 'notesBox';

  //helper to pen the box safely
  Future<Box<NoteModel>> get _box async {
    if (!Hive.isBoxOpen(boxName)) {
      // ignore: await_only_futures
      return await Hive.box<NoteModel>(boxName);
    } else {
      return await Hive.openBox<NoteModel>(boxName);
    }
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> cacheNote(NoteModel note) async {
    final box = await _box;
    await box.put(note.id, note);
  }

  @override
  Future<void> deleteNote(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> updateNoteSyncStatus(String id, bool isSynced) async {
    final box = await _box;
    final note = box.get(id);
    if (note != null) {
      final updatedNote = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        isSynced: isSynced,
        colorValue: note.colorValue,
      );
      await box.put(id, updatedNote);
    }
  }
}
