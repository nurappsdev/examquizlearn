import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/signin_controller.dart';
import '../../../../core/routes/app_routes.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});

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
                SizedBox(height: 20.h),
                Center(
                  child: Image.asset(
                    AppImages.logo,
                    height: 180.h,
                  ),
                ),
                SizedBox(height: 50.h),
                CustomTextField(
                  controller: controller.emailController,
                  hintText: AppString.enterYourEmail,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.mail_outline,
                      color: AppColors.whiteColor.withOpacity(0.7),
                      size: 20.sp,
                    ),
                  ),
                  filColor: Colors.transparent,
                  borderColor: AppColors.whiteColor.withOpacity(0.3),
                  textColor: AppColors.whiteColor,
                  hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                  borderRadio: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "${AppString.enterYourEmail} is required";
                    }
                    if (!GetUtils.isEmail(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: controller.passwordController,
                  hintText: AppString.enterYourPass,
                  isPassword: true,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.vpn_key_outlined,
                      color: AppColors.whiteColor.withOpacity(0.7),
                      size: 20.sp,
                    ),
                  ),
                  filColor: Colors.transparent,
                  borderColor: AppColors.whiteColor.withOpacity(0.3),
                  textColor: AppColors.whiteColor,
                  hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                  borderRadio: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "${AppString.enterYourPass} is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.verification);
                    },
                    child: const CustomText(
                      text: AppString.forgotPass,
                      fontsize: 14,
                      color: AppColors.redColor,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Obx(() => CustomButtonCommon(
                      title: AppString.signIn,
                      color: AppColors.greenColor,
                      allBorderRadius: BorderRadius.circular(30.r),
                      loading: controller.isLoading.value,
                      onpress: () => controller.signin(formKey),
                    )),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: AppString.dontHaveAccount,
                      fontsize: 14,
                      color: AppColors.whiteColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.signup);
                      },
                      child: const CustomText(
                        text: AppString.signUpButton,
                        fontsize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.redColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
