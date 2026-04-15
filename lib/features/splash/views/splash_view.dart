import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_image.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.navigateToNext();
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 200.h,),
              Image.asset(
                AppImages.logo,
                width: 250.w,
              ),
              SizedBox(height: 60.h),
               CustomText(
                text: AppString.splashFirstTxt,
              //  text: "Pass exams faster with\nstructured learning.",
                fontsize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              const CustomText(
                text:  AppString.splashSecondTxt,
                fontsize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.whiteColor,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const CircularProgressIndicator(
                color: AppColors.greyColorA6A6A6,
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
