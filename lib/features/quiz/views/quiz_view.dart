import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

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
          text: "Quiz",
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.menu, color: Colors.white),
          SizedBox(width: 24),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // Timer Section
            Obx(() => Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff129444),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_filled,
                          color: Colors.white, size: 24.r),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: controller.timerText,
                        fontsize: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 20.h),
            // Progress & Difficulty Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => CustomText(
                      text:
                          "Completed quiz ${controller.currentStep.value} of ${controller.totalSteps.value}",
                      fontsize: 14,
                      color: const Color(0xffD7D4D4),
                    )),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: const Color(0xffD7D4D4),
                      width: 0.5,
                    ),
                  ),
                  child: Obx(() => CustomText(
                        text: controller.difficulty.value,
                        fontsize: 14,
                        color: const Color(0xffD7D4D4),
                      )),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Progress Bar
            Obx(() => Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffE6E6E6),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: controller.currentStep.value /
                          controller.totalSteps.value,
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff19D160),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 30.h),
            // Question Section
            Obx(() => CustomText(
              text: controller.questions[controller.currentStep.value - 1].question,
              fontsize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xffD7D4D4),
              textAlign: TextAlign.start,
            )),
            SizedBox(height: 8.h),
            const CustomText(
              text: "Real Estate Demo Quiz",
              fontsize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff17BE57),
              textAlign: TextAlign.start,
              maxline: 2,
            ),
            SizedBox(height: 12.h),
            const Divider(color: Color(0xffD2D2D2), thickness: 0.5),
            SizedBox(height: 12.h),
            // Answers Section
            Expanded(
              child: Obx(() {
                int currentQuestionIndex = controller.currentStep.value - 1;
                var question = controller.questions[currentQuestionIndex];
                int selectedIdx = controller.selectedAnswerIndex.value;
                bool isAnswered = selectedIdx != -1;

                return ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    bool isThisSelected = selectedIdx == index;
                    bool isCorrect = question.correctAnswerIndex == index;
                    
                    Color borderColor = const Color(0xff333333);
                    Color indicatorColor = Colors.transparent;
                    Color textColor = const Color(0xffD7D4D4);
                    Widget? checkIcon;

                    if (isAnswered) {
                      if (isThisSelected) {
                        if (isCorrect) {
                          borderColor = const Color(0xff17BE57);
                          indicatorColor = const Color(0xff17BE57);
                          checkIcon = const Icon(Icons.check, size: 16, color: Colors.white);
                        } else {
                          borderColor = Colors.red;
                          indicatorColor = Colors.red;
                          checkIcon = const Icon(Icons.close, size: 16, color: Colors.white);
                        }
                      } else if (isCorrect) {
                        // Reveal correct answer if user picked wrong one
                        borderColor = const Color(0xff17BE57);
                      }
                    } else {
                      // Not answered yet
                      if (isThisSelected) {
                        borderColor = const Color(0xff17BE57);
                        indicatorColor = const Color(0xff17BE57);
                      }
                    }

                    return GestureDetector(
                      onTap: isAnswered ? null : () => controller.selectAnswer(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28.w,
                              height: 28.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                    color: const Color(0xffB0B0B0), width: 1),
                                color: indicatorColor,
                              ),
                              child: checkIcon,
                            ),
                            SizedBox(width: 13.w),
                            Expanded(
                              child: CustomText(
                                text: question.options[index],
                                fontsize: 12,
                                color: textColor,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            // Bottom Buttons
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "Previous",
                      onpress: () => controller.previousStep(),
                      color: Colors.transparent,
                      titlecolor: const Color(0xff17BE57),
                      bordercolor: const Color(0xff17BE57),
                      height: 50.h,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(() {
                      bool isAnswerSelected = controller.selectedAnswerIndex.value != -1;
                      return CustomButton(
                        title: controller.currentStep.value == controller.totalSteps.value ? "Finish" : "Next",
                        onpress: () => controller.nextStep(),
                        color: isAnswerSelected
                            ? AppColors.greenColor
                            : const Color(0xffB0B0B0),
                        titlecolor: Colors.white,
                        bordercolor: Colors.transparent,
                        height: 50.h,
                      );
                    }),
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
