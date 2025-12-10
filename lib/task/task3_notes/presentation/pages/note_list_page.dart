import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/note_controller.dart';
import '../note_binding.dart';
import 'add_edit_note_page.dart'; // Ensure this import points to your file

class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize Binding (Injects Controller & UseCases)
    NoteBinding().dependencies();

    // 2. Find Controller
    final controller = Get.find<NoteController>();

    return Scaffold(
      backgroundColor: Colors.grey[100], // Neutral background for the list
      appBar: AppBar(
        title: Text(
          "Notes",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: controller.syncNotes,
            tooltip: "Force Sync",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add New Note (No arguments)
          Get.to(() => const AddEditNotePage());
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        // State: Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // State: Empty
        if (controller.notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.note_add, size: 90, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No notes yet.\nTap + to add one!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // State: List of Notes
        // State: List of Notes
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notes.length,
          itemBuilder: (context, index) {
            final note = controller.notes[index];

            return Dismissible(
              // 1. UNIQUE KEY: Critical for Dismissible to identify items correctly
              key: ValueKey(note.id),

              // 2. SWIPE DIRECTION: Allow swiping both Left and Right
              direction: DismissDirection.horizontal,

              // 3. BACKGROUND UI: What shows behind the card when swiping
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                margin: const EdgeInsets.only(bottom: 12), // Match card margin
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 30),
              ),
              // Secondary background for swiping from right-to-left
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 30),
              ),

              // 4. CONFIRM DIALOG: Asks before deleting
              confirmDismiss: (direction) async {
                return await Get.defaultDialog(
                  title: "Delete Note?",
                  titleStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  middleText: "Are you sure? This action cannot be undone.",
                  middleTextStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                  radius: 15,
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.redAccent,
                  cancelTextColor: Colors.black87,
                  // Return TRUE to confirm dismiss, FALSE to cancel
                  onConfirm: () {
                    Get.back(result: true);
                  },
                );
              },

              // 5. ACTION: What happens after swipe is confirmed
              onDismissed: (direction) {
                // Delete from controller
                controller.deleteNote(note.id);

                // Optional: Show a snackbar feedback
                Get.snackbar(
                  "Deleted",
                  "Note removed successfully",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  duration: const Duration(seconds: 2),
                );
              },

              // THE ACTUAL CARD UI
              child: Card(
                color: Color(note.colorValue),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.to(() => AddEditNotePage(noteToEdit: note));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row (Title + Sync Icon)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                note.title,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (note.isSynced)
                              const Icon(
                                Icons.cloud_done,
                                color: Colors.green,
                                size: 20,
                              )
                            else
                              const Icon(
                                Icons.cloud_upload,
                                color: Colors.grey,
                                size: 20,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note.content,
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
