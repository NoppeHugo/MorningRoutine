import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../paywall/presentation/premium_controller.dart';
import '../routine_builder_controller.dart';
import '../widgets/empty_routine_placeholder.dart';
import '../widgets/routine_block_card.dart';
 
class RoutineBuilderScreen extends ConsumerWidget {
  const RoutineBuilderScreen({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = Localizations.localeOf(context).languageCode;
    final state = ref.watch(routineBuilderControllerProvider);
    final controller = ref.read(routineBuilderControllerProvider.notifier);
    final activeRoutine = state.activeRoutine;
    final scheduledRoutine = state.scheduledRoutine;
 
    if (state.isLoading) {
      return AppScaffold(
        title: AppI18n.t('builder.title', langCode),
        showBackButton: true,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
 
    final routine = state.routine;
    if (routine == null) {
      return AppScaffold(
        title: AppI18n.t('builder.title', langCode),
        showBackButton: true,
        body: Center(child: Text(AppI18n.t('builder.loadError', langCode))),
      );
    }
 
    return AppScaffold(
      title: AppI18n.t('builder.title', langCode),
      showBackButton: true,
      actions: [
        IconButton(
          onPressed: state.isSaving
              ? null
              : () async {
                  await controller.saveRoutine();
                  if (context.mounted) context.pop();
                },
          icon: state.isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check, color: AppColors.primary),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: _RoutineManagementCard(
              state: state,
              onSelectRoutine: controller.selectRoutine,
              onCreateRoutine: controller.createRoutine,
              onDeleteRoutine: () =>
                  _confirmDeleteRoutine(context, controller.deleteSelectedRoutine),
              onActivateNow: controller.activateSelectedRoutineNow,
              onActivateTomorrow: controller.scheduleSelectedRoutineForTomorrow,
              onClearTomorrowActivation: controller.clearScheduledActivation,
            ),
          ),

          if (activeRoutine != null || scheduledRoutine != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: _ActivationSummary(
                activeRoutineName: activeRoutine?.name,
                scheduledRoutineName: scheduledRoutine?.name,
                scheduledDate: state.pendingActivation?.activationDate,
              ),
            ),

          // Header info
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppI18n.tf('builder.wakeFmt', langCode, {
                        'time': DurationUtils.formatTimeOfDay(routine.wakeTime),
                      }),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppI18n.tf('builder.endFmt', langCode, {
                        'time': DurationUtils.formatTimeOfDay(routine.endTime),
                      }),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    '${routine.totalDurationMinutes} min',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
 
          // Block list
          Expanded(
            child: routine.blocks.isEmpty
                ? const EmptyRoutinePlaceholder()
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    itemCount: routine.blocks.length,
                    onReorder: controller.reorderBlocks,
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        color: Colors.transparent,
                        elevation: 4,
                        child: child,
                      );
                    },
                    itemBuilder: (context, index) {
                      final block = routine.blocks[index];
                      return RoutineBlockCard(
                        key: ValueKey(block.id),
                        block: block,
                        onDelete: () => _confirmDelete(
                          context,
                          () => controller.removeBlock(block.id),
                        ),
                        onDurationChanged: (duration) =>
                            controller.updateBlockDuration(
                                block.id, duration),
                      );
                    },
                  ),
          ),
 
          // Add button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _AddBlockButton(
              blockCount: routine.blocks.length,
            ),
          ),
        ],
      ),
    );
  }
 
  void _confirmDelete(
      BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppI18n.t('builder.confirmDeleteBlock', Localizations.localeOf(context).languageCode)),
        content: Text(AppI18n.t('builder.deleteBlockIrreversible', Localizations.localeOf(context).languageCode)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppI18n.t('common.cancel', Localizations.localeOf(context).languageCode)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(
              AppI18n.t('common.delete', Localizations.localeOf(context).languageCode),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteRoutine(
    BuildContext context,
    Future<void> Function() onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppI18n.t('builder.confirmDeleteRoutine', Localizations.localeOf(context).languageCode)),
        content: Text(AppI18n.t('builder.deleteRoutineHint', Localizations.localeOf(context).languageCode)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppI18n.t('common.cancel', Localizations.localeOf(context).languageCode)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await onConfirm();
            },
            child: Text(
              AppI18n.t('common.delete', Localizations.localeOf(context).languageCode),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineManagementCard extends StatelessWidget {
  const _RoutineManagementCard({
    required this.state,
    required this.onSelectRoutine,
    required this.onCreateRoutine,
    required this.onDeleteRoutine,
    required this.onActivateNow,
    required this.onActivateTomorrow,
    required this.onClearTomorrowActivation,
  });

  final RoutineBuilderState state;
  final ValueChanged<String> onSelectRoutine;
  final Future<void> Function() onCreateRoutine;
  final Future<void> Function() onDeleteRoutine;
  final Future<void> Function() onActivateNow;
  final Future<void> Function() onActivateTomorrow;
  final Future<void> Function() onClearTomorrowActivation;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final selectedRoutine = state.routine;
    final isSelectedActive =
        selectedRoutine != null && selectedRoutine.id == state.activeRoutineId;
    final hasScheduledActivation = state.pendingActivation != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppI18n.t('builder.manage', langCode),
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            value: selectedRoutine?.id,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            items: state.routines
                .map(
                  (routine) => DropdownMenuItem<String>(
                    value: routine.id,
                    child: Text(
                      routine.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              onSelectRoutine(value);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCreateRoutine,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(AppI18n.t('builder.new', langCode)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: state.routines.isEmpty ? null : onDeleteRoutine,
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: Text(AppI18n.t('common.delete', langCode)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (isSelectedActive)
            AppButton(
              label: AppI18n.t('builder.activeToday', langCode),
              variant: AppButtonVariant.secondary,
              onPressed: null,
              icon: Icons.check_circle_outline_rounded,
            )
          else
            AppButton(
              label: AppI18n.t('builder.activateNow', langCode),
              variant: AppButtonVariant.secondary,
              onPressed: onActivateNow,
              icon: Icons.bolt_rounded,
            ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: AppI18n.t('builder.activateTomorrow', langCode),
            variant: AppButtonVariant.primary,
            onPressed: onActivateTomorrow,
            icon: Icons.calendar_today_rounded,
          ),
          if (hasScheduledActivation) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: onClearTomorrowActivation,
              icon: const Icon(Icons.close_rounded, size: 16),
              label: Text(AppI18n.t('builder.cancelScheduled', langCode)),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActivationSummary extends StatelessWidget {
  const _ActivationSummary({
    required this.activeRoutineName,
    required this.scheduledRoutineName,
    required this.scheduledDate,
  });

  final String? activeRoutineName;
  final String? scheduledRoutineName;
  final DateTime? scheduledDate;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final dateText = scheduledDate == null
        ? null
        : '${scheduledDate!.day.toString().padLeft(2, '0')}/${scheduledDate!.month.toString().padLeft(2, '0')}/${scheduledDate!.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activeRoutineName != null)
            Text(
              AppI18n.tf('builder.activeFmt', langCode, {
                'name': activeRoutineName!,
              }),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (scheduledRoutineName != null && dateText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppI18n.tf('builder.tomorrowFmt', langCode, {
                'date': dateText,
                'name': scheduledRoutineName!,
              }),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddBlockButton extends ConsumerWidget {
  const _AddBlockButton({required this.blockCount});

  final int blockCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = Localizations.localeOf(context).languageCode;
    final isPremium = ref.watch(premiumControllerProvider).isPremium;
    final isAtMax = blockCount >= AppConstants.maxBlocks;
    final isAtFreeLimit =
        !isPremium && blockCount >= AppConstants.freeBlockLimit;

    if (isAtMax) {
      return AppButton(
        label: AppI18n.tf('builder.maxBlocksFmt', langCode, {
          'max': '${AppConstants.maxBlocks}',
        }),
        variant: AppButtonVariant.secondary,
        onPressed: null,
      );
    }

    if (isAtFreeLimit) {
      return Column(
        children: [
          AppButton(
            label: AppI18n.t('builder.addBlock', langCode),
            variant: AppButtonVariant.secondary,
            onPressed: () => context.push(AppRoutes.paywall),
            icon: Icons.lock_outline,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppI18n.tf('builder.proBlocksFmt', langCode, {
              'count': '${AppConstants.freeBlockLimit}',
            }),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return AppButton(
      label: AppI18n.t('builder.addBlock', langCode),
      variant: AppButtonVariant.secondary,
      onPressed: () => context.push(AppRoutes.builderBlocks),
    );
  }
}
