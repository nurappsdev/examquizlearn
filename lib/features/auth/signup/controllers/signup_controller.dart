import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  var isAgree = false.obs;
  var isLoading = false.obs;

  void toggleAgreement(bool? value) {
    isAgree.value = value ?? false;
  }

  void signup(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      if (!isAgree.value) {
        Get.snackbar("Error", "Please agree with Terms & Privacy Policy", 
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      isLoading.value = true;
      // Perform sign up logic
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        // Get.offAllNamed(AppRoutes.home);
      });
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
