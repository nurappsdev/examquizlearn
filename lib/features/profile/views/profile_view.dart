import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../controllers/profile_controller.dart';

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
        SizedBox(height: 50.h),
        // Menu Items
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Divider(color: Colors.white.withOpacity(0.3), height: 1),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Profile Information',
                onTap: () => Get.toNamed(AppRoutes.profileInfo),
              ),
              _buildMenuItem(
                icon: Icons.badge_outlined,
                title: 'Personal Information',
                onTap: () => Get.toNamed(AppRoutes.profileInfoProfile),
              ),
              _buildMenuItem(
                icon: Icons.workspace_premium_outlined,
                title: 'Subscription',
                onTap: () => Get.toNamed(AppRoutes.subscriptionScreen),
              ),
              _buildMenuItem(
                icon: Icons.support_agent_outlined,
                title: 'Admin Support',
                onTap: () => Get.toNamed(AppRoutes.adminSupport),
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
            ],
          ),
        ),
      ],
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
