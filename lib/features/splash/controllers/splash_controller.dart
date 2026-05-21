import 'package:get/get.dart';
import '../../../core/helpers/prefs_helper.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_constant.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToNext();
  }

  Future<void> navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await PrefsHelper.getString(AppConstants.bearerToken);

    if (token.trim().isNotEmpty) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.signin);
    }
  }
}
