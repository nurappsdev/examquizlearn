import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/widgets/custom_button.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:examtest/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController oldPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            _buildLabel('Current Password'),
            CustomTextField(
              controller: oldPassController,
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
              controller: newPassController,
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
              controller: confirmPassController,
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
                onTap: () {
                  // Handle forget password
                },
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: CustomButton(
          title: 'Update password',
          onpress: () {
            // Handle update password logic
          },
          color: AppColors.greenColor,
          titlecolor: Colors.white,
          width: double.infinity,
          height: 56.h,
          bordercolor: AppColors.greenColor,
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
