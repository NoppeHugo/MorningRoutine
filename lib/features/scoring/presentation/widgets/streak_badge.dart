import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
 
class StreakBadge extends StatelessWidget {
  const StreakBadge({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
  });
 
  final int currentStreak;
  final int bestStreak;
 
  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: currentStreak > 0
          ? AppColors.streak.withValues(alpha: 0.1)
          : AppColors.surface,
      child: Row(
        children: [
          Text(
            currentStreak > 0 ? '🔥' : '💤',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentStreak > 0
                      ? '$currentStreak jour${currentStreak > 1 ? 's' : ''} de streak'
                      : 'Pas de streak',
                  style: AppTypography.headingSmall.copyWith(
                    color: currentStreak > 0
                        ? AppColors.streak
                        : AppColors.textSecondary,
                  ),
                ),
                if (bestStreak > 0) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Meilleur: $bestStreak jour${bestStreak > 1 ? 's' : ''}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
