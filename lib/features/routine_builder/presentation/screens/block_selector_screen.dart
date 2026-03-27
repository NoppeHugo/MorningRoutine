import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/blocks_repository.dart';
import '../routine_builder_controller.dart';
 
class BlockSelectorScreen extends ConsumerWidget {
  const BlockSelectorScreen({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(routineBuilderControllerProvider.notifier);
    final state = ref.watch(routineBuilderControllerProvider);
    final existingTemplateIds =
        state.routine?.blocks.map((b) => b.templateId).toSet() ?? {};
 
    return AppScaffold(
      title: 'Ajouter un bloc',
      showBackButton: true,
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.0,
        ),
        itemCount: BlocksRepository.templates.length,
        itemBuilder: (context, index) {
          final template = BlocksRepository.templates[index];
          final alreadyAdded = existingTemplateIds.contains(template.id);
 
          return _BlockTemplateCard(
            template: template,
            alreadyAdded: alreadyAdded,
            onTap: alreadyAdded
                ? null
                : () {
                    controller.addBlock(template);
                    context.pop();
                  },
          );
        },
      ),
    );
  }
}
 
class _BlockTemplateCard extends StatelessWidget {
  const _BlockTemplateCard({
    required this.template,
    required this.alreadyAdded,
    this.onTap,
  });
 
  final BlockTemplate template;
  final bool alreadyAdded;
  final VoidCallback? onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: alreadyAdded
              ? AppColors.surfaceLight.withValues(alpha: 0.5)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: alreadyAdded ? Colors.transparent : AppColors.surfaceLight,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              template.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              template.name,
              style: AppTypography.labelMedium.copyWith(
                color: alreadyAdded
                    ? AppColors.textTertiary
                    : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${template.defaultDurationMinutes} min',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            if (alreadyAdded) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Déjà ajouté',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
