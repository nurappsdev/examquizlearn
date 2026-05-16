import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/custom_text.dart';
import '../../home/model/home_view_model.dart';
import '../controllers/educational_content_controller.dart';

class EducationalContentView extends StatelessWidget {
  const EducationalContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final EducationalContentController controller =
        Get.find<EducationalContentController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          const Center(
            child: CustomText(
              text: "Educational content",
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: CustomText(
              text: "Learn at your own pace with rich tutorials",
              fontsize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xffB5B5B5),
            ),
          ),
          SizedBox(height: 22.h),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return RefreshIndicator(
                  color: AppColors.greenColor,
                  onRefresh: controller.getTopics,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: const Center(child: CustomLoader()),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
              if (controller.topics.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.greenColor,
                  onRefresh: controller.getTopics,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: _buildEmptyState(),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.greenColor,
                onRefresh: controller.getTopics,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h, top: 4.h),
                  itemCount: controller.topics.length + 1,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildSummaryRow(
                        topicCount: controller.topics.length,
                        totalTutorials: controller.topics.fold<int>(
                          0,
                          (sum, t) => sum + (t.quizCount ?? 0),
                        ),
                      );
                    }
                    final topic = controller.topics[index - 1];
                    return _buildContentCard(
                      topic: topic,
                      buttonText: controller.selectedTab.value == 0
                          ? "View all tutorial"
                          : "View all Text content",
                      onTap: () => controller.selectedTab.value == 0
                          ? Get.toNamed(
                              AppRoutes.tutorialList,
                              arguments: topic,
                            )
                          : Get.toNamed(
                              AppRoutes.textContentList,
                              arguments: topic,
                            ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required int topicCount, required int totalTutorials}) {
    return Row(
      children: [
        Expanded(
          child: _buildStatTile(
            icon: Icons.menu_book_rounded,
            label: "Topics",
            value: topicCount.toString(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatTile(
            icon: Icons.play_circle_outline_rounded,
            label: "Tutorials",
            value: totalTutorials.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff1F1F1F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xff2E2E2E), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.greenColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.greenColor, size: 20.r),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: value,
                fontsize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                textAlign: TextAlign.start,
              ),
              CustomText(
                text: label,
                fontsize: 10,
                fontWeight: FontWeight.w400,
                color: const Color(0xffB5B5B5),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90.w,
            height: 90.w,
            decoration: BoxDecoration(
              color: const Color(0xff1F1F1F),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xff2E2E2E), width: 1),
            ),
            child: Icon(
              Icons.menu_book_outlined,
              color: AppColors.greenColor,
              size: 40.r,
            ),
          ),
          SizedBox(height: 16.h),
          const CustomText(
            text: "No topics found",
            fontsize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          SizedBox(height: 6.h),
          const CustomText(
            text: "Pull down to refresh",
            fontsize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xffB5B5B5),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard({
    required HomeViewModel topic,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    final title = topic.displayTitle;
    final description = topic.displayDescription;
    final totalTutorials = topic.quizCount ?? 0;
    final iconUrl = topic.displayIconUrl;
    final progress = topic.quizCompletionProgress;
    final completed = topic.completedCount ?? 0;
    final hasProgress = progress > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff363636),
              Color(0xff2A2A2A),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xff3F3F3F), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xffE3A76F).withOpacity(0.18),
                          const Color(0xffE3A76F).withOpacity(0.06),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: const Color(0xffE3A76F).withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(10.r),
                    child: iconUrl.isEmpty
                        ? Icon(Icons.construction,
                            color: const Color(0xffE3A76F), size: 40.r)
                        : Image.network(
                            "${ApiConstants.imageBaseUrl}$iconUrl",
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.construction,
                                color: const Color(0xffE3A76F),
                                size: 40.r),
                          ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: title,
                          fontsize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          textAlign: TextAlign.start,
                          maxline: 2,
                        ),
                        SizedBox(height: 6.h),
                        CustomText(
                          text: description,
                          fontsize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffD7D4D4),
                          textAlign: TextAlign.start,
                          maxline: 2,
                          textHeight: 1.4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  _buildMetaChip(
                    icon: Icons.play_circle_fill_rounded,
                    label: "$totalTutorials tutorials",
                  ),
                  SizedBox(width: 8.w),
                  if (hasProgress)
                    _buildMetaChip(
                      icon: Icons.check_circle_rounded,
                      label: "$completed done",
                    ),
                ],
              ),
              if (hasProgress) ...[
                SizedBox(height: 12.h),
                _buildProgressBar(progress),
              ],
              SizedBox(height: 14.h),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  height: 44.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff17A15D),
                        Color(0xff19D160),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greenColor.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: buttonText,
                        fontsize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 16.r),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.greenColor, size: 14.r),
          SizedBox(width: 6.w),
          CustomText(
            text: label,
            fontsize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xffE6E6E6),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    final percent = (progress * 100).clamp(0, 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: "Progress",
              fontsize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xffB5B5B5),
            ),
            CustomText(
              text: "$percent%",
              fontsize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.greenColor,
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5.h,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xff19D160)),
          ),
        ),
      ],
    );
  }
}
