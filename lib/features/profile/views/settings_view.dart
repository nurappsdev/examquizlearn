import 'package:nailed_quiz_app/core/routes/app_routes.dart';
import 'package:nailed_quiz_app/core/utils/app_colors.dart';
import 'package:nailed_quiz_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Settings',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () => Get.toNamed(AppRoutes.changePassword),
            ),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: 'About Us',
              onTap: () => Get.toNamed(AppRoutes.aboutUs),
            ),
            _buildSettingItem(
              icon: Icons.verified_user_outlined,
              title: 'Privacy Policy',
              onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'Terms of service',
              onTap: () => Get.toNamed(AppRoutes.termsOfService),
            ),
            const Spacer(),
            // Delete Account Button
            Obx(() => GestureDetector(
              onTap: controller.isLoading.value ? null : () {
                _showDeleteDialog(context, controller);
              },
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: Center(
                  child: controller.isLoading.value 
                    ? const CircularProgressIndicator(color: Colors.red)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red, size: 24.sp),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: 'Delete Account',
                            color: Colors.red,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                ),
              ),
            )),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.white, size: 24.sp),
          title: CustomText(
            text: title,
            color: Colors.white,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.sp),
        ),
        Divider(color: Colors.white.withOpacity(0.2), height: 1),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2A2A2A),
        title: const CustomText(text: 'Delete Account', color: Colors.white, fontWeight: FontWeight.bold),
        content: const CustomText(
          text: 'Are you sure you want to delete your account? This action cannot be undone.',
          color: Colors.white70,
          textAlign: TextAlign.start,
          maxline: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const CustomText(text: 'Cancel', color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // controller.deleteAccount();
            },
            child: const CustomText(text: 'Delete', color: Colors.red),
          ),
        ],
      ),
    );
  }
}
