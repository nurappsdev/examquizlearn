import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/quiz_controller.dart';

class QuizResultView extends GetView<QuizController> {
  const QuizResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const CustomText(
          text: "Exam result",
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildScoreCircle(),
            SizedBox(height: 20.h),
            _buildStatusBadge(),
            SizedBox(height: 24.h),
            const CustomText(
              text: "Real Estate Demo Exam",
              fontsize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Obx(() => CustomText(
              text: controller.scorePercentage >= 70 
                  ? "Excellent work ! You have met the minimum threshold of 70% for the Real Estate Demo simulation"
                  : "Keep practicing ! You need 70% to pass the Real Estate Demo simulation",
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xffD7D4D4),
              textAlign: TextAlign.center,
              maxline: 4,
            )),
            SizedBox(height: 30.h),
            _buildStatsRow(),
            SizedBox(height: 24.h),
            Obx(() => _buildAnswerBreakdown(
              title: "Correct answers",
              count: "${controller.correctAnswersCount}",
              description: "Total number of questions you answered correctly.",
              color: const Color(0xff19D160),
            )),
            SizedBox(height: 16.h),
            Obx(() => _buildAnswerBreakdown(
              title: "Incorrect answers",
              count: "${controller.incorrectAnswersCount}",
              description: "Total number of questions you answered incorrectly.",
              color: const Color(0xffBD0000),
            )),
            SizedBox(height: 24.h),
            _buildNextSteps(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCircle() {
    return Container(
      width: 180.w,
      height: 180.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xff19D160), width: 10.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => CustomText(
            text: "${controller.scorePercentage.toInt()} %",
            fontsize: 48,
            fontWeight: FontWeight.w700,
            color: const Color(0xff19D160),
          )),
          const CustomText(
            text: "Overall score",
            fontsize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Obx(() {
      bool passed = controller.scorePercentage >= 70;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: passed ? const Color(0xff47DA80) : Colors.red, width: 1.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(passed ? Icons.verified : Icons.error_outline, 
                 color: passed ? const Color(0xff19D160) : Colors.red, 
                 size: 24.r),
            SizedBox(width: 8.w),
            CustomText(
              text: passed ? "Passed" : "Failed",
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: passed ? const Color(0xff19D160) : Colors.red,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.access_time,
            title: "Time spent",
            value: "05 : 12 min",
            valueColor: const Color(0xff19D160),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Obx(() => _buildStatItem(
            icon: Icons.bar_chart,
            title: "Accuracy",
            value: controller.scorePercentage >= 80 ? "High" : (controller.scorePercentage >= 50 ? "Medium" : "Low"),
            valueColor: const Color(0xff19D160),
          )),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xffE6E6E6), width: 1.w),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24.r),
          SizedBox(height: 8.h),
          CustomText(
            text: title,
            fontsize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xff545454),
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            fontsize: 20,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerBreakdown({
    required String title,
    required String count,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xff333333),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: CustomText(
                text: count,
                fontsize: 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontsize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: description,
                  fontsize: 10,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffD7D4D4),
                  textAlign: TextAlign.start,
                  maxline: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps() {
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
            text: "Whats Next",
            fontsize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          SizedBox(height: 8.h),
          const CustomText(
            text: "Review your answers or continue to the next module to further your real estate knowledge.",
            fontsize: 10,
            fontWeight: FontWeight.w400,
            color: Color(0xffD7D4D4),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            title: "Continue to next",
            onpress: () {},
            color: const Color(0xff19D160),
            titlecolor: Colors.white,
            height: 50.h,
          ),
          SizedBox(height: 12.h),
          CustomButton(
            title: "Retry quiz",
            onpress: () {
              controller.currentStep.value = 1;
              controller.selectedAnswerIndex.value = -1;
              controller.userAnswers.value = List.filled(controller.questions.length, -1);
              Get.back();
            },
            color: Colors.transparent,
            titlecolor: const Color(0xff19D160),
            bordercolor: const Color(0xff19D160),
            height: 50.h,
          ),
        ],
      ),
    );
  }
}
