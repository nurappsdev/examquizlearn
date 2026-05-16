import 'package:nailed_quiz_app/features/home/model/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeViewModel', () {
    test('quizCompletionProgress uses quiz attempts over quiz count', () {
      final topic = HomeViewModel.fromJson({
        'quizCount': 31,
        'quizAttemptCount': 3,
      });

      expect(topic.quizCompletionProgress, closeTo(3 / 31, 0.0001));
    });

    test('quizCompletionProgress is zero when quiz count is missing', () {
      final topic = HomeViewModel.fromJson({'quizAttemptCount': 3});

      expect(topic.quizCompletionProgress, 0);
    });
  });
}
