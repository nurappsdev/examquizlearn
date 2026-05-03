import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/home_controller.dart';
import '../model/home_view_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final MainController mainController = Get.find<MainController>();

    return Obx(() {
      final topics = mainController.learningTopics;
      final progress = mainController.topicProgress;
      final isSearching = mainController.learningTopicSearchTerm.isNotEmpty;
      final isRefreshingTopics = mainController.isRefreshingLearningTopics;
      final isLoadingMoreTopics = mainController.isLoadingMoreLearningTopics;
      final isLearningSelected = controller.selectedCategoryIndex == 0;

      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - 240.h) {
            mainController.loadNextLearningTopicsPage();
          }
          return false;
        },
        child: SingleChildScrollView(
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
              if (isLearningSelected) ...[
                _buildTopicSearchField(controller),
                SizedBox(height: 20.h),
              ],
              if (isRefreshingTopics)
                _buildTopicsLoader()
              else if (topics.isEmpty)
                _buildEmptyTopicsCard(
                  isLearning: isLearningSelected,
                  isSearching: isLearningSelected && isSearching,
                )
              else
                ...topics.map((topic) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: _buildCategoryCard(
                      topic: topic,
                      isLearning: isLearningSelected,
                    ),
                  );
                }),
              if (isLoadingMoreTopics) _buildLoadMoreIndicator(),
              SizedBox(height: 100.h),
            ],
          ),
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

  Widget _buildTopicSearchField(HomeController controller) {
    return Obx(() {
      final hasSearchTerm = controller.topicSearchTerm.isNotEmpty;

      return TextFormField(
        controller: controller.topicSearchController,
        onChanged: controller.updateTopicSearchTerm,
        textInputAction: TextInputAction.search,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        cursorColor: AppColors.greenColor,
        decoration: InputDecoration(
          hintText: 'Search topics',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 14.sp,
          ),
          filled: true,
          fillColor: const Color(0xff222222),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withValues(alpha: 0.7),
            size: 22.r,
          ),
          suffixIcon: hasSearchTerm
              ? IconButton(
                  onPressed: controller.clearTopicSearch,
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 20.r,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 14.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.r),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.r),
            borderSide: const BorderSide(color: AppColors.greenColor),
          ),
        ),
      );
    });
  }

  Widget _buildTopicsLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.greenColor),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 18.h),
      child: Center(
        child: SizedBox(
          width: 24.r,
          height: 24.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.greenColor,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTopicsCard({
    required bool isLearning,
    required bool isSearching,
  }) {
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
            text: isSearching
                ? 'No topics found for your search.'
                : isLearning
                ? 'No learning topics are available right now.'
                : 'No tests are available right now.',
            fontsize: 14.sp,
            color: Colors.white.withValues(alpha: 0.8),
            maxline: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required HomeViewModel topic,
    required bool isLearning,
  }) {
    final title = topic.displayTitle;
    final subtitle = topic.displayDescription;
    final progress = topic.progress;
    final imageUrl = topic.displayIconUrl;
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
                    SizedBox(height: 12.h),
                    _buildTopicStats(topic, isLearning: isLearning),
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
                controller.startLearningQuiz(topic.id.toString()); // ✅
              } else {
                Get.toNamed(
                  AppRoutes.carpentryAlternative,
                  arguments: {"topicId": topic.id, "topicName": topic.title},
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.greenColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child:  Center(
                child: CustomText(
                  text: controller.selectedCategoryIndex == 0? "Play Quiz": "Details",
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

  Widget _buildTopicStats(HomeViewModel topic, {required bool isLearning}) {
    final stats = isLearning
        ? [
            _TopicStat('Quizzes', topic.quizCount),
            _TopicStat('Progress', topic.userProgressCount),
            _TopicStat('Started', topic.startedCount),
            _TopicStat('Completed', topic.completedCount),
          ]
        : [
            _TopicStat('Quizzes', topic.quizCount),
            _TopicStat('Attempts', topic.quizAttemptCount),
          ];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: stats.map(_buildTopicStatChip).toList(),
    );
  }

  Widget _buildTopicStatChip(_TopicStat stat) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: CustomText(
        text: '${stat.label}: ${stat.value ?? 0}',
        fontsize: 10,
        color: Colors.white.withValues(alpha: 0.8),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTopicImage(String imageUrl) {
    final resolvedImageUrl = _resolveTopicImageUrl(imageUrl);
    final hasNetworkImage = resolvedImageUrl.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 70.w,
        height: 70.w,
        color: const Color(0xff333333),
        child: hasNetworkImage
            ? Image.network(
                resolvedImageUrl,
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

  String _resolveTopicImageUrl(String imageUrl) {
    final value = imageUrl.trim();
    if (value.isEmpty) {
      return '';
    }
    if (value.startsWith('http')) {
      return value;
    }

    final baseUrl = ApiConstants.imageBaseUrl.endsWith('/')
        ? ApiConstants.imageBaseUrl
        : '${ApiConstants.imageBaseUrl}/';
    final relativePath = value.startsWith('/') ? value.substring(1) : value;
    return '$baseUrl$relativePath';
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

class _TopicStat {
  const _TopicStat(this.label, this.value);

  final String label;
  final int? value;
}
