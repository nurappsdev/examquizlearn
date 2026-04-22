import 'package:examtest/core/routes/app_routes.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/utils.dart';
import '../controllers/personal_info_controller.dart';

class PersonalInfoViewProfile extends StatelessWidget {
   PersonalInfoViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // final PersonalInfoController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Personal information',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            _buildSection(
              title: 'Short Bio',
              buttonText: 'Add bio',
              onTap: () {
                Get.toNamed(AppRoutes.addBio);
              },
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: 'Contact information',
              buttonText: 'Add contact info',
              onTap: () {
                Get.toNamed(AppRoutes.addContactInfo);
              },
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: 'Education',
              buttonText: 'Add education',
              onTap: () {
                Get.toNamed(AppRoutes.addEducation);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: Colors.white,
          fontsize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: AppColors.greenColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: buttonText,
                  color: AppColors.greenColor,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.add,
                  color: AppColors.greenColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

