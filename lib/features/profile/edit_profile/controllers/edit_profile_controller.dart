import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/image_picker_helper.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final universityNameController = TextEditingController();

  final selectedGender = ''.obs;
  final selectedEducation = ''.obs;
  final imagePath = ''.obs;

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

  void saveChanges(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      // Perform save logic
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.snackbar('Success', 'Profile updated successfully');
        Get.back();
      });
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    universityNameController.dispose();
    super.onClose();
  }
}
