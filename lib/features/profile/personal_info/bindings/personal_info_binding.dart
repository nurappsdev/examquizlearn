import 'package:get/get.dart';
import '../controllers/personal_info_controller.dart';

class PersonalInfoProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalInfoProfileController>(
      () => PersonalInfoProfileController(),
    );
  }
}
