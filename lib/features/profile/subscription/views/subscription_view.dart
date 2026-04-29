import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_loader.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Subscription Plans',
          color: Colors.white,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CustomLoader());
          }

          if (controller.errorMessage.isNotEmpty) {
            return _ErrorState(
              message: controller.errorMessage,
              onRetry: controller.fetchPlans,
            );
          }

          if (controller.plans.isEmpty) {
            return _EmptyState(onRefresh: controller.fetchPlans);
          }

          return RefreshIndicator(
            color: AppColors.greenColor,
            backgroundColor: const Color(0xff222222),
            onRefresh: controller.fetchPlans,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;
                final plans = controller.plans;

                if (isWide) {
                  return GridView.builder(
                    padding: EdgeInsets.all(20.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: plans.length,
                    itemBuilder: (_, index) => _PlanCard(plan: plans[index]),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  itemCount: plans.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (_, index) => _PlanCard(plan: plans[index]),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomText(
                  text: plan.displayName,
                  color: Colors.white,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  maxline: 2,
                ),
              ),
              if (plan.hasAllAccess)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.greenColor),
                  ),
                  child: CustomText(
                    text: 'All access',
                    color: AppColors.greenColor,
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: _priceText(plan),
                color: Colors.white,
                fontsize: 34.sp,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: CustomText(
                  text: plan.billingLabel,
                  color: Colors.white.withValues(alpha: 0.62),
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _PlanDetail(icon: Icons.schedule, text: plan.durationLabel),
          SizedBox(height: 8.h),
          _PlanDetail(
            icon: Icons.card_membership_outlined,
            text: plan.code.isEmpty ? 'Subscription plan' : plan.code,
          ),
          if (plan.trialPeriodDays > 0) ...[
            SizedBox(height: 8.h),
            _PlanDetail(
              icon: Icons.workspace_premium_outlined,
              text: '${plan.trialPeriodDays} day trial included',
            ),
          ],
          SizedBox(height: 14.h),
          CustomText(
            text: plan.description.isEmpty
                ? 'Unlock learning topics, materials, progress tracking, and quizzes.'
                : plan.description,
            color: Colors.white.withValues(alpha: 0.72),
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            maxline: 3,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  String _priceText(SubscriptionPlan plan) {
    if (plan.price <= 0) {
      return 'Free';
    }

    final price = plan.price.truncateToDouble() == plan.price
        ? plan.price.toInt().toString()
        : plan.price.toStringAsFixed(2);
    return '${plan.currency.toUpperCase()} $price';
  }
}

class _PlanDetail extends StatelessWidget {
  const _PlanDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.greenColor, size: 18.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomText(
            text: text,
            color: Colors.white.withValues(alpha: 0.82),
            fontsize: 13.sp,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
            maxline: 2,
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 46.r),
            SizedBox(height: 14.h),
            CustomText(
              text: message,
              color: Colors.white,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              maxline: 4,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: CustomText(
                text: 'Try again',
                color: Colors.white,
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.greenColor,
      onRefresh: onRefresh,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        children: [
          SizedBox(height: 160.h),
          Icon(
            Icons.card_membership_outlined,
            color: Colors.white.withValues(alpha: 0.7),
            size: 48.r,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: 'No subscription plans are available right now.',
            color: Colors.white.withValues(alpha: 0.82),
            fontsize: 14.sp,
            fontWeight: FontWeight.w500,
            maxline: 3,
          ),
        ],
      ),
    );
  }
}
