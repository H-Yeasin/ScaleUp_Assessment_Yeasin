import 'package:hive/hive.dart';

import '../../domain/entities/note_entity.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends NoteEntity {
  @override
  @HiveField(0)
  // ignore: overridden_fields
  final String id;

  @override
  @HiveField(1)
  // ignore: overridden_fields
  final String title;

  @override
  @HiveField(2)
  // ignore: overridden_fields
  final String content;

  @override
  @HiveField(3)
  // ignore: overridden_fields
  final DateTime createdAt;

  @override
  @HiveField(4)
  // ignore: overridden_fields
  final DateTime updatedAt;

  @override
  @HiveField(5)
  // ignore: overridden_fields
  final bool isSynced;

  @override
  @HiveField(6)
  // ignore: overridden_fields
  final int colorValue;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    required this.colorValue,
  }) : super(
         id: id,
         title: title,
         content: content,
         createdAt: createdAt,
         updatedAt: updatedAt,
         isSynced: isSynced,
         colorValue: colorValue,
       );
  //----Mapping from Entity to Model----
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
      colorValue: entity.colorValue,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
      'colorValue': colorValue,
    };
  }
}
