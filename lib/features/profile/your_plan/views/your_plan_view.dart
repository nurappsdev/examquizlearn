import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../../core/widgets/custom_text.dart';
import '../controllers/your_plan_controller.dart';
import '../model/my_subscription_model.dart';

class YourPlanView extends GetView<YourPlanController> {
  const YourPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Your Plan',
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
          if (controller.isLoading.value) {
            return const Center(child: CustomLoader());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return _ErrorState(
              message: controller.errorMessage.value,
              onRetry: controller.fetchSubscription,
            );
          }

          final sub = controller.subscription.value;
          if (sub == null) {
            return _EmptyState(onRefresh: controller.fetchSubscription);
          }

          return RefreshIndicator(
            color: AppColors.greenColor,
            backgroundColor: const Color(0xff222222),
            onRefresh: controller.fetchSubscription,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              children: [
                _ActivePlanCard(subscription: sub),
                SizedBox(height: 20.h),
                _BillingDetails(subscription: sub),
                SizedBox(height: 24.h),
                _BrowsePlansButton(),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ActivePlanCard extends StatelessWidget {
  const _ActivePlanCard({required this.subscription});

  final MySubscription subscription;

  @override
  Widget build(BuildContext context) {
    final plan = subscription.plan;
    final price = plan?.price ?? 0;
    final currency = (plan?.currency ?? subscription.currency ?? 'USD')
        .toUpperCase();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.greenColor.withOpacity(0.22),
            AppColors.greenColor.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.greenColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded,
                        color: Colors.black, size: 14.r),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: 'Current Plan',
                      color: Colors.black,
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _StatusChip(status: subscription.status),
            ],
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: plan?.displayName ?? 'Subscription',
            color: Colors.white,
            fontsize: 26.sp,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.start,
            maxline: 2,
          ),
          if ((plan?.description ?? '').isNotEmpty) ...[
            SizedBox(height: 6.h),
            CustomText(
              text: plan!.description!,
              color: Colors.white.withOpacity(0.75),
              fontsize: 13.sp,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
              maxline: 3,
            ),
          ],
          SizedBox(height: 18.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: price <= 0 ? 'Free' : '$currency ${_formatPrice(price)}',
                color: Colors.white,
                fontsize: 30.sp,
                fontWeight: FontWeight.w800,
              ),
              if (price > 0) ...[
                SizedBox(width: 6.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: CustomText(
                    text: plan?.billingLabel ?? '',
                    color: Colors.white.withOpacity(0.65),
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          if (plan?.hasAllAccess == true)
            _PlanDetail(
              icon: Icons.workspace_premium_outlined,
              text: 'All-access membership',
            ),
          if ((plan?.durationDays ?? 0) > 0) ...[
            SizedBox(height: 8.h),
            _PlanDetail(
              icon: Icons.schedule_rounded,
              text: '${plan!.durationDays} days access',
            ),
          ],
          if ((plan?.trialPeriodDays ?? 0) > 0) ...[
            SizedBox(height: 8.h),
            _PlanDetail(
              icon: Icons.bolt_rounded,
              text: '${plan!.trialPeriodDays} day trial included',
            ),
          ],
          SizedBox(height: 16.h),
          _ValidityBar(subscription: subscription),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price.truncateToDouble() == price) {
      return price.toInt().toString();
    }
    return price.toStringAsFixed(2);
  }
}

class _ValidityBar extends StatelessWidget {
  const _ValidityBar({required this.subscription});

  final MySubscription subscription;

  @override
  Widget build(BuildContext context) {
    final start =
        subscription.currentPeriodStart ?? subscription.startedAt;
    final end = subscription.currentPeriodEnd ?? subscription.expiresAt;

    if (start == null || end == null) {
      return const SizedBox.shrink();
    }

    final total = end.difference(start).inSeconds;
    final elapsed = DateTime.now().difference(start).inSeconds;
    final ratio = total <= 0
        ? 0.0
        : (elapsed / total).clamp(0.0, 1.0).toDouble();
    final daysLeft = subscription.daysRemaining;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: _formatDate(start),
              color: Colors.white.withOpacity(0.7),
              fontsize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text: daysLeft > 0
                  ? '$daysLeft day${daysLeft == 1 ? '' : 's'} left'
                  : 'Expired',
              color: daysLeft > 0
                  ? AppColors.greenColor
                  : AppColors.redColor,
              fontsize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: _formatDate(end),
              color: Colors.white.withOpacity(0.7),
              fontsize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6.h,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.greenColor),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      DateFormat('MMM d, yyyy').format(date.toLocal());
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final normalized = (status ?? '').toLowerCase();
    Color color;
    String label;
    switch (normalized) {
      case 'active':
        color = AppColors.greenColor;
        label = 'Active';
        break;
      case 'trialing':
        color = Colors.amberAccent;
        label = 'Trialing';
        break;
      case 'past_due':
        color = Colors.orangeAccent;
        label = 'Past Due';
        break;
      case 'canceled':
      case 'cancelled':
        color = AppColors.redColor;
        label = 'Cancelled';
        break;
      case 'incomplete':
        color = Colors.amber;
        label = 'Incomplete';
        break;
      default:
        color = Colors.white.withOpacity(0.6);
        label = status?.isNotEmpty == true ? status! : '—';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: CustomText(
        text: label,
        color: color,
        fontsize: 11.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BillingDetails extends StatelessWidget {
  const _BillingDetails({required this.subscription});

  final MySubscription subscription;

  @override
  Widget build(BuildContext context) {
    final amount = subscription.amountPaid ?? 0;
    final currency = (subscription.currency ?? 'USD').toUpperCase();
    final amountText = amount <= 0
        ? 'Free / trial'
        : '$currency ${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';

    final ref = subscription.paymentRef ?? '';
    final maskedRef = ref.length > 14
        ? '${ref.substring(0, 6)}…${ref.substring(ref.length - 6)}'
        : ref;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Billing details',
            color: Colors.white,
            fontsize: 15.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 12.h),
          _DetailRow(label: 'Amount paid', value: amountText),
          if (subscription.paymentProvider?.isNotEmpty == true)
            _DetailRow(
              label: 'Payment provider',
              value: subscription.paymentProvider!.capitalizeFirst ??
                  subscription.paymentProvider!,
            ),
          if (subscription.startedAt != null)
            _DetailRow(
              label: 'Started on',
              value: DateFormat('MMM d, yyyy')
                  .format(subscription.startedAt!.toLocal()),
            ),
          if (subscription.expiresAt != null)
            _DetailRow(
              label: 'Expires on',
              value: DateFormat('MMM d, yyyy')
                  .format(subscription.expiresAt!.toLocal()),
            ),
          if (subscription.isCancellationRequested)
            _DetailRow(
              label: 'Cancellation requested',
              value: DateFormat('MMM d, yyyy')
                  .format(subscription.cancellationRequestedAt!.toLocal()),
              valueColor: AppColors.redColor,
            ),
          if (maskedRef.isNotEmpty)
            _DetailRow(label: 'Reference', value: maskedRef),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.w,
            child: CustomText(
              text: label,
              color: Colors.white.withOpacity(0.6),
              fontsize: 12.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              color: valueColor ?? Colors.white,
              fontsize: 12.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              maxline: 2,
            ),
          ),
        ],
      ),
    );
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
        Icon(icon, color: AppColors.greenColor, size: 18.r),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomText(
            text: text,
            color: Colors.white.withOpacity(0.85),
            fontsize: 13.sp,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class _BrowsePlansButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton.icon(
        onPressed: () => Get.toNamed(AppRoutes.subscriptionScreen),
        icon: Icon(Icons.list_alt_rounded,
            color: AppColors.greenColor, size: 18.r),
        label: CustomText(
          text: 'Browse all plans',
          color: AppColors.greenColor,
          fontsize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.greenColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
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
          SizedBox(height: 120.h),
          Icon(Icons.workspace_premium_outlined,
              color: Colors.white.withOpacity(0.7), size: 56.r),
          SizedBox(height: 16.h),
          CustomText(
            text: 'You don\'t have an active plan yet.',
            color: Colors.white.withOpacity(0.85),
            fontsize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Choose a plan that fits your learning goals.',
            color: Colors.white.withOpacity(0.55),
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 50.h,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.subscriptionScreen),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: CustomText(
                text: 'View plans',
                color: Colors.white,
                fontsize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                color: AppColors.redColor, size: 46.r),
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
                padding:
                    EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
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
