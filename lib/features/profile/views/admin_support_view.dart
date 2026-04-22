import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/utils/app_image.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminSupportView extends StatelessWidget {
  const AdminSupportView({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      _showRestartNotice();
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      _showRestartNotice();
    }
  }

  void _showRestartNotice() {
    Get.snackbar(
      'Action Required',
      'Please fully STOP and RESTART the app to enable Dial/Email features.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Admin support',
          color: Colors.white,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Image.asset(
              AppImages.supportPic,
              height: 250.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 40.h),
            
            // Support Description Box
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greenColor, width: 2),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: CustomText(
                    text: 'If you have any questions, need assistance, or want to discuss your progress, feel free to reach out to your coach. We’re here to help you achieve your fitness goals!',
                    color: AppColors.greenColor,
                    fontsize: 14.sp,
                    maxline: 5,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  top: -15.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 8.r,
                            width: 8.r,
                            decoration: const BoxDecoration(
                              color: AppColors.greenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: 'Support',
                            color: AppColors.greenColor,
                            fontsize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            height: 8.r,
                            width: 8.r,
                            decoration: const BoxDecoration(
                              color: AppColors.greenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Contact Info Box
            Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColors.greenColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  _buildContactRow(
                    icon: Icons.phone_outlined,
                    text: '(609)327-7992',
                    onTap: () => _makePhoneCall('6093277992'),
                  ),
                  SizedBox(height: 16.h),
                  _buildContactRow(
                    icon: Icons.email_outlined,
                    text: 'abc@gmail.com',
                    onTap: () => _sendEmail('abc@gmail.com'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.grey.shade700, size: 20.r),
          ),
          SizedBox(width: 16.w),
          CustomText(
            text: text,
            color: Colors.white,
            fontsize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

