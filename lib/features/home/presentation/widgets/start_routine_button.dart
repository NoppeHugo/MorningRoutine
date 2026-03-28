import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      height: 56,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: hasCompletedToday
                ? null
                : const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                  ),
            color: hasCompletedToday ? AppColors.secondary : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: hasCompletedToday
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasCompletedToday
                    ? CupertinoIcons.refresh
                    : CupertinoIcons.play_fill,
                color: AppColors.textOnPrimary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                hasCompletedToday ? 'Refaire la routine' : 'Commencer',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
