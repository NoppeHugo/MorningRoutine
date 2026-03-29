import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import 'premium_controller.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isAnnual = true;
  bool _isPurchasing = false;

  @override
  Widget build(BuildContext context) {
    final premiumState = ref.watch(premiumControllerProvider);

    if (premiumState.isPremium) {
      return _buildAlreadyPremium();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Header
                    _buildHeader()
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -0.2, end: 0),

                    const SizedBox(height: AppSpacing.xl),

                    // Feature list
                    _buildFeatures()
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 150.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: AppSpacing.xl),

                    // Pricing toggle
                    _buildPricingToggle(premiumState)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 250.ms),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // CTA section
            _buildCTA(premiumState)
                .animate()
                .fadeIn(duration: 400.ms, delay: 350.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text('🌅', style: TextStyle(fontSize: 40)),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Morning Routine Pro',
          style: AppTypography.headingLarge.copyWith(
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [AppColors.primaryLight, AppColors.secondary],
              ).createShader(const Rect.fromLTWH(0, 0, 300, 60)),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Débloque ton plein potentiel matinal',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    final features = [
      _FeatureItem(
        emoji: '∞',
        title: 'Blocs illimités',
        subtitle: 'Jusqu\'à 10 blocs dans ta routine (gratuit : 3)',
      ),
      _FeatureItem(
        emoji: '📊',
        title: 'Historique complet',
        subtitle: 'Consulte tes stats des 30 derniers jours',
      ),
      _FeatureItem(
        emoji: '🎯',
        title: 'Routines d\'experts',
        subtitle: 'Accède aux routines des meilleurs performers (bientôt)',
      ),
      _FeatureItem(
        emoji: '🔔',
        title: 'Rappels avancés',
        subtitle: 'Notifications personnalisées par bloc (bientôt)',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: features
            .asMap()
            .entries
            .map((entry) => _buildFeatureRow(entry.value, entry.key == features.length - 1))
            .toList(),
      ),
    );
  }

  Widget _buildFeatureRow(_FeatureItem feature, bool isLast) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Center(
                  child: Text(
                    feature.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feature.title, style: AppTypography.labelMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      feature.subtitle,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: AppColors.secondary,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.surfaceLight,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),
      ],
    );
  }

  Widget _buildPricingToggle(PremiumState state) {
    final offerings = state.offerings;
    final current = offerings?.current;
    final monthlyPkg = current?.monthly;
    final annualPkg = current?.annual;

    final monthlyPrice = monthlyPkg?.storeProduct.priceString ?? '4,99 €';
    final annualPrice = annualPkg?.storeProduct.priceString ?? '29,99 €';

    return Column(
      children: [
        // Toggle
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          child: Row(
            children: [
              Expanded(
                child: _PricingOption(
                  label: 'Mensuel',
                  price: monthlyPrice,
                  isSelected: !_isAnnual,
                  badge: null,
                  onTap: () => setState(() => _isAnnual = false),
                ),
              ),
              Expanded(
                child: _PricingOption(
                  label: 'Annuel',
                  price: annualPrice,
                  isSelected: _isAnnual,
                  badge: 'MEILLEURE OFFRE',
                  onTap: () => setState(() => _isAnnual = true),
                ),
              ),
            ],
          ),
        ),

        if (_isAnnual) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Économise 50% par rapport au mensuel',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildCTA(PremiumState state) {
    final current = state.offerings?.current;
    final selectedPkg = _isAnnual ? current?.annual : current?.monthly;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          AppButton(
            label: _isPurchasing
                ? 'Traitement...'
                : _isAnnual
                    ? 'Essayer Pro — Annuel'
                    : 'Essayer Pro — Mensuel',
            isLoading: _isPurchasing,
            onPressed: _isPurchasing
                ? null
                : () => _handlePurchase(state, selectedPkg),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: _isPurchasing ? null : () => _handleRestore(),
            child: Text(
              'Restaurer mes achats',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Annulation possible à tout moment depuis les Réglages iOS.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase(PremiumState state, Package? package) async {
    if (package == null) {
      _showNoOfferingsSnackBar();
      return;
    }
    setState(() => _isPurchasing = true);
    final success = await ref
        .read(premiumControllerProvider.notifier)
        .purchase(package);
    if (mounted) {
      setState(() => _isPurchasing = false);
      if (success) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isPurchasing = true);
    await ref.read(premiumControllerProvider.notifier).restore();
    if (mounted) {
      setState(() => _isPurchasing = false);
      final isPremium = ref.read(premiumControllerProvider).isPremium;
      if (isPremium) Navigator.of(context).pop(true);
    }
  }

  void _showNoOfferingsSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Impossible de charger les offres. Réessaie plus tard.'),
      ),
    );
  }

  Widget _buildAlreadyPremium() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 64)),
              const SizedBox(height: AppSpacing.lg),
              Text('Tu es déjà Pro !', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Profite de toutes les fonctionnalités sans limite.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Fermer',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
  final String emoji;
  final String title;
  final String subtitle;
}

class _PricingOption extends StatelessWidget {
  const _PricingOption({
    required this.label,
    required this.price,
    required this.isSelected,
    required this.badge,
    required this.onTap,
  });

  final String label;
  final String price;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Column(
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.background,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              price,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
