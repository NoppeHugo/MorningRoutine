import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
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
      child: AppGlassContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        radius: 18,
        child: Row(
          children: [
            // Drag handle
            const Icon(
              Icons.drag_handle,
              color: Color(0xB9E8ECF2),
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
                    style: AppTypography.labelMedium.copyWith(
                      color: const Color(0xFFF2F4F7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${block.durationMinutes} min',
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xD3E5EAF1),
                    ),
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
                color: Color(0xC4E5EAF1),
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
          color: isDisabled ? const Color(0x2FF8FAFF) : const Color(0x45F8FAFF),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(color: const Color(0x55F2F5FA)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDisabled
              ? const Color(0x92E2E8F0)
              : const Color(0xFFF2F4F7),
        ),
      ),
    );
  }
}
