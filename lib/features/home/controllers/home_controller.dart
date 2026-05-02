import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main/controllers/main_controller.dart';

class HomeController extends GetxController {
  final _selectedCategoryIndex = 0.obs;
  final TextEditingController topicSearchController = TextEditingController();
  final _topicSearchTerm = ''.obs;

  Worker? _topicSearchWorker;

  int get selectedCategoryIndex => _selectedCategoryIndex.value;
  set selectedCategoryIndex(int index) => _selectedCategoryIndex.value = index;

  String get topicSearchTerm => _topicSearchTerm.value;

  @override
  void onInit() {
    super.onInit();
    _topicSearchWorker = debounce<String>(_topicSearchTerm, (term) {
      if (Get.isRegistered<MainController>()) {
        Get.find<MainController>().searchLearningTopics(term);
      }
    }, time: const Duration(milliseconds: 450));
  }

  @override
  void onClose() {
    _topicSearchWorker?.dispose();
    topicSearchController.dispose();
    super.onClose();
  }

  void changeCategory(int index) {
    _selectedCategoryIndex.value = index;
    if (Get.isRegistered<MainController>()) {
      final type = index == 0 ? 'learning' : 'test';
      Get.find<MainController>().changeLearningTopicType(type);
    }
  }

  void updateTopicSearchTerm(String term) {
    _topicSearchTerm.value = term.trim();
  }

  void clearTopicSearch() {
    topicSearchController.clear();
    updateTopicSearchTerm('');
  }
}
