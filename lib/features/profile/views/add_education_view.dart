import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/widgets/custom_button.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:examtest/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddEducationView extends StatefulWidget {
  const AddEducationView({super.key});

  @override
  State<AddEducationView> createState() => _AddEducationViewState();
}

class EducationEntry {
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  bool isCurrentlyStudying = false;

  void dispose() {
    schoolController.dispose();
    degreeController.dispose();
    majorController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
  }
}

class _AddEducationViewState extends State<AddEducationView> {
  final List<EducationEntry> _educationEntries = [EducationEntry()];

  @override
  void dispose() {
    for (var entry in _educationEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addNewEntry() {
    setState(() {
      _educationEntries.add(EducationEntry());
    });
  }

  void _removeEntry(int index) {
    setState(() {
      _educationEntries[index].dispose();
      _educationEntries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Education',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._educationEntries.asMap().entries.map((item) {
              int index = item.key;
              EducationEntry entry = item.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0) Divider(color: Colors.white.withOpacity(0.1), height: 40.h),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('School or university name'),
                      if (_educationEntries.length > 1)
                        GestureDetector(
                          onTap: () => _removeEntry(index),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: Colors.red.withOpacity(0.5)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red, size: 16.sp),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: 'Remove',
                                  color: Colors.red,
                                  fontsize: 12.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  CustomTextField(
                    controller: entry.schoolController,
                    hintText: 'Write here..',
                    filColor: Colors.transparent,
                    borderColor: const Color(0xffA1A1A1),
                    textColor: Colors.white,
                    hinTextColor: Colors.grey.shade600,
                    borderRadio: 30,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel('Degree type'),
                  CustomTextField(
                    controller: entry.degreeController,
                    hintText: 'Write here..',
                    filColor: Colors.transparent,
                    borderColor: const Color(0xffA1A1A1),
                    textColor: Colors.white,
                    hinTextColor: Colors.grey.shade600,
                    borderRadio: 30,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel('Major'),
                  CustomTextField(
                    controller: entry.majorController,
                    hintText: 'Write here..',
                    filColor: Colors.transparent,
                    borderColor: const Color(0xffA1A1A1),
                    textColor: Colors.white,
                    hinTextColor: Colors.grey.shade600,
                    borderRadio: 30,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('From'),
                            _buildDatePicker(entry.fromDateController),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('To'),
                            _buildDatePicker(entry.toDateController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      SizedBox(
                        height: 24.r,
                        width: 24.r,
                        child: Checkbox(
                          value: entry.isCurrentlyStudying,
                          onChanged: (value) {
                            setState(() {
                              entry.isCurrentlyStudying = value ?? false;
                            });
                          },
                          activeColor: AppColors.greenColor,
                          checkColor: Colors.black,
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      CustomText(
                        text: 'I currently study here',
                        color: Colors.white,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),

            SizedBox(height: 30.h),
            // Add Button (Middle)
            GestureDetector(
              onTap: _addNewEntry,
              child: Container(
                width: double.infinity,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.greenColor, width: 1.5),
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.greenColor,
                  size: 28.sp,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: CustomButton(
          title: 'Submit',
          onpress: () {
            Get.back();
          },
          color: AppColors.greenColor,
          titlecolor: Colors.white,
          width: double.infinity,
          height: 56.h,
          bordercolor: AppColors.greenColor,
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label,
        color: Colors.white,
        fontsize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppColors.greenColor,
                  onPrimary: Colors.white,
                  surface: const Color(0xFF1A1A1A),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            controller.text = "${picked.month.toString().padLeft(2, '0')} - ${picked.day.toString().padLeft(2, '0')} - ${picked.year}";
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: const Color(0xffA1A1A1), width: 0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: controller.text.isEmpty ? 'MM - DD - YYYY' : controller.text,
              color: controller.text.isEmpty ? Colors.grey.shade600 : Colors.white,
              fontsize: 14.sp,
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey.shade600,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
