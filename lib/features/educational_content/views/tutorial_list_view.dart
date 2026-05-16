import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_bottom_bar.dart';
import '../controllers/tutorial_list_controller.dart';
import '../model/learning_material_model.dart';

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
          return RefreshIndicator(
            color: AppColors.greenColor,
            onRefresh: controller.getMaterials,
            child: LayoutBuilder(
              builder: (context, constraints) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Center(child: CustomLoader()),
                  ),
                ],
              ),
            ),
          );
        }
        if (controller.materials.isEmpty) {
          return RefreshIndicator(
            color: AppColors.greenColor,
            onRefresh: controller.getMaterials,
            child: LayoutBuilder(
              builder: (context, constraints) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: _buildEmptyState(),
                  ),
                ],
              ),
            ),
          );
        }

        final videoCount = controller.materials
            .where((m) => m.contentType == "video")
            .length;
        final textCount = controller.materials
            .where((m) => m.contentType == "text")
            .length;

        return RefreshIndicator(
          color: AppColors.greenColor,
          onRefresh: controller.getMaterials,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.materials.length + 1,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader(
                  topicTitle: controller.topic.displayTitle,
                  topicDescription: controller.topic.displayDescription,
                  total: controller.materials.length,
                  videoCount: videoCount,
                  textCount: textCount,
                );
              }

              final material = controller.materials[index - 1];
              return _buildTutorialCard(
                material: material,
                index: index - 1,
                onTap: () async {
                  if (material.id != null) {
                    bool canStart =
                        await controller.startMaterial(material.id!);
                    if (!canStart) return;
                  }
                  if (material.contentType == "video") {
                    Get.toNamed(AppRoutes.videoPlay, arguments: material);
                  } else {
                    Get.toNamed(AppRoutes.textContentDetail,
                        arguments: material);
                  }
                },
              );
            },
          ),
        );
      }),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildHeader({
    required String topicTitle,
    required String topicDescription,
    required int total,
    required int videoCount,
    required int textCount,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff262626), Color(0xff181818)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xff2E2E2E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.greenColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.menu_book_rounded,
                    color: AppColors.greenColor, size: 22.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: topicTitle,
                      fontsize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      textAlign: TextAlign.start,
                      maxline: 1,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: "$total ${total == 1 ? 'item' : 'items'} available",
                      fontsize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffB5B5B5),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (videoCount > 0 || textCount > 0) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                if (videoCount > 0)
                  _buildHeaderChip(
                    icon: Icons.play_circle_fill_rounded,
                    label: "$videoCount video${videoCount == 1 ? '' : 's'}",
                  ),
                if (videoCount > 0 && textCount > 0) SizedBox(width: 8.w),
                if (textCount > 0)
                  _buildHeaderChip(
                    icon: Icons.article_rounded,
                    label: "$textCount text${textCount == 1 ? '' : 's'}",
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.greenColor, size: 13.r),
          SizedBox(width: 6.w),
          CustomText(
            text: label,
            fontsize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xffE6E6E6),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90.w,
            height: 90.w,
            decoration: BoxDecoration(
              color: const Color(0xff1F1F1F),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xff2E2E2E), width: 1),
            ),
            child: Icon(Icons.video_library_outlined,
                color: AppColors.greenColor, size: 40.r),
          ),
          SizedBox(height: 16.h),
          const CustomText(
            text: "No tutorials found",
            fontsize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          SizedBox(height: 6.h),
          const CustomText(
            text: "Pull down to refresh",
            fontsize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xffB5B5B5),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard({
    required LearningMaterialModel material,
    required int index,
    required VoidCallback onTap,
  }) {
    final isVideo = material.contentType == "video";
    final title = material.contentData?.title ??
        (isVideo ? "Video Tutorial" : "Text Material");
    final rawSubtitle = material.contentData?.text ?? "";
    final subtitle = _stripHtml(rawSubtitle);

    String? imageUrl;
    String time = "";

    if (isVideo) {
      imageUrl = material.contentData?.thumbnail;
      if (imageUrl != null && !imageUrl.startsWith("http")) {
        imageUrl = "${ApiConstants.imageBaseUrl}$imageUrl";
      }
      if (material.durationSec != null && material.durationSec! > 0) {
        final minutes = material.durationSec! ~/ 60;
        final seconds = material.durationSec! % 60;
        time = "$minutes:${seconds.toString().padLeft(2, '0')} min";
      }
    } else {
      imageUrl = material.contentData?.url;
      if (imageUrl != null && !imageUrl.startsWith("http")) {
        imageUrl = "${ApiConstants.imageBaseUrl}$imageUrl";
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: const Color(0xff2E2E2E), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22.r)),
                  child: _buildThumbnail(imageUrl: imageUrl, isVideo: isVideo),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(22.r)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isVideo)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 56.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.6), width: 1),
                          ),
                          child: Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 32.r),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff19D160),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVideo
                              ? Icons.play_arrow_rounded
                              : Icons.article_rounded,
                          color: Colors.white,
                          size: 12.r,
                        ),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: isVideo ? "Video" : "Text",
                          fontsize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                if (time.isNotEmpty)
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.15), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule_rounded,
                              color: Colors.white, size: 11.r),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: time,
                            fontsize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 10.h,
                  left: 12.w,
                  child: Container(
                    width: 26.w,
                    height: 26.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: CustomText(
                      text: (index + 1).toString().padLeft(2, '0'),
                      fontsize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: title,
                          fontsize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          textAlign: TextAlign.start,
                          maxline: 2,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: AppColors.greenColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chevron_right_rounded,
                            color: AppColors.greenColor, size: 18.r),
                      ),
                    ],
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    CustomText(
                      text: subtitle,
                      fontsize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffD7D4D4),
                      textAlign: TextAlign.start,
                      maxline: 2,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail({String? imageUrl, required bool isVideo}) {
    final placeholder = Container(
      height: 170.h,
      width: double.infinity,
      color: const Color(0xff262626),
      child: Center(
        child: Icon(
          isVideo
              ? Icons.video_library_rounded
              : Icons.article_outlined,
          color: const Color(0xff5A5A5A),
          size: 48.r,
        ),
      ),
    );

    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholder;
    }
    return Image.network(
      imageUrl,
      height: 170.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 170.h,
          width: double.infinity,
          color: const Color(0xff262626),
          child: const Center(child: CustomLoader()),
        );
      },
    );
  }

  String _stripHtml(String input) {
    if (input.isEmpty) return "";
    final withoutTags = input.replaceAll(RegExp(r'<[^>]*>'), ' ');
    final decoded = withoutTags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'");
    return decoded.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
