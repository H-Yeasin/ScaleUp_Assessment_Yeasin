import 'package:flutter/foundation.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository_interface.dart';
import '../datasources/note_local_source.dart';
import '../datasources/note_remote_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepositoryInterface {
  final NoteLocalSource localSource;
  final NoteRemoteSource remoteSource;

  NoteRepositoryImpl({required this.localSource, required this.remoteSource});

  Future<List<NoteModel>> getNotes() async {
    // ALWAYS return local data for offline speed
    return await localSource.getNotes();
  }

  @override
  Future<void> addNote(NoteEntity noteEntity) async {
    // 1. Convert Entity to Model
    final noteModel = NoteModel.fromEntity(noteEntity);

    // 2. Save to Local Hive DB first (Optimistic UI)
    // We explicitly set synced = false initially
    final localNote = NoteModel(
      id: noteModel.id,
      title: noteModel.title,
      content: noteModel.content,
      createdAt: noteModel.createdAt,
      updatedAt: noteModel.updatedAt,
      colorValue: noteModel.colorValue,
      isSynced: false,
    );
    await localSource.cacheNote(localNote);

    // 3. Try to Sync with API immediately
    try {
      final isSuccess = await remoteSource.createNote(localNote);

      if (isSuccess) {
        // 4. If API success, update Local DB to synced = true
        await localSource.updateNoteSyncStatus(localNote.id, true);
      }
    } catch (e) {
      // 5. If API fails, do nothing. It remains isSynced = false in Hive.
      // The background sync job will pick it up later.
      if (kDebugMode) {
        print("API Sync failed, stored locally: $e");
      }
    }
  }

  Future<void> deleteNote(String id) async {
    await localSource.deleteNote(id);
  }

  @override
  Future<void> syncUnsavedNotes() async {
    // 1. Get all notes
    final allNotes = await localSource.getNotes();

    // 2. Filter only unsaved ones
    final unsavedNotes = allNotes.where((n) => !n.isSynced).toList();

    // 3. Loop and try to push
    for (var note in unsavedNotes) {
      final isSuccess = await remoteSource.createNote(note);
      if (isSuccess) {
        await localSource.updateNoteSyncStatus(note.id, true);
      }
    }
  }

  @override
  Future<void> deleteNoteById(String id) async {
    await localSource.deleteNote(id);
  }

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    final noteModels = await localSource.getNotes();
    return noteModels
        .map(
          (model) => NoteEntity(
            id: model.id,
            title: model.title,
            content: model.content,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt,
            colorValue: model.colorValue,
            isSynced: model.isSynced,
          ),
        )
        .toList();
  }
}
