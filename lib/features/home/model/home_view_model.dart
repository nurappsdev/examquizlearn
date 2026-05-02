class HomeViewModel {
  final String? id;
  final bool? isActive;
  final String? status;
  final String? createdBy;
  final dynamic updatedBy;
  final dynamic deletedAt;
  final String? categoryId;
  final String? title;
  final String? slug;
  final String? description;
  final int? orderIndex;
  final int? v;
  final String? iconUrl;
  final int? questionCount;
  final int? quizTemplateCount;
  final int? quizCount;
  final int? quizAttemptCount;
  final int? userProgressCount;
  final int? completedCount;
  final int? startedCount;
  final double progress;

  const HomeViewModel({
    this.id,
    this.isActive,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.categoryId,
    this.title,
    this.slug,
    this.description,
    this.orderIndex,
    this.v,
    this.iconUrl,
    this.questionCount,
    this.quizTemplateCount,
    this.quizCount,
    this.quizAttemptCount,
    this.userProgressCount,
    this.completedCount,
    this.startedCount,
    this.progress = 0,
  });

  factory HomeViewModel.fromJson(Map<String, dynamic> json) {
    final completedCount = _intValue(json["completedCount"]);
    final userProgressCount = _intValue(json["userProgressCount"]);

    return HomeViewModel(
      id: _stringValue(json["_id"] ?? json["id"]),
      isActive: _boolValue(json["isActive"]),
      status: _stringValue(json["status"]),
      createdBy: _stringValue(json["createdBy"]),
      updatedBy: json["updatedBy"],
      deletedAt: json["deletedAt"],
      categoryId: _stringValue(json["categoryId"]),
      title: _stringValue(json["title"] ?? json["name"]),
      slug: _stringValue(json["slug"]),
      description: _stringValue(json["description"] ?? json["subtitle"]),
      orderIndex: _intValue(json["orderIndex"]),
      v: _intValue(json["__v"]),
      iconUrl: _stringValue(
        json["iconUrl"] ?? json["imageUrl"] ?? json["image"],
      ),
      questionCount: _intValue(json["questionCount"]),
      quizTemplateCount: _intValue(json["quizTemplateCount"]),
      quizCount: _intValue(json["quizCount"]),
      quizAttemptCount: _intValue(json["quizAttemptCount"]),
      userProgressCount: userProgressCount,
      completedCount: completedCount,
      startedCount: _intValue(json["startedCount"]),
      progress: _progressValue(
        json["progressPct"] ?? json["progress"] ?? json["completionPercentage"],
        completedCount: completedCount,
        totalCount: userProgressCount,
      ),
    );
  }

  String get displayTitle {
    final value = title?.trim() ?? '';
    return value.isEmpty ? 'Untitled topic' : value;
  }

  String get displayDescription {
    final value = description?.trim() ?? '';
    return value.isEmpty ? 'Learning materials and quizzes.' : value;
  }

  String get displayIconUrl => iconUrl?.trim() ?? '';

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isActive": isActive,
    "status": status,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deletedAt": deletedAt,
    "categoryId": categoryId,
    "title": title,
    "slug": slug,
    "description": description,
    "orderIndex": orderIndex,
    "__v": v,
    "iconUrl": iconUrl,
    "questionCount": questionCount,
    "quizTemplateCount": quizTemplateCount,
    "quizCount": quizCount,
    "quizAttemptCount": quizAttemptCount,
    "userProgressCount": userProgressCount,
    "completedCount": completedCount,
    "startedCount": startedCount,
    "progress": progress,
  };

  static String? _stringValue(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static bool? _boolValue(dynamic value) {
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

  static int? _intValue(dynamic value) {
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

  static double _progressValue(
    dynamic value, {
    int? completedCount,
    int? totalCount,
  }) {
    final parsed = _doubleValue(value);
    if (parsed != null) {
      final normalized = parsed > 1 ? parsed / 100 : parsed;
      return normalized.clamp(0.0, 1.0).toDouble();
    }

    if (completedCount != null && totalCount != null && totalCount > 0) {
      return (completedCount / totalCount).clamp(0.0, 1.0).toDouble();
    }

    return 0;
  }

  static double? _doubleValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}

typedef Welcome = HomeViewModel;
