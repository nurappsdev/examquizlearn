import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/leaderboard_controller.dart';
import '../widgets/leaderboard_item.dart';
import '../widgets/leaderboard_skeleton.dart';
import '../widgets/my_status_card.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Leaderboard',
          color: Colors.white,
          fontsize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        leading: showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20.sp),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isInitialLoading.value && controller.entries.isEmpty) {
            return _buildInitialLoading();
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.entries.isEmpty) {
            return _buildError();
          }

          return RefreshIndicator(
            color: AppColors.greenColor,
            onRefresh: controller.refreshAll,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent - 200) {
                  controller.loadMore();
                }
                return false;
              },
              child: ListView(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Obx(() => MyStatusCard(
                        entry: controller.myStatus.value,
                        isLoading: controller.isMyStatusLoading.value,
                      )),
                  SizedBox(height: 22.h),
                  _buildSectionHeader('Global Leaderboard'),
                  SizedBox(height: 12.h),
                  _buildList(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInitialLoading() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MyStatusCard(entry: null, isLoading: true),
        SizedBox(height: 22.h),
        _buildSectionHeader('Global Leaderboard'),
        SizedBox(height: 12.h),
        const LeaderboardSkeleton(),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return CustomText(
      text: text,
      color: Colors.white,
      fontsize: 16.sp,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildList() {
    return Obx(() {
      final entries = controller.entries;
      if (entries.isEmpty) {
        return _buildEmpty();
      }
      return Column(
        children: [
          ...entries.map((e) => LeaderboardItem(entry: e)),
          if (controller.isLoadingMore.value)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.greenColor,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          if (!controller.hasMore.value && entries.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: CustomText(
                text: "You've reached the end",
                color: Colors.white.withOpacity(0.5),
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      );
    });
  }

  Widget _buildEmpty() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            color: Colors.white.withOpacity(0.4),
            size: 56.r,
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: 'No leaderboard data yet',
            color: Colors.white.withOpacity(0.7),
            fontsize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: 'Take quizzes to climb the ranks!',
            color: Colors.white.withOpacity(0.4),
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                color: AppColors.redColor, size: 48.r),
            SizedBox(height: 16.h),
            CustomText(
              text: controller.errorMessage.value,
              color: Colors.white,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              maxline: 4,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: controller.loadInitial,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 28.w, vertical: 12.h),
              ),
              child: CustomText(
                text: 'Retry',
                color: Colors.white,
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
