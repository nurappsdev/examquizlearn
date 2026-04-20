import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/signup_controller.dart';
import '../../../../core/routes/app_routes.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: 10.h),
                Center(
                  child: Column(
                    children: [
                      CustomText(
                        text: AppString.createAccount,
                        fontsize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        text: AppString.signupSubTitle,
                        fontsize: 12.sp,
                        color: AppColors.greyColorA6A6A6,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                // Name
                CustomTextField(
                  controller: controller.nameController,
                  hintText: AppString.enterYourName,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(Icons.person_outline, color: AppColors.whiteColor.withOpacity(0.7), size: 20.sp),
                  ),
                  filColor: Colors.transparent,
                  borderColor: AppColors.whiteColor.withOpacity(0.3),
                  textColor: AppColors.whiteColor,
                  hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                  borderRadio: 12,
                  validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                ),
                SizedBox(height: 16.h),
                // Email
                CustomTextField(
                  controller: controller.emailController,
                  hintText: AppString.enterEmail,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(Icons.mail_outline, color: AppColors.whiteColor.withOpacity(0.7), size: 20.sp),
                  ),
                  filColor: Colors.transparent,
                  borderColor: AppColors.whiteColor.withOpacity(0.3),
                  textColor: AppColors.whiteColor,
                  hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                  borderRadio: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email is required";
                    if (!GetUtils.isEmail(value)) return "Enter a valid email";
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                // Phone
                CustomTextField(
                  controller: controller.phoneController,
                  hintText: AppString.phoneNumber,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(Icons.phone_outlined, color: AppColors.whiteColor.withOpacity(0.7), size: 20.sp),
                  ),
                  filColor: Colors.transparent,
                  borderColor: AppColors.whiteColor.withOpacity(0.3),
                  textColor: AppColors.whiteColor,
                  hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                  borderRadio: 12,
                  validator: (value) => value == null || value.isEmpty ? "Phone number is required" : null,
                ),
                SizedBox(height: 16.h),
                // Password
                CustomTextField(
                  controller: controller.passwordController,
                  hintText: AppString.enterYourPass,
                  isPassword: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(Icons.vpn_key_outlined, color: AppColors.whiteColor.withOpacity(0.7), size: 20.sp),
                  ),
                  filColor: Colors.transparent,
                  borderColor: AppColors.whiteColor.withOpacity(0.3),
                  textColor: AppColors.whiteColor,
                  hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                  borderRadio: 12,
                  validator: (value) => value == null || value.isEmpty ? "Password is required" : null,
                ),
                SizedBox(height: 16.h),
                // Confirm Password
                CustomTextField(
                  controller: controller.confirmPasswordController,
                  hintText: AppString.enterYourPassCon,
                  isPassword: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(Icons.vpn_key_outlined, color: AppColors.whiteColor.withOpacity(0.7), size: 20.sp),
                  ),
                  filColor: Colors.transparent,
                  borderColor: AppColors.whiteColor.withOpacity(0.3),
                  textColor: AppColors.whiteColor,
                  hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                  borderRadio: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Confirm password is required";
                    if (value != controller.passwordController.text) return "Passwords do not match";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                // Agree Checkbox
                Row(
                  children: [
                    Obx(() => Checkbox(
                      value: controller.isAgree.value,
                      onChanged: (value) => controller.toggleAgreement(value),
                      activeColor: AppColors.greenColor,
                      checkColor: AppColors.whiteColor,
                      side: BorderSide(color: AppColors.whiteColor.withOpacity(0.5)),
                    )),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: AppString.agreeWith,
                          style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
                          children: [
                            TextSpan(
                              text: AppString.termsOfServices,
                              style: TextStyle(color: AppColors.redColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                // Navigate to terms
                              },
                            ),
                            TextSpan(
                              text: " & ",
                              style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
                            ),
                            TextSpan(
                              text: AppString.privacyPolicyText,
                              style: TextStyle(color: AppColors.redColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                // Navigate to privacy policy
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                // Register Button
                Obx(() => CustomButtonCommon(
                  title: AppString.register,
                  color: AppColors.greenColor,
                  allBorderRadius: BorderRadius.circular(30.r),
                  loading: controller.isLoading.value,
                  onpress: () => controller.signup(),
                )),
                SizedBox(height: 30.h),
                // Footer
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppString.haveAnAccount,
                      style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp),
                      children: [
                        TextSpan(
                          text: AppString.login,
                          style: TextStyle(color: AppColors.redColor, fontSize: 14.sp, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Get.offAllNamed(AppRoutes.signin);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
