import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/carpentry_controller.dart';
import '../model/test_exam_carpentry_model.dart';

class CarpentryAlternativeView extends GetView<CarpentryController> {
  const CarpentryAlternativeView({super.key});

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
        title: Obx(
          () => CustomText(
            text: controller.topicName.value,
            fontsize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.quizzes.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff19D160)),
          );
        }

        if (controller.quizzes.isEmpty) {
          return const Center(
            child: CustomText(
              text: "No quizzes available",
              color: Colors.white,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshQuizzes,
          color: const Color(0xff19D160),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              itemCount:
                  controller.quizzes.length +
                  (controller.hasMore.value ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (index == controller.quizzes.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Color(0xff19D160),
                      ),
                    ),
                  );
                }
                return _buildQuizCard(controller.quizzes[index]);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildQuizCard(TestExamCarpentryModel quiz) {
    final difficultyCounts = quiz.templateId?.difficultyCounts;

    return Container(
      width: 346.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xff333333),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: quiz.title ?? "Quiz",
            fontsize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xffD7D4D4),
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: "Quiz Code: ${quiz.quizCode ?? "N/A"}",
            fontsize: 10,
            fontWeight: FontWeight.w400,
            color: const Color(0xffD7D4D4),
            textAlign: TextAlign.start,
            maxline: 2,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Total quiz : ${quiz.questionCount ?? 0}",
                fontsize: 8,
                color: const Color(0xffD7D4D4),
              ),
              CustomText(
                text: "Time: ${(quiz.timeLimitSec ?? 0) ~/ 60} min",
                fontsize: 8,
                color: const Color(0xffD7D4D4),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildStatusChip("Easy : ${difficultyCounts?.easy ?? 0}"),
              SizedBox(width: 8.w),
              _buildStatusChip("Medium : ${difficultyCounts?.moderate ?? 0}"),
              SizedBox(width: 8.w),
              _buildStatusChip("Hard : ${difficultyCounts?.hard ?? 0}"),
            ],
          ),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: () => Get.toNamed(
              AppRoutes.quizInfo,
              arguments: {
                "id": quiz.id,
                "quizId": quiz.id,
                "topicId": quiz.topicId,
                "timeLimitSec": quiz.timeLimitSec,
                "title": quiz.title,
              },
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff19D160)),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: const Center(
                child: CustomText(
                  text: "Get Started",
                  fontsize: 10,
                  color: Color(0xff19D160),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD7D4D4), width: 0.5),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: CustomText(
        text: label,
        fontsize: 8,
        color: const Color(0xffD7D4D4),
      ),
    );
  }
}
