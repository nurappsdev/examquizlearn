import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_bottom_bar.dart';

class TutorialListView extends StatelessWidget {
  const TutorialListView({super.key});

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
          text: "Tutorials & Blogs",
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
        itemBuilder: (context, index) {
          return _buildTutorialCard(
            title: "Titles here . . .",
            subtitle: "This will raise awareness & increase your chances of achieving results.",
            time: index == 0 ? "22 : 00 min" : (index == 1 ? "17 : 43 min" : "6 : 13 min"),
            imageUrl: "https://picsum.photos/400/200?random=$index", // Placeholder
          );
        },
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildTutorialCard({
    required String title,
    required String subtitle,
    required String time,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.videoPlay),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xff333333), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Time Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  child: Image.network(
                    imageUrl,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180.h,
                      color: const Color(0xff333333),
                      child: const Center(child: Icon(Icons.image, color: Colors.white)),
                    ),
                  ),
                ),
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff19D160),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: time,
                          fontsize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        const Icon(Icons.play_arrow, color: Colors.white, size: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Text Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: title,
                        fontsize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: subtitle,
                    fontsize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffD7D4D4),
                    textAlign: TextAlign.start,
                    maxline: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
