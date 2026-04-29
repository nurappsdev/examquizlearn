class AppConstants {
  ///=======================Prefs Helper data===============================>
  static const String role = "role";
  // static String roleMock = 'roleMock';
  static String bearerToken = 'accessToken';
  static String resetPasswordToken = 'resetPasswordToken';

  static String email = 'email';
  static String isHotDeals = 'true';
  static String userId = 'userId';
  static String userIdTest = '';
  static String businessID = '';
  static String firstname = 'firstName';
  static String lastname = 'lastName';
  static String image = '';
  static String dateOfBirth = '';
  // static String promoCode = '';
  static String stribeUrl = '';

  static RegExp emailValidate = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static bool validatePassword(String value) {
    return value.length >= 6;
  }
}

enum Status { loading, completed, error, internetError }
