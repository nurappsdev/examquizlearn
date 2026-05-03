import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
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





  // HomeController এ add করো


  final _isStartingQuiz = false.obs;
  bool get isStartingQuiz => _isStartingQuiz.value;
  final _questions = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get questions => _questions;

  Future<void> startLearningQuiz(String topicId) async {
    if (topicId.isEmpty) return;

    _isStartingQuiz.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstants.learningQuizStartEndPoint(topicId),
        jsonEncode({}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body != null && response.body['data'] != null) {
          final data = response.body['data'];

          // ✅ Questions save করো
          _questions.value = List<Map<String, dynamic>>.from(data['questions'] ?? []);

          final attemptId = data['attemptId']?.toString() ?? "";

          Get.toNamed(AppRoutes.quiz, arguments: {
            'attemptId': attemptId,
            'topicId': topicId,
            'questions': _questions, // ✅ pass করো
          });
        }
        debugPrint("_questions.value_questions.value${_questions.value}");
      } else {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? "Failed to start learning quiz",
        );
      }
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("An error occurred: $e");
    } finally {
      _isStartingQuiz.value = false;
    }
  }
}
