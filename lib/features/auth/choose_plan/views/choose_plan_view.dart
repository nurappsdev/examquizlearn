import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button_common.dart';

class ChoosePlanView extends StatelessWidget {
  const ChoosePlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(),
              Text(
                'Choose Your Plan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Start with a free trial or go straight\nto a paid subscription.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              CustomButtonCommon(
                title: 'Free Trial',
                allBorderRadius: BorderRadius.circular(30.r),
                onpress: () => Get.offAllNamed(AppRoutes.freeTrial),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () => Get.offAllNamed(AppRoutes.subscriptionScreen),
                child: Container(
                  width: 355.w,
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: AppColors.whiteColor.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'Paid Subscription',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
