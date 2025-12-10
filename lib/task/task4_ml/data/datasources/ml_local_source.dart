import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:tflite_v2/tflite_v2.dart';

class MLLocalSource {
  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/ml/food-101.tflite",
        labels: "assets/ml/labels.txt",
        numThreads: 1, // Keep it low for stability
        isAsset: true,
        useGpuDelegate: false,
      );
      if (kDebugMode) {
        print("Model Loaded Status: $res");
      } // Check logs: Should print "success"
    } catch (e) {
      if (kDebugMode) {
        print("Failed to load model: $e");
      }
    }
  }

  Future<List?> predict(File image) async {
    return await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1, // We only need the Top-1
      threshold: 0.1, // Minimum confidence
      imageMean: 127.5, // Standard for many models
      imageStd: 127.5,
    );
  }

  Future<void> close() async {
    await Tflite.close();
  }
}
