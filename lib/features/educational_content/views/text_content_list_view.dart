import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_image.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_bottom_bar.dart';

class TextContentListView extends StatelessWidget {
  const TextContentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const CustomText(
          text: "Carpentry content",
          fontsize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          return _buildTextContentCard(
            title: "Titles here",
            subtitle: "Transform your look with expert cuts, styling, and personalized service at our premier salon, designed for your ultimate satisfaction.",
          );
        },
      ),
      // bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildTextContentCard({
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.textContentDetail),
      child: Container(
        width: double.infinity,
        height: 150.h,
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xff333333), width: 1),
        ),
        child: Row(
          children: [
            // Left Side: Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(24.r)),
              child: Image.asset(
                AppImages.contentPic,
                height: double.infinity,
                width: 110.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 130.w,
                  height: double.infinity,
                  color: const Color(0xff333333),
                  child: const Center(child: Icon(Icons.image, color: Colors.white)),
                ),
              ),
            ),
            // Right Side: Text Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontsize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 4.h),
                    Expanded(
                      child: CustomText(
                        text: subtitle,
                        fontsize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                        textAlign: TextAlign.start,
                        maxline: 3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // "View details" Button
                    Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: const Color(0xff19D160), width: 1),
                      ),
                      child: const Center(
                        child: CustomText(
                          text: "View details",
                          fontsize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff19D160),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
