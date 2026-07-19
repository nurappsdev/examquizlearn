import 'package:get/get.dart';
import '../../../core/helpers/prefs_helper.dart';
import '../../../core/helpers/subscription_access_helper.dart';
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

    if (token.trim().isEmpty) {
      Get.offAllNamed(AppRoutes.signin);
      return;
    }

    // Re-check access on every app open so an expired trial or
    // subscription forces the user back to the paywall.
    final nextRoute = await SubscriptionAccessHelper.resolveStartRoute();
    Get.offAllNamed(nextRoute);
  }
}
