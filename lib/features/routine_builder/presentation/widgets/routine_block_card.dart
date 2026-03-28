import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/block_model.dart';

class RoutineBlockCard extends StatelessWidget {
  const RoutineBlockCard({
    super.key,
    required this.block,
    required this.onDelete,
    required this.onDurationChanged,
  });

  final BlockModel block;
  final VoidCallback onDelete;
  final ValueChanged<int> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Drag handle
            const Icon(
              CupertinoIcons.line_horizontal_3,
              color: AppColors.textTertiary,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.sm),

            // Emoji
            Text(
              block.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Name and duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    block.name,
                    style: AppTypography.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${block.durationMinutes} min',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),

            // Duration controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: block.durationMinutes > 1
                      ? () {
                          HapticFeedback.lightImpact();
                          onDurationChanged(block.durationMinutes - 1);
                        }
                      : null,
                  child: Icon(
                    CupertinoIcons.minus_circle,
                    size: 20,
                    color: block.durationMinutes > 1
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  child: Text(
                    '${block.durationMinutes}',
                    style: AppTypography.labelMedium,
                  ),
                ),
                GestureDetector(
                  onTap: block.durationMinutes < 60
                      ? () {
                          HapticFeedback.lightImpact();
                          onDurationChanged(block.durationMinutes + 1);
                        }
                      : null,
                  child: Icon(
                    CupertinoIcons.plus_circle,
                    size: 20,
                    color: block.durationMinutes < 60
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),

            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: const Icon(
                CupertinoIcons.xmark,
                color: AppColors.textTertiary,
                size: AppSpacing.iconSm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
