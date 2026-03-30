import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../paywall/presentation/premium_controller.dart';
import '../../data/blocks_repository.dart';
import '../../data/preset_routines.dart';
import '../routine_builder_controller.dart';

class TemplateChooserScreen extends ConsumerWidget {
  const TemplateChooserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = Localizations.localeOf(context).languageCode;
    final isPremium = ref.watch(premiumControllerProvider).isPremium;

    return AppScaffold(
      title: AppI18n.t('templates.title', langCode),
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.82,
          ),
          itemCount: PresetRoutines.all.length,
          itemBuilder: (context, index) {
            final preset = PresetRoutines.all[index];
            return _PresetCard(
              preset: preset,
              isPremium: isPremium,
              langCode: langCode,
              onTap: () async =>
                  _handleTap(context, ref, preset, isPremium),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleTap(
    BuildContext context,
    WidgetRef ref,
    PresetRoutine preset,
    bool isPremium,
  ) async {
    if (preset.isPro && !isPremium) {
      context.push(AppRoutes.paywall);
      return;
    }
    await ref
        .read(routineBuilderControllerProvider.notifier)
        .loadPreset(preset);
    if (!context.mounted) return;
    context.pop();
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.isPremium,
    required this.langCode,
    required this.onTap,
  });

  final PresetRoutine preset;
  final bool isPremium;
  final String langCode;
  final VoidCallback onTap;

  int _computeTotalDuration() {
    return preset.blockIds.fold(0, (sum, id) {
      final template = BlocksRepository.findById(id);
      return sum + (template?.defaultDurationMinutes ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalMinutes = _computeTotalDuration();
    final isLocked = preset.isPro && !isPremium;

    return GestureDetector(
      onTap: onTap,
      child: AppGlassContainer(
        radius: AppSpacing.radiusLarge,
        color: const Color(0x30F8FAFF),
        borderColor: const Color(0x70F2F5FA),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: preset.accentColor.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMedium),
                    ),
                    child: Icon(
                      preset.icon,
                      color: const Color(0xFFEFF3F8),
                      size: AppSpacing.iconMd,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Name
                  Text(
                    preset.name,
                    style: AppTypography.labelMedium.copyWith(
                      color: const Color(0xFFF2F4F7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Description
                  Expanded(
                    child: Text(
                      preset.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xD6E6ECF3),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Stats row
                  Row(
                    children: [
                      Icon(
                        Icons.grid_view_rounded,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppI18n.tf('templates.blocksFmt', langCode, {
                          'count': '${preset.blockIds.length}',
                        }),
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xCCE2E8F0),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${totalMinutes}min',
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xCCE2E8F0),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // PRO badge
            if (preset.isPro)
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isLocked
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLocked) ...[
                        const Icon(
                          Icons.lock_rounded,
                          size: 9,
                          color: AppColors.textOnPrimary,
                        ),
                        const SizedBox(width: 3),
                      ],
                      Text(
                        'PRO',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          color: isLocked
                              ? AppColors.textOnPrimary
                              : AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
