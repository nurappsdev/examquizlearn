import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/utils/app_constant.dart';

class PersonalInfoController extends GetxController {
  final dateOfBirthController = TextEditingController();
  final employmentController = TextEditingController();
  final universityNameController = TextEditingController();
  final linkedinProfileController = TextEditingController();

  final selectedGender = ''.obs;
  final selectedEducation = ''.obs;
  Map<String, dynamic> signupData = {};

  var isLoading = false.obs;

  final genderOptions = ['Male', 'Female', 'Other'];
  final educationOptions = [
    'High School',
    'Associate',
    'Bachelor',
    'Master',
    'PhD',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map) {
      signupData = Map<String, dynamic>.from(arguments);
    }
  }

  void selectGender(String value) {
    selectedGender.value = value;
  }

  void selectEducation(String value) {
    selectedEducation.value = value;
  }

  Future<void> saveAndContinue(GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (selectedGender.value.isEmpty) {
      ToastMessageHelper.errorMessageShowToster('Gender is required');
      return;
    }

    if (selectedEducation.value.isEmpty) {
      ToastMessageHelper.errorMessageShowToster('Education is required');
      return;
    }

    if (signupData.isEmpty) {
      ToastMessageHelper.errorMessageShowToster(
        'Signup information is missing. Please start registration again.',
      );
      Get.offNamed(AppRoutes.signup);
      return;
    }

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading.value = true;
      final body = {
        "fullName": signupData["fullName"],
        "email": signupData["email"],
        "phoneNumber": signupData["phoneNumber"],
        "password": signupData["password"],
        "isTcPpAccepted": signupData["isTcPpAccepted"] ?? false,
        "dateOfBirth": dateOfBirthController.text.trim(),
        "gender": selectedGender.value,
        "employment": employmentController.text.trim(),
        "education": selectedEducation.value,
        "university": universityNameController.text.trim(),
        "linkedinUrl": linkedinProfileController.text.trim(),
      };

      final response = await ApiClient.postData(
        ApiConstants.signUpEndPoint,
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body is Map ? response.body['data'] : null;
        final accessToken = data is Map ? data['accessToken'] : null;
        final token = data is Map
            ? accessToken ?? data['verificationToken'] ?? data['token']
            : null;

        if (accessToken != null) {
          await PrefsHelper.setString(
            AppConstants.bearerToken,
            accessToken.toString(),
          );
        }
        if (token != null) {
          await PrefsHelper.setString(AppConstants.bearerToken, token);
        }

        ToastMessageHelper.successMessageShowToster(
          response.body is Map && response.body['message'] != null
              ? response.body['message'].toString()
              : 'Account created successfully',
        );
        Get.offAllNamed(AppRoutes.otp, arguments: {'screenType': 'register'});
      } else {
        ToastMessageHelper.errorMessageShowToster(_errorMessage(response.body));
      }
    } finally {
      isLoading.value = false;
    }
  }

  String _errorMessage(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }

    return 'Registration failed. Please try again.';
  }

  @override
  void onClose() {
    dateOfBirthController.dispose();
    employmentController.dispose();
    universityNameController.dispose();
    linkedinProfileController.dispose();
    super.onClose();
  }
}
