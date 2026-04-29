import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_view.dart';
import '../../educational_content/views/educational_content_view.dart';
import '../../profile/views/profile_view.dart';
import '../../../core/widgets/custom_bottom_bar.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/custom_text.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isCheckingLearningAccess) {
            return const Center(child: CustomLoader());
          }

          if (controller.learningAccessError.isNotEmpty) {
            return _LearningAccessError(
              message: controller.learningAccessError,
              onRetry: controller.checkLearningAccess,
            );
          }

          switch (controller.currentIndex) {
            case 0:
              return const HomeView();
            case 1:
              return const EducationalContentView();
            case 2:
              return const ProfileView();
            default:
              return const HomeView();
          }
        }),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isCheckingLearningAccess ||
            controller.learningAccessError.isNotEmpty) {
          return const SizedBox.shrink();
        }

        return const CustomBottomBar();
      }),
    );
  }
}

class _LearningAccessError extends StatelessWidget {
  const _LearningAccessError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 48.r),
            SizedBox(height: 16.h),
            CustomText(
              text: message,
              color: Colors.white,
              fontsize: 15.sp,
              fontWeight: FontWeight.w500,
              maxline: 4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 46.h,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff17A15D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: CustomText(
                  text: 'Try again',
                  color: Colors.white,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
