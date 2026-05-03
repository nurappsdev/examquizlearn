import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/tutorial_list_controller.dart';
import '../model/learning_material_model.dart';

class TextContentListView extends StatelessWidget {
  const TextContentListView({super.key});

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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "${controller.topic.title} content",
          fontsize: 18,
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
              text: "No text content found",
              color: Colors.white,
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          itemCount: controller.materials.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            var material = controller.materials[index];
            return _buildTextContentCard(
              material: material,
              controller: controller,
            );
          },
        );
      }),
    );
  }

  Widget _buildTextContentCard({
    required LearningMaterialModel material,
    required TutorialListController controller,
  }) {
    String? imageUrl = material.contentData?.url;
    if (imageUrl != null && !imageUrl.startsWith("http")) {
      imageUrl = "${ApiConstants.imageBaseUrl}$imageUrl";
    }

    return GestureDetector(
      onTap: () async {
        if (material.id != null) {
          bool canStart = await controller.startMaterial(material.id!);
          if (!canStart) return;
        }
        Get.toNamed(AppRoutes.textContentDetail, arguments: material);
      },
      child: Container(
        width: double.infinity,
        height: 150.h,
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xff333333), width: 1),
        ),
        child: Row(
          children: [
            // Left Side: Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(24.r)),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: double.infinity,
                      width: 110.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 110.w,
                        height: double.infinity,
                        color: const Color(0xff333333),
                        child: const Center(
                            child: Icon(Icons.image, color: Colors.white)),
                      ),
                    )
                  : Container(
                      width: 110.w,
                      height: double.infinity,
                      color: const Color(0xff333333),
                      child: const Center(
                          child: Icon(Icons.image, color: Colors.white)),
                    ),
            ),
            // Right Side: Text Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: material.contentData?.title ?? "Untitled",
                      fontsize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      textAlign: TextAlign.start,
                      maxline: 1,
                    ),
                    SizedBox(height: 4.h),
                    Expanded(
                      child: CustomText(
                        text: material.contentData?.text ?? "",
                        fontsize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                        textAlign: TextAlign.start,
                        maxline: 3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // "View details" Button
                    Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border:
                            Border.all(color: const Color(0xff19D160), width: 1),
                      ),
                      child: const Center(
                        child: CustomText(
                          text: "View details",
                          fontsize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff19D160),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
