import 'package:nailed_quiz_app/core/utils/app_colors.dart';
import 'package:nailed_quiz_app/core/widgets/custom_button.dart';
import 'package:nailed_quiz_app/core/widgets/custom_text.dart';
import 'package:nailed_quiz_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final ChangePasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChangePasswordController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Change password',
          color: Colors.white,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              _buildLabel('Current Password'),
              CustomTextField(
                controller: controller.oldPasswordController,
                hintText: 'Enter old password',
                isPassword: true,
                filColor: Colors.transparent,
                borderColor: const Color(0xffA1A1A1),
                textColor: Colors.white,
                hinTextColor: Colors.grey.shade600,
              ),
              SizedBox(height: 20.h),
              _buildLabel('New Password'),
              CustomTextField(
                controller: controller.newPasswordController,
                hintText: 'Enter new password',
                isPassword: true,
                filColor: Colors.transparent,
                borderColor: const Color(0xffA1A1A1),
                textColor: Colors.white,
                hinTextColor: Colors.grey.shade600,
              ),
              SizedBox(height: 20.h),
              _buildLabel('Confirm Password'),
              CustomTextField(
                controller: controller.confirmPasswordController,
                hintText: 'Re-enter new password',
                isPassword: true,
                filColor: Colors.transparent,
                borderColor: const Color(0xffA1A1A1),
                textColor: Colors.white,
                hinTextColor: Colors.grey.shade600,
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.verification),
                  child: CustomText(
                    text: 'Forget Password?',
                    color: Colors.red,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Obx(
          () => CustomButton(
            title: 'Update password',
            loading: controller.isLoading.value,
            onpress: () => controller.changePassword(_formKey),
            color: AppColors.greenColor,
            titlecolor: AppColors.blackColor,
            width: double.infinity,
            height: 56.h,
            bordercolor: AppColors.greenColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label,
        color: Colors.white,
        fontsize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
