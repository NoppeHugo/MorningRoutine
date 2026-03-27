import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
 
class StartRoutineButton extends StatelessWidget {
  const StartRoutineButton({
    super.key,
    required this.hasCompletedToday,
    required this.onPressed,
  });
 
  final bool hasCompletedToday;
  final VoidCallback onPressed;
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: hasCompletedToday
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6C5CE7),
                      Color(0xFF8B7CF7),
                    ],
                  ),
            color: hasCompletedToday ? AppColors.surfaceLight : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            boxShadow: hasCompletedToday
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 16,
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasCompletedToday
                    ? Icons.replay_rounded
                    : Icons.play_arrow_rounded,
                color: hasCompletedToday
                    ? AppColors.textTertiary
                    : AppColors.textOnPrimary,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                hasCompletedToday ? 'Refaire' : 'Commencer',
                style: AppTypography.labelLarge.copyWith(
                  color: hasCompletedToday
                      ? AppColors.textTertiary
                      : AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
