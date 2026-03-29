import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/marketplace_repository.dart';
import '../../domain/expert_pack_model.dart';
import '../marketplace_controller.dart';

// Provider for expert name by expertId
final _expertNameByIdProvider =
    FutureProvider.family<String, String>((ref, expertId) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  final expert = await repo.getExpertById(expertId);
  return expert.name;
});

final _myPurchasesProvider = FutureProvider<List<ExpertPack>>((ref) async {
  final repo = ref.watch(marketplaceRepositoryProvider);
  final marketState = ref.watch(marketplaceControllerProvider);
  final unlockedIds = marketState.purchaseState.unlockedPackIds;

  final all = await repo.getPacksByCategory(null);
  return all
      .where((p) => p.isUnlocked || p.isFree || unlockedIds.contains(p.id))
      .toList();
});

class MyPurchasesScreen extends ConsumerWidget {
  const MyPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(_myPurchasesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: purchasesAsync.when(
                loading: () => const Center(
                  child: CupertinoActivityIndicator(),
                ),
                error: (e, _) => _buildError(e.toString()),
                data: (packs) => packs.isEmpty
                    ? _buildEmptyState(context)
                    : _buildPurchasesList(context, ref, packs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.pop(),
            child: const Icon(
              CupertinoIcons.back,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('Mes achats', style: AppTypography.headingMedium),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🛍️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Aucun achat pour l\'instant',
              style: AppTypography.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Explore notre catalogue de routines\nexpertes et trouve celle qui te correspond.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Explorer le catalogue',
              onPressed: () => context.go(AppRoutes.marketplace),
              isExpanded: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchasesList(
    BuildContext context,
    WidgetRef ref,
    List<ExpertPack> packs,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      itemCount: packs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return _PurchasedPackItem(
          pack: packs[index],
          onUse: () {
            ref
                .read(marketplaceControllerProvider.notifier)
                .importPackAsRoutine(packs[index]);
            context.go(AppRoutes.home);
          },
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        'Erreur: $message',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.error,
        ),
      ),
    );
  }
}

class _PurchasedPackItem extends ConsumerWidget {
  const _PurchasedPackItem({
    required this.pack,
    required this.onUse,
  });

  final ExpertPack pack;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expertNameAsync = ref.watch(_expertNameByIdProvider(pack.expertId));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          // Category emoji
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Center(
              child: Text(
                pack.categoryEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Title + expert
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pack.title, style: AppTypography.labelMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  expertNameAsync.valueOrNull ?? '',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),

          // Use button
          CupertinoButton(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            onPressed: onUse,
            child: Text(
              'Utiliser',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
