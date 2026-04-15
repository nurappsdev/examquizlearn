import 'package:get/get.dart';
import '../controllers/carpentry_controller.dart';

class CarpentryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarpentryController>(() => CarpentryController());
  }
}
