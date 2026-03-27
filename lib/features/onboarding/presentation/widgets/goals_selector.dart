import 'package:flutter/material.dart';
 
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
 
class GoalsSelector extends StatelessWidget {
  const GoalsSelector({
    super.key,
    required this.selectedGoals,
    required this.onGoalToggled,
  });
 
  final List<String> selectedGoals;
  final ValueChanged<String> onGoalToggled;
 
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: AppConstants.goalOptions.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final goal = AppConstants.goalOptions[index];
        final isSelected = selectedGoals.contains(goal.id);
        return _GoalTile(
          goal: goal,
          isSelected: isSelected,
          onTap: () => onGoalToggled(goal.id),
        );
      },
    );
  }
}
 
class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });
 
  final GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: isSelected
              ? null
              : Border.all(color: AppColors.surfaceLight, width: 1),
        ),
        child: Row(
          children: [
            Text(
              goal.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              goal.label,
              style: AppTypography.bodyLarge.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.textOnPrimary,
                size: AppSpacing.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}
