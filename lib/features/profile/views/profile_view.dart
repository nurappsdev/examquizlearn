import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';
import '../controllers/profile_controller.dart';
import '../widgets/quiz_attempt_card.dart';
import '../widgets/quiz_attempt_skeleton.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    return Column(
      children: [
        SizedBox(height: 50.h),
        // Profile Icon and Name
        Center(
          child: Column(
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 60.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() => Text(
                    controller.name.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        // Menu Items
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Divider(color: Colors.white.withOpacity(0.3), height: 1),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent - 200) {
                controller.loadMoreQuizAttempts();
              }
              return false;
            },
            child: RefreshIndicator(
              color: AppColors.greenColor,
              backgroundColor: const Color(0xff1C1C1C),
              onRefresh: controller.refreshProfile,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Profile Information',
                  onTap: () => Get.toNamed(AppRoutes.profileInfo),
                ),
                // _buildMenuItem(
                //   icon: Icons.workspace_premium_outlined,
                //   title: 'Subscription',
                //   onTap: () => Get.toNamed(AppRoutes.subscriptionScreen),
                // ),
                _buildMenuItem(
                  icon: Icons.support_agent_outlined,
                  title: 'Admin Support',
                  onTap: () => Get.toNamed(AppRoutes.adminSupport),
                ),
                _buildMenuItem(
                  icon: Icons.card_membership_outlined,
                  title: 'Your Plan',
                  onTap: () => Get.toNamed(AppRoutes.yourPlan),
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => Get.toNamed(AppRoutes.settings),
                ),
                _buildMenuItem(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  showArrow: false,
                  onTap: () => controller.logout(),
                ),
                SizedBox(height: 24.h),
                _buildSectionHeader('My Recent Quiz Activity'),
                SizedBox(height: 12.h),
                _buildQuizActivity(controller),
                SizedBox(height: 24.h),
              ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: text,
        color: Colors.white,
        fontsize: 16.sp,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildQuizActivity(ProfileController controller) {
    return Obx(() {
      if (controller.isAttemptsLoading.value &&
          controller.quizAttempts.isEmpty) {
        return const QuizAttemptSkeleton();
      }

      if (controller.attemptsErrorMessage.value.isNotEmpty &&
          controller.quizAttempts.isEmpty) {
        return _buildAttemptsError(controller);
      }

      final attempts = controller.quizAttempts;
      if (attempts.isEmpty) {
        return _buildAttemptsEmpty();
      }

      return Column(
        children: [
          ...attempts.map((a) => QuizAttemptCard(attempt: a)),
          if (controller.isAttemptsLoadingMore.value)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.greenColor,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          if (controller.hasMoreAttempts.value &&
              !controller.isAttemptsLoadingMore.value)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: TextButton(
                onPressed: controller.loadMoreQuizAttempts,
                child: CustomText(
                  text: 'Load more',
                  color: AppColors.greenColor,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildAttemptsEmpty() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            color: Colors.white.withOpacity(0.4),
            size: 36.r,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'No quiz activity yet',
            color: Colors.white.withOpacity(0.7),
            fontsize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: 'Your recent attempts will appear here.',
            color: Colors.white.withOpacity(0.4),
            fontsize: 11.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptsError(ProfileController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.redColor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline,
              color: AppColors.redColor, size: 28.r),
          SizedBox(height: 8.h),
          CustomText(
            text: controller.attemptsErrorMessage.value,
            color: Colors.white.withOpacity(0.85),
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            maxline: 3,
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: controller.retryQuizAttempts,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.greenColor,
              padding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
            ),
            child: CustomText(
              text: 'Retry',
              color: AppColors.greenColor,
              fontsize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.white, size: 24.r),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          trailing: showArrow
              ? Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.r)
              : null,
        ),
        Divider(color: Colors.white.withOpacity(0.3), height: 1),
      ],
    );
  }
}
