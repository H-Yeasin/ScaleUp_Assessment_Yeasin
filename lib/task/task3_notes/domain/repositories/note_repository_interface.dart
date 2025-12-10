import '../entities/note_entity.dart';

abstract class NoteRepositoryInterface {
  Future<List<NoteEntity>> getAllNotes();
  Future<void> addNote(NoteEntity note);
  Future<void> deleteNoteById(String id);
  Future<void> syncUnsavedNotes();
}
