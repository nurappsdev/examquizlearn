import 'package:get/get.dart';
import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../model/test_exam_carpentry_model.dart';

class CarpentryController extends GetxController {
  final topicId = "".obs;
  final topicName = "Carpentry".obs;
  final quizzes = <TestExamCarpentryModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  // Pagination
  final currentPage = 1.obs;
  final totalItems = 0.obs;
  final totalPages = 1.obs;
  final itemsPerPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      topicId.value = (Get.arguments as Map)["topicId"]?.toString() ?? "";
      topicName.value = (Get.arguments as Map)["topicName"]?.toString() ?? "Carpentry";
    } else if (Get.arguments != null) {
      topicId.value = Get.arguments.toString();
    }
    getQuizzes();
  }

  Future<void> getQuizzes({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      currentPage.value = 1;
      quizzes.clear();
    }

    try {
      final queryParameters = <String, String>{
        "status": "published",
        "page": page.toString(),
        "limit": itemsPerPage.value.toString(),
        if (topicId.value.isNotEmpty) "topicId": topicId.value,
      };

      final uri = Uri(
        path: ApiConstants.quizzesEndPoint,
        queryParameters: queryParameters,
      ).toString();

      final response = await ApiClient.getData(uri);

      if (response.statusCode == 200) {
        final responseModel = TestExamCarpentryResponseModel.fromJson(response.body);
        
        if (responseModel.data != null) {
          if (isLoadMore) {
            quizzes.addAll(responseModel.data!);
          } else {
            quizzes.assignAll(responseModel.data!);
          }
        }

        if (responseModel.pagination != null) {
          currentPage.value = responseModel.pagination!.currentPage ?? page;
          totalItems.value = responseModel.pagination!.totalItems ?? 0;
          totalPages.value = responseModel.pagination!.totalPages ?? 1;
          hasMore.value = currentPage.value < totalPages.value;
        } else {
          hasMore.value = false;
        }
      } else {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? "Failed to load quizzes",
        );
      }
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("An error occurred: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && hasMore.value) {
      getQuizzes(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  Future<void> refreshQuizzes() async {
    await getQuizzes();
  }
}
