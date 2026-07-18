import 'package:nailed_quiz_app/core/widgets/custom_button.dart';
import 'package:nailed_quiz_app/core/widgets/custom_text.dart';
import 'package:nailed_quiz_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/delete_account_controller.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final _formKey = GlobalKey<FormState>();
  late final DeleteAccountController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DeleteAccountController());
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
          text: 'Delete Account',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              CustomText(
                text:
                    'Are you sure you want to delete your account? This action cannot be undone. Enter your password to confirm.',
                color: Colors.white70,
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                maxline: 4,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: CustomText(
                  text: 'Password',
                  color: Colors.white,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              CustomTextField(
                controller: controller.passwordController,
                hintText: 'Enter your password',
                isPassword: true,
                filColor: Colors.transparent,
                borderColor: const Color(0xffA1A1A1),
                textColor: Colors.white,
                hinTextColor: Colors.grey.shade600,
                validator: (value) {
                  if (value == null || value.toString().trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Obx(
          () => CustomButton(
            title: 'Delete',
            loading: controller.isLoading.value,
            onpress: () => controller.deleteAccount(_formKey),
            color: Colors.red,
            titlecolor: Colors.white,
            width: double.infinity,
            height: 56.h,
            bordercolor: Colors.red,
          ),
        ),
      ),
    );
  }
}
