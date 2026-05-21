class LeaderboardEntry {
  final int? rank;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final int? totalScore;

  LeaderboardEntry({
    this.rank,
    this.userId,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.totalScore,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: _toInt(json['rank']),
      userId: json['userId']?.toString() ?? json['_id']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      totalScore: _toInt(json['totalScore']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class LeaderboardPagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? limit;
  final int? nextPage;
  final int? prevPage;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  LeaderboardPagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
    this.nextPage,
    this.prevPage,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory LeaderboardPagination.fromJson(Map<String, dynamic> json) {
    return LeaderboardPagination(
      currentPage: _toInt(json['currentPage']) ?? _toInt(json['page']),
      totalPages: _toInt(json['totalPages']) ?? _toInt(json['totalPage']),
      totalItems: _toInt(json['totalItems']) ??
          _toInt(json['total']) ??
          _toInt(json['totalDocs']),
      limit: _toInt(json['limit']),
      nextPage: _toInt(json['nextPage']),
      prevPage: _toInt(json['prevPage']),
      hasNextPage: _toBool(json['hasNextPage']),
      hasPrevPage: _toBool(json['hasPrevPage']),
    );
  }

  bool get hasMore {
    if (hasNextPage != null) return hasNextPage!;
    if (nextPage != null) return true;
    if (currentPage != null && totalPages != null) {
      return currentPage! < totalPages!;
    }
    return false;
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool? _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final v = value.toLowerCase();
      if (v == 'true') return true;
      if (v == 'false') return false;
    }
    return null;
  }
}
