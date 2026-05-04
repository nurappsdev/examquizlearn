import 'package:get/get.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/helpers/time_format.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/utils/app_constant.dart';
import '../model/get_user_esponse_model.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  // Add any profile-related state here
  final name = 'Refan'.obs;

  // For Profile Information display
  final profileData = <String, String>{
    'Name': '',
    'Email': '',
    'Phone no': '',
    'Date of birth': '',
    'Gender': '',
    'Education': '',
    'University name': '',
    'Linkedin link': '',
  }.obs;

  final rxUserModel = GetUserModel().obs;
  final isLoading = false.obs;

  getProfile() async {
    isLoading.value = true;
    Response response = await ApiClient.getData(ApiConstants.profileEndPoint);

    if (response.statusCode == 200) {
      rxUserModel.value = GetUserModel.fromJson(response.body['data']);
      final user = rxUserModel.value;

      profileData['Name'] = user.fullName ?? '';
      profileData['Email'] = user.email ?? '';
      profileData['Phone no'] = user.phoneNumber ?? '';
      profileData['Date of birth'] = user.dateOfBirth != null
          ? TimeFormatHelper.formatDate(user.dateOfBirth!)
          : '';
      profileData['Gender'] = user.gender ?? '';
      profileData['Education'] = user.education ?? '';
      profileData['University name'] = user.university ?? '';
      profileData['Linkedin link'] = user.linkedinUrl ?? '';

      name.value = user.fullName ?? 'Refan';
    }
    isLoading.value = false;
  }

  void logout() async {
    // Implement logout logic
    await PrefsHelper.remove(AppConstants.bearerToken);
    Get.offAllNamed(AppRoutes.signin);
  }
}
