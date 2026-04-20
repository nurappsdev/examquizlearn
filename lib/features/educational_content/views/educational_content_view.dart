import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/educational_content_controller.dart';

class EducationalContentView extends GetView<EducationalContentController> {
  const EducationalContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        title: const CustomText(
          text: "Educational content",
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Custom Toggle/Tab Bar
            Container(
              height: 56.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeTab(0),
                          child: Container(
                            margin: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: controller.selectedTab.value == 0
                                  ? const Color(0xff204F9D)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                            child: Center(
                              child: CustomText(
                                text: "Tutorial",
                                fontsize: 16,
                                fontWeight: FontWeight.w500,
                                color: controller.selectedTab.value == 0
                                    ? Colors.white
                                    : const Color(0xff204F9D),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeTab(1),
                          child: Container(
                            margin: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: controller.selectedTab.value == 1
                                  ? const Color(0xff204F9D)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                            child: Center(
                              child: CustomText(
                                text: "Text content",
                                fontsize: 16,
                                fontWeight: FontWeight.w500,
                                color: controller.selectedTab.value == 1
                                    ? Colors.white
                                    : const Color(0xff204F9D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 30.h),
            // Content List
            Expanded(
              child: ListView(
                children: [
                  _buildContentCard(
                    title: "Carpentry",
                    description: "We shop and deliver your essentials quickly and reliably",
                    totalTutorials: 23,
                    icon: Icons.construction, // Placeholder for Carpentry icon
                    onTap: () => Get.toNamed(AppRoutes.tutorialList),
                  ),
                  SizedBox(height: 20.h),
                  _buildContentCard(
                    title: "OSHA",
                    description: "We shop and deliver your essentials quickly and reliably",
                    totalTutorials: 23,
                    icon: Icons.roofing, // Placeholder for OSHA icon
                    onTap: () => Get.toNamed(AppRoutes.tutorialList),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard({
    required String title,
    required String description,
    required int totalTutorials,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xff333333),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Placeholder
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Icon(icon, color: const Color(0xffE3A76F), size: 60.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontsize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: description,
                  fontsize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffD7D4D4),
                  textAlign: TextAlign.start,
                  maxline: 2,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: "Total tutorial : $totalTutorials",
                  fontsize: 10,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffD7D4D4),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: const Center(
                      child: CustomText(
                        text: "View all tutorial",
                        fontsize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
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
}
