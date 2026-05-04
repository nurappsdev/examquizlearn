import 'package:get/get.dart';

import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../home/model/home_view_model.dart';

class MainController extends GetxController {
  final _currentIndex = 0.obs;
  final _isCheckingLearningAccess = true.obs;
  final _learningAccessError = ''.obs;
  final _learningTopics = <HomeViewModel>[].obs;
  final _topicProgress = Rxn<Map<String, dynamic>>();
  final _isRefreshingLearningTopics = false.obs;
  final _isLoadingMoreLearningTopics = false.obs;
  final _hasMoreLearningTopics = true.obs;
  final _learningTopicSearchTerm = ''.obs;
  final _learningTopicType = 'learning'.obs;

  int _learningTopicsCurrentPage = 1;
  int _learningTopicsRequestId = 0;
  bool _isRedirectingToSubscription = false;

  int get currentIndex => _currentIndex.value;
  set currentIndex(int index) => _currentIndex.value = index;

  bool get isCheckingLearningAccess => _isCheckingLearningAccess.value;
  String get learningAccessError => _learningAccessError.value;
  List<HomeViewModel> get learningTopics =>
      _learningTopics.toList(growable: false);
  Map<String, dynamic>? get topicProgress => _topicProgress.value;
  bool get isRefreshingLearningTopics => _isRefreshingLearningTopics.value;
  bool get isLoadingMoreLearningTopics => _isLoadingMoreLearningTopics.value;
  bool get hasMoreLearningTopics => _hasMoreLearningTopics.value;
  String get learningTopicSearchTerm => _learningTopicSearchTerm.value;
  String get learningTopicType => _learningTopicType.value;

  @override
  void onInit() {
    super.onInit();
    checkLearningAccess();
  }

  void changeIndex(int index) {
    _currentIndex.value = index;
  }

  Future<void> checkLearningAccess() async {
    final requestId = ++_learningTopicsRequestId;
    final requestTopicType = _learningTopicType.value;

    _isRedirectingToSubscription = false;
    _isCheckingLearningAccess.value = true;
    _learningAccessError.value = '';

    try {
      final responses = await Future.wait([
        ApiClient.getData(_learningTopicsUri(page: 1)),
        ApiClient.getData(ApiConstants.topicProgressEndPoint),
      ]);

      final topicsResponse = responses[0];
      final progressResponse = responses[1];

      if (topicsResponse.statusCode == 403 ||
          progressResponse.statusCode == 403) {
        if (requestId != _learningTopicsRequestId ||
            requestTopicType != _learningTopicType.value) {
          return;
        }

        _redirectToSubscriptionList();
        return;
      }

      if (!_isSuccess(topicsResponse) || !_isSuccess(progressResponse)) {
        if (requestId != _learningTopicsRequestId ||
            requestTopicType != _learningTopicType.value) {
          return;
        }
        _learningAccessError.value = _responseMessage(
          !_isSuccess(topicsResponse)
              ? topicsResponse.body
              : progressResponse.body,
          fallback: 'Failed to load learning data. Please try again.',
        );
        return;
      }

      final topics = _extractList(topicsResponse.body);
      if (requestId != _learningTopicsRequestId ||
          requestTopicType != _learningTopicType.value) {
        return;
      }
      _learningTopics.assignAll(topics);
      _learningTopicsCurrentPage = 1;
      _updateLearningTopicsPagination(topicsResponse.body, topics, 1);
      _topicProgress.value = _extractMap(progressResponse.body);
    } catch (_) {
      if (requestId != _learningTopicsRequestId ||
          requestTopicType != _learningTopicType.value) {
        return;
      }
      _learningAccessError.value =
          'Failed to load learning data. Please try again.';
    } finally {
      if (!_isRedirectingToSubscription) {
        _isCheckingLearningAccess.value = false;
      }
    }
  }

  Future<void> searchLearningTopics(String term) async {
    final normalizedTerm = term.trim();
    if (normalizedTerm == _learningTopicSearchTerm.value &&
        !_isRefreshingLearningTopics.value) {
      return;
    }

    _learningTopicSearchTerm.value = normalizedTerm;
    await _fetchLearningTopics(page: 1, replace: true);
  }

  Future<void> changeLearningTopicType(String type) async {
    final normalizedType = type.trim().toLowerCase();
    if (normalizedType.isEmpty || normalizedType == _learningTopicType.value) {
      return;
    }

    _learningTopicType.value = normalizedType;
    _learningTopics.clear();
    _learningTopicsCurrentPage = 1;
    _hasMoreLearningTopics.value = true;
    await _fetchLearningTopics(page: 1, replace: true);
  }

  Future<void> loadNextLearningTopicsPage() async {
    if (_isCheckingLearningAccess.value ||
        _isRefreshingLearningTopics.value ||
        _isLoadingMoreLearningTopics.value ||
        !_hasMoreLearningTopics.value) {
      return;
    }

    await _fetchLearningTopics(
      page: _learningTopicsCurrentPage + 1,
      replace: false,
    );
  }

