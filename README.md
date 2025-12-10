# taskdirectory

A new Flutter project.

## Getting Started

# ScaleUp Ads Assessment - Flutter Developer

This repository contains the solution for the Junior Flutter Developer assessment. The application demonstrates Clean Architecture, State Management (GetX), Offline-First Logic (Hive), and UI responsiveness.

## 📱 Features Implemented

### ✅ Task 1: Login System
- **Pattern:** MVC
- **Features:** - Regex Validation (1 Upper, 1 Number, 6+ Chars).
  - Password Visibility Toggle.
  - Reactive UI using GetX Obx.

### ✅ Task 2: Product Store
- **Pattern:** MVC
- **Features:** - Async API Fetching (FakeStoreAPI).
  - **Search & Filter:** Instant local filtering logic.
  - **Category Dropdown:** Dynamic category extraction.
  - **Bonus:** Pull-to-Refresh & Skeleton Loading.

### ✅ Task 3: Note Taking App (The Core Task)
- **Architecture:** **Clean Architecture** (Data, Domain, Presentation).
- **Offline-First:** - Notes are saved to **Hive** (Local DB) instantly (Optimistic UI).
  - Background Sync attempts to POST to JSONPlaceholder.
  - **Auto-Sync:** Listens to Connectivity changes to retry failed syncs.
- **Bonus Features:**
  - **Color Tags:** Users can select note colors.
  - **Dark Mode:** Auto-syncs with System Theme.

### ⚠️ Task 4: Food Classification (Bonus)
- **Architecture:** Clean Architecture.
- **Status:** **Partially Implemented (Mock Mode)**.
- **Explanation:** - I integrated the `tflite_v2` package and the full `DataSource -> Repository -> Controller` flow.
  - However, due to a known `Interpreter Busy (RuntimeException)` compatibility issue with `tflite_v2` on Android 12+, the app was crashing during prediction.
  - **Solution:** To prevent the app from crashing during review, I implemented a **Mock Mode** in `MLRepositoryImpl`. It simulates the network delay and returns a successful prediction result to demonstrate the UI flow and Architecture.
  - *The real TFLite implementation code is preserved in comments within `ml_repository_impl.dart`.*

## 🛠 Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** GetX
- **Local Database:** Hive
- **Networking:** HTTP
- **Architecture:** Clean Architecture (Task 3 & 4)

## 📂 Folder Structure (Clean Architecture)

```
ScaleUp_Assessment_Yeasin/
├── assets/
│   └── ml/
│       ├── food_101_labels.txt
│       └── food_101_model.tflite 
├── lib/
│   ├── dashboard_screen.dart
│   ├── main.dart
│   └── task/
│       ├── task1_login/
│       │   ├── login_controller.dart
│       │   └── login_screen.dart
│       ├── task2_product/
│       │   ├── product_controller.dart
│       │   ├── product_list_screen.dart
│       │   └── product_model.dart
│       ├── task3_notes/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   ├── note_local_source.dart
│       │   │   │   └── note_remote_source.dart
│       │   │   ├── models/
│       │   │   │   ├── note_model.dart
│       │   │   │   └── note_model.g.dart
│       │   │   └── repositories/
│       │   │       └── note_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── note_entity.dart
│       │   │   ├── repositories/
│       │   │   │   └── note_repository_interface.dart
│       │   │   └── usecase/
│       │   │       ├── add_note_usecase.dart
│       │   │       ├── delete_note_usecase.dart
│       │   │       ├── get_note_usecase.dart
│       │   │       └── sync_note_usecase.dart
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── note_controller.dart
│       │       ├── note_binding.dart
│       │       └── pages/
│       │           ├── add_edit_note_page.dart
│       │           └── note_list_page.dart
│       └── task4_ml/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── ml_local_source.dart
│           │   └── repositories/
│           │       └── ml_repository_impl.dart
│           ├── domain/
│           │   ├── entities/
│           │   │   └── food_prediction_entity.dart
│           │   └── repositories/
│           │       └── ml_repository_interface.dart
│           ├── food_classifier_screen.dart
│           └── presentation/
│               └── controller/
│                   └── ml_controller.dart
├── pubspec.lock
├── pubspec.yaml
├── README.md

```

## 🚀 How to Run
1. **Clone the repo:**
   git clone [https://github.com/Yeasin84/ScaleUp_Assessment_Yeasin.git]
2. **Install dependencies:**
    ```flutter pub get```
3. **Generate Hive Adapters:**
    ```dart run build_runner build --delete-conflicting-outputs```
4. **Run the app:**
    ```flutter run```
