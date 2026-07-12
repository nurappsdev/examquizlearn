import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/video_play_controller.dart';

class VideoPlayView extends StatefulWidget {
  const VideoPlayView({super.key});

  @override
  State<VideoPlayView> createState() => _VideoPlayViewState();
}

class _VideoPlayViewState extends State<VideoPlayView> {
  final ScrollController _scrollController = ScrollController();
  final RxBool _canProceed = false.obs;
  static const double _scrollThreshold = 24;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _evaluateScroll());
  }

  void _handleScroll() {
    _evaluateScroll();
  }

  void _evaluateScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) {
      _canProceed.value = true;
      return;
    }
    if (position.pixels >= position.maxScrollExtent - _scrollThreshold) {
      _canProceed.value = true;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

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
      body: NotificationListener<ScrollMetricsNotification>(
        onNotification: (_) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _evaluateScroll());
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
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
              Obx(() => CustomText(
                    text: controller.currentMaterial.value?.contentData?.title ??
                        "Video Tutorial",
                    fontsize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    textAlign: TextAlign.start,
                  )),
              SizedBox(height: 16.h),
              Obx(() {
                final raw =
                    controller.currentMaterial.value?.contentData?.text ?? "";
                if (raw.trim().isEmpty) {
                  return const SizedBox.shrink();
                }
                return HtmlWidget(
                  raw,
                  textStyle: TextStyle(
                    fontSize: 14.h,
                    fontFamily: "Montserrat-Light",
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffD7D4D4),
                    height: 1.5,
                  ),
                  customStylesBuilder: (element) {
                    switch (element.localName) {
                      case 'h1':
                      case 'h2':
                      case 'h3':
                      case 'h4':
                      case 'h5':
                      case 'h6':
                        return {'color': '#FFFFFF', 'margin': '12px 0 6px 0'};
                      case 'a':
                        return {'color': '#19D160'};
                      case 'code':
                      case 'pre':
                        return {
                          'background-color': '#1A1A1A',
                          'color': '#E3A76F',
                          'padding': '4px 6px',
                          'border-radius': '6px',
                        };
                      case 'blockquote':
                        return {
                          'border-left': '3px solid #19D160',
                          'padding-left': '10px',
                          'color': '#B5B5B5',
                        };
                    }
                    return null;
                  },
                  onTapUrl: (url) async => true,
                );
              }),
              SizedBox(height: 24.h),
              Obx(() {
                if (_canProceed.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xff19D160), size: 18.r),
                      SizedBox(width: 4.w),
                      const CustomText(
                        text: "Scroll down to continue",
                        fontsize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffB5B5B5),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Obx(() {
          final isProcessing = controller.isCompleting.value;
          final enabled = _canProceed.value && !isProcessing;
          final color = enabled
              ? AppColors.greenColor
              : AppColors.greenColor.withOpacity(0.35);
          return Opacity(
            opacity: enabled ? 1.0 : 0.6,
            child: IgnorePointer(
              ignoring: !enabled,
              child: CustomButton(
                title: isProcessing ? "Processing..." : "Next",
                onpress: () => controller.completeAndNext(),
                color: color,
                titlecolor: AppColors.blackColor,
                bordercolor: color,
                height: 56.h,
              ),
            ),
          );
        }),
      ),
    );
  }
}
