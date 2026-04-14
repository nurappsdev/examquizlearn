import 'package:get/get.dart';


class DependencyInjection implements Bindings {

  DependencyInjection();

  @override
  void dependencies() {

   // Get.lazyPut(() => ProfileSetupController(), fenix: true);
   // Get.lazyPut(() => AuthController(), fenix: true);
   // Get.lazyPut(() => NotificationController(), fenix: true);
  }
}