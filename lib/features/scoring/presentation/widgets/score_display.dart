import 'package:flutter/material.dart';
 
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/score_model.dart';
 
class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({
    super.key,
    required this.score,
  });
 
  final DailyScore? score;
 
  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;

    if (score == null) {
      return AppCard(
        child: Row(
          children: [
            const Text('○', style: TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.sm),
            Text(
              AppI18n.t('score.notDoneToday', langCode),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
 
    final percent = score!.scorePercent;
    final color = percent >= 80 ? AppColors.secondary : AppColors.warning;
 
    return AppCard(
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$percent% - ${percent >= 80 ? AppI18n.t('score.goodJob', langCode) : AppI18n.t('score.canImprove', langCode)}',
                  style: AppTypography.labelMedium.copyWith(color: color),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  AppI18n.tf('score.blocksDoneFmt', langCode, {
                    'completed': '${score!.completedBlocks}',
                    'total': '${score!.totalBlocks}',
                  }),
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
