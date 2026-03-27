import 'package:flutter/material.dart';
 
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
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Row(
          children: [
            // Drag handle
            const Icon(
              Icons.drag_handle,
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
                _DurationButton(
                  icon: Icons.remove,
                  onPressed: block.durationMinutes > 1
                      ? () => onDurationChanged(block.durationMinutes - 1)
                      : null,
                ),
                const SizedBox(width: AppSpacing.xs),
                _DurationButton(
                  icon: Icons.add,
                  onPressed: block.durationMinutes < 60
                      ? () => onDurationChanged(block.durationMinutes + 1)
                      : null,
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
 
            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.close,
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
 
class _DurationButton extends StatelessWidget {
  const _DurationButton({
    required this.icon,
    this.onPressed,
  });
 
  final IconData icon;
  final VoidCallback? onPressed;
 
  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.surfaceLight.withValues(alpha: 0.5)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDisabled ? AppColors.textTertiary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
