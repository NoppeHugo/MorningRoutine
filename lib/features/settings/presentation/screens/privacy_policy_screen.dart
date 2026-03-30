import 'package:flutter/material.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return AppScaffold(
      title: AppI18n.t('privacy.title', langCode),
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            AppI18n.t('privacy.heading', langCode),
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppI18n.t('privacy.updated', langCode),
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          _Section(
            title: AppI18n.t('privacy.summary.title', langCode),
            body: AppI18n.t('privacy.summary.body', langCode),
          ),

          _Section(
            title: AppI18n.t('privacy.collected.title', langCode),
            body: AppI18n.t('privacy.collected.body', langCode),
          ),

          _Section(
            title: AppI18n.t('privacy.subscriptions.title', langCode),
            body: AppI18n.t('privacy.subscriptions.body', langCode),
          ),

          _Section(
            title: AppI18n.t('privacy.notifications.title', langCode),
            body: AppI18n.t('privacy.notifications.body', langCode),
          ),

          _Section(
            title: AppI18n.t('privacy.ads.title', langCode),
            body: AppI18n.t('privacy.ads.body', langCode),
          ),

          _Section(
            title: AppI18n.t('privacy.minors.title', langCode),
            body: AppI18n.t('privacy.minors.body', langCode),
          ),

          _Section(
            title: AppI18n.t('privacy.contact.title', langCode),
            body: AppI18n.t('privacy.contact.body', langCode),
          ),

          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 24,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    AppI18n.t('privacy.badge', langCode),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
