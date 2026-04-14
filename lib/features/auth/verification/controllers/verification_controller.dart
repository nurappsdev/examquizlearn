import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class VerificationController extends GetxController {
  final emailController = TextEditingController();
  
  var isLoading = false.obs;

  void sendOTP(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      // Perform send OTP logic
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.toNamed(AppRoutes.otp);
      });
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
