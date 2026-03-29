import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Confidentialité',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Politique de confidentialité',
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Dernière mise à jour : Mars 2026',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          _Section(
            title: 'Résumé',
            body:
                'Morning Routine ne collecte aucune donnée personnelle. '
                'Toutes tes données restent sur ton appareil. '
                'Nous ne vendons, ne partageons et ne transmettons aucune information à des tiers.',
          ),

          _Section(
            title: '1. Données collectées',
            body:
                'Morning Routine ne collecte aucune donnée personnelle identifiable.\n\n'
                'Les seules données créées sont :\n'
                '• Ta routine (blocs, durées) — stockée localement sur ton iPhone\n'
                '• Tes scores quotidiens et streak — stockés localement\n'
                '• Tes préférences (heure de réveil, notifications) — stockées localement\n\n'
                'Aucune de ces données ne quitte ton appareil.',
          ),

          _Section(
            title: '2. Abonnements (RevenueCat)',
            body:
                'Si tu souscris à Morning Routine Pro, ta transaction est gérée par Apple '
                'via l\'App Store. RevenueCat est utilisé uniquement pour vérifier le statut '
                'de ton abonnement. RevenueCat peut recevoir un identifiant anonyme d\'appareil '
                'à cet effet. Consulte la politique de RevenueCat : revenuecat.com/privacy',
          ),

          _Section(
            title: '3. Notifications',
            body:
                'Les notifications sont gérées localement par iOS. '
                'Aucune notification n\'est envoyée depuis nos serveurs. '
                'Tu peux désactiver les notifications à tout moment dans les Réglages iOS.',
          ),

          _Section(
            title: '4. Publicité et tracking',
            body:
                'Morning Routine ne contient aucune publicité.\n'
                'Aucun SDK de tracking publicitaire (Facebook, Google Ads, etc.) n\'est intégré.',
          ),

          _Section(
            title: '5. Mineurs',
            body:
                'Morning Routine ne collecte pas de données. '
                'L\'application est utilisable par tous les âges.',
          ),

          _Section(
            title: '6. Contact',
            body:
                'Pour toute question concernant ta confidentialité, contacte-nous à :\n'
                'privacy@morningroutineapp.com',
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
                    'Aucune donnée personnelle collectée.\nTout reste sur ton iPhone.',
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
