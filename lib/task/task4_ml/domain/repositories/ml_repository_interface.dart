import 'dart:io';

import '../entities/food_prediction_entity.dart';

abstract class MLRepositoryInterface {
  Future<void> loadModel();
  Future<FoodPredictionEntity?> classifyImage(File image);
  Future<void> disposeModel();
}
