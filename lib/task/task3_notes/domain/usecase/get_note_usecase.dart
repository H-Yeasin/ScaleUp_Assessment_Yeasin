import 'package:taskdirectory/task/task3_notes/domain/repositories/note_repository_interface.dart';

import '../entities/note_entity.dart';

class GetNoteUsecase {
  final NoteRepositoryInterface repository;
  GetNoteUsecase(this.repository);
  Future<List<NoteEntity>> call() async {
    return await repository.getAllNotes();
  }
}
