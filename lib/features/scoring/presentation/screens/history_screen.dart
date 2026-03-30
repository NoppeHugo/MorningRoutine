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
import '../../data/scoring_repository.dart';
import '../../domain/score_model.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLanguageProvider);
    final langCode = locale.languageCode;
    final isPremium = ref.watch(premiumControllerProvider).isPremium;
    if (!isPremium) return _buildPaywallGate(context, langCode);

    final allScores = scoringRepositoryInstance.getAllScores();

    // Build a lookup map keyed by dateKey (yyyy-MM-dd)
    final scoresByKey = <String, DailyScore>{
      for (final s in allScores) s.dateKey: s,
    };

    // Stats
    final bestStreak = scoringRepositoryInstance.getBestStreak();
    final totalCompleted =
        allScores.where((s) => s.isSuccessful).length;
    final avgScore = allScores.isEmpty
        ? 0
        : (allScores.map((s) => s.scorePercent).reduce((a, b) => a + b) /
                allScores.length)
            .round();

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    int activeDaysThisMonth = 0;
    for (var d = firstDayOfMonth;
        !d.isAfter(lastDayOfMonth);
        d = d.add(const Duration(days: 1))) {
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if (scoresByKey.containsKey(key)) activeDaysThisMonth++;
    }

    // Last 10 sessions sorted by date descending
    final recentScores = List<DailyScore>.from(allScores)
      ..sort((a, b) => b.date.compareTo(a.date));
    final last10 = recentScores.take(10).toList();

    // Two months: current and previous
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(now.year, now.month - 1);

    return AppScaffold(
      title: AppI18n.t('history.title', langCode),
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section A — Summary chips
            _buildSummarySection(
              bestStreak: bestStreak,
              totalCompleted: totalCompleted,
              avgScore: avgScore,
              activeDaysThisMonth: activeDaysThisMonth,
              langCode: langCode,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Section B — Calendar (current month)
            _MonthCalendar(
              month: currentMonth,
              scoresByKey: scoresByKey,
              langCode: langCode,
            ),
            const SizedBox(height: AppSpacing.md),

            // Section B — Calendar (previous month)
            _MonthCalendar(
              month: previousMonth,
              scoresByKey: scoresByKey,
              langCode: langCode,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildEnergySection(allScores: allScores, langCode: langCode),
            const SizedBox(height: AppSpacing.lg),

            // Section C — Recent sessions list
            if (last10.isNotEmpty) ...[
              Text(
                AppI18n.t('history.recent', langCode),
                style: AppTypography.headingSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildRecentSessionsList(last10, langCode),
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergySection({
    required List<DailyScore> allScores,
    required String langCode,
  }) {
    final withMood = allScores
        .where((s) => s.moodBefore != null && s.moodAfter != null)
        .toList();

    if (withMood.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppI18n.t('history.energyTitle', langCode),
              style: AppTypography.labelLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppI18n.t('history.energyNoData', langCode),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final deltas = withMood
        .map((s) => _moodValue(s.moodAfter!) - _moodValue(s.moodBefore!))
        .toList();
    final avgDelta = deltas.reduce((a, b) => a + b) / deltas.length;
    final deltaLabel = avgDelta >= 0
        ? '+${avgDelta.toStringAsFixed(1)}'
        : avgDelta.toStringAsFixed(1);

    String? bestModeLabel;
    final grouped = <String, List<DailyScore>>{};
    for (final score in allScores) {
      final mode = score.sessionMode;
      if (mode == null) continue;
      grouped.putIfAbsent(mode, () => []).add(score);
    }
    if (grouped.length >= 2) {
      String? bestMode;
      double bestAvg = -1;
      grouped.forEach((mode, scores) {
        final avg =
            scores.map((s) => s.scorePercent).reduce((a, b) => a + b) /
                scores.length;
        if (avg > bestAvg) {
          bestAvg = avg;
          bestMode = mode;
        }
      });
      if (bestMode != null) {
        bestModeLabel = bestMode == 'guided'
            ? AppI18n.t('timer.modeGuided', langCode)
            : AppI18n.t('timer.modeChecklist', langCode);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppI18n.t('history.energyTitle', langCode),
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppI18n.tf('history.energyAvgDeltaFmt', langCode, {
              'delta': deltaLabel,
            }),
            style: AppTypography.bodyMedium,
          ),
          if (bestModeLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppI18n.tf('history.bestModeFmt', langCode, {
                'mode': bestModeLabel!,
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

  int _moodValue(String mood) {
    switch (mood) {
      case 'tired':
        return 1;
      case 'stressed':
        return 2;
      case 'calm':
        return 3;
      case 'focused':
        return 4;
      case 'energized':
        return 5;
      default:
        return 3;
    }
  }

  // ---------------------------------------------------------------------------
  // Section A — 4 summary chips
  // ---------------------------------------------------------------------------

  Widget _buildSummarySection({
    required int bestStreak,
    required int totalCompleted,
    required int avgScore,
    required int activeDaysThisMonth,
    String langCode = 'fr',
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.warning,
              value: '$bestStreak',
              label: AppI18n.t('history.bestStreak', langCode),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.check_circle_outline_rounded,
              iconColor: AppColors.secondary,
              value: '$totalCompleted',
              label: AppI18n.t('history.completed', langCode),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.bar_chart_rounded,
              iconColor: AppColors.primary,
              value: '$avgScore%',
              label: AppI18n.t('history.avgScore', langCode),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.calendar_today_rounded,
              iconColor: AppColors.info,
              value: '$activeDaysThisMonth',
              label: AppI18n.t('history.activeDays', langCode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 48,
      color: AppColors.surfaceLight,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    );
  }

  // ---------------------------------------------------------------------------
  // Section C — Recent sessions list
  // ---------------------------------------------------------------------------

  Widget _buildRecentSessionsList(List<DailyScore> scores, String langCode) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: scores.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 1,
          color: AppColors.surfaceLight,
          indent: AppSpacing.md,
          endIndent: AppSpacing.md,
        ),
        itemBuilder: (context, index) {
          return _SessionTile(score: scores[index], langCode: langCode);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Paywall gate
  // ---------------------------------------------------------------------------

  Widget _buildPaywallGate(BuildContext context, String langCode) {
    return AppScaffold(
      title: AppI18n.t('history.title', langCode),
      showBackButton: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSpacing.iconXxl + AppSpacing.lg,
                height: AppSpacing.iconXxl + AppSpacing.lg,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: AppSpacing.iconXl,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppI18n.t('history.fullTitle', langCode),
                style: AppTypography.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppI18n.t('history.fullSub', langCode),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: AppI18n.t('history.unlockPro', langCode),
                icon: Icons.star_rounded,
                onPressed: () => context.push(AppRoutes.paywall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _StatChip — one stat cell
// =============================================================================

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: AppSpacing.iconMd),
        const SizedBox(height: AppSpacing.xxs + 2),
        Text(
          value,
          style: AppTypography.headingSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// =============================================================================
// _MonthCalendar — one month grid
// =============================================================================

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.month,
    required this.scoresByKey,
    required this.langCode,
  });

  final DateTime month;
  final Map<String, DailyScore> scoresByKey;
  final String langCode;

  // First weekday: 1=Mon … 7=Sun  (Dart DateTime)
  // We want Mon=0 … Sun=6
  int _weekdayIndex(int dartWeekday) => (dartWeekday - 1) % 7;

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final monthLabel = AppI18n.monthLabel(month, langCode);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstWeekdayIdx = _weekdayIndex(DateTime(month.year, month.month, 1).weekday);

    final dayLabels = AppI18n.weekDayLabels(langCode);

    // Build flat list of cells: leading empty + day cells
    final totalCells = firstWeekdayIdx + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month title + legend
          Text(AppI18n.t('history.monthOverview', langCode), style: AppTypography.labelSmall),
          const SizedBox(height: AppSpacing.xxs),
          Text(monthLabel, style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _LegendChip(
                color: AppColors.secondary,
                label: AppI18n.t('history.legend.done', langCode),
              ),
              const SizedBox(width: AppSpacing.sm),
              _LegendChip(
                color: AppColors.surfaceLight,
                label: AppI18n.t('history.legend.missed', langCode),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Day-of-week header
          Row(
            children: dayLabels
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Day grid
          ...List.generate(rows, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: List.generate(7, (col) {
                  final cellIndex = row * 7 + col;
                  final dayNumber = cellIndex - firstWeekdayIdx + 1;

                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const Expanded(child: SizedBox());
                  }

                  final date = DateTime(month.year, month.month, dayNumber);
                  final key = _dateKey(date);
                  final score = scoresByKey[key];
                  final isToday = date == today;
                  final isFuture = date.isAfter(today);

                  return Expanded(
                    child: _DayCell(
                      score: score,
                      isToday: isToday,
                      isFuture: isFuture,
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// =============================================================================
// _DayCell — one small square in the month view
// =============================================================================

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.score,
    required this.isToday,
    required this.isFuture,
  });

  final DailyScore? score;
  final bool isToday;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    BoxBorder? border;

    if (isFuture) {
      bgColor = AppColors.background;
    } else if (score == null) {
      bgColor = AppColors.surfaceLight;
    } else {
      bgColor = AppColors.secondary;
    }

    if (isToday) {
      border = Border.all(color: AppColors.warning, width: 2);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(3),
          border: border,
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// =============================================================================
// _SessionTile — one row in the recent sessions list
// =============================================================================

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.score, required this.langCode});

  final DailyScore score;
  final String langCode;

  String _formatDate(DateTime date) {
    final weekDays = switch (langCode) {
      'nl' => const ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'],
      'en' => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      _ => const ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
    };

    final dayLabel = weekDays[(date.weekday - 1) % 7];
    final monthLabel = AppI18n.monthLabel(DateTime(date.year, date.month), langCode)
        .split(' ')
        .first;
    return '$dayLabel ${date.day} $monthLabel';
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).round();
    return '${minutes} min';
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = score.scorePercent >= 80;
    final badgeColor = isSuccess ? AppColors.secondary : AppColors.warning;
    final badgeBg = isSuccess
        ? AppColors.secondary.withValues(alpha: 0.12)
        : AppColors.warning.withValues(alpha: 0.12);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          // Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(score.date),
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${score.completedBlocks}/${score.totalBlocks} blocs  •  ${_formatDuration(score.actualDurationSeconds)}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs + 2,
            ),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '${score.scorePercent}%',
              style: AppTypography.labelSmall.copyWith(color: badgeColor),
            ),
          ),
        ],
      ),
    );
  }
}
