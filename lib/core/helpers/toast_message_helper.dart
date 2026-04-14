
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ToastMessageHelper{
  static void successMessageShowToster(String message,   {
    int seconds = 3,
  }) {
    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.TOP,
    //   timeInSecForIosWeb: 2,
    //   backgroundColor: Colors.green,
    //   textColor: Colors.white,
    //   fontSize: _getFontSize(16),
    // );


    Get.snackbar(
      "",
      "", // Empty because we will use custom widgets
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: seconds),
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(12),

      titleText: const Text(
        "Success",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),

      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
  static void errorMessageShowToster(
      String message, {
        int seconds = 3,
      }) {
    Get.snackbar(
      "",
      "", // Empty because we will use custom widgets
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: seconds),
      backgroundColor: Colors.red,
      margin: const EdgeInsets.all(12),

      titleText: const Text(
        "Error",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),

      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  static double _getFontSize(double size) {
    try {
      // Try to use ScreenUtil if it's initialized, otherwise fall back to regular size
      return size.h;
    } catch (e) {
      // If ScreenUtil isn't initialized, return the original size
    }
    return size.toDouble();
  }
}