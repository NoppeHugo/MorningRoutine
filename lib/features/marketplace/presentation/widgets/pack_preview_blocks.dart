import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/expert_pack_model.dart';

class PackPreviewBlocks extends StatelessWidget {
  const PackPreviewBlocks({
    super.key,
    required this.blocks,
    required this.previewBlockCount,
    required this.isUnlocked,
  });

  final List<PackBlock> blocks;
  final int previewBlockCount;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Column(
        children: [
          for (int i = 0; i < blocks.length; i++) ...[
            _buildBlockRow(blocks[i], i),
            if (i < blocks.length - 1)
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: AppColors.surfaceLight,
                indent: AppSpacing.lg,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildBlockRow(PackBlock block, int index) {
    final unlocked = isUnlocked || index < previewBlockCount;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Emoji
          Text(
            unlocked ? block.emoji : '🔒',
            style: TextStyle(
              fontSize: 22,
              color: unlocked ? null : AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Name
          Expanded(
            child: Text(
              unlocked ? block.name : '???',
              style: AppTypography.bodyMedium.copyWith(
                color: unlocked
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
          ),
          // Duration
          Text(
            '${block.durationMinutes} min',
            style: AppTypography.bodySmall.copyWith(
              color: unlocked
                  ? AppColors.textSecondary
                  : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
