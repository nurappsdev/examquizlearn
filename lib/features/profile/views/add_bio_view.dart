import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/widgets/custom_button.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddBioView extends StatelessWidget {
  const AddBioView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController bioController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Bio',
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
            SizedBox(height: 20.h),
            CustomText(
              text: 'Add short bio about you.',
              color: Colors.white,
              fontsize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: bioController,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write here..',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            CustomButton(
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
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
