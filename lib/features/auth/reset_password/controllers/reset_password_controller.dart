import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void resetPassword(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      if (newPasswordController.text != confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }
      isLoading.value = true;
      // Perform reset password logic
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        // Navigate to login or show success
        Get.snackbar('Success', 'Password reset successfully');
        Get.back();
      });
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
