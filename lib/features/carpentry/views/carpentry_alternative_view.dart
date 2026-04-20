import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/carpentry_controller.dart';

class CarpentryAlternativeView extends GetView<CarpentryController> {
  const CarpentryAlternativeView({super.key});

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
          text: "Carpentry",
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return _buildQuizCard(index + 1);
        },
      ),
    );
  }

  Widget _buildQuizCard(int quizNumber) {
    return Container(
      width: 346.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xff333333),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Quiz - $quizNumber",
            fontsize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xffD7D4D4),
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: "We shop and deliver your essentials quickly and reliably",
            fontsize: 10,
            fontWeight: FontWeight.w400,
            color: const Color(0xffD7D4D4),
            textAlign: TextAlign.start,
            maxline: 2,
          ),
          SizedBox(height: 12.h),
          const CustomText(
            text: "Total quiz : 25",
            fontsize: 8,
            color: Color(0xffD7D4D4),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildStatusChip("Easy : 10"),
              SizedBox(width: 8.w),
              _buildStatusChip("Medium : 10"),
              SizedBox(width: 8.w),
              _buildStatusChip("Hard : 5"),
            ],
          ),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.quizInfo),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff19D160)),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: const Center(
                child: CustomText(
                  text: "Get Started",
                  fontsize: 10,
                  color: Color(0xff19D160),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD7D4D4), width: 0.5),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: CustomText(
        text: label,
        fontsize: 8,
        color: const Color(0xffD7D4D4),
      ),
    );
  }
}
