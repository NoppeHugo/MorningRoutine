import 'package:flutter/material.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class StartRoutineButton extends StatelessWidget {
  const StartRoutineButton({
    super.key,
    required this.hasCompletedToday,
    required this.onPressed,
    this.totalDurationMinutes,
    required this.langCode,
  });

  final bool hasCompletedToday;
  final VoidCallback onPressed;

  /// Optional total routine duration shown as subtitle.
  final int? totalDurationMinutes;
  final String langCode;

  @override
  Widget build(BuildContext context) {
    final isCompleted = hasCompletedToday;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            gradient: isCompleted
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
            color: isCompleted ? AppColors.surfaceLight : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            boxShadow: isCompleted
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      offset: const Offset(0, 6),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCompleted
                        ? Icons.replay_rounded
                        : Icons.play_circle_filled_rounded,
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textOnPrimary,
                    size: AppSpacing.iconLg,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    isCompleted
                        ? AppI18n.t('start.redo', langCode)
                        : AppI18n.t('start.launch', langCode),
                    style: AppTypography.labelLarge.copyWith(
                      color: isCompleted
                          ? AppColors.textSecondary
                          : AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              if (totalDurationMinutes != null && totalDurationMinutes! > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatDuration(totalDurationMinutes!),
                  style: AppTypography.bodySmall.copyWith(
                    color: isCompleted
                        ? AppColors.textTertiary
                        : AppColors.textOnPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h $m min';
  }
}
