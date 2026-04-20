import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              _buildHeader(),
              SizedBox(height: 30.h),
              _buildProgressCard(),
              SizedBox(height: 30.h),
              const CustomText(
                text: "Select a category",
                fontsize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              SizedBox(height: 15.h),
              _buildCategorySelector(),
              SizedBox(height: 20.h),
              _buildCategoryCard(
                title: "Carpentry",
                subtitle: "We shop and deliver your essentials quickly and reliably",
                progress: 0.56,
                image: "assets/images/logo.png", // Placeholder
              ),
              SizedBox(height: 15.h),
              _buildCategoryCard(
                title: "OSHA",
                subtitle: "We shop and deliver your essentials quickly and reliably",
                progress: 0.56,
                image: "assets/images/logo.png", // Placeholder
              ),
              SizedBox(height: 100.h), // Space for bottom bar
            ],
          ),
        ),
      ),
    );
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
              color: Colors.white.withOpacity(0.7),
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
            constraints: const BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
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

  Widget _buildProgressCard() {
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
            text: "Over all progress",
            fontsize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 10.h),
          const CustomText(
            text: "60%",
            fontsize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 15.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 10.h,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: 10.h),
          const CustomText(
            text: "Completed 100 lessons of 250 lessons",
            fontsize: 12,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
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

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required double progress,
    required String image,
  }) {
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
              // Icon Placeholder
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.contain,
                  ),
                ),
                child: image == "assets/images/logo.png" ? Icon(Icons.image, color: Colors.grey, size: 40.r) : null,
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontsize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      text: subtitle,
                      fontsize: 11,
                      color: Colors.white.withOpacity(0.7),
                      textAlign: TextAlign.start,
                      maxline: 2,
                    ),
                    SizedBox(height: 15.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6.h,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffBAD6EC)),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      text: "Complete ${(progress * 100).toInt()} %",
                      fontsize: 10,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: title == "Carpentry"
                ? () {
                    if (controller.selectedCategoryIndex == 0) {
                      Get.toNamed(AppRoutes.quiz);
                    } else {
                      Get.toNamed(AppRoutes.carpentryAlternative);
                    }
                  }
                : null,
            child: Container(
              width: double.infinity,
              height: 45.h,
              decoration: BoxDecoration(
                color: const Color(0xff17A15D),
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
}
