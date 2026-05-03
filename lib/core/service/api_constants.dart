class ApiConstants {
  static const String baseUrl = "https://iftek7500.merinasib.shop/api/v1";
  static const String imageBaseUrl =
      "https://iftek9000.merinasib.shop/naileditquizapp/";
  static const String socketBaseUrl = "https://api.drop-dr.com";

  // static const String baseUrl = "https://health-mamun.sarv.live/api/v1";
  // static const String imageBaseUrl = "https://health-mamun.sarv.live/uploads/";
  // static const String socketBaseUrl = "https://health-mamun.sarv.live";

  /// client key
  ///AIzaSyAxaYzHRBhydkW_TwUGHeRYSUV2iCc_uuk
  static const String mapAPIEndPoint =
      "AIzaSyAxaYzHRBhydkW_TwUGHeRYSUV2iCc_uuk";

  // from maqmun bro
  //static const String mapAPIEndPoint = "AIzaSyBTNR1NWw7LcTsEJTTogqVZ39tgY--eD5U";

  /// amader key
  //static const String mapAPIEndPoint = "AIzaSyA-Iri6x5mzNv45XO3a-Ew3z4nvF4CdYo0";

  static const String signUpEndPoint = "/auth/register";
  static const String signInEndPoint = "/auth/login";
  static const String accountDelete = "/users/delete";
  static const String verifyEmailEndPoint = "/auth/verify-email";
  static const String updateMoreInformationEndPoint =
      "/employee/update-employee-profile";
  static const String forgotPasswordPoint = "/auth/forgot-password";
  static const String resetPasswordEndPoint = "/auth/reset-password";
  static const String notification = "/notification";
  static const int learningTopicsPageLimit = 10;
  static const String learningTopicsEndPoint = "/learning-topics";
  static const String learningMaterialsEndPoint = "/learning-materials";
  static const String quizzesEndPoint = "/quizzes";
  static String quizQuestionsEndPoint(String quizId) =>
      "$quizzesEndPoint/$quizId/questions";
  static String quizAttemptsEndPoint(String quizId) =>
      "$quizzesEndPoint/$quizId/attempts";
  static String submitAnswerEndPoint(String attemptId) =>
      "/quiz-attempts/$attemptId/answers";
  static String submitQuizAttemptEndPoint(String attemptId) =>
      "/quiz-attempts/$attemptId/submit";
  static const String topicProgressEndPoint = "/learning/progress";
  static const String subscriptionPlansEndPoint = "/subscriptions/plans";
  static const String subscriptionCheckoutEndPoint = "/subscriptions/checkout";


  static String startLearningMaterialEndPoint(String materialId) =>
      "/user-learnings/materials/$materialId/start";
  static String completeLearningMaterialEndPoint(String materialId) =>
      "/user-learnings/materials/$materialId/complete";

  static String learningQuizStartEndPoint(String topicId) =>
      '/learning-quizzes/topic/$topicId/start';
  static String learningQuizSubmitEndPoint(String topicId) =>
      '/learning-quizzes/topic/$topicId/submit';
}
