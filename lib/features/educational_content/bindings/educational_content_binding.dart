import 'package:get/get.dart';
import '../controllers/educational_content_controller.dart';


class EducationalContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EducationalContentController>(() => EducationalContentController());
  }
}
