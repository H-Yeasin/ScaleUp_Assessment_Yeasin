import '../repositories/note_repository_interface.dart';

class DeleteNoteUsecase {
  final NoteRepositoryInterface repository;
  DeleteNoteUsecase(this.repository);
  Future<void> call(String id) async {
    return await repository.deleteNoteById(id);
  }
}
