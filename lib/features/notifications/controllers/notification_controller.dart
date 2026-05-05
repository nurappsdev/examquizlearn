import 'package:get/get.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../model/notification_model.dart';
import '../../../core/routes/app_routes.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications({int page = 1}) async {
    if (page == 1) {
      isLoading.value = true;
    }

    final response = await ApiClient.getData("${ApiConstants.notification}?page=$page&limit=10");

    if (response.statusCode == 200) {
      final List<dynamic> data = response.body['data'];
      final List<NotificationModel> fetchedNotifications = data.map((e) => NotificationModel.fromJson(e)).toList();

      if (page == 1) {
        notifications.assignAll(fetchedNotifications);
      } else {
        notifications.addAll(fetchedNotifications);
      }

      final pagination = response.body['pagination'];
      if (pagination != null) {
        currentPage.value = pagination['currentPage'] ?? 1;
        totalPages.value = pagination['totalPages'] ?? 1;
      }
    }
    
    isLoading.value = false;
  }

  void handleNotificationClick(NotificationModel notification) {
    final metadata = notification.metadata;
    if (metadata == null) return;

    if (metadata.screen == "SubscriptionScreen") {
      Get.toNamed(AppRoutes.subscriptionScreen);
    } else if (metadata.relatedType == "subscription") {
       Get.toNamed(AppRoutes.subscriptionScreen);
    }
    // Add more routing logic here based on metadata.screen or deepLink
  }
}
