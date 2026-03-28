import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class DurationSelector extends StatelessWidget {
  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onDurationSelected,
  });

  final int? selectedDuration;
  final ValueChanged<int> onDurationSelected;

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> children = {
      for (final duration in AppConstants.durationOptions)
        duration: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${duration}min',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selectedDuration == duration
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                AppConstants.durationLabels[duration] ?? '',
                style: TextStyle(
                  fontSize: 11,
                  color: selectedDuration == duration
                      ? AppColors.textOnPrimary.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoSlidingSegmentedControl<int>(
            groupValue: selectedDuration,
            backgroundColor: AppColors.surfaceLight,
            thumbColor: AppColors.primary,
            children: children,
            onValueChanged: (value) {
              if (value != null) {
                HapticFeedback.lightImpact();
                onDurationSelected(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
