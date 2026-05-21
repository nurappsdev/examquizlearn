import 'dart:convert';

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
  final formKey = GlobalKey<FormState>();

  var isAgree = false.obs;
  var isLoading = false.obs;

  void toggleAgreement(bool? value) {
    isAgree.value = value ?? false;
  }

  void signup() {
    if (formKey.currentState?.validate() ?? false) {
      if (!isAgree.value) {
        Get.snackbar(
          "Error",
          "Please agree with Terms & Privacy Policy",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      Get.toNamed(
        AppRoutes.personalInfo,
        arguments: {
          "fullName": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phoneNumber": phoneController.text.trim(),
          "password": passwordController.text,
          "isTcPpAccepted": isAgree.value,
        },
      );
    }
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
