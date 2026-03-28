import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          onTap: () {
            HapticFeedback.lightImpact();
            onGoalToggled(goal.id);
          },
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
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 150),
      builder: (context, scale, child) => Transform.scale(
        scale: scale,
        child: child,
      ),
      child: _GoalTileContent(
        goal: goal,
        isSelected: isSelected,
        onTap: onTap,
      ),
    );
  }
}

class _GoalTileContent extends StatefulWidget {
  const _GoalTileContent({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_GoalTileContent> createState() => _GoalTileContentState();
}

class _GoalTileContentState extends State<_GoalTileContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.02), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.primary : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          child: Row(
            children: [
              Text(
                widget.goal.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                widget.goal.label,
                style: AppTypography.bodyLarge.copyWith(
                  color: widget.isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                widget.isSelected
                    ? CupertinoIcons.checkmark_circle_fill
                    : CupertinoIcons.circle,
                color: widget.isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textTertiary,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
