import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    final isPremium = ref.watch(premiumControllerProvider).isPremium;
    if (!isPremium) return _buildPaywallGate(context);

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
      title: 'Historique',
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
            ),
            const SizedBox(height: AppSpacing.lg),

            // Section B — Calendar (current month)
            _MonthCalendar(
              month: currentMonth,
              scoresByKey: scoresByKey,
            ),
            const SizedBox(height: AppSpacing.md),

            // Section B — Calendar (previous month)
            _MonthCalendar(
              month: previousMonth,
              scoresByKey: scoresByKey,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Section C — Recent sessions list
            if (last10.isNotEmpty) ...[
              Text('Dernières sessions', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.sm),
              _buildRecentSessionsList(last10),
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section A — 4 summary chips
  // ---------------------------------------------------------------------------

  Widget _buildSummarySection({
    required int bestStreak,
    required int totalCompleted,
    required int avgScore,
    required int activeDaysThisMonth,
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
              label: 'Meilleur\nstreak',
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.check_circle_outline_rounded,
              iconColor: AppColors.secondary,
              value: '$totalCompleted',
              label: 'Routines\ncomplétées',
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.bar_chart_rounded,
              iconColor: AppColors.primary,
              value: '$avgScore%',
              label: 'Score\nmoyen',
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _StatChip(
              icon: Icons.calendar_today_rounded,
              iconColor: AppColors.info,
              value: '$activeDaysThisMonth',
              label: 'Jours actifs\nce mois',
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

  Widget _buildRecentSessionsList(List<DailyScore> scores) {
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
          return _SessionTile(score: scores[index]);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Paywall gate
  // ---------------------------------------------------------------------------

  Widget _buildPaywallGate(BuildContext context) {
    return AppScaffold(
      title: 'Historique',
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
                'Historique complet',
                style: AppTypography.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Vois ta progression sur 30 jours, tes scores passés et tes statistiques détaillées.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Débloquer avec Pro',
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
  });

  final DateTime month;
  final Map<String, DailyScore> scoresByKey;

  // First weekday: 1=Mon … 7=Sun  (Dart DateTime)
  // We want Mon=0 … Sun=6
  int _weekdayIndex(int dartWeekday) => (dartWeekday - 1) % 7;

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final monthLabel = _capitalise(DateFormat('MMMM yyyy', 'fr_FR').format(month));
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstWeekdayIdx = _weekdayIndex(DateTime(month.year, month.month, 1).weekday);

    const dayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

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
          // Month title
          Text(monthLabel, style: AppTypography.labelLarge),
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
                      dayNumber: dayNumber,
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

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// =============================================================================
// _DayCell — one day circle in the calendar
// =============================================================================

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.dayNumber,
    required this.score,
    required this.isToday,
    required this.isFuture,
  });

  final int dayNumber;
  final DailyScore? score;
  final bool isToday;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Widget? overlay;
    BoxBorder? border;

    if (isFuture) {
      bgColor = Colors.transparent;
      textColor = AppColors.textTertiary;
    } else if (score == null) {
      bgColor = AppColors.surfaceLight;
      textColor = AppColors.textSecondary;
    } else if (score!.scorePercent >= 80) {
      bgColor = AppColors.secondary;
      textColor = Colors.white;
      overlay = const Icon(
        Icons.check_rounded,
        size: 10,
        color: Colors.white,
      );
    } else {
      // score > 0 but < 80
      bgColor = AppColors.warning.withValues(alpha: 0.35);
      textColor = AppColors.textPrimary;
    }

    if (isToday) {
      border = Border.all(color: AppColors.warning, width: 2);
      if (score == null && !isFuture) {
        bgColor = Colors.transparent;
        textColor = AppColors.warning;
      }
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.xxs),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$dayNumber',
              style: AppTypography.bodySmall.copyWith(
                color: textColor,
                fontWeight:
                    isToday ? FontWeight.w700 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
            if (overlay != null)
              Positioned(
                bottom: 2,
                right: 2,
                child: overlay,
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// _SessionTile — one row in the recent sessions list
// =============================================================================

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.score});

  final DailyScore score;

  String _formatDate(DateTime date) {
    return _capitalise(
      DateFormat('EEE. d MMMM', 'fr_FR').format(date),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).round();
    return '${minutes} min';
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

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
