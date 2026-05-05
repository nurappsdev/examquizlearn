import 'package:get/get.dart';

import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../model/leaderboard_model.dart';

class LeaderboardController extends GetxController {
  final entries = <LeaderboardEntry>[].obs;
  final myStatus = Rxn<LeaderboardEntry>();

  final isInitialLoading = false.obs;
  final isLoadingMore = false.obs;
  final isMyStatusLoading = false.obs;
  final errorMessage = ''.obs;
  final hasMore = true.obs;

  int _currentPage = 1;
  final Set<String> _seenUserIds = <String>{};

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isInitialLoading.value = true;
    errorMessage.value = '';
    _currentPage = 1;
    _seenUserIds.clear();
    entries.clear();
    hasMore.value = true;

    await Future.wait([
      _fetchMyStatus(),
      _fetchGlobalPage(page: 1, replace: true),
    ]);

    isInitialLoading.value = false;
  }

  Future<void> refreshAll() async {
    await loadInitial();
  }

  Future<void> loadMore() async {
    if (isInitialLoading.value ||
        isLoadingMore.value ||
        !hasMore.value) {
      return;
    }
    await _fetchGlobalPage(page: _currentPage + 1, replace: false);
  }

  Future<void> _fetchMyStatus() async {
    isMyStatusLoading.value = true;
    final response =
        await ApiClient.getData(ApiConstants.leaderboardMeEndPoint);

    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300 && response.body is Map) {
      final body = Map<String, dynamic>.from(response.body as Map);
      final data = body['data'];
      Map<String, dynamic>? source;
      if (data is Map) {
        source = Map<String, dynamic>.from(data);
      } else if (body.containsKey('rank') ||
          body.containsKey('totalScore') ||
          body.containsKey('fullName')) {
        source = body;
      }
      if (source != null) {
        myStatus.value = LeaderboardEntry.fromJson(source);
      }
    }
    isMyStatusLoading.value = false;
  }

  Future<void> _fetchGlobalPage({
    required int page,
    required bool replace,
  }) async {
    if (replace) {
      // initial loading flag is managed by caller
    } else {
      isLoadingMore.value = true;
    }

    final uri =
        '${ApiConstants.leaderboardGlobalEndPoint}?page=$page&limit=${ApiConstants.leaderboardPageLimit}';
    final response = await ApiClient.getData(uri);
    final statusCode = response.statusCode ?? 0;

    if (statusCode < 200 || statusCode >= 300) {
      if (replace) {
        errorMessage.value = response.statusText?.isNotEmpty == true
            ? response.statusText!
            : 'Failed to load leaderboard';
      }
      isLoadingMore.value = false;
      return;
    }

    final body = response.body;
    final list = _extractList(body);
    final fetched = list
        .whereType<Map>()
        .map((e) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final newOnes = <LeaderboardEntry>[];
    for (final entry in fetched) {
      final key = entry.userId ?? '${entry.rank}-${entry.email}';
      if (key.isEmpty) {
        newOnes.add(entry);
        continue;
      }
      if (_seenUserIds.add(key)) {
        newOnes.add(entry);
      }
    }

    if (replace) {
      entries.assignAll(newOnes);
    } else {
      entries.addAll(newOnes);
    }

    _currentPage = page;

    final pagination = _extractPagination(body);
    if (pagination != null) {
      if (pagination.hasNextPage != null) {
        hasMore.value = pagination.hasNextPage!;
      } else if (pagination.nextPage != null) {
        hasMore.value = true;
      } else if (pagination.totalPages != null) {
        hasMore.value = page < pagination.totalPages!;
      } else {
        hasMore.value =
            fetched.length >= ApiConstants.leaderboardPageLimit;
      }
    } else {
      hasMore.value = fetched.length >= ApiConstants.leaderboardPageLimit;
    }

    isLoadingMore.value = false;
  }

  List<dynamic> _extractList(dynamic body) {
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

  LeaderboardPagination? _extractPagination(dynamic body) {
    if (body is! Map) return null;
    final pagination = body['pagination'];
    if (pagination is Map) {
      return LeaderboardPagination.fromJson(
        Map<String, dynamic>.from(pagination),
      );
    }
    final data = body['data'];
    if (data is Map && data['pagination'] is Map) {
      return LeaderboardPagination.fromJson(
        Map<String, dynamic>.from(data['pagination']),
      );
    }
    return null;
  }
}
