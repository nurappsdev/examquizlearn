import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/utils/app_constant.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();

  var isLoading = false.obs;
  var secondsRemaining = 83.obs; // 01:23 as in image
  Timer? _timer;
  String screenType = '';

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map && arguments['screenType'] != null) {
      screenType = arguments['screenType'].toString();
    }
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

  Future<void> verify() async {
    final otpCode = otpController.text.trim();
    if (otpCode.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter a 6-digit OTP",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    await verfyEmail(otpCode, screenType: screenType);
  }

  void resendCode() {
    secondsRemaining.value = 83;
    startTimer();
    // Logic to resend OTP
  }

  @override
  void onClose() {
    _timer?.cancel();
    // otpController.dispose();
    super.onClose();
  }

  ///===============Verify Email================<>
  RxBool verfyLoading = false.obs;

  verfyEmail(String otpCode, {String screenType = ''}) async {
    isLoading(true);
    verfyLoading(true);
    String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    var body = {"code": otpCode};

    var response = await ApiClient.postData(
      ApiConstants.verifyEmailEndPoint,
      jsonEncode(body),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (screenType == 'forgot') {
        final resetPasswordToken = _resetPasswordTokenFromResponse(
          response.body,
        );

        if (resetPasswordToken.isNotEmpty) {
          await PrefsHelper.setString(
            AppConstants.resetPasswordToken,
            resetPasswordToken,
          );
        }

        Get.toNamed(
          AppRoutes.resetPassword,
          arguments: {'resetPasswordToken': resetPasswordToken},
        );
      } else {
        Get.offAllNamed(AppRoutes.signin);
      }
    } else if (response.statusCode == 1) {
      ToastMessageHelper.errorMessageShowToster(
        response.statusText ?? 'Server error. Please try later',
      );
    } else {
      ToastMessageHelper.errorMessageShowToster(_errorMessage(response.body));
    }
    isLoading(false);
    verfyLoading(false);
  }

  String _errorMessage(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }

    return 'OTP verification failed. Please try again.';
  }

  String _resetPasswordTokenFromResponse(dynamic body) {
    if (body is! Map) {
      return '';
    }

    final data = body['data'];
    final token =
        body['resetPasswordToken'] ??
        body['passwordResetToken'] ??
        body['token'] ??
        (data is Map
            ? data['resetPasswordToken'] ??
                  data['passwordResetToken'] ??
                  data['token']
            : null);

    if (token == null) {
      return '';
    }

    return token.toString().trim();
  }
}
