import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/helpers/toast_message_helper.dart';
import '../../home/model/home_view_model.dart';
import '../model/learning_material_model.dart';

class TutorialListController extends GetxController {
  var isLoading = false.obs;
  var materials = <LearningMaterialModel>[].obs;
  late HomeViewModel topic;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is HomeViewModel) {
      topic = Get.arguments;
      getMaterials();
    }
  }

  Future<void> getMaterials() async {
    isLoading.value = true;
    try {
      var response = await ApiClient.getData(
        "${ApiConstants.learningMaterialsEndPoint}?topicId=${topic.id}",
      );

      if (response.statusCode == 200) {
        var data = response.body['data'] as List;
        materials.value =
            data.map((e) => LearningMaterialModel.fromJson(e)).toList();
      } else {
        debugPrint("Error fetching materials: ${response.statusText}");
      }
    } catch (e) {
      debugPrint("Exception fetching materials: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> startMaterial(String materialId) async {
    try {
      var response = await ApiClient.postData(
        ApiConstants.startLearningMaterialEndPoint(materialId),
        {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Material started successfully");
        return true;
      } else if (response.statusCode == 403) {
        String message = response.body['message'] ?? "Access denied";
        ToastMessageHelper.errorMessageShowToster(message);
        return false;
      } else {
        debugPrint("Error starting material: ${response.statusText}");
        return false;
      }
    } catch (e) {
      debugPrint("Exception starting material: $e");
      return false;
    }
  }
}
