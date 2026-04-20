import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';

class SigninController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  void signin() {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading.value = true;
      // Perform sign in logic
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.offAllNamed(AppRoutes.main);
      });
    }
  }

  @override
  void onClose() {
    // Sometimes disposing here causes "used after disposed" error if 
    // accessibility services or pending gestures are still active.
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
