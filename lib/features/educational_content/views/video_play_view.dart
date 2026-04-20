import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_button.dart';

class VideoPlayView extends StatelessWidget {
  const VideoPlayView({super.key});

  @override
  Widget build(BuildContext context) {
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
            Container(
              width: double.infinity,
              height: 220.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                image: const DecorationImage(
                  image: NetworkImage("https://picsum.photos/800/400?grayscale"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Overlay for controls
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  // Play/Skip Controls
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.replay_10, color: Colors.white, size: 32),
                        SizedBox(width: 40.w),
                        const Icon(Icons.play_circle_fill, color: Colors.white, size: 64),
                        SizedBox(width: 40.w),
                        const Icon(Icons.forward_10, color: Colors.white, size: 32),
                      ],
                    ),
                  ),
                  // Progress and Time
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "00 : 12 : 23",
                                fontsize: 12,
                                color: Colors.white,
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    text: "01 : 21 : 53",
                                    fontsize: 12,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.w),
                                  const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 2.h,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white.withOpacity(0.3),
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            value: 0.15,
                            onChanged: (v) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Title
            const CustomText(
              text: "Titles here . . .",
              fontsize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            // Description
            const CustomText(
              text: "Exploring the latest in technology, innovations, and breakthroughs to keep, Exploring the latest in technology, innovations, and breakthroughs to keep.",
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xffD7D4D4),
              textAlign: TextAlign.start,
              maxline: 5,
            ),
            SizedBox(height: 24.h),
            const CustomText(
              text: "Exploring the latest in technology, innovations, and breakthroughs to keep, Exploring the latest in technology, innovations, and breakthroughs to keep. Exploring the latest in technology, innovations, and breakthroughs to keep, Exploring the latest in technology, innovations, and breakthroughs to keep.",
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xffD7D4D4),
              textAlign: TextAlign.start,
              maxline: 10,
            ),
            SizedBox(height: 100.h), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: CustomButton(
          title: "Next",
          onpress: () => Get.back(),
          color: Colors.transparent,
          titlecolor: const Color(0xff19D160),
          bordercolor: const Color(0xff19D160),
          height: 56.h,
        ),
      ),
    );
  }
}
