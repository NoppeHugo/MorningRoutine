import 'package:flutter/material.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../routine_builder/data/blocks_repository.dart';
import '../../../routine_builder/domain/block_model.dart';
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
    final langCode = Localizations.localeOf(context).languageCode;
    const maxPreviewBlocks = 3;
    final remainingCount = routine.blocks.length - maxPreviewBlocks;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row ────────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.name,
                      style: AppTypography.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: AppSpacing.iconXs,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          AppI18n.tf('preview.totalDurationFmt', langCode, {
                            'minutes': '${routine.totalDurationMinutes}',
                          }),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Edit button, compact
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: AppSpacing.iconSm,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.separator, height: 1),
          const SizedBox(height: AppSpacing.md),

          // Block list preview ─────────────────────────────────────────────
          ...routine.blocks.take(maxPreviewBlocks).map(
                (block) => _BlockPreviewRow(block: block),
              ),

          if (remainingCount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const SizedBox(width: AppSpacing.xl + AppSpacing.sm),
                Text(
                  AppI18n.tf('preview.moreBlocksFmt', langCode, {
                    'count': '$remainingCount',
                    'suffix': remainingCount > 1 ? 's' : '',
                  }),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BlockPreviewRow extends StatelessWidget {
  const _BlockPreviewRow({required this.block});

  final BlockModel block;

  @override
  Widget build(BuildContext context) {
    final template = BlocksRepository.findById(block.templateId);
    final icon = template?.icon ?? Icons.star_rounded;
    final categoryColor = template?.category.color ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          // Icon pill
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(
              icon,
              size: AppSpacing.iconSm,
              color: categoryColor,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Name
          Expanded(
            child: Text(
              block.name,
              style: AppTypography.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Duration chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '${block.durationMinutes} min',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
