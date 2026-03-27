import 'package:flutter/material.dart';
 
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
 
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5,
        children: AppConstants.durationOptions.map((duration) {
          final isSelected = selectedDuration == duration;
          final label = AppConstants.durationLabels[duration] ?? '';
          return _DurationCard(
            duration: duration,
            label: label,
            isSelected: isSelected,
            onTap: () => onDurationSelected(duration),
          );
        }).toList(),
      ),
    );
  }
}
 
class _DurationCard extends StatelessWidget {
  const _DurationCard({
    required this.duration,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
 
  final int duration;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: isSelected
              ? null
              : Border.all(color: AppColors.surfaceLight, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${duration}min',
              style: AppTypography.headingMedium.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary.withValues(alpha: 0.8)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
