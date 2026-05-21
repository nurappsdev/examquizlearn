class QuizAttempt {
  final String? id;
  final String? attemptId;
  final String? quizId;
  final String? quizTitle;
  final String? status;
  final int? score;
  final int? maxScore;
  final int? correctCount;
  final int? incorrectCount;
  final int? totalQuestions;
  final DateTime? startedAt;
  final DateTime? expiresAt;
  final DateTime? submittedAt;

  QuizAttempt({
    this.id,
    this.attemptId,
    this.quizId,
    this.quizTitle,
    this.status,
    this.score,
    this.maxScore,
    this.correctCount,
    this.incorrectCount,
    this.totalQuestions,
    this.startedAt,
    this.expiresAt,
    this.submittedAt,
  });

  bool get isInProgress => (status ?? '').toLowerCase() == 'in_progress';
  bool get isCompleted => (status ?? '').toLowerCase() == 'completed';

  String get effectiveAttemptId => attemptId ?? id ?? '';

  double get progressRatio {
    final max = maxScore ?? 0;
    if (max <= 0) return 0;
    final value = (score ?? 0) / max;
    if (value.isNaN || value.isInfinite) return 0;
    return value.clamp(0.0, 1.0).toDouble();
  }

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    final quizField = json['quizId'];
    String? resolvedQuizId;
    String? resolvedQuizTitle;
    if (quizField is Map) {
      resolvedQuizId =
          quizField['_id']?.toString() ?? quizField['id']?.toString();
      resolvedQuizTitle = quizField['title']?.toString() ??
          quizField['name']?.toString();
    } else {
      resolvedQuizId = quizField?.toString();
    }

    return QuizAttempt(
      id: json['_id']?.toString(),
      attemptId: json['attemptId']?.toString() ?? json['_id']?.toString(),
      quizId: resolvedQuizId,
      quizTitle: resolvedQuizTitle ??
          json['quizTitle']?.toString() ??
          json['title']?.toString(),
      status: json['status']?.toString(),
      score: _toInt(json['score']),
      maxScore: _toInt(json['maxScore']) ?? _toInt(json['totalScore']),
      correctCount:
          _toInt(json['correctCount']) ?? _toInt(json['correctAnswers']),
      incorrectCount:
          _toInt(json['incorrectCount']) ?? _toInt(json['incorrectAnswers']),
      totalQuestions: _toInt(json['totalQuestions']) ??
          _toInt(json['questionsCount']),
      startedAt: _toDate(json['startedAt']),
      expiresAt: _toDate(json['expiresAt']),
      submittedAt: _toDate(json['submittedAt']) ?? _toDate(json['completedAt']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
