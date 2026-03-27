import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../routine_builder/domain/routine_model.dart';
 
class RoutinePreviewCard extends StatelessWidget {
  const RoutinePreviewCard({
    super.key,
    required this.routine,
    required this.onEdit,
  });
 
  final RoutineModel routine;
  final VoidCallback onEdit;
 
  @override
  Widget build(BuildContext context) {
    final maxPreviewBlocks = 3;
    final remainingCount = routine.blocks.length - maxPreviewBlocks;
 
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${routine.name} (${routine.totalDurationMinutes}min)',
                style: AppTypography.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
 
          // Block list preview
          ...routine.blocks.take(maxPreviewBlocks).map(
                (block) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Text(block.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          block.name,
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                      Text(
                        '${block.durationMinutes}min',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
 
          if (remainingCount > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '... +$remainingCount autre${remainingCount > 1 ? 's' : ''}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
 
          const SizedBox(height: AppSpacing.md),
 
          // Edit button
          Center(
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: AppSpacing.iconSm),
              label: const Text('Modifier'),
            ),
          ),
        ],
      ),
    );
  }
}
