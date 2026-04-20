import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:examtest/features/quiz/controllers/quiz_controller.dart';

void main() {
  group('QuizController Test', () {
    late QuizController controller;

    setUp(() {
      controller = QuizController();
    });

    test('Initial values are correct', () {
      expect(controller.currentStep.value, 1);
      expect(controller.totalSteps.value, 50);
      expect(controller.selectedAnswerIndex.value, -1);
    });

    test('Next step increases currentStep', () {
      controller.nextStep();
      expect(controller.currentStep.value, 2);
      expect(controller.selectedAnswerIndex.value, -1);
    });

    test('Previous step decreases currentStep', () {
      controller.nextStep(); // to 2
      controller.previousStep(); // back to 1
      expect(controller.currentStep.value, 1);
    });

    test('Select answer updates selectedAnswerIndex', () {
      controller.selectAnswer(2);
      expect(controller.selectedAnswerIndex.value, 2);
    });
  });
}
