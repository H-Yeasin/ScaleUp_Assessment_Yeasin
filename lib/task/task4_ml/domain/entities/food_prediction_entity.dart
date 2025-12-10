import 'dart:io';

class FoodPredictionEntity {
  final File image;
  final double confidence;
  final String label;

  FoodPredictionEntity({
    required this.image,
    required this.confidence,
    required this.label,
  });
}
