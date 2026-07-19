import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../../../profile/subscription/controllers/subscription_controller.dart';

class FreeTrialView extends GetView<SubscriptionController> {
  const FreeTrialView({super.key});

  static const Color _orange = Color(0xffFF9F0A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          'Start Your 7-Day\nFree Trial',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 30.h,
                            child: Container(
                              width: 48.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.r),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    _orange,
                                    _orange,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.65, 1.0],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              _buildTrialItem(
                                icon: Icons.lock,
                                title: 'Full access',
                                description:
                                    'Unlock unlimited access to the tools, lessons, and practice exams.',
                              ),
                              SizedBox(height: 24.h),
                              _buildTrialItem(
                                icon: Icons.notifications,
                                title: 'Self-Paced Study',
                                description:
                                    'Access expert-designed quizzes and study smarter whenever and wherever you choose.',
                              ),
                              SizedBox(height: 24.h),
                              _buildTrialItem(
                                icon: Icons.star,
                                title: 'Monthly Access Begins',
                                subtitle: 'Automatic cancelled trial',
                                description:
                                    'Your subscription will automatically begin after your 7-day free trial ends. Cancel anytime.',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              Obx(() => CustomButtonCommon(
                    title: 'Start My Free Trial',
                    allBorderRadius: BorderRadius.circular(30.r),
                    loading: controller.isStartingFreeTrial,
                    onpress: () => controller.startFreeTrial(),
                  )),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrialItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48.w,
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(icon, color: Colors.white, size: 24.r),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
