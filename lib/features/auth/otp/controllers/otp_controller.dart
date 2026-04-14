import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
  
  var isLoading = false.obs;
  var secondsRemaining = 83.obs; // 01:23 as in image
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  String get timeString {
    int minutes = secondsRemaining.value ~/ 60;
    int seconds = secondsRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} s';
  }

  void verify() {
    if (otpController.text.length == 6) {
      isLoading.value = true;
      // Perform OTP verification logic
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        // Navigate to Reset Password or Home
        Get.offAllNamed(AppRoutes.resetPassword);
      });
    } else {
      Get.snackbar("Error", "Please enter a 6-digit OTP", 
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void resendCode() {
    secondsRemaining.value = 83;
    startTimer();
    // Logic to resend OTP
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
