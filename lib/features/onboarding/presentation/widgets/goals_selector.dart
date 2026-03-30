import 'package:flutter/material.dart';
 
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
 
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
      child: AnimatedScale(
        scale: isSelected ? 1.0 : 0.985,
        duration: const Duration(milliseconds: 200),
        child: AppGlassContainer(
          radius: AppSpacing.radiusMedium,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          color: isSelected ? const Color(0x3BF6F8FF) : const Color(0x24F8FAFF),
          borderColor: isSelected ? const Color(0xA3F2F5FA) : const Color(0x66F2F5FA),
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
                  color: const Color(0xFFF3F6FB),
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFFF3F6FB),
                  size: AppSpacing.iconMd,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
