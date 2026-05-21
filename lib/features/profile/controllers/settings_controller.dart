import 'package:get/get.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_constant.dart';
import '../../../core/helpers/prefs_helper.dart';

class SettingsController extends GetxController {
  final content = "".obs;
  final isLoading = false.obs;

  Future<void> fetchSettingsContent(String endpoint) async {
    isLoading.value = true;
    content.value = "";
    
    try {
      final response = await ApiClient.getData(endpoint);
      if (response.statusCode == 200) {
        content.value = response.body['data']['content'] ?? "";
      } else {
        ToastMessageHelper.errorMessageShowToster("Failed to load content");
      }
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("An error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> deleteAccount() async {
  //   isLoading.value = true;
  //   try {
  //     final response = await ApiClient.deleteData(ApiConstants.accountDelete, {});
  //     if (response.statusCode == 200) {
  //       ToastMessageHelper.successMessageShowToster("Account deleted successfully");
  //       await PrefsHelper.remove(AppConstants.bearerToken);
  //       Get.offAllNamed(AppRoutes.signin);
  //     } else {
  //       ToastMessageHelper.errorMessageShowToster("Failed to delete account");
  //     }
  //   } catch (e) {
  //     ToastMessageHelper.errorMessageShowToster("An error occurred");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
