import 'package:taskdirectory/task/task3_notes/domain/entities/note_entity.dart';
import 'package:taskdirectory/task/task3_notes/domain/repositories/note_repository_interface.dart';

class AddNoteUsecase {
  final NoteRepositoryInterface repository;
  AddNoteUsecase(this.repository);

  Future<void> call(NoteEntity note) async {
    return await repository.addNote(note);
  }
}
