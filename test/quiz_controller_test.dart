import 'package:examtest/features/quiz/controllers/quiz_controller.dart';
import 'package:examtest/features/quiz/model/quiz_question_model.dart'
    as quiz_model;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuizController Test', () {
    late QuizController controller;

    setUp(() {
      controller = QuizController();
      _seedQuestions(controller);
    });

    tearDown(() {
      controller.onClose();
    });

    test('Initial values are correct', () {
      expect(controller.currentStep.value, 1);
      expect(controller.totalSteps.value, 2);
      expect(controller.selectedAnswerIndex.value, -1);
    });

    test('Next step increases currentStep after answer selection', () {
      controller.selectAnswer(1);
      controller.nextStep();

      expect(controller.currentStep.value, 2);
      expect(controller.selectedAnswerIndex.value, -1);
    });

    test('Previous step decreases currentStep and restores answer', () {
      controller.selectAnswer(1);
      controller.nextStep();
      controller.previousStep();

      expect(controller.currentStep.value, 1);
      expect(controller.selectedAnswerIndex.value, 1);
    });

    test('Select answer updates selectedAnswerIndex', () {
      controller.selectAnswer(1);

      expect(controller.selectedAnswerIndex.value, 1);
    });

    test('Result counts use correct option from API model', () {
      controller.selectAnswer(1);
      controller.nextStep();
      controller.selectAnswer(0);

      expect(controller.correctAnswersCount, 1);
      expect(controller.incorrectAnswersCount, 1);
      expect(controller.unattemptedCount, 0);
      expect(controller.scorePercentage, 50);
    });
  });
}

void _seedQuestions(QuizController controller) {
  controller.questions.value = [
    _question(correctIndex: 1),
    _question(correctIndex: 1),
  ];
  controller.totalSteps.value = controller.questions.length;
  controller.currentStep.value = 1;
  controller.selectedAnswerIndex.value = -1;
  controller.userAnswers.value = List.filled(controller.questions.length, -1);
}

quiz_model.TestExamQuizModel _question({required int correctIndex}) {
  return quiz_model.TestExamQuizModel(
    difficultySnapshot: "hard",
    question: quiz_model.Question(
      content: "Question",
      options: List.generate(
        2,
        (index) => quiz_model.Option(
          content: "Option $index",
          isCorrect: index == correctIndex,
          orderIndex: index + 1,
        ),
      ),
    ),
  );
}
