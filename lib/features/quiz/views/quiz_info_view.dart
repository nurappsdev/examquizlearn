import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_image.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/quiz_controller.dart';

class QuizInfoView extends GetView<QuizController> {
  const QuizInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final Map<dynamic, dynamic> quizArguments = arguments is Map
        ? arguments
        : {"id": arguments};
    final int timeLimitSec =
        int.tryParse(quizArguments["timeLimitSec"]?.toString() ?? "") ?? 0;
    final String title =
        quizArguments["title"]?.toString().trim().isNotEmpty == true
        ? quizArguments["title"].toString()
        : "Need to know";
    final String timedTestTitle = timeLimitSec > 0
        ? "Timed test (${_formatDuration(timeLimitSec)})"
        : "Timed test";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: title,
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            const CustomText(
              text: "Exam mode",
              fontsize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            SizedBox(height: 12.h),
            CustomText(
              text:
                  "Enter a distraction-free environment designed to replicate the actual contractor licensing examination. High-stakes testing protocols are active.",
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xffD7D4D4),
              textAlign: TextAlign.center,
              maxline: 4,
            ),
            SizedBox(height: 30.h),
            _buildInfoCard(
              icon: Icons.access_time_filled,
              iconColor: const Color(0xff19D160),
              title: timedTestTitle,
              subtitle:
                  "The timer starts the moment you click begin. Auto-submission occurs at 0:00.",
            ),
            SizedBox(height: 16.h),
            _buildInfoCard(
              icon: Icons.visibility_off,
              iconColor: const Color(0xffBD0000),
              title: "No answers shown during exam",
              subtitle:
                  "Correct answers and explanations are hidden until the final submission.",
            ),
            SizedBox(height: 16.h),
            _buildInfoCard(
              icon: Icons.assignment_turned_in,
              iconColor: const Color(0xff19D160),
              title: "Final score provided at the end",
              subtitle:
                  "Receive a detailed performance breakdown across all technical categories.",
            ),
            SizedBox(height: 30.h),
            Image.asset(AppImages.rafiki, height: 200.h, fit: BoxFit.contain),
            SizedBox(height: 30.h),
            _buildPrecisionSection(),
            SizedBox(height: 30.h),
            Obx(
              () => CustomButton(
                title: controller.isLoading.value ? "Starting..." : "Start exam",
                onpress: controller.isLoading.value
                    ? () {}
                    : () => controller.startQuizAttempt(),
                color: AppColors.greenColor,
                titlecolor: Colors.white,
                bordercolor: Colors.transparent,
                height: 50.h,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;

    if (seconds == 0) {
      return "$minutes mins";
    }

    return "$minutes mins $seconds secs";
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xff333333),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.r),
          ),
          SizedBox(height: 15.h),
          CustomText(
            text: title,
            fontsize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: subtitle,
            fontsize: 10,
            fontWeight: FontWeight.w400,
            color: const Color(0xffD7D4D4),
            textAlign: TextAlign.center,
            maxline: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPrecisionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xff333333),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Precision & Integrity",
            fontsize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          SizedBox(height: 12.h),
          CustomText(
            text:
                "This mode disables all hints, references, and external links. Ensure you are in a quiet environment with no interruptions. Once started, the session cannot be paused.",
            fontsize: 10,
            color: const Color(0xffD7D4D4),
            textAlign: TextAlign.start,
            maxline: 5,
          ),
          SizedBox(height: 15.h),
          _buildCheckItem("Browser lock-out recommended"),
          SizedBox(height: 8.h),
          _buildCheckItem("Authorized code books allowed"),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: const BoxDecoration(
            color: Color(0xff19D160),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: Colors.white, size: 12.r),
        ),
        SizedBox(width: 10.w),
        CustomText(text: text, fontsize: 10, color: const Color(0xffD7D4D4)),
      ],
    );
  }
}
