import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasources/ml_local_source.dart';
import '../../data/repositories/ml_repository_impl.dart';
import '../../domain/entities/food_prediction_entity.dart';

class MLController extends GetxController {
  final repository = MLRepositoryImpl(localSource: MLLocalSource());
  final ImagePicker _picker = ImagePicker();

  // State
  var prediction = Rxn<FoodPredictionEntity>();
  var isLoading = true.obs; // Start as TRUE to block interaction
  var imageFile = Rxn<File>();

  // Flag to ensure we don't predict before model is ready
  bool _isModelLoaded = false;

  @override
  void onInit() {
    super.onInit();
    _initModel();
  }

  Future<void> _initModel() async {
    try {
      isLoading.value = true;
      // Wait a tiny bit to ensure the UI is built before hitting the native bridge
      await Future.delayed(Duration(milliseconds: 500));

      await repository.loadModel();
      _isModelLoaded = true;
      if (kDebugMode) {
        print("✅ TFLite Model Loaded Successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load AI model: $e");
    } finally {
      isLoading.value = false; // Unlock the UI
    }
  }

  Future<void> pickImage(ImageSource source) async {
    // 1. Safety Check
    if (!_isModelLoaded) {
      Get.snackbar("Wait", "AI Model is still loading...");
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600, // Optimize: Don't send 4K images to TFLite, it chokes
        maxHeight: 600,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        isLoading.value = true;
        imageFile.value = File(pickedFile.path);

        // 2. Clear previous prediction
        prediction.value = null;

        // 3. Attempt Prediction with Retry Logic
        FoodPredictionEntity? result;

        try {
          result = await repository.classifyImage(imageFile.value!);
        } catch (e) {
          if (e.toString().contains("Interpreter busy")) {
            if (kDebugMode) {
              print("⚠️ Interpreter Busy. Retrying in 1 second...");
            }
            await Future.delayed(Duration(seconds: 1));
            // Retry once
            result = await repository.classifyImage(imageFile.value!);
          } else {
            rethrow; // If it's another error, crash/print it
          }
        }

        prediction.value = result;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Failed to process image: $e");
      }
      Get.snackbar("Error", "Could not analyze image. Try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose nicely
    repository.disposeModel();
    super.onClose();
  }
}
