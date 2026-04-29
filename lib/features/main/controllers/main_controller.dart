import 'package:get/get.dart';

import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';

class MainController extends GetxController {
  final _currentIndex = 0.obs;
  final _isCheckingLearningAccess = true.obs;
  final _learningAccessError = ''.obs;
  final _learningTopics = <Map<String, dynamic>>[].obs;
  final _topicProgress = Rxn<Map<String, dynamic>>();

  bool _isRedirectingToSubscription = false;

  int get currentIndex => _currentIndex.value;
  set currentIndex(int index) => _currentIndex.value = index;

  bool get isCheckingLearningAccess => _isCheckingLearningAccess.value;
  String get learningAccessError => _learningAccessError.value;
  List<Map<String, dynamic>> get learningTopics =>
      _learningTopics.toList(growable: false);
  Map<String, dynamic>? get topicProgress => _topicProgress.value;

  @override
  void onInit() {
    super.onInit();
    checkLearningAccess();
  }

  void changeIndex(int index) {
    _currentIndex.value = index;
  }

  Future<void> checkLearningAccess() async {
    _isRedirectingToSubscription = false;
    _isCheckingLearningAccess.value = true;
    _learningAccessError.value = '';

    try {
      final responses = await Future.wait([
        ApiClient.getData(ApiConstants.learningTopicsEndPoint),
        ApiClient.getData(ApiConstants.topicProgressEndPoint),
      ]);

      final topicsResponse = responses[0];
      final progressResponse = responses[1];

      if (topicsResponse.statusCode == 403 ||
          progressResponse.statusCode == 403) {
        _redirectToSubscriptionList();
        return;
      }

      if (!_isSuccess(topicsResponse) || !_isSuccess(progressResponse)) {
        _learningAccessError.value = _responseMessage(
          !_isSuccess(topicsResponse)
              ? topicsResponse.body
              : progressResponse.body,
          fallback: 'Failed to load learning data. Please try again.',
        );
        return;
      }

      _learningTopics.assignAll(_extractList(topicsResponse.body));
      _topicProgress.value = _extractMap(progressResponse.body);
    } catch (_) {
      _learningAccessError.value =
          'Failed to load learning data. Please try again.';
    } finally {
      if (!_isRedirectingToSubscription) {
        _isCheckingLearningAccess.value = false;
      }
    }
  }

  bool _isSuccess(Response response) {
    final statusCode = response.statusCode ?? 0;
    return statusCode >= 200 && statusCode < 300;
  }

  void _redirectToSubscriptionList() {
    _isRedirectingToSubscription = true;
    ToastMessageHelper.errorMessageShowToster(
      'Please choose a subscription plan to continue learning.',
    );
    Future.microtask(() {
      if (Get.currentRoute != AppRoutes.subscriptionScreen) {
        Get.offNamed(AppRoutes.subscriptionScreen);
      }
    });
  }

  List<Map<String, dynamic>> _extractList(dynamic body) {
    final data = body is Map ? body['data'] : body;
    final possibleList = _findList(data);
    return possibleList
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<dynamic> _findList(dynamic value) {
    if (value is List) {
      return value;
    }

    if (value is Map) {
      for (final key in ['docs', 'items', 'results', 'topics', 'data']) {
        final nested = value[key];
        if (nested is List) {
          return nested;
        }
      }
    }

    return const [];
  }

  Map<String, dynamic> _extractMap(dynamic body) {
    final data = body is Map ? body['data'] : body;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return <String, dynamic>{};
  }

  String _responseMessage(dynamic body, {required String fallback}) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }

    return fallback;
  }
}
