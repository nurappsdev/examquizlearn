import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/carpentry_controller.dart';

class CarpentryView extends GetView<CarpentryController> {
  const CarpentryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const CustomText(
          text: "Carpentry",
          fontsize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            _buildLevelCard(
              level: "Easy",
              subtitle: "We shop and deliver your essentials quickly and reliably",
              progress: 0.56,
              icon: Icons.thumb_up_alt_outlined, // Replace with proper asset if available
            ),
            SizedBox(height: 20.h),
            _buildLevelCard(
              level: "Medium",
              subtitle: "We shop and deliver your essentials quickly and reliably",
              progress: 0.56,
              icon: Icons.search, // Replace with proper asset if available
            ),
            SizedBox(height: 20.h),
            _buildLevelCard(
              level: "Hard",
              subtitle: "We shop and deliver your essentials quickly and reliably",
              progress: 0.56,
              icon: Icons.psychology, // Replace with proper asset if available
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required String level,
    required String subtitle,
    required double progress,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Icon(icon, color: const Color(0xff17A15D), size: 50.r),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: level,
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                SizedBox(height: 5.h),
                CustomText(
                  text: subtitle,
                  fontsize: 12,
                  color: Colors.white.withOpacity(0.7),
                  textAlign: TextAlign.start,
                  maxline: 2,
                ),
                SizedBox(height: 15.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8.h,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffBAD6EC)),
                  ),
                ),
                SizedBox(height: 5.h),
                CustomText(
                  text: "Complete ${(progress * 100).toInt()} %",
                  fontsize: 10,
                  color: Colors.white.withOpacity(0.5),
                ),
                SizedBox(height: 15.h),
                Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff17A15D)),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const Center(
                    child: CustomText(
                      text: "Get Started",
                      fontsize: 14,
                      color: Color(0xff17A15D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
