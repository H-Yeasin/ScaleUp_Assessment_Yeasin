import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/note_controller.dart';
import '../../domain/entities/note_entity.dart';

class AddEditNotePage extends StatefulWidget {
  final NoteEntity? noteToEdit;

  const AddEditNotePage({super.key, this.noteToEdit});

  @override
  // ignore: library_private_types_in_public_api
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final NoteController controller = Get.find<NoteController>();

  late TextEditingController titleController;
  late TextEditingController contentController;

  final List<Color> colors = [
    Colors.white,
    Colors.red.shade50,
    Colors.orange.shade50,
    Colors.amber.shade50,
    Colors.green.shade50,
    Colors.lightBlue.shade50,
    Colors.indigo.shade50,
    Colors.purple.shade50,
    Colors.pink.shade50,
    Colors.grey.shade200,
    Colors.brown.shade50,
  ];

  late int selectedColor;

  @override
  void initState() {
    super.initState();
    // Initialize Logic
    titleController = TextEditingController(
      text: widget.noteToEdit?.title ?? "",
    );
    contentController = TextEditingController(
      text: widget.noteToEdit?.content ?? "",
    );
    selectedColor = widget.noteToEdit?.colorValue ?? colors[0].value;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. UX: Use AnimatedContainer for smooth color transitions
    return Scaffold(
      backgroundColor: Colors.white, // Base layer
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: Color(selectedColor),
        child: SafeArea(
          child: Column(
            children: [
              // --- Custom App Bar ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Save Button (Pill Shape for Prominence)
                    ElevatedButton.icon(
                      onPressed: _saveNote,
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(
                        "Save",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Editor Area ---
              // 2. UX: Use Expanded + SingleChildScrollView so the whole page scrolls
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Title Field
                      TextField(
                        controller: titleController,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Title",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black38,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Metadata (Optional: Date or simple divider)
                      Row(
                        children: [
                          Text(
                            DateTime.now().toString().split(
                              ' ',
                            )[0], // Shows "YYYY-MM-DD"
                            style: GoogleFonts.poppins(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 12,
                            color: Colors.black26,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${contentController.text.length} characters", // Simple dynamic counter
                            style: GoogleFonts.poppins(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Content Field
                      TextField(
                        controller: contentController,
                        onChanged: (_) => setState(() {}), // Updates char count
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          height: 1.6, // Better readability line-height
                          color: Colors.black87,
                        ),
                        maxLines: null, // Grows infinitely
                        decoration: InputDecoration(
                          hintText: "Start typing your note here...",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black38,
                            fontSize: 17,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      // Extra space at bottom to avoid keyboard covering text
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // --- Color Toolbar ---
              // 3. UI: A modern floating toolbar at the bottom
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6), // Glassmorphism feel
                  border: Border(
                    top: BorderSide(color: Colors.black.withOpacity(0.05)),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final colorInt = colors[index].value;
                    final isSelected = selectedColor == colorInt;

                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = colorInt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        width: isSelected ? 46 : 36, // Grow animation
                        height: isSelected ? 46 : 36,
                        decoration: BoxDecoration(
                          color: colors[index],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black87 : Colors.black12,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.black87,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final int currentColor = selectedColor;

    if (title.isEmpty && content.isEmpty) {
      Get.snackbar(
        "Empty Note",
        "Please add a title or content",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (widget.noteToEdit != null) {
      controller.updateNote(
        widget.noteToEdit!.id,
        title,
        content,
        currentColor,
      );
    } else {
      controller.addNote(title, content, currentColor);
    }
  }
}
