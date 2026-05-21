import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/utils/app_constant.dart';

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

  Future<void> resetPassword(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      if (newPasswordController.text != confirmPasswordController.text) {
        ToastMessageHelper.errorMessageShowToster('Passwords do not match');
        return;
      }

      FocusManager.instance.primaryFocus?.unfocus();
      isLoading.value = true;
      final resetPasswordToken = await _resetPasswordToken();

      if (resetPasswordToken.isEmpty) {
        isLoading.value = false;
        ToastMessageHelper.errorMessageShowToster(
          'Reset password token is missing. Please verify your OTP again.',
        );
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final body = {
        "resetPasswordToken": resetPasswordToken,
        "newPassword": newPasswordController.text,
      };

      try {
        final response = await ApiClient.postData(
          ApiConstants.resetPasswordEndPoint,
          jsonEncode(body),
          headers: headers,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await PrefsHelper.remove(AppConstants.resetPasswordToken);
          ToastMessageHelper.successMessageShowToster(
            response.body is Map && response.body['message'] != null
                ? response.body['message'].toString()
                : 'Password reset successfully',
          );
          Get.offAllNamed(AppRoutes.signin);
        } else if (response.statusCode == 1) {
          ToastMessageHelper.errorMessageShowToster(
            response.statusText ?? 'Server error. Please try later',
          );
        } else {
          ToastMessageHelper.errorMessageShowToster(
            _errorMessage(response.body),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<String> _resetPasswordToken() async {
    final arguments = Get.arguments;
    if (arguments is Map) {
      final argumentToken =
          arguments['resetPasswordToken'] ?? arguments['token'];
      if (argumentToken != null && argumentToken.toString().trim().isNotEmpty) {
        return argumentToken.toString().trim();
      }
    }

    return PrefsHelper.getString(AppConstants.resetPasswordToken);
  }

  String _errorMessage(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }

    return 'Password reset failed. Please try again.';
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
