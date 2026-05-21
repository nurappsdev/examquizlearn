import 'package:get/get.dart';

import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../model/my_subscription_model.dart';

class YourPlanController extends GetxController {
  final subscription = Rxn<MySubscription>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscription();
  }

  Future<void> fetchSubscription() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response =
        await ApiClient.getData(ApiConstants.subscriptionMeEndPoint);
    final statusCode = response.statusCode ?? 0;

    if (statusCode == 404) {
      subscription.value = null;
      isLoading.value = false;
      return;
    }

    if (statusCode < 200 || statusCode >= 300) {
      errorMessage.value = _extractMessage(response.body) ??
          response.statusText ??
          'Failed to load your plan';
      isLoading.value = false;
      return;
    }

    final body = response.body;
    if (body is Map) {
      final data = body['data'];
      if (data is Map) {
        subscription.value =
            MySubscription.fromJson(Map<String, dynamic>.from(data));
      } else {
        subscription.value = null;
      }
    } else {
      subscription.value = null;
    }

    isLoading.value = false;
  }

  String? _extractMessage(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }
    return null;
  }
}
