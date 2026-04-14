import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.whiteColor,
                      size: 20.sp,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Image.asset(
                    AppImages.logo,
                    height: 180.h,
                  ),
                ),
                SizedBox(height: 50.h),
                Obx(() => CustomTextField(
                      controller: controller.newPasswordController,
                      hintText: 'New Password',
                      isPassword: !controller.isNewPasswordVisible.value,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.vpn_key_outlined,
                          color: AppColors.whiteColor.withOpacity(0.7),
                          size: 20.sp,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            controller.isNewPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.whiteColor.withOpacity(0.7),
                            size: 20.sp,
                          ),
                          onPressed: controller.toggleNewPasswordVisibility,
                        ),
                      ),
                      filColor: Colors.transparent,
                      borderColor: AppColors.whiteColor.withOpacity(0.3),
                      textColor: AppColors.whiteColor,
                      hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                      borderRadio: 12,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    )),
                SizedBox(height: 16.h),
                Obx(() => CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: 'Confirm Password',
                      isPassword: !controller.isConfirmPasswordVisible.value,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.vpn_key_outlined,
                          color: AppColors.whiteColor.withOpacity(0.7),
                          size: 20.sp,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.whiteColor.withOpacity(0.7),
                            size: 20.sp,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      filColor: Colors.transparent,
                      borderColor: AppColors.whiteColor.withOpacity(0.3),
                      textColor: AppColors.whiteColor,
                      hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                      borderRadio: 12,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        }
                        if (value != controller.newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    )),
                SizedBox(height: 50.h),
                Obx(() => CustomButtonCommon(
                      title: 'Confirm',
                      color: AppColors.greenColor,
                      allBorderRadius: BorderRadius.circular(30.r),
                      loading: controller.isLoading.value,
                      onpress: () => controller.resetPassword(formKey),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
