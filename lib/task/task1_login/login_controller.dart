import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //keys
  final formKey = GlobalKey<FormState>();

  //observables
  var isPasswordHidden = true.obs;

  //validator
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!GetUtils.isEmail(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    // Logic: At least 6 chars, 1 Uppercase, 1 Number
    RegExp hasUpper = RegExp(r'[A-Z]');
    RegExp hasDigit = RegExp(r'[0-9]');
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (!hasUpper.hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!hasDigit.hasMatch(value)) {
      return "Password must contain at least one number";
    }
    return null;
  }

  //Action
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() {
    // This triggers the 'validator' functions in the UI
    if (formKey.currentState!.validate()) {
      _showSuccess();
    } else {
      Get.snackbar(
        "Invalid Input",
        "Please fix the errors in red!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
      );
    }
  }

  void _showSuccess() {
    Get.snackbar(
      "Success",
      "Login Validation Passed!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
