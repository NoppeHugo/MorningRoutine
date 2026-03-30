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
import '../../domain/shared_routine_template.dart';
import '../shared_routines_controller.dart';

class SharedRoutinesCatalogScreen extends ConsumerStatefulWidget {
  const SharedRoutinesCatalogScreen({super.key});

  @override
  ConsumerState<SharedRoutinesCatalogScreen> createState() =>
      _SharedRoutinesCatalogScreenState();
}

class _SharedRoutinesCatalogScreenState
    extends ConsumerState<SharedRoutinesCatalogScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final state = ref.watch(sharedRoutinesControllerProvider);
    final controller = ref.read(sharedRoutinesControllerProvider.notifier);

    return AppScaffold(
      title: AppI18n.t('shared.catalogTitle', langCode),
      showBackButton: true,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: controller.setQuery,
                  decoration: InputDecoration(
                    hintText: AppI18n.t('shared.searchHint', langCode),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: state.query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              controller.setQuery('');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMedium),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _FiltersRow(
                  state: state,
                  controller: controller,
                  langCode: langCode,
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.filteredTemplates.isEmpty
                    ? _EmptyState(onReset: controller.clearFilters)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        itemBuilder: (context, index) {
                          final template = state.filteredTemplates[index];
                          final creator = state.creators[template.creatorId];

                          return _RoutineCard(
                            template: template,
                            creatorName: creator?.displayName ?? AppI18n.t('shared.creatorFallback', langCode),
                            onTap: () => context.push(
                              '${AppRoutes.sharedRoutines}/${template.id}',
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemCount: state.filteredTemplates.length,
                      ),
          ),
        ],
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.state,
    required this.controller,
    required this.langCode,
  });

  final SharedRoutinesState state;
  final SharedRoutinesController controller;
  final String langCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FilterDropdown<RoutineTemplateTheme>(
                value: state.selectedTheme,
                hint: AppI18n.t('shared.theme', langCode),
                items: RoutineTemplateTheme.values,
                labelBuilder: (theme) => theme.label,
                onChanged: controller.setTheme,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _FilterDropdown<RoutineTemplateLevel>(
                value: state.selectedLevel,
                hint: AppI18n.t('shared.level', langCode),
                items: RoutineTemplateLevel.values,
                labelBuilder: (level) => level.label,
                onChanged: controller.setLevel,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  ChoiceChip(
                    label: Text(AppI18n.t('shared.all', langCode)),
                    selected: state.maxDurationMinutes == null,
                    onSelected: (_) => controller.setMaxDuration(null),
                  ),
                  ChoiceChip(
                    label: Text(AppI18n.t('shared.max30', langCode)),
                    selected: state.maxDurationMinutes == 30,
                    onSelected: (_) => controller.setMaxDuration(30),
                  ),
                  ChoiceChip(
                    label: Text(AppI18n.t('shared.max45', langCode)),
                    selected: state.maxDurationMinutes == 45,
                    onSelected: (_) => controller.setMaxDuration(45),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilterChip(
              selected: state.onlyFree,
              onSelected: (_) => controller.toggleOnlyFree(),
              label: Text(AppI18n.t('shared.freeOnly', langCode)),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      hint: Text(hint),
      items: [
        DropdownMenuItem<T>(
          value: null,
          child: Text(AppI18n.t('shared.all', Localizations.localeOf(context).languageCode)),
        ),
        ...items.map(
          (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(labelBuilder(item)),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.template,
    required this.creatorName,
    required this.onTap,
  });

  final SharedRoutineTemplate template;
  final String creatorName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(template.icon, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(template.title, style: AppTypography.headingSmall),
                      Text(
                        creatorName,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (template.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSmall),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          size: 12,
                          color: AppColors.textOnPrimary,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          'PRO',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              template.subtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _MetaChip(label: template.theme.label),
                const SizedBox(width: AppSpacing.xs),
                _MetaChip(label: template.level.label),
                const SizedBox(width: AppSpacing.xs),
                _MetaChip(label: '${template.totalDurationMinutes} min'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

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
        label,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: AppSpacing.iconXl,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(AppI18n.t('shared.emptyTitle', langCode), style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppI18n.t('shared.emptySub', langCode),
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: AppI18n.t('shared.resetFilters', langCode),
              onPressed: onReset,
              isExpanded: false,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
