import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/helpers/toast_message_helper.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../model/quiz_question_model.dart' as quiz_model;

class QuizController extends GetxController {
  final currentStep = 1.obs;
  final totalSteps = 0.obs;
  final selectedAnswerIndex = (-1).obs;
  final difficulty = "Easy".obs;
  final quizId = "".obs;
  final topicId = "".obs;
  final quizTitle = "Quiz".obs;
  final isLoading = false.obs;
  final isSubmittingAnswer = false.obs;
  final isSubmittingQuiz = false.obs;
  final errorMessage = "".obs;
  final questions = <quiz_model.TestExamQuizModel>[].obs;
  final attemptId = "".obs;

  final isLearningQuiz = false.obs;
  final learningQuizResult = <String, dynamic>{}.obs;

  final userAnswers = <int>[].obs;
  final currentOptionsList = <quiz_model.Option>[].obs;

  final remainingSeconds = (10 * 60).obs;
  final initialSeconds = (10 * 60).obs;
  Timer? _timer;
  bool _hasOpenedResult = false;

  @override
  void onInit() {
    super.onInit();
    _readArguments();
  }

  void _readArguments() {
    final arguments = Get.arguments;
    if (arguments is Map) {
      topicId.value =
          arguments["topicId"]?.toString() ?? arguments["id"]?.toString() ?? "";
      quizId.value =
          arguments["quizId"]?.toString() ?? arguments["id"]?.toString() ?? "";
      quizTitle.value =
          arguments["title"]?.toString() ??
          arguments["topicName"]?.toString() ??
          "Quiz";
      attemptId.value = arguments["attemptId"]?.toString() ?? "";

      if (arguments.containsKey("questions")) {
        isLearningQuiz.value = true;
        final dynamic questionList = arguments["questions"];
        
        if (questionList is List) {
          final List<quiz_model.TestExamQuizModel> parsedQuestions = [];
          for (var e in questionList) {
            if (e is Map<String, dynamic>) {
              if (e.containsKey('question')) {
                // Wrapped format (like exam quiz)
                parsedQuestions.add(quiz_model.TestExamQuizModel.fromJson(e));
              } else {
                // Raw question format
                parsedQuestions.add(quiz_model.TestExamQuizModel(
                  id: e['_id']?.toString() ?? e['id']?.toString(),
                  questionId: e['_id']?.toString() ?? e['id']?.toString(),
                  question: quiz_model.Question.fromJson(e),
                ));
              }
            }
          }
          questions.assignAll(parsedQuestions);
        }
        
        totalSteps.value = questions.length;
        currentStep.value = questions.isEmpty ? 0 : 1;
        selectedAnswerIndex.value = -1;
        userAnswers.assignAll(List.filled(questions.length, -1));
        _updateDifficulty();
        _updateCurrentOptions();
        
        if (questions.isNotEmpty) {
          startTimer();
        }
      }

      final parsedTimeLimit = int.tryParse(
        arguments["timeLimitSec"]?.toString() ?? "",
      );
      if (parsedTimeLimit != null && parsedTimeLimit > 0) {
        initialSeconds.value = parsedTimeLimit;
        remainingSeconds.value = parsedTimeLimit;
      }
    } else if (arguments != null) {
      topicId.value = arguments.toString();
      quizId.value = arguments.toString();
    }
  }

  Future<void> getQuestions() async {
    isLoading.value = true;
    errorMessage.value = "";
    _timer?.cancel();

    try {
      if (quizId.value.isEmpty) {
        errorMessage.value =
            "Quiz id missing. Please start the quiz from the quiz list.";
        return;
      }

      final uri = Uri(
        path: ApiConstants.quizQuestionsEndPoint(quizId.value),
        queryParameters: {"page": "1", "limit": "10"},
      ).toString();

      final response = await ApiClient.getData(uri);

      if (response.statusCode == 200) {
        final responseModel = quiz_model.TestExamQuizResponseModel.fromJson(
          response.body,
        );
        questions.assignAll(responseModel.data ?? []);
        totalSteps.value = questions.length;
        currentStep.value = questions.isEmpty ? 0 : 1;
        selectedAnswerIndex.value = -1;
        userAnswers.assignAll(List.filled(questions.length, -1));
        _updateDifficulty();
        _updateCurrentOptions();

        if (questions.isNotEmpty) {
          startTimer();
        } else {
          errorMessage.value = "No questions found for this quiz.";
        }
      } else {
        errorMessage.value = response.statusText ?? "Failed to load questions";
        ToastMessageHelper.errorMessageShowToster(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      ToastMessageHelper.errorMessageShowToster(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    _timer?.cancel();
    remainingSeconds.value = initialSeconds.value;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        finishQuiz();
      }
    });
  }

  int get currentCorrectAnswerIndex =>
      _correctAnswerIndexForQuestion(currentStep.value - 1);

  String get timerText {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return "Times remaining : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} sec";
  }

  String get timeSpentText {
    final spentSeconds = initialSeconds.value - remainingSeconds.value;
    final safeSpentSeconds = spentSeconds < 0 ? 0 : spentSeconds;
    final minutes = safeSpentSeconds ~/ 60;
    final seconds = safeSpentSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} min";
  }

