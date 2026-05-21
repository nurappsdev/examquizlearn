import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/notification_controller.dart';

class NotificationsView extends GetView<NotificationController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const CustomText(
          text: "Notifications",
          fontsize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.greenColor));
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 64.r, color: Colors.white.withOpacity(0.3)),
                SizedBox(height: 16.h),
                CustomText(
                  text: "No notifications found",
                  fontsize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return GestureDetector(
              onTap: () => controller.handleNotificationClick(notification),
              child: Container(
                margin: EdgeInsets.only(bottom: 15.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff222222),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: notification.isRead == false
                        ? AppColors.greenColor.withOpacity(0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCategoryIcon(notification.category),
                        color: AppColors.greenColor,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: notification.title ?? "",
                                  fontsize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              CustomText(
                                text: _formatDate(notification.deliveredAt),
                                fontsize: 10,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          CustomText(
                            text: notification.body ?? "",
                            fontsize: 12,
                            color: Colors.white.withOpacity(0.7),
                            textAlign: TextAlign.start,
                            maxline: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'billing':
        return Icons.account_balance_wallet_outlined;
      case 'quiz':
        return Icons.quiz_outlined;
      case 'learning':
        return Icons.menu_book_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
