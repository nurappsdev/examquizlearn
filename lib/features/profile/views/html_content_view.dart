import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class HtmlContentView extends StatelessWidget {
  final String title;
  final String htmlContent;

  const HtmlContentView({
    super.key,
    required this.title,
    required this.htmlContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: title,
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: HtmlWidget(
          htmlContent,
          textStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