  Future<void> refreshLearningTopics() async {
    await _fetchLearningTopics(page: 1, replace: true);
  }

  Future<void> _fetchLearningTopics({
    required int page,
    required bool replace,
  }) async {
    final requestId = ++_learningTopicsRequestId;
    final requestSearchTerm = _learningTopicSearchTerm.value;
    final requestTopicType = _learningTopicType.value;

    if (replace) {
      _isRefreshingLearningTopics.value = true;
      _isLoadingMoreLearningTopics.value = false;
      _hasMoreLearningTopics.value = true;
    } else {
      _isLoadingMoreLearningTopics.value = true;
    }

    try {
      final response = await ApiClient.getData(_learningTopicsUri(page: page));

      if (response.statusCode == 403) {
        _redirectToSubscriptionList();
        return;
      }

      if (!_isSuccess(response)) {
        if (requestId != _learningTopicsRequestId ||
            requestSearchTerm != _learningTopicSearchTerm.value ||
            requestTopicType != _learningTopicType.value) {
          return;
        }
        ToastMessageHelper.errorMessageShowToster(
          _responseMessage(
            response.body,
            fallback: 'Failed to load topics. Please try again.',
          ),
        );
        return;
      }

      final topics = _extractList(response.body);
      if (requestId != _learningTopicsRequestId ||
          requestSearchTerm != _learningTopicSearchTerm.value ||
          requestTopicType != _learningTopicType.value) {
        return;
      }

      if (replace) {
        _learningTopics.assignAll(topics);
      } else {
        _learningTopics.addAll(topics);
      }

      _learningTopicsCurrentPage = page;
      _updateLearningTopicsPagination(response.body, topics, page);
    } catch (_) {
      if (requestId != _learningTopicsRequestId ||
          requestSearchTerm != _learningTopicSearchTerm.value ||
          requestTopicType != _learningTopicType.value) {
        return;
      }
      ToastMessageHelper.errorMessageShowToster(
        'Failed to load topics. Please try again.',
      );
    } finally {
      if (requestId == _learningTopicsRequestId) {
        if (replace) {
          _isRefreshingLearningTopics.value = false;
        } else {
          _isLoadingMoreLearningTopics.value = false;
        }
      }
    }
  }

  String _learningTopicsUri({required int page}) {
    final topicType = _learningTopicType.value;
    final queryParameters = <String, String>{
      'page': page.toString(),
      'limit': ApiConstants.learningTopicsPageLimit.toString(),
      'type': topicType,
      if (topicType == 'learning' && _learningTopicSearchTerm.value.isNotEmpty)
        'term': _learningTopicSearchTerm.value,
    };

    return Uri(
      path: ApiConstants.learningTopicsEndPoint,
      queryParameters: queryParameters,
    ).toString();
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

  List<HomeViewModel> _extractList(dynamic body) {
    final data = body is Map ? body['data'] : body;
    final possibleList = _findList(data);
    return possibleList
        .whereType<Map>()
        .map((item) => HomeViewModel.fromJson(Map<String, dynamic>.from(item)))
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

  void _updateLearningTopicsPagination(
    dynamic body,
    List<HomeViewModel> newTopics,
    int requestedPage,
  ) {
    final meta = _findPaginationMap(body);
    final hasNextPage = _boolValue(meta, 'hasNextPage');
    if (hasNextPage != null) {
      _hasMoreLearningTopics.value = hasNextPage;
      return;
    }

    final nextPage = _intValue(meta, 'nextPage');
    if (nextPage != null) {
      _hasMoreLearningTopics.value = nextPage > requestedPage;
      return;
    }

    final totalPages =
        _intValue(meta, 'totalPages') ??
        _intValue(meta, 'totalPage') ??
        _intValue(meta, 'pages');
    if (totalPages != null) {
      _hasMoreLearningTopics.value = requestedPage < totalPages;
      return;
    }

    final totalItems =
        _intValue(meta, 'totalDocs') ??
        _intValue(meta, 'totalResults') ??
        _intValue(meta, 'totalItems') ??
        _intValue(meta, 'total');
    if (totalItems != null) {
      _hasMoreLearningTopics.value = _learningTopics.length < totalItems;
      return;
    }

    _hasMoreLearningTopics.value =
        newTopics.length >= ApiConstants.learningTopicsPageLimit;
  }

  Map<String, dynamic> _findPaginationMap(dynamic body) {
    final data = body is Map ? body['data'] : body;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (body is Map) {
      return Map<String, dynamic>.from(body);
    }

    return <String, dynamic>{};
  }

  bool? _boolValue(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }

    return null;
  }

  int? _intValue(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }

    return null;
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
