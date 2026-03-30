import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../paywall/presentation/premium_controller.dart';
import '../../../routine_builder/data/blocks_repository.dart';
import '../../../routine_builder/presentation/routine_builder_controller.dart';
import '../../domain/shared_routine_template.dart';
import '../shared_routines_controller.dart';

class SharedRoutineDetailScreen extends ConsumerStatefulWidget {
  const SharedRoutineDetailScreen({
    super.key,
    required this.templateId,
  });

  final String templateId;

  @override
  ConsumerState<SharedRoutineDetailScreen> createState() =>
      _SharedRoutineDetailScreenState();
}

class _SharedRoutineDetailScreenState
    extends ConsumerState<SharedRoutineDetailScreen> {
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final sharedController = ref.read(sharedRoutinesControllerProvider.notifier);
    final template = sharedController.findTemplateById(widget.templateId);

    if (template == null) {
      return AppScaffold(
        title: AppI18n.t('shared.notFoundTitle', langCode),
        showBackButton: true,
        body: Center(
          child: Text(AppI18n.t('shared.notFoundSub', langCode)),
        ),
      );
    }

    final creator = sharedController.findCreatorById(template.creatorId);
    final isPremiumUser = ref.watch(premiumControllerProvider).isPremium;
    final isLocked = template.isPremium && !isPremiumUser;

    return AppScaffold(
      title: template.title,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(template: template, creatorName: creator?.displayName),
            const SizedBox(height: AppSpacing.md),
            _InfoCard(template: template, langCode: langCode),
            const SizedBox(height: AppSpacing.md),
            Text(AppI18n.t('shared.sequence', langCode), style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            ...template.blocks.asMap().entries.map((entry) {
              final index = entry.key;
              final block = entry.value;
              final refBlock = BlocksRepository.findById(block.templateId);

              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        '${index + 1}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${refBlock?.emoji ?? '•'} ${refBlock?.name ?? block.templateId}',
                            style: AppTypography.labelMedium,
                          ),
                          Text(
                            '${block.durationMinutes} min',
                            style: AppTypography.bodySmall,
                          ),
                          if (block.note != null)
                            Padding(
                              padding: const EdgeInsets.only(top: AppSpacing.xs),
                              child: Text(
                                block.note!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.md),
            Text(
              template.disclaimer,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (isLocked)
              Column(
                children: [
                  AppButton(
                    label: AppI18n.t('shared.unlockPro', langCode),
                    onPressed: () => context.push(AppRoutes.paywall),
                    icon: Icons.lock_rounded,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppI18n.t('shared.proOnly', langCode),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else
              _Actions(
                isLoading: _isImporting,
                onDuplicate: () => _importTemplate(
                  template,
                  activateNow: false,
                  activateTomorrow: false,
                  redirectToBuilder: true,
                ),
                onActivateNow: () => _importTemplate(
                  template,
                  activateNow: true,
                  activateTomorrow: false,
                  redirectToBuilder: false,
                ),
                onActivateTomorrow: () => _importTemplate(
                  template,
                  activateNow: false,
                  activateTomorrow: true,
                  redirectToBuilder: false,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _importTemplate(
    SharedRoutineTemplate template, {
    required bool activateNow,
    required bool activateTomorrow,
    required bool redirectToBuilder,
  }) async {
    if (_isImporting) return;

    setState(() => _isImporting = true);

    final controller = ref.read(routineBuilderControllerProvider.notifier);
    final blockIds = template.blocks.map((block) => block.templateId).toList();
    final durations = template.blocks.map((block) => block.durationMinutes).toList();

    await controller.importSharedRoutineTemplate(
      routineName: template.title,
      blockTemplateIds: blockIds,
      blockDurationsMinutes: durations,
      activateNow: activateNow,
      activateTomorrow: activateTomorrow,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isImporting = false);

    if (redirectToBuilder) {
      context.push(AppRoutes.builder);
      return;
    }

    context.go(AppRoutes.home);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.template,
    required this.creatorName,
  });

  final SharedRoutineTemplate template;
  final String? creatorName;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            creatorName == null
                ? AppI18n.t('shared.inspiredRoutine', langCode)
                : AppI18n.tf('shared.inspiredByFmt', langCode, {
                    'creator': creatorName!,
                  }),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            template.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.template, required this.langCode});

  final SharedRoutineTemplate template;
  final String langCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(template.goal, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _Pill(text: AppI18n.t(template.theme.i18nKey, langCode)),
              _Pill(text: AppI18n.t(template.level.i18nKey, langCode)),
              _Pill(text: AppI18n.t(template.status.i18nKey, langCode)),
              _Pill(
                text:
                    '${template.totalDurationMinutes} ${AppI18n.t('common.min', langCode)}',
              ),
              _Pill(
                text: template.isPremium
                    ? AppI18n.t('common.pro', langCode)
                    : AppI18n.t('common.free', langCode),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            template.sourceLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.isLoading,
    required this.onDuplicate,
    required this.onActivateNow,
    required this.onActivateTomorrow,
  });

  final bool isLoading;
  final Future<void> Function() onDuplicate;
  final Future<void> Function() onActivateNow;
  final Future<void> Function() onActivateTomorrow;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        AppButton(
          label: AppI18n.t('shared.duplicate', langCode),
          onPressed: isLoading ? null : () => onDuplicate(),
          isLoading: isLoading,
          icon: Icons.edit_rounded,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: AppI18n.t('builder.activateNow', langCode),
          variant: AppButtonVariant.secondary,
          onPressed: isLoading ? null : () => onActivateNow(),
          icon: Icons.bolt_rounded,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: AppI18n.t('shared.tryTomorrow', langCode),
          variant: AppButtonVariant.secondary,
          onPressed: isLoading ? null : () => onActivateTomorrow(),
          icon: Icons.calendar_today_rounded,
        ),
      ],
    );
  }
}
