import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoController extends GetxController {
  final dateOfBirthController = TextEditingController();
  final universityNameController = TextEditingController();
  final linkedinProfileController = TextEditingController();

  final selectedGender = ''.obs;
  final selectedEmploymentStatus = ''.obs;
  final selectedEducation = ''.obs;

  var isLoading = false.obs;

  final genderOptions = ['Male', 'Female', 'Other'];
  final employmentStatusOptions = [
    'Employed',
    'Unemployed',
    'Student',
    'Retired',
    'Other',
  ];
  final educationOptions = [
    'High School',
    'Associate Degree',
    "Bachelor's Degree",
    "Master's Degree",
    'PhD',
    'Other',
  ];

  void selectGender(String value) {
    selectedGender.value = value;
  }

  void selectEmploymentStatus(String value) {
    selectedEmploymentStatus.value = value;
  }

  void selectEducation(String value) {
    selectedEducation.value = value;
  }

  void saveAndContinue(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      // Perform save logic
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.snackbar('Success', 'Personal information saved');
        // Navigate to next screen
      });
    }
  }

  @override
  void onClose() {
    dateOfBirthController.dispose();
    universityNameController.dispose();
    linkedinProfileController.dispose();
    super.onClose();
  }
}