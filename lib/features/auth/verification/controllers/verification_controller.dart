import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/utils/app_constant.dart';

class VerificationController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  Future<void> forgot() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    await forgotHandle(email: emailController.text.trim());
  }

  ///==================SForgot===========================
  RxBool forgotLoading = false.obs;

  Future<void> forgotHandle({
    required String email,
  }) async {
    isLoading(true);
    forgotLoading(true);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "email": email,
    };

    try {
      final response = await ApiClient.postData(
        ApiConstants.forgotPasswordPoint,
        jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken = _accessTokenFromResponse(response.body);

        if (accessToken.isEmpty) {
          ToastMessageHelper.errorMessageShowToster(
            'OTP sent but access token was missing.',
          );
          return;
        }

        await PrefsHelper.setString(AppConstants.bearerToken, accessToken);
        ToastMessageHelper.successMessageShowToster(
          response.body is Map && response.body["message"] != null
              ? response.body["message"].toString()
              : 'OTP sent successfully',
        );

        Get.toNamed(AppRoutes.otp, arguments: {'screenType': 'forgot'});
      } else if (response.statusCode == 1) {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? 'Server error. Please try later',
        );
      } else {
        ToastMessageHelper.errorMessageShowToster(_errorMessage(response.body));
      }
    } finally {
      isLoading(false);
      forgotLoading(false);
    }
  }

  String _accessTokenFromResponse(dynamic body) {
    if (body is! Map) {
      return '';
    }

    final data = body['data'];
    if (data is! Map) {
      return '';
    }

    final token =
        data['accessToken'] ?? data['verificationToken'] ?? data['token'];
    if (token == null) {
      return '';
    }

    return token.toString().trim();
  }

  String _errorMessage(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }

    return 'Unable to send OTP. Please try again.';
  }

  @override
  void onClose() {
    // emailController.dispose();
    super.onClose();
  }
}
