import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/custom_button_common.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/personal_info_controller.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _openDropdown = '';

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
    final PersonalInfoController controller = Get.find();

    return GestureDetector(
      onTap: _closeDropdowns,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 40.h),
                  CustomTextField(
                    controller: controller.dateOfBirthController,
                    hintText: 'Date of birth',
                    readOnly: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.whiteColor.withOpacity(0.7),
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
                        controller.dateOfBirthController.text =
                            '${picked.day}/${picked.month}/${picked.year}';
                      }
                    },
                    filColor: Colors.transparent,
                    borderColor: AppColors.whiteColor.withOpacity(0.3),
                    textColor: AppColors.whiteColor,
                    hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                    borderRadio: 12,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of birth is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => _buildDropdown(
                        key: 'gender',
                        hintText: 'Gender',
                        icon: Icons.male_outlined,
                        value: controller.selectedGender.value,
                        items: controller.genderOptions,
                        onChanged: controller.selectGender,
                      )),
                  SizedBox(height: 16.h),
                  Obx(() => _buildDropdown(
                        key: 'employment',
                        hintText: 'Employment status',
                        icon: Icons.badge_outlined,
                        value: controller.selectedEmploymentStatus.value,
                        items: controller.employmentStatusOptions,
                        onChanged: controller.selectEmploymentStatus,
                      )),
                  SizedBox(height: 16.h),
                  Obx(() => _buildDropdown(
                        key: 'education',
                        hintText: 'Education',
                        icon: Icons.school_outlined,
                        value: controller.selectedEducation.value,
                        items: controller.educationOptions,
                        onChanged: controller.selectEducation,
                      )),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: controller.universityNameController,
                    hintText: 'University name',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.business_outlined,
                        color: AppColors.whiteColor.withOpacity(0.7),
                        size: 20.sp,
                      ),
                    ),
                    filColor: Colors.transparent,
                    borderColor: AppColors.whiteColor.withOpacity(0.3),
                    textColor: AppColors.whiteColor,
                    hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                    borderRadio: 12,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: controller.linkedinProfileController,
                    hintText: 'Linkedin profile link',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.link_outlined,
                        color: AppColors.whiteColor.withOpacity(0.7),
                        size: 20.sp,
                      ),
                    ),
                    filColor: Colors.transparent,
                    borderColor: AppColors.whiteColor.withOpacity(0.3),
                    textColor: AppColors.whiteColor,
                    hinTextColor: AppColors.whiteColor.withOpacity(0.5),
                    borderRadio: 12,
                  ),
                  SizedBox(height: 60.h),
                  Obx(() => CustomButtonCommon(
                        title: 'Save and continue',
                        color: AppColors.greenColor,
                        allBorderRadius: BorderRadius.circular(30.r),
                        loading: controller.isLoading.value,
                        onpress: () {
                          _closeDropdowns();
                          controller.saveAndContinue(_formKey);
                        },
                      )),
                  SizedBox(height: 30.h),
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
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.whiteColor.withOpacity(0.3),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.whiteColor.withOpacity(0.7),
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    value.isEmpty ? hintText : value,
                    style: TextStyle(
                      color: value.isEmpty
                          ? AppColors.whiteColor.withOpacity(0.5)
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
                  color: AppColors.whiteColor.withOpacity(0.7),
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
                color: AppColors.whiteColor.withOpacity(0.3),
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
