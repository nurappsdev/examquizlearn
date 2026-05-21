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
  final Map<int, int> _serverSavedAnswers = {};
  bool _resumeMode = false;
  DateTime? _expiresAt;

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    if (Get.currentRoute == AppRoutes.quiz &&
        !isLearningQuiz.value &&
        quizId.value.isNotEmpty &&
        questions.isEmpty) {
      _resumeMode = attemptId.value.isNotEmpty;
      _resumeOrLoadQuiz();
    }
  }

  Future<void> _resumeOrLoadQuiz() async {
    await getQuestions();
    if (attemptId.value.isNotEmpty && questions.isNotEmpty) {
      await _restoreAttemptProgress();
    } else if (questions.isNotEmpty) {
      startTimer();
    }
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

      final argExpiresAt = arguments["expiresAt"];
      if (argExpiresAt is DateTime) {
        _expiresAt = argExpiresAt;
      } else if (argExpiresAt is String && argExpiresAt.isNotEmpty) {
        _expiresAt = DateTime.tryParse(argExpiresAt);
      }

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
                parsedQuestions.add(
                  quiz_model.TestExamQuizModel(
                    id: e['_id']?.toString() ?? e['id']?.toString(),
                    questionId: e['_id']?.toString() ?? e['id']?.toString(),
                    question: quiz_model.Question.fromJson(e),
                  ),
                );
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
          if (!_resumeMode) {
            startTimer();
          }
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

  void startTimer({bool resume = false}) {
    _timer?.cancel();
    if (!resume) {
      remainingSeconds.value = initialSeconds.value;
    }
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
        // debugPrint("test and quiz");
      }
    } else {
      await submitAnswer();
      debugPrint("test and quifgdfgdfdfz");
      if (currentStep.value < totalSteps.value) {
        currentStep.value++;
        selectedAnswerIndex.value = userAnswers[currentStep.value - 1];
        _updateDifficulty();
        _updateCurrentOptions();
        // debugPrint("test and quiz");
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
        options.sort(
          (a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0),
        );

        if (answerIndex < options.length) {
          final selectedOptionId = options[answerIndex].id;
          answers.add({
            "questionId": question.question?.id ?? question.id,
            "selectedOptionIds": [selectedOptionId],
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
      final correctIndex = _correctAnswerIndexForQuestion(
        currentStep.value - 1,
      );
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: const Color(0xffBD0000),
                      size: 28.r,
                    ),
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
    if (quizId.value.isEmpty || isLoading.value) return;

    isLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstants.quizAttemptsEndPoint(quizId.value),
        jsonEncode({}),
      );

      final statusCode = response.statusCode ?? 0;
      final isSuccess = statusCode >= 200 && statusCode < 300;
      final newAttemptId = _extractAttemptId(response.body);
      print("newAttemptId--------------${newAttemptId}");
      if (!isSuccess || newAttemptId.isEmpty) {
        ToastMessageHelper.errorMessageShowToster(
          response.statusText ?? "Failed to start quiz attempt",
        );
        isLoading.value = false;

        return;
      }

      isLoading.value = false;
      Get.offNamed(
        AppRoutes.quiz,
        arguments: _quizRouteArguments(newAttemptId),
      );
    } catch (e) {
      ToastMessageHelper.errorMessageShowToster("An error occurred: $e");
      isLoading.value = false;
    }
  }

  String _extractAttemptId(dynamic body) {
    dynamic decodedBody = body;
    if (body is String && body.isNotEmpty) {
      try {
        decodedBody = jsonDecode(body);
      } catch (_) {
        return body;
      }
    }

    final data = decodedBody is Map
        ? (decodedBody['data'] ?? decodedBody)
        : decodedBody;
    return _attemptIdFromValue(data);
  }

  String _attemptIdFromValue(dynamic value) {
    if (value == null) return "";
    if (value is String) return value;
    if (value is num) return value.toString();

    if (value is List) {
      for (final item in value) {
        final nestedId = _attemptIdFromValue(item);
        if (nestedId.isNotEmpty) return nestedId;
      }
      return "";
    }

    if (value is! Map) return "";

    final directId =
        value['attemptId']?.toString() ??
        value['attempt_id']?.toString() ??
        value['quizAttemptId']?.toString() ??
        value['quiz_attempt_id']?.toString() ??
        value['_id']?.toString() ??
        value['id']?.toString();
    if (directId != null && directId.isNotEmpty) return directId;

    for (final key in const [
      'attempt',
      'quizAttempt',
      'quiz_attempt',
      'result',
      'item',
    ]) {
      final nestedId = _attemptIdFromValue(value[key]);
      if (nestedId.isNotEmpty) return nestedId;
    }

    return "";
  }

  Map<String, dynamic> _quizRouteArguments(String newAttemptId) {
    final currentArguments = Get.arguments;
    final arguments = <String, dynamic>{};
    if (currentArguments is Map) {
      currentArguments.forEach((key, value) {
        arguments[key.toString()] = value;
      });
    }

    arguments['attemptId'] = newAttemptId;
    if (quizId.value.isNotEmpty) {
      arguments['quizId'] = quizId.value;
      arguments['id'] = quizId.value;
    }
    if (topicId.value.isNotEmpty) {
      arguments['topicId'] = topicId.value;
    }
    if (quizTitle.value.isNotEmpty) {
      arguments['title'] = quizTitle.value;
    }

    return arguments;
  }

  Future<void> submitAnswer() async {
    if (attemptId.value.isEmpty ||
        currentQuestion == null ||
        selectedAnswerIndex.value == -1) {
      debugPrint("test and quiz..............");
      debugPrint("attemptId.value isEmpty-------------${attemptId.value}");
      return;
    }

    final questionIndex = currentStep.value - 1;
    if (_serverSavedAnswers[questionIndex] == selectedAnswerIndex.value) {
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
        "selectedOptionIds": [selectedOptionId],
      });

      final response = await ApiClient.postData(
        ApiConstants.submitAnswerEndPoint(attemptId.value),
        body,
      );
      debugPrint("attemptId.value---------${attemptId.value}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        _serverSavedAnswers[questionIndex] = selectedAnswerIndex.value;
        debugPrint(
          "attemptId.value---------${_serverSavedAnswers[questionIndex]}",
        );
      } else {
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

  Future<void> _restoreAttemptProgress() async {
    try {
      final response = await ApiClient.getData(
        ApiConstants.quizAttemptDetailsEndPoint(attemptId.value),
      );
      if (response.statusCode != 200) {
        _applyResumeTiming();
        return;
      }

      final body = response.body;
      final dynamic root = body is Map ? (body['data'] ?? body) : body;
      if (root is! Map) {
        _applyResumeTiming();
        return;
      }

      debugPrint("[QuizResume] attempt details keys: ${root.keys.toList()}");

      final responseExpiresAt = _parseDateField(root['expiresAt']);
      if (responseExpiresAt != null) {
        _expiresAt = responseExpiresAt;
      }
      final responseStartedAt = _parseDateField(root['startedAt']);
      final responseTimeLimit = _parseIntField(
        root['timeLimit'] ?? root['timeLimitSec'] ?? root['durationSec'],
      );

      int? totalDuration = responseTimeLimit;
      if (totalDuration == null &&
          responseStartedAt != null &&
          _expiresAt != null) {
        totalDuration = _expiresAt!.difference(responseStartedAt).inSeconds;
      }
      if (totalDuration != null && totalDuration > 0) {
        initialSeconds.value = totalDuration;
      }

      List<dynamic>? answers = _findAnswersList(root);

      if (answers == null || answers.isEmpty) {
        debugPrint(
          "[QuizResume] no embedded answers found — fetching dedicated answers endpoint",
        );
        final altResponse = await ApiClient.getData(
          ApiConstants.submitAnswerEndPoint(attemptId.value),
        );
        if (altResponse.statusCode == 200) {
          final altBody = altResponse.body;
          if (altBody is List) {
            answers = altBody;
          } else if (altBody is Map) {
            final altRoot = altBody['data'] ?? altBody;
            if (altRoot is List) {
              answers = altRoot;
            } else if (altRoot is Map) {
              answers = _findAnswersList(altRoot);
            }
          }
        }
      }

      int restoredCount = 0;
      if (answers != null && answers.isNotEmpty) {
        for (final entry in answers) {
          if (entry is! Map) continue;
          if (_restoreSingleAnswer(entry)) {
            restoredCount++;
          }
        }
      }

      debugPrint(
        "[QuizResume] restored $restoredCount answer(s) of ${questions.length}",
      );

      int targetIndex = userAnswers.indexWhere((a) => a == -1);

      if (targetIndex == -1 || restoredCount == 0) {
        final hintIndex =
            _parseIntField(
              root['currentQuestionIndex'] ??
                  root['nextQuestionIndex'] ??
                  root['lastQuestionIndex'] ??
                  root['answeredCount'] ??
                  root['questionsAnswered'],
            ) ??
            (root['progress'] is Map
                ? _parseIntField(
                    (root['progress'] as Map)['answeredCount'] ??
                        (root['progress'] as Map)['currentQuestionIndex'],
                  )
                : null);
        if (hintIndex != null &&
            hintIndex >= 0 &&
            hintIndex < questions.length) {
          targetIndex = hintIndex;
        }
      }

      if (targetIndex == -1) {
        targetIndex = questions.length - 1;
      }
      if (targetIndex < 0) targetIndex = 0;

      currentStep.value = targetIndex + 1;
      selectedAnswerIndex.value = userAnswers[currentStep.value - 1];
      _updateDifficulty();
      _updateCurrentOptions();

      _applyResumeTiming();
    } catch (e) {
      debugPrint("Failed to restore attempt progress: $e");
      _applyResumeTiming();
    }
  }

  List<dynamic>? _findAnswersList(Map root) {
    const candidates = [
      'answers',
      'submittedAnswers',
      'responses',
      'userAnswers',
      'attemptAnswers',
      'answeredQuestions',
      'submitted',
      'userResponses',
    ];
    for (final key in candidates) {
      final value = root[key];
      if (value is List) return value;
      if (value is Map) {
        for (final nestedKey in const ['data', 'docs', 'items']) {
          final nested = value[nestedKey];
          if (nested is List) return nested;
        }
      }
    }
    final progress = root['progress'];
    if (progress is Map) {
      return _findAnswersList(progress);
    }
    return null;
  }

  bool _restoreSingleAnswer(Map entry) {
    final questionField =
        entry['questionId'] ??
        entry['question'] ??
        entry['quizQuestionId'] ??
        entry['questionRef'];
    String? questionId;
    if (questionField is Map) {
      questionId =
          questionField['_id']?.toString() ??
          questionField['id']?.toString() ??
          questionField['questionId']?.toString();
    } else if (questionField != null) {
      questionId = questionField.toString();
    }

    final dynamic selected =
        entry['selectedOptionIds'] ??
        entry['selectedOptionId'] ??
        entry['optionIds'] ??
        entry['optionId'] ??
        entry['selectedOptions'] ??
        entry['selectedOption'] ??
        entry['answer'] ??
        entry['answerId'];
    String? optionId;
    if (selected is List && selected.isNotEmpty) {
      final first = selected.first;
      optionId = first is Map
          ? (first['_id']?.toString() ?? first['id']?.toString())
          : first?.toString();
    } else if (selected is Map) {
      optionId = selected['_id']?.toString() ?? selected['id']?.toString();
    } else if (selected != null) {
      optionId = selected.toString();
    }

    if (questionId == null) return false;

    final qIndex = questions.indexWhere(
      (q) =>
          (q.question?.id ?? q.questionId) == questionId || q.id == questionId,
    );
    if (qIndex == -1 || qIndex >= userAnswers.length) return false;

    int oIndex = -1;
    if (optionId != null) {
      final qOptions = List<quiz_model.Option>.from(
        questions[qIndex].question?.options ?? const [],
      );
      qOptions.sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
      oIndex = qOptions.indexWhere((o) => o.id == optionId);
    }

    // Even if the option can't be matched, we still mark this question as
    // answered so the resume position skips past it.
    final markIndex = oIndex == -1 ? 0 : oIndex;
    userAnswers[qIndex] = markIndex;
    if (oIndex != -1) {
      _serverSavedAnswers[qIndex] = oIndex;
    }
    return true;
  }

  void _applyResumeTiming() {
    if (_expiresAt != null) {
      final remaining = _expiresAt!.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        remainingSeconds.value = 0;
        finishQuiz();
        return;
      }
      remainingSeconds.value = remaining;
      startTimer(resume: true);
    } else {
      startTimer();
    }
  }

  DateTime? _parseDateField(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  int? _parseIntField(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
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
