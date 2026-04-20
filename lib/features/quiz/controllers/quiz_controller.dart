import 'dart:async';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizController extends GetxController {
  var currentStep = 1.obs;
  var totalSteps = 10.obs;
  var selectedAnswerIndex = (-1).obs;
  var difficulty = "Easy".obs;
  
  // Track user answers
  var userAnswers = <int>[].obs;

  final List<Question> questions = [
    Question(
      question: "What is Real Estate?",
      options: ["Mobile phone business", "Buying clothes", "Property like land and buildings", "Selling food"],
      correctAnswerIndex: 2,
    ),
    Question(
      question: "What is the main purpose of a property title?",
      options: ["Decoration paper", "Proof of ownership", "Tax bill only", "Electricity bill"],
      correctAnswerIndex: 1,
    ),
    Question(
      question: "Which one is Residential Real Estate?",
      options: ["Factory", "Shopping mall", "Apartment", "Warehouse"],
      correctAnswerIndex: 2,
    ),
    Question(
      question: "Why is location important in real estate?",
      options: ["It changes wall color", "It affects property value", "It makes rooms bigger", "It gives free furniture"],
      correctAnswerIndex: 1,
    ),
    Question(
      question: "What is a down payment?",
      options: ["Monthly rent", "First upfront payment when buying property", "Agent salary", "Repair cost"],
      correctAnswerIndex: 1,
    ),
    Question(
      question: "What is ROI in real estate?",
      options: ["Room of Interest", "Return on Investment", "Rate of Income Tax", "Rent on Installment"],
      correctAnswerIndex: 1,
    ),
    Question(
      question: "What is a mortgage?",
      options: ["Home cleaning service", "Property loan", "Painting contract", "Land tax receipt"],
      correctAnswerIndex: 1,
    ),
    Question(
      question: "How do real estate agents usually earn money?",
      options: ["By commission from deals", "By selling cars", "By farming land", "By paying buyers"],
      correctAnswerIndex: 0,
    ),
    Question(
      question: "What should be checked before buying property?",
      options: ["Shoe size", "Legal documents", "Favorite color", "TV brand"],
      correctAnswerIndex: 1,
    ),
    Question(
      question: "Which one is Commercial Real Estate?",
      options: ["Office building", "Bedroom", "Garden chair", "Playground"],
      correctAnswerIndex: 0,
    ),
  ];

  // Timer logic
  var remainingSeconds = (10 * 60).obs; 
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    userAnswers.value = List.filled(questions.length, -1);
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        Get.offNamed(AppRoutes.quizResult);
      }
    });
  }

  String get timerText {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return "Times remaining : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} sec";
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void nextStep() {
    // Save current answer
    userAnswers[currentStep.value - 1] = selectedAnswerIndex.value;

    if (currentStep.value < totalSteps.value) {
      currentStep.value++;
      // Restore previous selection if any
      selectedAnswerIndex.value = userAnswers[currentStep.value - 1];
    } else {
      Get.offNamed(AppRoutes.quizResult);
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      // Save current answer before going back
      userAnswers[currentStep.value - 1] = selectedAnswerIndex.value;
      
      currentStep.value--;
      // Restore previous selection
      selectedAnswerIndex.value = userAnswers[currentStep.value - 1];
    }
  }

  void selectAnswer(int index) {
    selectedAnswerIndex.value = index;
    userAnswers[currentStep.value - 1] = index;
  }

  // Result calculations
  int get correctAnswersCount {
    int count = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  int get incorrectAnswersCount {
    int count = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] != -1 && userAnswers[i] != questions[i].correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  int get unattemptedCount {
    int count = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == -1) {
        count++;
      }
    }
    return count;
  }

  double get scorePercentage {
    return (correctAnswersCount / questions.length) * 100;
  }
}
