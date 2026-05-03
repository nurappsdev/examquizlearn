import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/service/api_constants.dart';
import '../../../core/widgets/custom_text.dart';
import '../model/learning_material_model.dart';

class TextContentDetailView extends StatelessWidget {
  const TextContentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final LearningMaterialModel material = Get.arguments;
    String? imageUrl = material.contentData?.url;
    if (imageUrl != null && !imageUrl.startsWith("http")) {
      imageUrl = "${ApiConstants.imageBaseUrl}$imageUrl";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const CustomText(
          text: "Content details",
          fontsize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              height: 230.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 230.h,
                                width: double.infinity,
                                color: const Color(0xff333333),
                                child: const Center(
                                  child: Icon(Icons.image,
                                      color: Colors.white, size: 50),
                                ),
                              ),
                            )
                          : Container(
                              height: 230.h,
                              width: double.infinity,
                              color: const Color(0xff333333),
                              child: const Center(
                                child: Icon(Icons.image,
                                    color: Colors.white, size: 50),
                              ),
                            ),
                    ),
                    SizedBox(height: 20.h),
                    CustomText(
                      text: material.contentData?.title ?? "Untitled",
                      fontsize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 12.h),
                    CustomText(
                      text: material.contentData?.text ?? "",
                      fontsize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.7),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Next Button
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border:
                      Border.all(color: const Color(0xff19D160), width: 1.5),
                ),
                child: const Center(
                  child: CustomText(
                    text: "Next",
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff19D160),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
