import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';
import '../model/quiz_attempt_model.dart';

class QuizAttemptCard extends StatelessWidget {
  const QuizAttemptCard({super.key, required this.attempt});

  final QuizAttempt attempt;

  @override
  Widget build(BuildContext context) {
    final inProgress = attempt.isInProgress;
    final score = attempt.score ?? 0;
    final maxScore = attempt.maxScore ?? 0;
    final progress = attempt.progressRatio;
    final correct = attempt.correctCount ?? 0;
    final incorrect = attempt.incorrectCount ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: inProgress
              ? AppColors.greenColor.withOpacity(0.45)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.greenColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  color: AppColors.greenColor,
                  size: 18.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: _displayTitle(attempt),
                      color: Colors.white,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      maxline: 1,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: _startedLabel(attempt),
                      color: Colors.white.withOpacity(0.55),
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start,
                      maxline: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _StatusChip(status: attempt.status),
            ],
          ),
          SizedBox(height: 12.h),
          if (maxScore > 0) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6.h,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        inProgress
                            ? AppColors.greenColor.withOpacity(0.85)
                            : AppColors.greenColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                CustomText(
                  text: '$score / $maxScore',
                  color: Colors.white,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
          Row(
            children: [
              _CountBadge(
                icon: Icons.check_circle_rounded,
                color: AppColors.greenColor,
                label: '$correct correct',
              ),
              SizedBox(width: 8.w),
              _CountBadge(
                icon: Icons.cancel_rounded,
                color: AppColors.redColor,
                label: '$incorrect wrong',
              ),
            ],
          ),
          if (inProgress && attempt.expiresAt != null) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.timer_outlined,
                    color: Colors.amberAccent, size: 14.r),
                SizedBox(width: 6.w),
                CustomText(
                  text: 'Expires ${_formatRelative(attempt.expiresAt!)}',
                  color: Colors.amberAccent.withOpacity(0.85),
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
          if (inProgress) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _continueQuiz(attempt),
                icon: Icon(Icons.play_arrow_rounded, size: 18.r),
                label: CustomText(
                  text: 'Continue Quiz',
                  color: Colors.white,
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _displayTitle(QuizAttempt attempt) {
    final title = attempt.quizTitle?.trim();
    if (title != null && title.isNotEmpty) return title;
    final id = attempt.quizId;
    if (id != null && id.isNotEmpty) {
      final shortId = id.length > 8 ? id.substring(id.length - 6) : id;
      return 'Quiz Attempt #$shortId';
    }
    return 'Quiz Attempt';
  }

  String _startedLabel(QuizAttempt attempt) {
    final started = attempt.startedAt;
    if (started == null) return 'Started -';
    return 'Started ${DateFormat('MMM d, h:mm a').format(started.toLocal())}';
  }

  String _formatRelative(DateTime target) {
    final now = DateTime.now();
    final diff = target.difference(now);
    if (diff.isNegative) {
      return 'expired';
    }
    if (diff.inMinutes < 1) return 'soon';
    if (diff.inHours < 1) return 'in ${diff.inMinutes}m';
    if (diff.inDays < 1) return 'in ${diff.inHours}h';
    return 'in ${diff.inDays}d';
  }

  void _continueQuiz(QuizAttempt attempt) {
    final attemptId = attempt.effectiveAttemptId;
    final quizId = attempt.quizId ?? '';
    if (attemptId.isEmpty && quizId.isEmpty) return;

    Get.toNamed(AppRoutes.quiz, arguments: {
      if (quizId.isNotEmpty) 'quizId': quizId,
      if (quizId.isNotEmpty) 'id': quizId,
      if (attemptId.isNotEmpty) 'attemptId': attemptId,
      if (attempt.quizTitle != null) 'title': attempt.quizTitle,
    });
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final normalized = (status ?? '').toLowerCase();
    final isInProgress = normalized == 'in_progress';
    final isCompleted = normalized == 'completed';

    final color = isInProgress
        ? Colors.amberAccent
        : isCompleted
            ? AppColors.greenColor
            : Colors.white.withOpacity(0.5);
    final label = isInProgress
        ? 'In Progress'
        : isCompleted
            ? 'Completed'
            : (status ?? '—');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: CustomText(
        text: label,
        color: color,
        fontsize: 10.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.r),
          SizedBox(width: 4.w),
          CustomText(
            text: label,
            color: color,
            fontsize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
