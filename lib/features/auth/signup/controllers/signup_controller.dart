import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/utils/app_constant.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  var isAgree = false.obs;
  var isLoading = false.obs;

  final selectedGender = ''.obs;
  final genderOptions = ['Male', 'Female', 'Other'];

  void selectGender(String value) {
    selectedGender.value = value;
  }

  void toggleAgreement(bool? value) {
    isAgree.value = value ?? false;
  }

  Future<void> signup(GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Gender is required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!isAgree.value) {
      Get.snackbar(
        "Error",
        "Please agree with Terms & Privacy Policy",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading.value = true;
      final body = {
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phoneNumber": phoneController.text.trim(),
        "password": passwordController.text,
        "isTcPpAccepted": isAgree.value,
        "dateOfBirth": dateOfBirthController.text.trim(),
        "gender": selectedGender.value,
      };

      final response = await ApiClient.postData(
        ApiConstants.signUpEndPoint,
        body,
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
        Get.offAllNamed(
          AppRoutes.otp,
          arguments: {'screenType': 'register', 'registerBody': body},
        );
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
    // nameController.dispose();
    // emailController.dispose();
    // phoneController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }

  RxBool isSelected = true.obs;
  RxBool signUpLoading = false.obs;

  ///===============Sing up ================<>
  handleSignUp({required String name, email, password}) async {
    signUpLoading(true);

    var role = await PrefsHelper.getString(AppConstants.role);

    var body = {
      "name": name,
      "email": "$email",
      "role": role,
      "password": "$password",
      "confirmPassword": "$password",
    };

    var response = await ApiClient.postData(
      ApiConstants.signUpEndPoint,
      body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(
        AppRoutes.verification,
        arguments: {'screenType': 'register'},
      );
      PrefsHelper.setString(
        AppConstants.bearerToken,
        response.body['data']["verificationToken"],
      );
      ToastMessageHelper.successMessageShowToster(
        "Account create successful.\n \nNow you have a one time code your email",
      );
      signUpLoading(false);
    } else {
      signUpLoading(false);
      ToastMessageHelper.errorMessageShowToster("${response.body["message"]}");
    }
  }
}
