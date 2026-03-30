import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../routine_builder/presentation/routine_builder_controller.dart';
import '../../../scoring/data/scoring_repository.dart';
import '../../../scoring/domain/score_model.dart';
import '../../../scoring/presentation/scoring_controller.dart';
import '../widgets/routine_preview_card.dart';
import '../widgets/start_routine_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scoringControllerProvider.notifier).refresh();
      ref.read(routineBuilderControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(appLanguageProvider).languageCode;
    final routineState = ref.watch(routineBuilderControllerProvider);
    final scoringState = ref.watch(scoringControllerProvider);
    final routine = routineState.activeRoutine;
    final hasRoutine = routine != null && routine.blocks.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            _buildHeader(langCode),

            // ── Scrollable content ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sm),

                    // Streak + score card
                    _StreakScoreCard(
                      currentStreak: scoringState.currentStreak,
                      bestStreak: scoringState.bestStreak,
                      todayScore: scoringState.todayScore,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Weekly tracker
                    _WeeklyTrackerCard(),
                    const SizedBox(height: AppSpacing.md),

                    // Motivational message
                    _MotivationBanner(streak: scoringState.currentStreak),
                    const SizedBox(height: AppSpacing.md),

                    // Routine preview or CTA
                    if (hasRoutine)
                      RoutinePreviewCard(
                        routine: routine,
                        onEdit: () => context.push(AppRoutes.builder),
                      )
                    else
                      _buildCreateRoutineCTA(context),

                    const SizedBox(height: AppSpacing.md),
                    _InspiredRoutinesCTA(
                      onTap: () => context.push(AppRoutes.sharedRoutines),
                      langCode: langCode,
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // ── Start button ───────────────────────────────────────────────
            if (hasRoutine)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: StartRoutineButton(
                  hasCompletedToday: scoringState.hasCompletedToday,
                  totalDurationMinutes: routine?.totalDurationMinutes,
                  onPressed: () => context.go(AppRoutes.timer),
                  langCode: langCode,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(String langCode) {
    final hour = DateTime.now().hour;
    final greeting = AppI18n.t('home.hello', langCode);
    final subtitle = hour < 12
        ? AppI18n.t('home.subtitleMorning', langCode)
        : AppI18n.t('home.subtitleAfter', langCode);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sun icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Create routine CTA ────────────────────────────────────────────────────

  Widget _buildCreateRoutineCTA(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconLg,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppI18n.t('home.createRoutine', langCode),
            style: AppTypography.headingSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppI18n.t('home.createRoutineSub', langCode),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: AppI18n.t('home.createRoutineButton', langCode),
            onPressed: () => context.push(AppRoutes.builder),
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}

class _InspiredRoutinesCTA extends StatelessWidget {
  const _InspiredRoutinesCTA({required this.onTap, required this.langCode});

  final VoidCallback onTap;
  final String langCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  AppI18n.t('home.inspiredTitle', langCode),
                  style: AppTypography.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppI18n.t('home.inspiredSub', langCode),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: AppI18n.t('home.inspiredButton', langCode),
            onPressed: onTap,
            variant: AppButtonVariant.secondary,
            icon: Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }
}

// ── Streak + Score card ────────────────────────────────────────────────────

class _StreakScoreCard extends StatelessWidget {
  const _StreakScoreCard({
    required this.currentStreak,
    required this.bestStreak,
    required this.todayScore,
  });

  final int currentStreak;
  final int bestStreak;
  final DailyScore? todayScore;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final hasScore = todayScore != null;
    final percent = hasScore ? todayScore!.scorePercent : 0;
    final scoreColor = percent >= 80 ? AppColors.secondary : AppColors.warning;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Streak side
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: currentStreak > 0
                    ? const Color(0xFFFF6B00).withValues(alpha: 0.08)
                    : AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLarge),
                  bottomLeft: Radius.circular(AppSpacing.radiusLarge),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: currentStreak > 0
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        AppI18n.t('home.streak', langCode),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    currentStreak == 0
                        ? '0 jour'
                        : '$currentStreak jour${currentStreak > 1 ? 's' : ''}',
                    style: AppTypography.headingMedium.copyWith(
                      color: currentStreak > 0
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                  ),
                  if (bestStreak > 0)
                    Text(
                      'Record : $bestStreak j',
                      style: AppTypography.bodySmall,
                    ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 80,
            color: AppColors.separator,
          ),

          // Score side
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: hasScore
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: scoreColor,
                              size: AppSpacing.iconSm,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              AppI18n.t('home.today', langCode),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '$percent%',
                          style: AppTypography.headingMedium.copyWith(
                            color: scoreColor,
                          ),
                        ),
                        Text(
                          '${todayScore!.completedBlocks}/${todayScore!.totalBlocks} blocs',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.radio_button_unchecked_rounded,
                              color: AppColors.textTertiary,
                              size: AppSpacing.iconSm,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              AppI18n.t('home.today', langCode),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          AppI18n.t('home.waiting', langCode),
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          AppI18n.t('home.launchNow', langCode),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Weekly tracker ─────────────────────────────────────────────────────────

class _WeeklyTrackerCard extends StatelessWidget {
  _WeeklyTrackerCard();

  final List<DailyScore> _allScores =
      scoringRepositoryInstance.getAllScores();

  static const _dayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    // Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));

    // Build a map of dateKey → isSuccessful for this week
    final weekMap = <String, bool>{};
    for (final score in _allScores) {
      weekMap[score.dateKey] = score.isSuccessful;
    }

    // Count completed days this week
    int completedCount = 0;
    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      if (weekMap[key] == true) completedCount++;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppI18n.t('home.week', langCode),
                style: AppTypography.labelMedium,
              ),
              
              Text(
                AppI18n.tf('home.daysFmt', langCode, {
                  'done': '$completedCount',
                }),
                style: AppTypography.bodySmall.copyWith(
                  color: completedCount > 0
                      ? AppColors.secondary
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final day = monday.add(Duration(days: i));
              final key =
                  '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
              final isCompleted = weekMap[key] == true;
              final isToday = day.year == now.year &&
                  day.month == now.month &&
                  day.day == now.day;
              final isFuture = day.isAfter(now);

              return _DayDot(
                label: _dayLabels[i],
                isCompleted: isCompleted,
                isToday: isToday,
                isFuture: isFuture,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.label,
    required this.isCompleted,
    required this.isToday,
    required this.isFuture,
  });

  final String label;
  final bool isCompleted;
  final bool isToday;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final dotColor = isCompleted
        ? AppColors.secondary
        : isFuture
            ? AppColors.surfaceLight
            : AppColors.textTertiary.withValues(alpha: 0.3);

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 18,
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isToday ? AppColors.primary : AppColors.textTertiary,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Motivation banner ──────────────────────────────────────────────────────

class _MotivationBanner extends StatelessWidget {
  const _MotivationBanner({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final String message;
    final Color bgColor;
    final Color textColor;
    final IconData icon;

    if (streak == 0) {
      message = AppI18n.t('home.motivationStart', langCode);
      bgColor = AppColors.primaryLight;
      textColor = AppColors.primary;
      icon = Icons.rocket_launch_rounded;
    } else if (streak < 7) {
      message = AppI18n.t('home.motivationKeep', langCode);
      bgColor = AppColors.secondary.withValues(alpha: 0.1);
      textColor = AppColors.secondary;
      icon = Icons.trending_up_rounded;
    } else {
      message = AppI18n.tf('home.motivationFireFmt', langCode, {
        'streak': '$streak',
      });
      bgColor = AppColors.primary.withValues(alpha: 0.1);
      textColor = AppColors.primary;
      icon = Icons.local_fire_department_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.labelMedium.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
