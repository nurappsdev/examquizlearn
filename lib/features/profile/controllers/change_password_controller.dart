import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/helpers/prefs_helper.dart';
import '../../../core/utils/app_constant.dart';
import '../../../core/routes/app_routes.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> changePassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      ToastMessageHelper.errorMessageShowToster(
        'New password and confirm password do not match',
      );
      return;
    }

    isLoading.value = true;

    final body = {
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text,
    };

    final response = await ApiClient.postData(
      ApiConstants.changePasswordEndPoint,
      body,
    );

    isLoading.value = false;

    final String? serverMessage = (response.body is Map)
        ? response.body['message'] as String?
        : null;

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster(
        serverMessage ?? 'Password changed successfully',
      );
      
      // Since the server logs out the user from all devices, we should logout locally too
      await PrefsHelper.remove(AppConstants.bearerToken);
      Get.offAllNamed(AppRoutes.signin);
      
      _clearFields();
    } else {
      ToastMessageHelper.errorMessageShowToster(
        serverMessage ?? response.statusText ?? 'Failed to change password',
      );
    }
  }

  void _clearFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
