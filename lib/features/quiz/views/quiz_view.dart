import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff19D160)),
          );
        }

        if (controller.questions.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff129444),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: Colors.white,
                        size: 24.r,
                      ),
                      SizedBox(width: 10.w),
                      Obx(
                            () => CustomText(
                          text: controller.timerText,
                          fontsize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () => CustomText(
                        text:
                        "Completed quiz ${controller.currentStep.value} of ${controller.totalSteps.value}",
                        fontsize: 14,
                        color: const Color(0xffD7D4D4),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: const Color(0xffD7D4D4),
                          width: 0.5,
                        ),
                      ),
                      child: Obx(
                            () => CustomText(
                          text: controller.difficulty.value,
                          fontsize: 14,
                          color: const Color(0xffD7D4D4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Obx(
                      () => Stack(
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
                        widthFactor:
                        controller.totalSteps.value > 0
                            ? controller.currentStep.value /
                            controller.totalSteps.value
                            : 0,
                        child: Container(
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff19D160),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                Obx(
                      () => CustomText(
                    text: controller.currentQuestion?.question?.content ?? "",
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffD7D4D4),
                    textAlign: TextAlign.start,
                    maxline: 8,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                      () => CustomText(
                    text:
                    controller.currentQuestion?.question?.subtopic ??
                        controller.quizTitle.value,
                    fontsize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff17BE57),
                    textAlign: TextAlign.start,
                    maxline: 2,
                  ),
                ),
                SizedBox(height: 12.h),
                const Divider(color: Color(0xffD2D2D2), thickness: 0.5),
                SizedBox(height: 12.h),
                Expanded(
                  child: Obx(() {
                    final options = controller.currentOptionsList;
                    return ListView.separated(
                      itemCount: options.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final isThisSelected =
                              controller.selectedAnswerIndex.value == index;
                          final isLearning = controller.isLearningQuiz.value;
                          final correctIndex = controller.currentCorrectAnswerIndex;
                          final hasAnswered = controller.selectedAnswerIndex.value != -1;

                          Color borderColor = const Color(0xff333333);
                          Color indicatorColor = Colors.transparent;

                          if (isLearning && hasAnswered) {
                            if (index == correctIndex) {
                              borderColor = const Color(0xff17BE57); // Green
                              indicatorColor = const Color(0xff17BE57);
                            } else if (isThisSelected) {
                              borderColor = const Color(0xffBD0000); // Red
                              indicatorColor = const Color(0xffBD0000);
                            }
                          } else if (isThisSelected) {
                            borderColor = const Color(0xff17BE57);
                            indicatorColor = const Color(0xff17BE57);
                          }

                          return GestureDetector(
                            onTap: hasAnswered ? null : () => controller.selectAnswer(index),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 13.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor, width: 1),
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
                                        color: const Color(0xffB0B0B0),
                                        width: 1,
                                      ),
                                      color: indicatorColor,
                                    ),
                                    child: (isThisSelected || (isLearning && hasAnswered && index == correctIndex))
                                        ? Icon(
                                      (isLearning && hasAnswered && index != correctIndex && isThisSelected) ? Icons.close : Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                        : null,
                                  ),
                                  SizedBox(width: 13.w),
                                  Expanded(
                                    child: CustomText(
                                      text: options[index].content ?? "",
                                      fontsize: 12,
                                      color: const Color(0xffD7D4D4),
                                      textAlign: TextAlign.start,
                                      maxline: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
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
                        child: Obx(
                              () => CustomButton(
                            title:
                            controller.currentStep.value ==
                                controller.totalSteps.value
                                ? (controller.isLearningQuiz.value ? "Submit" : "Finish")
                                : "Next",
                            loading: controller.isSubmittingAnswer.value || controller.isSubmittingQuiz.value,
                            onpress: controller.selectedAnswerIndex.value == -1
                                ? () {}
                                : () => controller.nextStep(),
                            color: controller.selectedAnswerIndex.value != -1
                                ? AppColors.greenColor
                                : const Color(0xffB0B0B0),
                            titlecolor: Colors.white,
                            bordercolor: Colors.transparent,
                            height: 50.h,
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

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xff129444),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: Colors.white,
                      size: 24.r,
                    ),
                    SizedBox(width: 10.w),
                    Obx(
                      () => CustomText(
                        text: controller.timerText,
                        fontsize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => CustomText(
                      text:
                          "Completed quiz ${controller.currentStep.value} of ${controller.totalSteps.value}",
                      fontsize: 14,
                      color: const Color(0xffD7D4D4),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: const Color(0xffD7D4D4),
                        width: 0.5,
                      ),
                    ),
                    child: Obx(
                      () => CustomText(
                        text: controller.difficulty.value,
                        fontsize: 14,
                        color: const Color(0xffD7D4D4),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Obx(
                () => Stack(
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
                      widthFactor:
                          controller.totalSteps.value > 0
                              ? controller.currentStep.value /
                                  controller.totalSteps.value
                              : 0,
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff19D160),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Obx(
                () => CustomText(
                  text: controller.currentQuestion?.question?.content ?? "",
                  fontsize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffD7D4D4),
                  textAlign: TextAlign.start,
                  maxline: 8,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => CustomText(
                  text:
                      controller.currentQuestion?.question?.subtopic ??
                      controller.quizTitle.value,
                  fontsize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff17BE57),
                  textAlign: TextAlign.start,
                  maxline: 2,
                ),
              ),
              SizedBox(height: 12.h),
              const Divider(color: Color(0xffD2D2D2), thickness: 0.5),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(() {
                  final options = controller.currentOptionsList;
                  return ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return Obx(() {
                        final isThisSelected =
                            controller.selectedAnswerIndex.value == index;
                        final borderColor = isThisSelected
                            ? const Color(0xff17BE57)
                            : const Color(0xff333333);
                        final indicatorColor = isThisSelected
                            ? const Color(0xff17BE57)
                            : Colors.transparent;

                        return GestureDetector(
                          onTap: () => controller.selectAnswer(index),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 13.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: borderColor, width: 1),
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
                                      color: const Color(0xffB0B0B0),
                                      width: 1,
                                    ),
                                    color: indicatorColor,
                                  ),
                                  child: isThisSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 13.w),
                                Expanded(
                                  child: CustomText(
                                    text: options[index].content ?? "",
                                    fontsize: 12,
                                    color: const Color(0xffD7D4D4),
                                    textAlign: TextAlign.start,
                                    maxline: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
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
                      child: Obx(
                        () => CustomButton(
                          title:
                              controller.currentStep.value ==
                                      controller.totalSteps.value
                                  ? "Finish"
                                  : "Next",
                          loading: controller.isSubmittingAnswer.value || controller.isSubmittingQuiz.value,
                          onpress: controller.selectedAnswerIndex.value == -1
                              ? () {}
                              : () => controller.nextStep(),
                          color: controller.selectedAnswerIndex.value != -1
                              ? AppColors.greenColor
                              : const Color(0xffB0B0B0),
                          titlecolor: Colors.white,
                          bordercolor: Colors.transparent,
                          height: 50.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
