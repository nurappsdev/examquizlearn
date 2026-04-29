import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final MainController mainController = Get.find<MainController>();

    return Obx(() {
      final topics = mainController.learningTopics;
      final progress = mainController.topicProgress;

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildHeader(),
            SizedBox(height: 30.h),
            _buildProgressCard(progress),
            SizedBox(height: 30.h),
            const CustomText(
              text: "Select a category",
              fontsize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            SizedBox(height: 15.h),
            _buildCategorySelector(controller),
            SizedBox(height: 20.h),
            if (topics.isEmpty)
              _buildEmptyTopicsCard()
            else
              ...topics.map((topic) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: _buildCategoryCard(
                    title: _stringValue(topic, ['title', 'name']),
                    subtitle: _stringValue(topic, ['description', 'subtitle']),
                    progress: _topicProgress(topic),
                    imageUrl: _stringValue(topic, [
                      'iconUrl',
                      'imageUrl',
                      'image',
                    ]),
                  ),
                );
              }),
            SizedBox(height: 100.h),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.person, color: Colors.white, size: 30.r),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "David !",
              fontsize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            CustomText(
              text: "welcome to app name",
              fontsize: 12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ],
        ),
        const Spacer(),
        _buildIconWithBadge(Icons.access_time, "1"),
        SizedBox(width: 15.w),
        _buildIconWithBadge(Icons.notifications_none, "0"),
      ],
    );
  }

  Widget _buildIconWithBadge(IconData icon, String badgeCount) {
    return Stack(
      children: [
        Icon(icon, color: Colors.white, size: 28.r),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            child: Text(
              badgeCount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(Map<String, dynamic>? progressData) {
    final totalMaterials = _intValue(progressData, 'totalMaterials');
    final completedMaterials = _intValue(progressData, 'completedMaterials');
    final progressPct = _progressPercent(progressData?['progressPct']);
    final progressValue = (progressPct / 100).clamp(0.0, 1.0).toDouble();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: const LinearGradient(
          colors: [Color(0xff058240), Color(0xff17A15D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Overall progress",
            fontsize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: "${progressPct.toStringAsFixed(0)}%",
            fontsize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 15.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 10.h,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text:
                "Completed $completedMaterials lessons of $totalMaterials lessons",
            fontsize: 12,
            color: Colors.white,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(HomeController controller) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeCategory(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: controller.selectedCategoryIndex == 0
                        ? const Color(0xff224B97)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Learning",
                      fontsize: 16,
                      color: controller.selectedCategoryIndex == 0
                          ? Colors.white
                          : const Color(0xff224B97),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeCategory(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: controller.selectedCategoryIndex == 1
                        ? const Color(0xff224B97)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Test or exam",
                      fontsize: 16,
                      color: controller.selectedCategoryIndex == 1
                          ? Colors.white
                          : const Color(0xff224B97),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyTopicsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            color: Colors.white.withValues(alpha: 0.7),
            size: 40.r,
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: 'No learning topics are available right now.',
            fontsize: 14.sp,
            color: Colors.white.withValues(alpha: 0.8),
            maxline: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required double progress,
    required String imageUrl,
  }) {
    final progressValue = progress.clamp(0.0, 1.0).toDouble();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopicImage(imageUrl),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title.isEmpty ? 'Untitled topic' : title,
                      fontsize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      textAlign: TextAlign.start,
                      maxline: 2,
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      text: subtitle.isEmpty
                          ? 'Learning materials and quizzes.'
                          : subtitle,
                      fontsize: 11,
                      color: Colors.white.withValues(alpha: 0.7),
                      textAlign: TextAlign.start,
                      maxline: 3,
                    ),
                    SizedBox(height: 15.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 6.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xffBAD6EC),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      text: "Complete ${(progressValue * 100).toInt()} %",
                      fontsize: 10,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: () {
              if (controller.selectedCategoryIndex == 0) {
                Get.toNamed(AppRoutes.quiz);
              } else {
                Get.toNamed(AppRoutes.carpentryAlternative);
              }
            },
            child: Container(
              width: double.infinity,
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.greenColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: const Center(
                child: CustomText(
                  text: "Details",
                  fontsize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicImage(String imageUrl) {
    final hasNetworkImage = imageUrl.startsWith('http');

    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 70.w,
        height: 70.w,
        color: const Color(0xff333333),
        child: hasNetworkImage
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _topicFallbackIcon(),
              )
            : _topicFallbackIcon(),
      ),
    );
  }

  Widget _topicFallbackIcon() {
    return Icon(Icons.school_outlined, color: Colors.grey, size: 40.r);
  }

  String _stringValue(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return '';
  }

  int _intValue(Map<String, dynamic>? source, String key) {
    final value = source?[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  double _topicProgress(Map<String, dynamic> topic) {
    for (final key in ['progressPct', 'progress', 'completionPercentage']) {
      final value = topic[key];
      final parsed = _doubleValue(value);
      if (parsed != null) {
        return parsed > 1 ? parsed / 100 : parsed;
      }
    }

    return 0;
  }

  double _progressPercent(dynamic value) {
    final parsed = _doubleValue(value) ?? 0;
    return parsed > 1 ? parsed : parsed * 100;
  }

  double? _doubleValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
