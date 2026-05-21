import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/custom_text.dart';
import '../model/leaderboard_model.dart';
import 'leaderboard_avatar.dart';

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({super.key, required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank ?? 0;
    final isTopThree = rank >= 1 && rank <= 3;
    final fullName = entry.fullName?.trim().isNotEmpty == true
        ? entry.fullName!
        : 'Unknown';
    final email = entry.email ?? '';
    final score = entry.totalScore ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isTopThree
              ? _badgeColor(rank).withOpacity(0.5)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          _RankBadge(rank: rank),
          SizedBox(width: 12.w),
          LeaderboardAvatar(
            avatarUrl: entry.avatarUrl,
            size: 48.r,
            borderColor: isTopThree ? _badgeColor(rank) : null,
            borderWidth: 1.5,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: fullName,
                  color: Colors.white,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  maxline: 1,
                ),
                if (email.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  CustomText(
                    text: email,
                    color: Colors.white.withOpacity(0.6),
                    fontsize: 11.sp,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    maxline: 1,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: '$score',
                color: Colors.white,
                fontsize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                text: 'pts',
                color: Colors.white.withOpacity(0.5),
                fontsize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Color _badgeColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xffFFD54F);
      case 2:
        return const Color(0xffBDC3C7);
      case 3:
        return const Color(0xffCD7F32);
      default:
        return Colors.white;
    }
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final isTop = rank >= 1 && rank <= 3;
    final color = LeaderboardItem._badgeColor(rank);

    if (isTop) {
      return Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.65)],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.emoji_events,
          color: Colors.black87,
          size: 20.r,
        ),
      );
    }

    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      alignment: Alignment.center,
      child: CustomText(
        text: rank > 0 ? '$rank' : '-',
        color: Colors.white,
        fontsize: 13.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
