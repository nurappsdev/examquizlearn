import 'package:get/get.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/helpers/time_format.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/utils/app_constant.dart';
import '../model/get_user_esponse_model.dart';
import '../model/quiz_attempt_model.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    getProfile();
    loadQuizAttempts();
    super.onInit();
  }

  // Add any profile-related state here
  final name = 'Refan'.obs;

  // For Profile Information display
  final profileData = <String, String>{
    'Name': '',
    'Email': '',
    'Phone no': '',
    'Date of birth': '',
    'Gender': '',
    'Education': '',
    'University name': '',
    'Linkedin link': '',
  }.obs;

  final rxUserModel = GetUserModel().obs;
  final isLoading = false.obs;

  // Quiz attempt activity
  final quizAttempts = <QuizAttempt>[].obs;
  final isAttemptsLoading = false.obs;
  final isAttemptsLoadingMore = false.obs;
  final attemptsErrorMessage = ''.obs;
  final hasMoreAttempts = true.obs;
  int _attemptsCurrentPage = 1;
  final Set<String> _seenAttemptIds = <String>{};

  getProfile() async {
    isLoading.value = true;
    Response response = await ApiClient.getData(ApiConstants.profileEndPoint);

    if (response.statusCode == 200) {
      rxUserModel.value = GetUserModel.fromJson(response.body['data']);
      final user = rxUserModel.value;

      profileData['Name'] = user.fullName ?? '';
      profileData['Email'] = user.email ?? '';
      profileData['Phone no'] = user.phoneNumber ?? '';
      profileData['Date of birth'] = user.dateOfBirth != null
          ? TimeFormatHelper.formatDate(user.dateOfBirth!)
          : '';
      profileData['Gender'] = user.gender ?? '';
      profileData['Education'] = user.education ?? '';
      profileData['University name'] = user.university ?? '';
      profileData['Linkedin link'] = user.linkedinUrl ?? '';

      name.value = user.fullName ?? 'Refan';
    }
    isLoading.value = false;
  }

  Future<void> loadQuizAttempts() async {
    _attemptsCurrentPage = 1;
    _seenAttemptIds.clear();
    quizAttempts.clear();
    hasMoreAttempts.value = true;
    attemptsErrorMessage.value = '';
    await _fetchAttemptsPage(page: 1, replace: true);
  }

  Future<void> loadMoreQuizAttempts() async {
    if (isAttemptsLoading.value ||
        isAttemptsLoadingMore.value ||
        !hasMoreAttempts.value) {
      return;
    }
    await _fetchAttemptsPage(page: _attemptsCurrentPage + 1, replace: false);
  }

  Future<void> retryQuizAttempts() async {
    await loadQuizAttempts();
  }

  Future<void> refreshProfile() async {
    await Future.wait<dynamic>([
      getProfile(),
      loadQuizAttempts(),
    ]);
  }

  Future<void> _fetchAttemptsPage({
    required int page,
    required bool replace,
  }) async {
    if (replace) {
      isAttemptsLoading.value = true;
      attemptsErrorMessage.value = '';
    } else {
      isAttemptsLoadingMore.value = true;
    }

    final uri =
        '${ApiConstants.userQuizAttemptsEndPoint}?page=$page&limit=${ApiConstants.quizAttemptsPageLimit}';
    final response = await ApiClient.getData(uri);
    final statusCode = response.statusCode ?? 0;

    if (statusCode < 200 || statusCode >= 300) {
      if (replace) {
        attemptsErrorMessage.value = response.statusText?.isNotEmpty == true
            ? response.statusText!
            : 'Failed to load quiz activity';
      }
      isAttemptsLoading.value = false;
      isAttemptsLoadingMore.value = false;
      return;
    }

    final body = response.body;
    final list = _extractAttemptList(body);
    final fetched = list
        .whereType<Map>()
        .map((e) => QuizAttempt.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final newOnes = <QuizAttempt>[];
    for (final attempt in fetched) {
      final key = attempt.effectiveAttemptId;
      if (key.isEmpty) {
        newOnes.add(attempt);
        continue;
      }
      if (_seenAttemptIds.add(key)) {
        newOnes.add(attempt);
      }
    }

    if (replace) {
      quizAttempts.assignAll(newOnes);
    } else {
      quizAttempts.addAll(newOnes);
    }

    _attemptsCurrentPage = page;
    hasMoreAttempts.value = _resolveHasMore(body, fetched.length, page);
    isAttemptsLoading.value = false;
    isAttemptsLoadingMore.value = false;
  }

  List<dynamic> _extractAttemptList(dynamic body) {
    if (body is Map) {
      final data = body['data'];
      if (data is List) return data;
      if (data is Map) {
        for (final key in const ['docs', 'items', 'results', 'data']) {
          final nested = data[key];
          if (nested is List) return nested;
        }
      }
    }
    return const [];
  }

  bool _resolveHasMore(dynamic body, int fetchedCount, int requestedPage) {
    Map<String, dynamic>? pagination;
    if (body is Map) {
      final p = body['pagination'];
      if (p is Map) {
        pagination = Map<String, dynamic>.from(p);
      } else {
        final data = body['data'];
        if (data is Map && data['pagination'] is Map) {
          pagination = Map<String, dynamic>.from(data['pagination']);
        }
      }
    }

    if (pagination != null) {
      final hasNext = pagination['hasNextPage'];
      if (hasNext is bool) return hasNext;
      final nextPage = pagination['nextPage'];
      if (nextPage != null) return true;
      final totalPages = _toInt(pagination['totalPages']) ??
          _toInt(pagination['totalPage']);
      if (totalPages != null) return requestedPage < totalPages;
    }

    return fetchedCount >= ApiConstants.quizAttemptsPageLimit;
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  void logout() async {
    // Implement logout logic
    await PrefsHelper.remove(AppConstants.bearerToken);
    Get.offAllNamed(AppRoutes.signin);
  }
}
