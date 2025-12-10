import '../repositories/note_repository_interface.dart';

class SyncNoteUsecase {
  final NoteRepositoryInterface repository;
  SyncNoteUsecase(this.repository);
  Future<void> call() async {
    return await repository.syncUnsavedNotes();
  }
}
