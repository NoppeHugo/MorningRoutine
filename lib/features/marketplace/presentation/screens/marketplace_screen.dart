import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/marketplace_repository.dart';
import '../../domain/expert_pack_model.dart';
import '../marketplace_controller.dart';
import '../widgets/pack_card.dart';

// Cache for expert names to avoid async in GridView
final _expertNamesProvider = FutureProvider.family<String, String>(
  (ref, expertId) async {
    final repo = ref.watch(marketplaceRepositoryProvider);
    final expert = await repo.getExpertById(expertId);
    return expert.name;
  },
);

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  static const List<_CategoryItem> _categories = [
    _CategoryItem(null, 'Tous'),
    _CategoryItem('energy', 'Énergie'),
    _CategoryItem('focus', 'Focus'),
    _CategoryItem('calm', 'Calme'),
    _CategoryItem('fitness', 'Forme'),
    _CategoryItem('productivity', 'Productivité'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(marketplaceControllerProvider.notifier).loadPacks();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(marketplaceControllerProvider.notifier).loadPacks();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildHeader(),
              if (state.featuredPacks.isNotEmpty)
                _buildFeaturedSection(state.featuredPacks.first),
              _buildCategoryFilter(state.selectedCategory),
              if (state.isLoading && state.allPacks.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              else if (state.errorMessage != null && state.allPacks.isEmpty)
                SliverFillRemaining(
                  child: _buildErrorView(state.errorMessage!),
                )
              else
                _buildPacksGrid(state.filteredPacks),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Découvrir', style: AppTypography.headingLarge),
            Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.push(AppRoutes.marketplacePurchases),
                  child: const Icon(
                    CupertinoIcons.bag,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(ExpertPack featured) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'À la une',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildFeaturedCard(featured),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(ExpertPack pack) {
    return Consumer(
      builder: (context, ref, _) {
        final expertAsync = ref.watch(_expertNamesProvider(pack.expertId));
        final expertName = expertAsync.valueOrNull ?? '';

        return GestureDetector(
          onTap: () => context.push('/marketplace/${pack.id}'),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  offset: const Offset(0, 6),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background emoji
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Text(
                    pack.categoryEmoji,
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          '⭐ FEATURED',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        pack.title,
                        style: AppTypography.headingSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'par $expertName',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.warning, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            pack.rating.toStringAsFixed(1),
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            pack.formattedPrice,
                            style: AppTypography.labelMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(String? selectedCategory) {
    final selectedIndex = _categories.indexWhere(
      (c) => c.value == selectedCategory,
    );
    final currentIndex = selectedIndex < 0 ? 0 : selectedIndex;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: CupertinoSlidingSegmentedControl<int>(
          backgroundColor: AppColors.surface,
          thumbColor: AppColors.surfaceLight,
          groupValue: currentIndex,
          onValueChanged: (index) {
            if (index == null) return;
            final cat = _categories[index].value;
            ref
                .read(marketplaceControllerProvider.notifier)
                .filterByCategory(cat);
          },
          children: {
            for (int i = 0; i < _categories.length; i++)
              i: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  _categories[i].label,
                  style: AppTypography.labelSmall.copyWith(fontSize: 11),
                ),
              ),
          },
        ),
      ),
    );
  }

  Widget _buildPacksGrid(List<ExpertPack> packs) {
    if (packs.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'Aucun pack dans cette catégorie',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.78,
        ),
        itemCount: packs.length,
        itemBuilder: (context, index) {
          final pack = packs[index];
          return Consumer(
            builder: (context, ref, _) {
              final expertAsync =
                  ref.watch(_expertNamesProvider(pack.expertId));
              final expertName = expertAsync.valueOrNull ?? '';
              return PackCard(
                pack: pack,
                expertName: expertName,
                onTap: () => context.push('/marketplace/${pack.id}'),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
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

class _CategoryItem {
  const _CategoryItem(this.value, this.label);
  final String? value;
  final String label;
}
