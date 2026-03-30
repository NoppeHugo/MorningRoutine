import 'package:flutter/material.dart';
 
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
 
class EmptyRoutinePlaceholder extends StatelessWidget {
  const EmptyRoutinePlaceholder({super.key});
 
  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🌅',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppI18n.t('emptyRoutine.title', langCode),
              style: AppTypography.headingSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppI18n.t('emptyRoutine.sub', langCode),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
