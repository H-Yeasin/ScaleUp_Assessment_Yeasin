import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taskdirectory/task/task3_notes/domain/usecase/add_note_usecase.dart';
import 'package:taskdirectory/task/task3_notes/domain/usecase/sync_note_usecase.dart';
import '../data/datasources/note_remote_source.dart';
import '../data/repositories/note_repository_impl.dart';
import '../domain/usecase/delete_note_usecase.dart';
import '../domain/usecase/get_note_usecase.dart';
import '../data/datasources/note_local_source.dart';
import 'controllers/note_controller.dart';

class NoteBinding extends Bindings {
  @override
  void dependencies() {
    // 1. External Dependencies
    final client = http.Client();

    // 2. Data Sources
    final localSource = NoteLocalSourceImpl();
    final remoteSource = NoteRemoteSourceImpl(client: client);

    // 3. Repository
    final repository = NoteRepositoryImpl(
      localSource: localSource,
      remoteSource: remoteSource,
    );

    // 4. Use Cases
    final getNotes = GetNoteUsecase(repository);
    final addNote = AddNoteUsecase(repository);
    final deleteNote = DeleteNoteUsecase(repository);
    final syncNotes = SyncNoteUsecase(repository);

    // 5. Controller
    Get.lazyPut(
      () => NoteController(
        getNotesUseCase: getNotes,
        addNoteUseCase: addNote,
        deleteNoteUseCase: deleteNote,
        syncNotesUseCase: syncNotes,
      ),
    );
  }
}
