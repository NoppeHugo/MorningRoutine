import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../paywall/presentation/premium_controller.dart';
import '../../../scoring/presentation/scoring_controller.dart';
import '../../domain/timer_state.dart';
import '../timer_controller.dart';
 
class CompletionScreen extends ConsumerStatefulWidget {
  const CompletionScreen({super.key});
 
  @override
  ConsumerState<CompletionScreen> createState() => _CompletionScreenState();
}
 
class _CompletionScreenState extends ConsumerState<CompletionScreen> {
  String? _moodAfter;
  final TextEditingController _reflectionCtrl = TextEditingController();
  final TextEditingController _intentionCtrl = TextEditingController();
  final TextEditingController _priorityCtrl = TextEditingController();
  bool _isSaving = false;
 
  @override
  void dispose() {
    _reflectionCtrl.dispose();
    _intentionCtrl.dispose();
    _priorityCtrl.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final isPremium = ref.watch(premiumControllerProvider).isPremium;
    late final TimerState timerState;
    try {
      timerState = ref.watch(timerControllerProvider);
    } catch (_) {
      // If timer was disposed, go home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(AppRoutes.home);
      });
      return const SizedBox.shrink();
    }
 
    final completedCount =
        timerState.completedBlocks.where((b) => b.completed).length;
    final skippedCount =
        timerState.completedBlocks.where((b) => !b.completed).length;
    final totalBlocks = timerState.totalBlocksCount;
    final scorePercent =
        totalBlocks > 0 ? (completedCount / totalBlocks * 100).round() : 0;
 
    final totalActualSeconds = timerState.completedBlocks
        .fold<int>(0, (sum, b) => sum + b.actualDurationSeconds);
    final totalMinutes = totalActualSeconds ~/ 60;
 
    final scoringState = ref.watch(scoringControllerProvider);
    final streak = scoringState.currentStreak;
    final moods = ['tired', 'calm', 'stressed', 'focused', 'energized'];

    _moodAfter ??= timerState.moodBefore;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
 
              // Celebration icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: const Center(
                  child: Icon(
                    Icons.emoji_events_outlined,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
 
              // Title
              Text(
                AppI18n.t('completion.title', langCode),
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
 
              // Score card
              AppCard(
                child: Column(
                  children: [
                    Text(
                      '$scorePercent%',
                      style: AppTypography.displayLarge.copyWith(
                        color: scorePercent >= 80
                            ? AppColors.secondary
                            : AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppI18n.t('completion.score', langCode),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
 
              // Stats
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '$completedCount/$totalBlocks',
                      label: AppI18n.t('completion.completedBlocks', langCode),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      value: '$skippedCount',
                      label: AppI18n.t('completion.skippedBlocks', langCode),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      value: '${totalMinutes}min',
                      label: AppI18n.t('completion.duration', langCode),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              if (isPremium) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppI18n.t('timer.howFeelAfter', langCode),
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: moods
                            .map(
                              (mood) => ChoiceChip(
                                label: Text(
                                  AppI18n.t('mood.$mood', langCode),
                                ),
                                selected: _moodAfter == mood,
                                onSelected: (_) {
                                  setState(() => _moodAfter = mood);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppI18n.t('completion.journalTitle', langCode),
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _reflectionCtrl,
                        decoration: InputDecoration(
                          hintText: AppI18n.t('completion.promptReflection', langCode),
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _intentionCtrl,
                        decoration: InputDecoration(
                          hintText: AppI18n.t('completion.promptIntention', langCode),
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _priorityCtrl,
                        decoration: InputDecoration(
                          hintText: AppI18n.t('completion.promptPriority', langCode),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ] else ...[
                AppCard(
                  child: Column(
                    children: [
                      Text(
                        AppI18n.t('completion.proInsightsTitle', langCode),
                        style: AppTypography.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppI18n.t('completion.proInsightsSub', langCode),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
 
              // Streak
              if (streak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.streak.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 28,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '$streak jour${streak > 1 ? 's' : ''}',
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.streak,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        AppI18n.t('completion.streakSuffix', langCode),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.streak,
                        ),
                      ),
                    ],
                  ),
                ),
 
              const Spacer(),
 
              // Return button
              AppButton(
                label: _isSaving
                    ? AppI18n.t('paywall.processing', langCode)
                    : AppI18n.t('completion.finishSave', langCode),
                onPressed: _isSaving
                    ? null
                    : () => _saveAndExit(
                          timerState: timerState,
                          isPremium: isPremium,
                          langCode: langCode,
                        ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAndExit({
    required TimerState timerState,
    required bool isPremium,
    required String langCode,
  }) async {
    setState(() => _isSaving = true);

    try {
      if (isPremium && _moodAfter != null) {
        ref.read(timerControllerProvider.notifier).setCheckoutData(
              moodAfter: _moodAfter!,
              reflection: _reflectionCtrl.text.trim().isEmpty
                  ? null
                  : _reflectionCtrl.text.trim(),
              intention: _intentionCtrl.text.trim().isEmpty
                  ? null
                  : _intentionCtrl.text.trim(),
              topPriority: _priorityCtrl.text.trim().isEmpty
                  ? null
                  : _priorityCtrl.text.trim(),
            );
      }

      await ref
          .read(scoringControllerProvider.notifier)
          .saveRoutineResult(ref.read(timerControllerProvider));

      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppI18n.t('completion.saveError', langCode))),
      );
      setState(() => _isSaving = false);
    }
  }
}
 
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
  });
 
  final String value;
  final String label;
 
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headingSmall,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
