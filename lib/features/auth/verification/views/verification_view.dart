import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/verification_controller.dart';
import '../../../../core/routes/app_routes.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: AppString.oTPVerify,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.whiteColor,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Image.asset(
                    AppImages.logo,
                    height: 180.h,
                  ),
                ),
                SizedBox(height: 60.h),
                CustomTextField(
                  controller: controller.emailController,
                  hintText: AppString.enterYourEmail,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
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
                SizedBox(height: 100.h),
                Obx(() => CustomButtonCommon(
                      title: AppString.sendOTP,
                      color: AppColors.greenColor,
                      allBorderRadius: BorderRadius.circular(30.r),
                      loading: controller.isLoading.value,
                      onpress: () => controller.sendOTP(),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
