import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("SplashController initialized");
    navigateToNext();
  }

  void navigateToNext() async {
    print("Starting 3s delay...");
    await Future.delayed(const Duration(seconds: 3));
    print("Navigating to Main...");
    Get.offAllNamed(AppRoutes.signin);
  }
}
