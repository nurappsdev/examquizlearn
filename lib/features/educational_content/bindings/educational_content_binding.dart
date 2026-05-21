import 'package:get/get.dart';
import '../controllers/educational_content_controller.dart';
import '../controllers/tutorial_list_controller.dart';
import '../controllers/video_play_controller.dart';


class EducationalContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EducationalContentController>(() => EducationalContentController());
    Get.lazyPut<TutorialListController>(() => TutorialListController());
    Get.lazyPut<VideoPlayController>(() => VideoPlayController());
  }
}
