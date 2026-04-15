import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';

class SigninController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  void signin(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
