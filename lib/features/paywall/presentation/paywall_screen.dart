import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/localization/app_i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_atmosphere.dart';
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
    final langCode = Localizations.localeOf(context).languageCode;
    final premiumState = ref.watch(premiumControllerProvider);

    if (premiumState.isPremium) {
      return _buildAlreadyPremium();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: AppAtmosphericBackground()),
          SafeArea(
            child: Column(
              children: [
            // Free trial banner
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppGlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                radius: AppSpacing.radiusSmall,
                color: const Color(0x2EF8FAFF),
                borderColor: const Color(0x80F2F5FA),
                child: Row(
                  children: [
                    const Icon(
                      Icons.celebration_rounded,
                      color: Color(0xFFF2F5FA),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppI18n.t('paywall.trial', langCode),
                            style: AppTypography.labelMedium.copyWith(
                              color: const Color(0xFFF2F5FA),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            AppI18n.t('paywall.trialSub', langCode),
                            style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xDDE7EDF3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xDDE7EDF3),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0x2EF6F8FF),
                    side: const BorderSide(color: Color(0x66F2F5FA)),
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
                    _buildHeader(langCode)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -0.2, end: 0),

                    const SizedBox(height: AppSpacing.xl),

                    // Feature list
                    _buildFeatures(langCode)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 150.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: AppSpacing.xl),

                    // Pricing toggle
                    _buildPricingToggle(premiumState, langCode)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 250.ms),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // CTA section
            _buildCTA(premiumState, langCode)
                .animate()
                .fadeIn(duration: 400.ms, delay: 350.ms)
                .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String langCode) {
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
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.wb_sunny_rounded,
              size: 44,
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppI18n.t('paywall.title', langCode),
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
          AppI18n.t('paywall.subtitle', langCode),
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatures(String langCode) {
    final features = [
      _FeatureItem(
        iconData: Icons.all_inclusive_rounded,
        title: AppI18n.t('paywall.feature.unlimited.title', langCode),
        subtitle: AppI18n.t('paywall.feature.unlimited.sub', langCode),
      ),
      _FeatureItem(
        iconData: Icons.person_rounded,
        title: AppI18n.t('paywall.feature.creators.title', langCode),
        subtitle: AppI18n.t('paywall.feature.creators.sub', langCode),
      ),
      _FeatureItem(
        iconData: Icons.bar_chart_rounded,
        title: AppI18n.t('paywall.feature.analytics.title', langCode),
        subtitle: AppI18n.t('paywall.feature.analytics.sub', langCode),
      ),
      _FeatureItem(
        iconData: Icons.offline_bolt_rounded,
        title: AppI18n.t('paywall.feature.offline.title', langCode),
        subtitle: AppI18n.t('paywall.feature.offline.sub', langCode),
      ),
    ];

    return Container(
      child: AppGlassContainer(
        radius: AppSpacing.radiusLarge,
        color: const Color(0x24F8FAFF),
        borderColor: const Color(0x66F2F5FA),
      child: Column(
        children: features
            .asMap()
            .entries
            .map((entry) => _buildFeatureRow(entry.value, entry.key == features.length - 1))
            .toList(),
      ),
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
                  color: const Color(0x2CF6F8FF),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  border: Border.all(color: const Color(0x66F2F5FA)),
                ),
                child: Center(
                  child: Icon(
                    feature.iconData,
                    size: 22,
                    color: const Color(0xFFF2F5FA),
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
                color: Color(0xFFF2F5FA),
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            color: Color(0x42F2F5FA),
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),
      ],
    );
  }

  Widget _buildPricingToggle(PremiumState state, String langCode) {
    final offerings = state.offerings;
    final current = offerings?.current;
    final monthlyPkg = current?.monthly;
    final annualPkg = current?.annual;

    final monthlyPrice = monthlyPkg?.storeProduct.priceString ?? '4,99 €';
    final annualPrice = annualPkg?.storeProduct.priceString ?? '29,99 €';

    return Column(
      children: [
        // Toggle
        AppGlassContainer(
          padding: const EdgeInsets.all(AppSpacing.xs),
          radius: AppSpacing.radiusMedium,
          color: const Color(0x24F8FAFF),
          borderColor: const Color(0x66F2F5FA),
          child: Row(
            children: [
              Expanded(
                child: _PricingOption(
                  label: AppI18n.t('paywall.monthly', langCode),
                  price: monthlyPrice,
                  isSelected: !_isAnnual,
                  badge: null,
                  onTap: () => setState(() => _isAnnual = false),
                ),
              ),
              Expanded(
                child: _PricingOption(
                  label: AppI18n.t('paywall.yearly', langCode),
                  price: annualPrice,
                  isSelected: _isAnnual,
                  badge: AppI18n.t('paywall.bestOffer', langCode),
                  onTap: () => setState(() => _isAnnual = true),
                ),
              ),
            ],
          ),
        ),

        if (_isAnnual) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppI18n.t('paywall.save50', langCode),
            style: AppTypography.bodySmall.copyWith(
              color: const Color(0xFFF2F5FA),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildCTA(PremiumState state, String langCode) {
    final current = state.offerings?.current;
    final selectedPkg = _isAnnual ? current?.annual : current?.monthly;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          AppButton(
            label: _isPurchasing
              ? AppI18n.t('paywall.processing', langCode)
                : _isAnnual
                ? AppI18n.t('paywall.ctaAnnual', langCode)
                : AppI18n.t('paywall.ctaMonthly', langCode),
            isLoading: _isPurchasing,
            onPressed: _isPurchasing
                ? null
                : () => _handlePurchase(state, selectedPkg),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: _isPurchasing ? null : () => _handleRestore(),
            child: Text(
              AppI18n.t('paywall.restore', langCode),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppI18n.t('paywall.cancelAnytime', langCode),
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
    final langCode = ref.read(appLanguageProvider).languageCode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppI18n.t('paywall.noOffers', langCode)),
      ),
    );
  }

  Widget _buildAlreadyPremium() {
    final langCode = ref.read(appLanguageProvider).languageCode;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: AppAtmosphericBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              const Icon(
                Icons.workspace_premium_rounded,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(AppI18n.t('paywall.alreadyPro', langCode), style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppI18n.t('paywall.alreadyProSub', langCode),
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xDDE7EDF3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: AppI18n.t('common.close', langCode),
                onPressed: () => Navigator.of(context).pop(),
              ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.iconData,
    required this.title,
    required this.subtitle,
  });
  final IconData iconData;
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
          color: isSelected ? const Color(0x3BF6F8FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(
            color: isSelected ? const Color(0xA3F2F5FA) : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            if (badge != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppGlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  radius: AppSpacing.radiusFull,
                  color: const Color(0x32F6F8FF),
                  borderColor: const Color(0x80F2F5FA),
                  child: Text(
                    badge!,
                    style: AppTypography.labelSmall.copyWith(
                      color: const Color(0xFFF2F5FA),
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected
                    ? const Color(0xFFF2F5FA)
                    : const Color(0xDDE7EDF3),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              price,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? const Color(0xFFF2F5FA)
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
