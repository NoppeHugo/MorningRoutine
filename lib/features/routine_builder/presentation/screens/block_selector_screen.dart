import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/blocks_repository.dart';
import '../routine_builder_controller.dart';
 
class BlockSelectorScreen extends ConsumerWidget {
  const BlockSelectorScreen({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = Localizations.localeOf(context).languageCode;
    final controller = ref.read(routineBuilderControllerProvider.notifier);
    final state = ref.watch(routineBuilderControllerProvider);
    final existingTemplateIds =
        state.routine?.blocks.map((b) => b.templateId).toSet() ?? {};
 
    return AppScaffold(
      title: AppI18n.t('blocks.addTitle', langCode),
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
    final langCode = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: onTap,
      child: AppGlassContainer(
        radius: 22,
        color: alreadyAdded
            ? const Color(0x18F8FAFF)
            : const Color(0x2EF8FAFF),
        borderColor: alreadyAdded
            ? const Color(0x38F2F5FA)
            : const Color(0x66F2F5FA),
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
                      ? const Color(0xA2E5EAF1)
                      : const Color(0xFFF1F4F7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${template.defaultDurationMinutes} min',
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xCAE4E9F1),
                ),
              ),
              if (alreadyAdded) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppI18n.t('blocks.alreadyAdded', langCode),
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xAEE2E8F0),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
