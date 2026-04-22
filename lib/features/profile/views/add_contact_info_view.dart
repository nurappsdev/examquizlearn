import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/widgets/custom_button.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:examtest/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddContactInfoView extends StatelessWidget {
  const AddContactInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController linkedinController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Contact info',
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
            _buildLabel('Phone no'),
            CustomTextField(
              controller: phoneController,
              hintText: 'Write here..',
              keyboardType: TextInputType.phone,
              filColor: Colors.transparent,
              borderColor: const Color(0xffA1A1A1),
              textColor: Colors.white,
              hinTextColor: Colors.grey.shade600,
              borderRadio: 30,
            ),
            SizedBox(height: 20.h),
            _buildLabel('Email'),
            CustomTextField(
              controller: emailController,
              hintText: 'Write here..',
              keyboardType: TextInputType.emailAddress,
              filColor: Colors.transparent,
              borderColor: const Color(0xffA1A1A1),
              textColor: Colors.white,
              hinTextColor: Colors.grey.shade600,
              borderRadio: 30,
            ),
            SizedBox(height: 20.h),
            _buildLabel('LinkedIn profile link'),
            CustomTextField(
              controller: linkedinController,
              hintText: 'Write here..',
              keyboardType: TextInputType.url,
              filColor: Colors.transparent,
              borderColor: const Color(0xffA1A1A1),
              textColor: Colors.white,
              hinTextColor: Colors.grey.shade600,
              borderRadio: 30,
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: CustomButton(
          title: 'Save',
          onpress: () {
            Get.back();
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