  quiz_model.TestExamQuizModel? get currentQuestion {
    if (questions.isEmpty || currentStep.value < 1) {
      return null;
    }

    final index = currentStep.value - 1;
    if (index < 0 || index >= questions.length) {
      return null;
    }

    return questions[index];
  }

  List<quiz_model.Option> get currentOptions {
    final options = List<quiz_model.Option>.from(
      currentQuestion?.question?.options ?? const [],
    );
    options.sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
    return options;
  }

  void _updateCurrentOptions() {
    final options = List<quiz_model.Option>.from(
      currentQuestion?.question?.options ?? const [],
    );
    options.sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
    currentOptionsList.assignAll(options);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> nextStep() async {
    if (selectedAnswerIndex.value == -1 || questions.isEmpty) {
      return;
    }

    _saveCurrentAnswer();
    
    if (isLearningQuiz.value) {
       if (currentStep.value < totalSteps.value) {
          currentStep.value++;
          selectedAnswerIndex.value = userAnswers[currentStep.value - 1];
          _updateDifficulty();
          _updateCurrentOptions();
        } else {
          await submitLearningQuiz();
        }
    } else {
      await submitAnswer();

      if (currentStep.value < totalSteps.value) {
        currentStep.value++;
        selectedAnswerIndex.value = userAnswers[currentStep.value - 1];
        _updateDifficulty();
        _updateCurrentOptions();
      } else {
        await finishQuiz();
      }
    }
  }

  Future<void> submitLearningQuiz() async {
    if (topicId.value.isEmpty || questions.isEmpty) return;

    _timer?.cancel(); // Stop timer immediately on submission
    List<Map<String, dynamic>> answers = [];
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final answerIndex = userAnswers[i];
      if (answerIndex != -1) {
        final options = List<quiz_model.Option>.from(
          question.question?.options ?? const [],
        );
        options.sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
        
        if (answerIndex < options.length) {
          final selectedOptionId = options[answerIndex].id;
          answers.add({
            "questionId": question.question?.id ?? question.id,
            "selectedOptionIds": [selectedOptionId]
          });
        }
      }
    }

    isSubmittingQuiz.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstants.learningQuizSubmitEndPoint(topicId.value),
        jsonEncode({"answers": answers}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body['data'] != null) {
          learningQuizResult.value = response.body['data'];
          _hasOpenedResult = true;
          Get.toNamed(AppRoutes.quizResult);
        }
      } else {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? "Failed to submit learning quiz",
        );
      }
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("An error occurred: $e");
    } finally {
      isSubmittingQuiz.value = false;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      _saveCurrentAnswer();
      currentStep.value--;
      selectedAnswerIndex.value = userAnswers[currentStep.value - 1];
      _updateDifficulty();
      _updateCurrentOptions();
    }
  }

  void selectAnswer(int index) {
    selectedAnswerIndex.value = index;
    _saveCurrentAnswer();

    if (isLearningQuiz.value && index != -1) {
      final correctIndex = _correctAnswerIndexForQuestion(currentStep.value - 1);
      if (index != correctIndex) {
        _showExplanationDialog();
      }
    }
  }

  void _showExplanationDialog() {
    final question = currentQuestion?.question;
    if (question == null) return;

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xff1A1A1A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: const Color(0xffBD0000), size: 28.r),
                    SizedBox(width: 12.w),
                    const CustomText(
                      text: "Incorrect Answer",
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                if (question.rationale != null &&
                    question.rationale!.isNotEmpty) ...[
                  const CustomText(
                    text: "Rationale:",
                    fontsize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff17BE57),
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: question.rationale!,
                    fontsize: 13,
                    color: const Color(0xffD7D4D4),
                    textAlign: TextAlign.start,
                    maxline: 10,
                  ),
                  SizedBox(height: 20.h),
                ],
                if (question.trapExplanation != null &&
                    question.trapExplanation!.isNotEmpty) ...[
                  const CustomText(
                    text: "Trap Explanation:",
                    fontsize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFFC107),
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: question.trapExplanation!,
                    fontsize: 13,
                    color: const Color(0xffD7D4D4),
                    textAlign: TextAlign.start,
                    maxline: 10,
                  ),
                  SizedBox(height: 20.h),
                ],
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    title: "Got it",
                    onpress: () => Get.back(),
                    color: const Color(0xff17BE57),
                    titlecolor: Colors.white,
                    height: 45.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> finishQuiz() async {
    if (_hasOpenedResult) {
      return;
    }

    _timer?.cancel();
    if (selectedAnswerIndex.value != -1 && questions.isNotEmpty) {
      _saveCurrentAnswer();
    }
    
    _hasOpenedResult = true;
    Get.toNamed(AppRoutes.quizResult);
  }

  Future<void> submitQuiz() async {
    if (isLearningQuiz.value) {
      Get.offAllNamed(AppRoutes.main);
      return;
    }

    if (attemptId.value.isEmpty) {
      Get.offAllNamed(AppRoutes.main);
      return;
    }

    isSubmittingQuiz.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstants.submitQuizAttemptEndPoint(attemptId.value),
        jsonEncode({}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? "Failed to finalize quiz submission",
        );
      }
    } catch (e) {
      debugPrint("Error finalizing quiz submission: $e");
    } finally {
      isSubmittingQuiz.value = false;
    }
  }

  void retryQuiz() {
    _hasOpenedResult = false;
    currentStep.value = questions.isEmpty ? 0 : 1;
    selectedAnswerIndex.value = -1;
    userAnswers.assignAll(List.filled(questions.length, -1));
    _updateDifficulty();
    _updateCurrentOptions();
    if (questions.isNotEmpty) {
      startTimer();
    }
  }

  void _saveCurrentAnswer() {
    final index = currentStep.value - 1;
    if (index >= 0 && index < userAnswers.length) {
      userAnswers[index] = selectedAnswerIndex.value;
    }
  }

  void _updateDifficulty() {
    final value =
        currentQuestion?.difficultySnapshot ??
        currentQuestion?.question?.difficulty ??
        "Easy";
    difficulty.value = value.capitalizeFirst ?? value;
  }

  Future<void> startQuizAttempt() async {
    if (quizId.value.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstants.quizAttemptsEndPoint(quizId.value),
        jsonEncode({}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Save attemptId from response
        if (response.body != null && response.body['data'] != null) {
          attemptId.value = response.body['data']['attemptId']?.toString() ?? "";
        }
        
        getQuestions();
        Get.toNamed(AppRoutes.quiz, arguments: Get.arguments);
      } else {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? "Failed to start quiz attempt",
        );
      }
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAnswer() async {
    if (attemptId.value.isEmpty || currentQuestion == null || selectedAnswerIndex.value == -1) {
      return;
    }

    final questionIdValue = currentQuestion?.question?.id;
    final options = currentOptions;
    final selectedOptionId = options[selectedAnswerIndex.value].id;

    if (questionIdValue == null || selectedOptionId == null) return;

    isSubmittingAnswer.value = true;
    try {
      final body = jsonEncode({
        "questionId": questionIdValue,
        "selectedOptionIds": [selectedOptionId]
      });

      final response = await ApiClient.postData(
        ApiConstants.submitAnswerEndPoint(attemptId.value),
        body,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? "Failed to submit answer",
        );
      }
    } catch (e) {
      debugPrint("Error submitting answer: $e");
    } finally {
      isSubmittingAnswer.value = false;
    }
  }

  int _correctAnswerIndexForQuestion(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= questions.length) {
      return -1;
    }

    final options = List<quiz_model.Option>.from(
      questions[questionIndex].question?.options ?? const [],
    );
    options.sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
    return options.indexWhere((option) => option.isCorrect == true);
  }

  int get correctAnswersCount {
    int count = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < userAnswers.length &&
          userAnswers[i] == _correctAnswerIndexForQuestion(i)) {
        count++;
      }
    }
    return count;
  }

  int get incorrectAnswersCount {
    int count = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < userAnswers.length &&
          userAnswers[i] != -1 &&
          userAnswers[i] != _correctAnswerIndexForQuestion(i)) {
        count++;
      }
    }
    return count;
  }

  int get unattemptedCount {
    int count = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == -1) {
        count++;
      }
    }
    return count;
  }

  double get scorePercentage {
    if (isLearningQuiz.value && learningQuizResult.isNotEmpty) {
      return (learningQuizResult['score'] ?? 0).toDouble();
    }
    if (questions.isEmpty) {
      return 0;
    }
    return (correctAnswersCount / questions.length) * 100;
  }

  bool get isPassed {
    if (isLearningQuiz.value && learningQuizResult.isNotEmpty) {
      return learningQuizResult['passed'] ?? false;
    }
    return scorePercentage >= 70;
  }

  String get accuracyText => "${scorePercentage.toStringAsFixed(0)}%";
}
