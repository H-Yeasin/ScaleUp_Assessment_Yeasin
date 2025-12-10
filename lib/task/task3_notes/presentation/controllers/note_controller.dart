import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs offline
import '../../domain/entities/note_entity.dart';
import '../../domain/usecase/add_note_usecase.dart';
import '../../domain/usecase/delete_note_usecase.dart';
import '../../domain/usecase/get_note_usecase.dart';
import '../../domain/usecase/sync_note_usecase.dart';

class NoteController extends GetxController {
  // Use Cases
  final GetNoteUsecase getNotesUseCase;
  final AddNoteUsecase addNoteUseCase;
  final DeleteNoteUsecase deleteNoteUseCase;
  final SyncNoteUsecase syncNotesUseCase;

  NoteController({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.deleteNoteUseCase,
    required this.syncNotesUseCase,
  });

  // State
  var notes = <NoteEntity>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    loadNotes();
    _listenToConnectivity(); // Auto-sync listener
    super.onInit();
  }

  // --- Actions ---

  Future<void> loadNotes() async {
    try {
      isLoading.value = true;
      notes.value = await getNotesUseCase.call();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading notes: $e");
      }
      Get.snackbar("Error", "Could not load notes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote(
    String title,
    String content,
    int selectedColor, // Required Color
  ) async {
    final newNote = NoteEntity(
      id: const Uuid().v4(), // Generate ID immediately
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      colorValue: selectedColor, // <--- CRITICAL FIX: Use the passed color
    );

    // 1. Optimistic Update (Show it in UI immediately)
    notes.add(newNote);

    // 2. Save to DB & Try Sync
    await addNoteUseCase.call(newNote);

    // 3. Refresh list to get updated 'isSynced' status
    loadNotes();
    Get.back(); // Close the "Add Note" page
    Get.snackbar("Success", "Note saved locally!");
  }

  Future<void> updateNote(
    String id,
    String title,
    String content,
    int colorValue,
  ) async {
    final updatedNote = NoteEntity(
      id: id, // KEY: Use the EXISTING ID to overwrite the old note
      title: title,
      content: content,
      createdAt: DateTime.now(), // Keep original date if you prefer, or update
      updatedAt: DateTime.now(),
      isSynced: false, // Needs to sync changes
      colorValue: colorValue,
    );

    // Optimistic Update: Find the index and replace it in the list immediately
    final index = notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      notes[index] = updatedNote;
    }

    // Save to Hive (Hive.put will overwrite because ID is the same)
    await addNoteUseCase.call(updatedNote);

    loadNotes(); // Refresh list to be safe
    Get.back();
    Get.snackbar("Success", "Note updated!");
  }

  Future<void> deleteNote(String id) async {
    await deleteNoteUseCase.call(id);
    loadNotes();
    Get.snackbar('Deleted', "Note deleted successfully");
  }

  Future<void> syncNotes() async {
    await syncNotesUseCase.call();
    loadNotes();
    Get.snackbar(
      "Sync Complete",
      "All notes pushed to server",
      snackPosition: SnackPosition.BOTTOM, // Or SnackPosition.BOTTOM
      snackStyle: SnackStyle.FLOATING,
      maxWidth: Get.width * 0.8,
    );
  }

  // --- Auto-Sync Logic ---
  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      // ignore: unrelated_type_equality_checks
      if (result != ConnectivityResult.none) {
        // Internet is back! Try syncing unsaved notes.
        if (kDebugMode) {
          print("Internet restored. Syncing notes...");
        }
        syncNotesUseCase.call().then((_) => loadNotes());
      }
    });
  }
}
