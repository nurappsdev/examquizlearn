import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_pin_text_field.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

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
          text: "OTP Verification",
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.whiteColor,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              CustomPinCodeTextField(
                textEditingController: controller.otpController,
                textColor: AppColors.whiteColor,
                activeColor: AppColors.whiteColor.withOpacity(0.3),
                inactiveColor: AppColors.whiteColor.withOpacity(0.3),
                selectedColor: AppColors.whiteColor,
                activeFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                selectedFillColor: Colors.transparent,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   CustomText(
                    text: AppString.dontGetCode,
                    fontsize: 14.sp,
                    color: AppColors.whiteColor,
                  ),
                  Obx(() => GestureDetector(
                    onTap: controller.secondsRemaining.value == 0 ? controller.resendCode : null,
                    child: RichText(
                      text: TextSpan(
                        text: "Resend in ",
                        style: TextStyle(color: AppColors.redColor, fontSize: 14.sp),
                        children: [
                          TextSpan(
                            text: controller.timeString,
                            style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
              SizedBox(height: 100.h),
              Obx(() => CustomButtonCommon(
                    title: AppString.verifyButton,
                    color: AppColors.greenColor,
                    allBorderRadius: BorderRadius.circular(30.r),
                    loading: controller.isLoading.value,
                    onpress: () => controller.verify(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
