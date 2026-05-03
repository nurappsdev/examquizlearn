import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_bottom_bar.dart';
import '../controllers/tutorial_list_controller.dart';

class TutorialListView extends StatelessWidget {
  const TutorialListView({super.key});

  @override
  Widget build(BuildContext context) {
    final TutorialListController controller =
        Get.find<TutorialListController>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "${controller.topic.title} Tutorials",
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoader());
        }
        if (controller.materials.isEmpty) {
          return const Center(
            child: CustomText(
              text: "No tutorials found",
              color: Colors.white,
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          itemCount: controller.materials.length,
          separatorBuilder: (context, index) => SizedBox(height: 20.h),
          itemBuilder: (context, index) {
            var material = controller.materials[index];
            String? imageUrl;
            String? title = material.contentData?.title;
            String? subtitle = material.contentData?.text;
            String time = "";

            if (material.contentType == "video") {
              imageUrl = material.contentData?.thumbnail;
              if (imageUrl != null && !imageUrl.startsWith("http")) {
                imageUrl = "${ApiConstants.imageBaseUrl}$imageUrl";
              }
              if (material.durationSec != null) {
                int minutes = material.durationSec! ~/ 60;
                int seconds = material.durationSec! % 60;
                time =
                    "$minutes : ${seconds.toString().padLeft(2, '0')} min";
              }
            } else if (material.contentType == "text") {
              imageUrl = material.contentData?.url;
              if (imageUrl != null && !imageUrl.startsWith("http")) {
                imageUrl = "${ApiConstants.imageBaseUrl}$imageUrl";
              }
            }

            return _buildTutorialCard(
              title: title ?? (material.contentType == "video" ? "Video Tutorial" : "Text Material"),
              subtitle: subtitle ?? "",
              time: time,
              imageUrl: imageUrl,
              onTap: () async {
                if (material.id != null) {
                  bool canStart = await controller.startMaterial(material.id!);
                  if (!canStart) return;
                }
                if (material.contentType == "video") {
                  Get.toNamed(AppRoutes.videoPlay, arguments: material);
                } else {
                  Get.toNamed(AppRoutes.textContentDetail, arguments: material);
                }
              },
            );
          },
        );
      }),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildTutorialCard({
    required String title,
    required String subtitle,
    required String time,
    String? imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xff333333), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Time Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24.r)),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 180.h,
                            color: const Color(0xff333333),
                            child: const Center(
                                child: Icon(Icons.image, color: Colors.white)),
                          ),
                        )
                      : Container(
                          height: 180.h,
                          color: const Color(0xff333333),
                          child: const Center(
                              child: Icon(Icons.image, color: Colors.white)),
                        ),
                ),
                if (time.isNotEmpty)
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xff19D160),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: time,
                            fontsize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          const Icon(Icons.play_arrow,
                              color: Colors.white, size: 12),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Text Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: title,
                          fontsize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: subtitle,
                    fontsize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffD7D4D4),
                    textAlign: TextAlign.start,
                    maxline: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
