import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../model/leaderboard_model.dart';
import 'leaderboard_avatar.dart';

class MyStatusCard extends StatelessWidget {
  const MyStatusCard({
    super.key,
    required this.entry,
    required this.isLoading,
  });

  final LeaderboardEntry? entry;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.greenColor.withOpacity(0.85),
            AppColors.greenColor.withOpacity(0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isLoading && entry == null
          ? _LoadingRow()
          : _StatusRow(entry: entry),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.entry});

  final LeaderboardEntry? entry;

  @override
  Widget build(BuildContext context) {
    final hasEntry = entry != null;
    final fullName = entry?.fullName?.trim().isNotEmpty == true
        ? entry!.fullName!
        : 'You';
    final score = entry?.totalScore ?? 0;
    final rank = entry?.rank;

    return Row(
      children: [
        LeaderboardAvatar(
          avatarUrl: entry?.avatarUrl,
          size: 64.r,
          borderColor: Colors.white,
          borderWidth: 2,
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'My Status',
                color: Colors.white.withOpacity(0.9),
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: fullName,
                color: Colors.white,
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
                maxline: 1,
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.star_rounded,
                      color: Colors.amberAccent, size: 18.r),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: '$score pts',
                    color: Colors.white,
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Column(
            children: [
              CustomText(
                text: 'Rank',
                color: Colors.white.withOpacity(0.85),
                fontsize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: hasEntry && rank != null ? '#$rank' : '—',
                color: Colors.white,
                fontsize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.r,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
