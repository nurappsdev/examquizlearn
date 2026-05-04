import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/utils/app_constant.dart';

class SigninController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  Future<void> signIn({
    String? email,
    String? password,
  }) async {
    if (email == null || password == null) {
      if (!(formKey.currentState?.validate() ?? false)) {
        return;
      }

      FocusManager.instance.primaryFocus?.unfocus();
    }

    final loginEmail = (email ?? emailController.text).trim();
    final loginPassword = password ?? passwordController.text;

    isLoading(true);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "email": loginEmail,
      "password": loginPassword,
    };

    try {
      final response = await ApiClient.postData(
        ApiConstants.signInEndPoint,
        body,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken = _accessTokenFromResponse(response.body);

        if (accessToken.isEmpty) {
          ToastMessageHelper.errorMessageShowToster(
            'Login succeeded but token was missing.',
          );
          return;
        }

        await PrefsHelper.setString(
          AppConstants.bearerToken,
          accessToken,
        );
        ToastMessageHelper.successMessageShowToster(
          response.body is Map && response.body['message'] != null
              ? response.body['message'].toString()
              : 'Login successful',
        );

        Get.offAllNamed(AppRoutes.main);
      } else if (response.statusCode == 1) {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? 'Server error. Please try later',
        );
      } else {
        ToastMessageHelper.errorMessageShowToster(_errorMessage(response.body));
      }
    } finally {
      isLoading(false);
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

    final accessToken = data['accessToken'];
    if (accessToken is! String) {
      return '';
    }

    return accessToken.trim();
  }

  String _errorMessage(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }

    return 'Login failed. Please try again.';
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
