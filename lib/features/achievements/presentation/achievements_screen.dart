import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_atmosphere.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../domain/achievement_model.dart';
import 'achievements_controller.dart';

// ─── Tier display helpers ─────────────────────────────────────────────────────

extension _TierLabel on AchievementTier {
  String get label {
    switch (this) {
      case AchievementTier.platinum:
        return 'Platine';
      case AchievementTier.gold:
        return 'Or';
      case AchievementTier.silver:
        return 'Argent';
      case AchievementTier.bronze:
        return 'Bronze';
    }
  }

  Color get color {
    switch (this) {
      case AchievementTier.platinum:
        return const Color(0xFFB0C4DE);
      case AchievementTier.gold:
        return AppColors.warning;
      case AchievementTier.silver:
        return AppColors.textSecondary;
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
    }
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  static const List<AchievementTier> _tierOrder = [
    AchievementTier.platinum,
    AchievementTier.gold,
    AchievementTier.silver,
    AchievementTier.bronze,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(achievementsControllerProvider);

    if (state.isLoading) {
      return const AppScaffold(
        title: 'Succès',
        showBackButton: true,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final total = state.all.length;
    final unlocked = state.unlockedCount;
    final progress = total > 0 ? unlocked / total : 0.0;

    return AppScaffold(
      title: 'Succès',
      showBackButton: true,
      body: CustomScrollView(
        slivers: [
          // ── Header stats ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeaderStats(
              unlocked: unlocked,
              total: total,
              progress: progress,
            ),
          ),

          // ── Achievement groups by tier ────────────────────────────────────
          for (final tier in _tierOrder) ...[
            SliverToBoxAdapter(
              child: _TierHeader(tier: tier),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tierAchievements = state.all
                      .where((a) => a.tier == tier)
                      .toList();
                  final achievement = tierAchievements[index];
                  final isUnlocked =
                      state.unlockedIds.contains(achievement.id);
                  return _AchievementCard(
                    achievement: achievement,
                    isUnlocked: isUnlocked,
                  );
                },
                childCount:
                    state.all.where((a) => a.tier == tier).length,
              ),
            ),
          ],

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
        ],
      ),
    );
  }
}

// ─── Header stats widget ──────────────────────────────────────────────────────

class _HeaderStats extends StatelessWidget {
  const _HeaderStats({
    required this.unlocked,
    required this.total,
    required this.progress,
  });

  final int unlocked;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: AppGlassContainer(
        radius: AppSpacing.radiusMedium,
        color: const Color(0x24F8FAFF),
        borderColor: const Color(0x66F2F5FA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progression',
                  style: AppTypography.headingSmall,
                ),
                Text(
                  '$unlocked / $total débloqués',
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xDDE7EDF3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0x66F2F5FA),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFF2F5FA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tier section header ──────────────────────────────────────────────────────

class _TierHeader extends StatelessWidget {
  const _TierHeader({required this.tier});

  final AchievementTier tier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: tier.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            tier.label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: tier.color,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Achievement card ─────────────────────────────────────────────────────────

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
  });

  final Achievement achievement;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final tierColor = achievement.tier.color;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: AppGlassContainer(
        radius: AppSpacing.radiusMedium,
        color: const Color(0x24F8FAFF),
        borderColor: const Color(0x66F2F5FA),
        child: Row(
          children: [
            _AchievementBadge(
              icon: achievement.icon,
              tierColor: tierColor,
              isUnlocked: isUnlocked,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: AppTypography.labelLarge.copyWith(
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    achievement.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: isUnlocked
                          ? const Color(0xDDE7EDF3)
                          : AppColors.textTertiary,
                    ),
                  ),
                  if (!isUnlocked) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      achievement.condition,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Badge widget ─────────────────────────────────────────────────────────────

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.icon,
    required this.tierColor,
    required this.isUnlocked,
  });

  final IconData icon;
  final Color tierColor;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppSpacing.iconXxl,
          height: AppSpacing.iconXxl,
          decoration: BoxDecoration(
            color: isUnlocked
                ? tierColor
                : AppColors.surfaceLight.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppSpacing.iconLg,
            color: isUnlocked
                ? Colors.white
                : AppColors.textTertiary,
          ),
        ),
        if (!isUnlocked)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ),
      ],
    );
  }
}
