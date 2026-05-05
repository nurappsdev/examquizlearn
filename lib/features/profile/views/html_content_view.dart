import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../../core/utils/app_colors.dart';

class HtmlContentView extends StatefulWidget {
  final String title;
  final String? htmlContent;
  final String? endpoint;

  const HtmlContentView({
    super.key,
    required this.title,
    this.htmlContent,
    this.endpoint,
  });

  @override
  State<HtmlContentView> createState() => _HtmlContentViewState();
}

class _HtmlContentViewState extends State<HtmlContentView> {
  late SettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SettingsController());
    if (widget.endpoint != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchSettingsContent(widget.endpoint!);
      });
    }
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
          text: widget.title,
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.greenColor));
        }

        final content = widget.htmlContent ?? controller.content.value;

        if (content.isEmpty) {
          return const Center(
            child: CustomText(
              text: "No content available",
              color: Colors.white70,
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: HtmlWidget(
            content,
            textStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }),
    );
  }
}
