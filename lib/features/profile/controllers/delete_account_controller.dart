import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/helpers/prefs_helper.dart';
import '../../../core/routes/app_routes.dart';

class DeleteAccountController extends GetxController {
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> deleteAccount(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final body = {"password": passwordController.text};

    final response = await ApiClient.postData(
      ApiConstants.deleteAccountEndPoint,
      body,
    );

    isLoading.value = false;

    final String? serverMessage = (response.body is Map)
        ? response.body['message'] as String?
        : null;

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster(
        serverMessage ?? 'Account deleted successfully',
      );
      await PrefsHelper.clearAll();
      Get.offAllNamed(AppRoutes.signin);
    } else {
      ToastMessageHelper.errorMessageShowToster(
        serverMessage ?? response.statusText ?? 'Failed to delete account',
      );
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
