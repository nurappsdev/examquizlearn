import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/image_picker_helper.dart';
import '../../../../core/helpers/time_format.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../controllers/profile_controller.dart';
import '../../model/get_user_esponse_model.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final universityNameController = TextEditingController();
  final linkedinController = TextEditingController();

  final selectedGender = ''.obs;
  final selectedEducation = ''.obs;
  final imagePath = ''.obs;
  final avatarUrl = ''.obs;
  DateTime? selectedDate;

  var isLoading = false.obs;

  final genderOptions = ['Male', 'Female', 'Other'];
  final educationOptions = [
    'High School',
    'Associate Degree',
    "Bachelor's Degree",
    "Master's Degree",
    'PhD',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is GetUserModel) {
      final GetUserModel user = Get.arguments;
      nameController.text = user.fullName ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phoneNumber ?? '';
      selectedDate = user.dateOfBirth;
      dateOfBirthController.text = user.dateOfBirth != null
          ? TimeFormatHelper.formatDate(user.dateOfBirth!)
          : '';
      universityNameController.text = user.university ?? '';
      linkedinController.text = user.linkedinUrl ?? '';
      selectedGender.value = user.gender ?? '';
      selectedEducation.value = user.education ?? '';
      avatarUrl.value = user.avatarUrl ?? '';
    }
  }

  void pickImage() async {
    final File? image = await ImagePickerHelper.pickImage(ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  void selectGender(String value) {
    selectedGender.value = value;
  }

  void selectEducation(String value) {
    selectedEducation.value = value;
  }

  void saveChanges(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      Map<String, String> body = {
        'fullName': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'gender': selectedGender.value,
      };

      if (selectedDate != null) {
        body['dateOfBirth'] = selectedDate!.toIso8601String();
      }

      // Handle Image Upload with S3 Pre-signed URL
      if (imagePath.value.isNotEmpty) {
        String fileName = imagePath.value.split('/').last;
        Response preSignedResponse = await ApiClient.getData(
          "${ApiConstants.s3PreSignedUrlEndPoint}?fileName=$fileName&primaryPath=Profile_Images&expiresIn=300",
        );

        if (preSignedResponse.statusCode == 200) {
          final data = preSignedResponse.body['data'];
          String uploadUrl = data['url'];
          String s3Key = data['key'];

          var uploadResponse = await ApiClient.putBinaryData(
            uploadUrl,
            File(imagePath.value),
            headers: data['headers'] != null ? Map<String, String>.from(data['headers']) : null,
          );
          Get.back();
          if (uploadResponse.statusCode == 200 || uploadResponse.statusCode == 204) {
            body['avatarUrl'] = s3Key;
            Get.back();
          } else {
            isLoading.value = false;
            ToastMessageHelper.errorMessageShowToster('Failed to upload image to S3');
            return;
          }
        } else {
          isLoading.value = false;
          ToastMessageHelper.errorMessageShowToster('Failed to get pre-signed URL');
          return;
        }
      }

      Response response = await ApiClient.patch(ApiConstants.profileEndPoint, body);

      if (response.statusCode == 200) {
        Get.find<ProfileController>().getProfile();
        ToastMessageHelper.successMessageShowToster(
            'Profile updated successfully');
        Get.back();
      } else {
        ToastMessageHelper.errorMessageShowToster(
            response.statusText ?? 'Failed to update profile');
      }
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    universityNameController.dispose();
    linkedinController.dispose();
    super.onClose();
  }
}
