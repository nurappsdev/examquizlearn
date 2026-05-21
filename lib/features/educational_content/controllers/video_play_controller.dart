import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/service/api_client.dart';
import '../../../core/service/api_constants.dart';
import '../model/learning_material_model.dart';
import 'tutorial_list_controller.dart';

class VideoPlayController extends GetxController {
  var currentMaterial = Rxn<LearningMaterialModel>();
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  var isVideoLoading = true.obs;
  var errorLoadingVideo = false.obs;
  var isCompleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is LearningMaterialModel) {
      currentMaterial.value = Get.arguments;
      initializePlayer();
    } else {
      errorLoadingVideo.value = true;
      isVideoLoading.value = false;
    }
  }

  Future<void> initializePlayer() async {
    if (currentMaterial.value == null) return;
    
    isVideoLoading.value = true;
    errorLoadingVideo.value = false;

    String? videoUrl = currentMaterial.value!.contentData?.hls;

    if (videoUrl == null || videoUrl.isEmpty) {
      videoUrl = currentMaterial.value!.contentData?.originalS3Key ?? 
                 currentMaterial.value!.contentData?.s3Key;
    }

    if (videoUrl != null && !videoUrl.startsWith("http")) {
      videoUrl = "${ApiConstants.imageBaseUrl}$videoUrl";
    }

    if (videoUrl == null || videoUrl.isEmpty) {
      errorLoadingVideo.value = true;
      isVideoLoading.value = false;
      return;
    }

    try {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoPlayerController!.initialize();

      videoPlayerController!.addListener(_videoListener);

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint("Error initializing video player: $e");
      errorLoadingVideo.value = true;
    } finally {
      isVideoLoading.value = false;
    }
  }

  void _videoListener() {
    if (videoPlayerController != null &&
        videoPlayerController!.value.position >=
            videoPlayerController!.value.duration &&
        !isCompleting.value &&
        videoPlayerController!.value.isInitialized) {
      // Check if it's actually finished
      if (videoPlayerController!.value.position > Duration.zero) {
        completeAndNext();
      }
    }
  }

  Future<void> completeAndNext() async {
    if (isCompleting.value || currentMaterial.value == null) return;
    isCompleting.value = true;

    try {
      // 1. Hit Complete API
      if (currentMaterial.value!.id != null) {
        var response = await ApiClient.postData(
          ApiConstants.completeLearningMaterialEndPoint(currentMaterial.value!.id!),
          {},
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("Material marked as complete");
        } else {
          debugPrint("Error marking complete: ${response.statusText}");
        }
      }

      // 2. Find next material
      final listController = Get.find<TutorialListController>();
      int currentIndex = listController.materials.indexWhere((m) => m.id == currentMaterial.value!.id);
      
      if (currentIndex != -1 && currentIndex < listController.materials.length - 1) {
        var nextMaterial = listController.materials[currentIndex + 1];
        
        // 3. Start next material API call
        bool canStart = await listController.startMaterial(nextMaterial.id!);
        if (canStart) {
          // Dispose current player
          videoPlayerController?.removeListener(_videoListener);
          await videoPlayerController?.dispose();
          chewieController?.dispose();
          videoPlayerController = null;
          chewieController = null;

          // 4. Update observable material and Re-initialize UI/Player
          currentMaterial.value = nextMaterial;
          initializePlayer();
        } else {
          // If start API fails (403), we stop and go back or stay
          Get.back();
        }
      } else {
        debugPrint("No more materials in list");
        Get.back();
      }
    } catch (e) {
      debugPrint("Exception in completeAndNext: $e");
    } finally {
      isCompleting.value = false;
    }
  }

  @override
  void onClose() {
    videoPlayerController?.removeListener(_videoListener);
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
