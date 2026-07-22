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

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  late final SignupController controller;
  String _openDropdown = '';

  @override
  void initState() {
    super.initState();
    controller = Get.find<SignupController>();
  }

  void _toggleDropdown(String key) {
    setState(() {
      _openDropdown = _openDropdown == key ? '' : key;
    });
  }

  void _closeDropdowns() {
    setState(() {
      _openDropdown = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeDropdowns,
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
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
                  // Date of Birth
                  CustomTextField(
                    controller: controller.dateOfBirthController,
                    hintText: 'Date of Birth',
                    readOnly: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.whiteColor.withValues(alpha: 0.7),
                        size: 20.sp,
                      ),
                    ),
                    onTap: () async {
                      _closeDropdowns();
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: AppColors.greenColor,
                                onPrimary: Colors.white,
                                surface: Colors.black,
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        final month = picked.month.toString().padLeft(2, '0');
                        final day = picked.day.toString().padLeft(2, '0');
                        controller.dateOfBirthController.text =
                        '${picked.year}-$month-$day';
                      }
                    },
                    filColor: Colors.transparent,
                    borderColor: AppColors.whiteColor.withValues(alpha: 0.3),
                    textColor: AppColors.whiteColor,
                    hinTextColor: AppColors.whiteColor.withValues(alpha: 0.5),
                    borderRadio: 12,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of birth is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Gender
                  Obx(
                        () => _buildDropdown(
                      key: 'gender',
                      hintText: 'Gender',
                      icon: Icons.male_outlined,
                      value: controller.selectedGender.value,
                      items: controller.genderOptions,
                      onChanged: controller.selectGender,
                    ),
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
                                  Get.toNamed(AppRoutes.termsOfService);
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
                                  Get.toNamed(AppRoutes.privacyPolicy);
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
                    onpress: () {
                      _closeDropdowns();
                      controller.signup(_formKey);
                    },
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
      ),
    );
  }

  Widget _buildDropdown({
    required String key,
    required String hintText,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String) onChanged,
  }) {
    final isOpen = _openDropdown == key;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _toggleDropdown(key),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.whiteColor.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.whiteColor.withValues(alpha: 0.7),
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    value.isEmpty ? hintText : value,
                    style: TextStyle(
                      color: value.isEmpty
                          ? AppColors.whiteColor.withValues(alpha: 0.5)
                          : AppColors.whiteColor,
                      fontSize: 11.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: AppColors.whiteColor.withValues(alpha: 0.7),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.whiteColor.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Column(
              children: items.map((item) {
                final isSelected = item == value;
                return GestureDetector(
                  onTap: () {
                    onChanged(item);
                    _closeDropdowns();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.greenColor
                                  : AppColors.whiteColor,
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: AppColors.greenColor,
                            size: 18.sp,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
