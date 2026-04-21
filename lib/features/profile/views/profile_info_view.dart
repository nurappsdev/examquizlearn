import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../controllers/profile_controller.dart';

class ProfileInfoView extends GetView<ProfileController> {
  const ProfileInfoView({super.key});

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
        title: Text(
          'Profile Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      // Profile Icon
                      Center(
                        child: Container(
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
                      ),
                      SizedBox(height: 40.h),
                      // Profile Info Box
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Obx(() {
                          final data = controller.profileData;
                          final keys = [
                            'Name',
                            'Email',
                            'Phone no',
                            'Date of birth',
                            'Gender',
                            'Education',
                            'University name',
                            'Linkedin link',
                          ];
                          return Column(
                            children: keys.map((key) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120.w,
                                      child: Text(
                                        key,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14.sp,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ':  ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14.sp,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data[key] ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              CustomButtonCommon(
                title: 'Edit profile',
                color: AppColors.greenColor,
                allBorderRadius: BorderRadius.circular(30.r),
                onpress: () => Get.toNamed(AppRoutes.editProfile),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
