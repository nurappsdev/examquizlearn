import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../home/model/home_view_model.dart';

class EducationalContentController extends GetxController {
  var selectedTab = 0.obs; // 0 for Tutorial, 1 for Text content
  var isLoading = false.obs;
  var topics = <HomeViewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTopics();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  Future<void> getTopics() async {
    isLoading.value = true;
    try {
      String type = selectedTab.value == 0 ? "learning" : "text"; // Assuming type can be learning or text
      // Based on user prompt, for both it might be 'learning' or the endpoint handles it.
      // User prompt said: {{baseUrl}}/learning-topics?limit=10&page=1&type=learning
      // I will use type=learning for now as requested.
      
      var response = await ApiClient.getData(
        "${ApiConstants.learningTopicsEndPoint}?limit=10&page=1&type=learning",
      );

      if (response.statusCode == 200) {
        var data = response.body['data'] as List;
        topics.value = data.map((e) => HomeViewModel.fromJson(e)).toList();
      } else {
        debugPrint("Error fetching topics: ${response.statusText}");
      }
    } catch (e) {
      debugPrint("Exception fetching topics: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
