import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../data/marketplace_repository.dart';
import '../../domain/expert_model.dart';
import '../../domain/expert_pack_model.dart';
import '../marketplace_controller.dart';
import '../widgets/expert_header.dart';
import '../widgets/pack_preview_blocks.dart';
import '../widgets/purchase_button.dart';

final _packDetailProvider =
    FutureProvider.family<ExpertPack, String>((ref, packId) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getPackById(packId);
});

final _expertDetailProvider =
    FutureProvider.family<Expert, String>((ref, expertId) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getExpertById(expertId);
});

class PackDetailScreen extends ConsumerWidget {
  const PackDetailScreen({super.key, required this.packId});

  final String packId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packAsync = ref.watch(_packDetailProvider(packId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: packAsync.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => _buildError(context, e.toString()),
        data: (pack) => _PackDetailContent(pack: pack),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return SafeArea(
      child: Column(
        children: [
          _buildBackButton(context),
          Expanded(
            child: Center(
              child: Text(
                'Pack introuvable',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: const Icon(
            CupertinoIcons.back,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _PackDetailContent extends ConsumerWidget {
  const _PackDetailContent({required this.pack});

  final ExpertPack pack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expertAsync = ref.watch(_expertDetailProvider(pack.expertId));
    final marketState = ref.watch(marketplaceControllerProvider);
    final controller = ref.read(marketplaceControllerProvider.notifier);
    final isUnlocked = pack.isFree ||
        pack.isUnlocked ||
        controller.isPackUnlocked(pack.id);

    return SafeArea(
      child: Column(
        children: [
          // Back button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                child: const Icon(
                  CupertinoIcons.back,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expert header
                  expertAsync.when(
                    loading: () => const SizedBox(
                      height: 64,
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (expert) => ExpertHeader(
                      expert: expert,
                      showBio: true,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Pack title + rating
                  Text(pack.title, style: AppTypography.headingMedium),
                  const SizedBox(height: AppSpacing.xs),
                  _buildRatingRow(),
                  const SizedBox(height: AppSpacing.md),

                  // Description
                  Text(
                    pack.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Duration + block count
                  _buildMetaRow(),
                  const SizedBox(height: AppSpacing.lg),

                  // Blocks section
                  Text(
                    'CE QUI EST INCLUS',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PackPreviewBlocks(
                    blocks: pack.blocks,
                    previewBlockCount: pack.previewBlockCount,
                    isUnlocked: isUnlocked,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // CTA buttons
                  if (!isUnlocked && pack.previewBlockCount > 0)
                    _buildPreviewButton(context),
                  if (!isUnlocked && pack.previewBlockCount > 0)
                    const SizedBox(height: AppSpacing.sm),

                  PurchaseButton(
                    pack: pack,
                    purchaseStatus: marketState.purchaseState.status,
                    isPremiumSubscriber:
                        marketState.purchaseState.isPremiumSubscriber,
                    onPressed: isUnlocked
                        ? () {
                            controller.importPackAsRoutine(pack);
                            context.go(AppRoutes.home);
                          }
                        : () => controller.unlockPack(pack),
                  ),

                  // Error message
                  if (marketState.purchaseState.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      marketState.purchaseState.errorMessage!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  // Restore purchases
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          ref
                              .read(marketplaceControllerProvider.notifier)
                              .restorePurchases(),
                      child: Text(
                        'Restaurer les achats',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          pack.rating.toStringAsFixed(1),
          style: AppTypography.labelMedium,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '(${pack.reviewCount} avis)',
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMetaRow() {
    return Row(
      children: [
        _buildMetaChip('⏱ ${pack.durationMinutes} min'),
        const SizedBox(width: AppSpacing.sm),
        _buildMetaChip('📦 ${pack.blocks.length} blocs'),
        const SizedBox(width: AppSpacing.sm),
        _buildMetaChip(pack.categoryEmoji + ' ' + pack.categoryLabel),
      ],
    );
  }

  Widget _buildMetaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall,
      ),
    );
  }

  Widget _buildPreviewButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.surfaceLight,
          width: 1.5,
        ),
      ),
      child: TextButton(
        onPressed: () {
          // TODO: navigate to timer with preview block
        },
        child: Text(
          'Essayer gratuitement',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
