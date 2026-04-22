import 'package:examtest/core/routes/app_routes.dart';
import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/utils/app_image.dart';
import 'package:examtest/core/widgets/custom_button.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Subscription',
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              decoration: BoxDecoration(
                color: const Color(0xff2A2A2A),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Column(
                children: [
                  Image.asset(
                    AppImages.crownPic,
                    height: 80.h,
                    width: 80.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 30.h),
                  CustomText(
                    text: 'MEMBERSHIP PLAN',
                    color: Colors.grey.shade400,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Active ( Pro )',
                    color: AppColors.greenColor,
                    fontsize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 12.h,
                      backgroundColor: const Color(0xff3E3E3E),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xffB3C6E7),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    text: 'Your next billing date March 03, 2025',
                    color: Colors.grey.shade500,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    title: 'Manage subscription',
                    onpress: () {
                      Get.toNamed(AppRoutes.manageSubscription);
                    },
                    color: AppColors.greenColor,
                    titlecolor: Colors.white,
                    width: double.infinity,
                    height: 56.h,
                    bordercolor: AppColors.greenColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}