import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../task4_ml/presentation/controller/ml_controller.dart'; // Import controller

class FoodClassifierScreen extends StatelessWidget {
  FoodClassifierScreen({super.key});
  // Inject controller
  final MLController controller = Get.put(MLController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Food AI", style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Image Display Area
            Expanded(
              flex: 3,
              child: Obx(() {
                if (controller.imageFile.value == null) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fastfood_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No food selected",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      controller.imageFile.value!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }
              }),
            ),

            SizedBox(height: 20),

            // 2. Prediction Result Card
            Expanded(
              flex: 1,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.prediction.value == null) {
                  return Center(
                    child: Text(
                      "Take a photo to identify food!",
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }

                final p = controller.prediction.value!;
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "It looks like:",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        p.label.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: p.confidence,
                        backgroundColor: Colors.grey[200],
                        color: Colors.green,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Confidence: ${(p.confidence * 100).toStringAsFixed(1)}%",
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            // 3. Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo_library),
                    label: Text("Gallery"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text("Camera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
