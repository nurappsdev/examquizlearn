import 'package:get/get.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_constant.dart';

class ProfileController extends GetxController {
  // Add any profile-related state here
  final name = 'Refan'.obs;
  
  // For Profile Information display
  final profileData = {
    'Name': 'abc',
    'Email': 'abc@gmail.com',
    'Phone no': '438434873',
    'Date of birth': 'Here...........',
    'Gender': 'Here...........',
    'Education': 'Here...........',
    'University name': 'Here...........',
    'Linkedin link': 'Here...........',
  }.obs;

  void logout() async{
    // Implement logout logic
   await PrefsHelper.remove(AppConstants.bearerToken);
    Get.offAllNamed(AppRoutes.signin);
  }
}
