import 'package:flutter/material.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
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
          AppGlassContainer(
            padding: const EdgeInsets.all(AppSpacing.md),
            radius: AppSpacing.radiusMedium,
            color: const Color(0x24F8FAFF),
            borderColor: const Color(0x66F2F5FA),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 24,
                  color: Color(0xFFF2F5FA),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    AppI18n.t('privacy.badge', langCode),
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xDDE7EDF3),
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
      child: AppGlassContainer(
        padding: const EdgeInsets.all(AppSpacing.md),
        radius: AppSpacing.radiusLarge,
        color: const Color(0x20F8FAFF),
        borderColor: const Color(0x66F2F5FA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: const Color(0xFFF2F5FA),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: AppTypography.bodyMedium.copyWith(
                color: const Color(0xDCE3EAF5),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
