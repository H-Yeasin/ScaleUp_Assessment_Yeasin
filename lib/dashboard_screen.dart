import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskdirectory/task/task1_login/login_screen.dart';
import 'package:taskdirectory/task/task2_product/product_list_screen.dart';
import 'package:taskdirectory/task/task3_notes/presentation/pages/note_list_page.dart';
import 'package:taskdirectory/task/task4_ml/food_classifier_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Task 1: Login UI",
      "desc": "Validation & Forms",
      "icon": Icons.lock_outline,
      "color": Colors.blueAccent,
      "page": () => LoginScreen(),
    },
    {
      "title": "Task 2: Products",
      "desc": "API, Search & Filter",
      "icon": Icons.shopping_bag_outlined,
      "color": Colors.orangeAccent,
      "page": () => ProductListScreen(),
    },
    {
      "title": "Task 3: Notes App",
      "desc": "Offline Sync & Hive",
      "icon": Icons.note_alt_outlined,
      "color": Colors.green,
      "page": () => NoteListPage(),
    },
    {
      "title": "Task 4: Food AI",
      "desc": "TFLite Camera (Bonus)",
      "icon": Icons.camera_alt_outlined,
      "color": Colors.purpleAccent,
      "page": () => FoodClassifierScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ScaleUP Assignment",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Candidate: Md. Habib Ullah Yeasin",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, index) => _buildTaskCard(tasks[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () => Get.to(task['page']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            // ignore: deprecated_member_use
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(color: task['color'].withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: task['color'].withOpacity(0.1),
              child: Icon(task['icon'], color: task['color'], size: 28),
            ),
            const SizedBox(height: 15),
            Text(
              task['title'],
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
