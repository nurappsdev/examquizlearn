import 'package:get/get.dart';

class EducationalContentController extends GetxController {
  var selectedTab = 0.obs; // 0 for Tutorial, 1 for Text content

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
