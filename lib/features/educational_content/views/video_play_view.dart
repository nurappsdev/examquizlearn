import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/video_play_controller.dart';

class VideoPlayView extends StatelessWidget {
  const VideoPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoPlayController controller = Get.find<VideoPlayController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const CustomText(
          text: "Video play",
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // Video Player Area
            Obx(() {
              if (controller.isVideoLoading.value) {
                return Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: const Color(0xff1A1A1A),
                  ),
                  child: const Center(child: CustomLoader()),
                );
              }
              if (controller.errorLoadingVideo.value) {
                return Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: const Color(0xff1A1A1A),
                  ),
                  child: const Center(
                    child: CustomText(
                      text: "Error loading video",
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return Container(
                width: double.infinity,
                height: 220.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: const Color(0xff1A1A1A),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Chewie(
                    controller: controller.chewieController!,
                  ),
                ),
              );
            }),
            SizedBox(height: 24.h),
            // Title
            Obx(() => CustomText(
                  text: controller.currentMaterial.value?.contentData?.title ??
                      "Video Tutorial",
                  fontsize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                )),
            SizedBox(height: 16.h),
            // Description
            Obx(() => CustomText(
                  text: controller.currentMaterial.value?.contentData?.text ?? "",
                  fontsize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffD7D4D4),
                  textAlign: TextAlign.start,
                )),
            SizedBox(height: 100.h), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Obx(() => CustomButton(
              title: controller.isCompleting.value ? "Processing..." : "Next",
              onpress: () => controller.completeAndNext(),
              color: Colors.transparent,
              titlecolor: const Color(0xff19D160),
              bordercolor: const Color(0xff19D160),
              height: 56.h,
            )),
      ),
    );
  }
}
