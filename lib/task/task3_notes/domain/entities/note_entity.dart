class NoteEntity {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int colorValue; // Stores color as an integer (e.g., 0xFF...)
  final bool isSynced;

  NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.colorValue,
    this.isSynced = false,
  });
}
