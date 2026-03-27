import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../routine_builder_controller.dart';
import '../widgets/empty_routine_placeholder.dart';
import '../widgets/routine_block_card.dart';
 
class RoutineBuilderScreen extends ConsumerWidget {
  const RoutineBuilderScreen({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routineBuilderControllerProvider);
    final controller = ref.read(routineBuilderControllerProvider.notifier);
 
    if (state.isLoading) {
      return const AppScaffold(
        title: 'Ma Routine',
        showBackButton: true,
        body: Center(child: CircularProgressIndicator()),
      );
    }
 
    final routine = state.routine;
    if (routine == null) {
      return const AppScaffold(
        title: 'Ma Routine',
        showBackButton: true,
        body: Center(child: Text('Erreur de chargement')),
      );
    }
 
    return AppScaffold(
      title: 'Ma Routine',
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
                      'Réveil: ${DurationUtils.formatTimeOfDay(routine.wakeTime)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Fin estimée: ${DurationUtils.formatTimeOfDay(routine.endTime)}',
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
            child: AppButton(
              label: routine.blocks.length >= AppConstants.maxBlocks
                  ? 'Maximum ${AppConstants.maxBlocks} blocs atteint'
                  : '+ Ajouter un bloc',
              variant: AppButtonVariant.secondary,
              onPressed: routine.blocks.length >= AppConstants.maxBlocks
                  ? null
                  : () => context.push(AppRoutes.builderBlocks),
            ),
          ),
        ],
      ),
    );
  }
 
  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce bloc ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(
              'Supprimer',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
