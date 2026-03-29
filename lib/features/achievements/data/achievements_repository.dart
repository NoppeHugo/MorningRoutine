import 'package:flutter/material.dart';

import '../../scoring/domain/score_model.dart';
import '../../scoring/domain/streak_calculator.dart';
import '../domain/achievement_model.dart';

class AchievementsRepository {
  const AchievementsRepository();

  // ─── Complete list of 12 achievements ────────────────────────────────────

  static const List<Achievement> allAchievements = [
    Achievement(
      id: 'first_routine',
      title: 'Premier pas',
      description: 'Tu as complété ta première routine',
      icon: Icons.flag_rounded,
      tier: AchievementTier.bronze,
      condition: '1 routine complétée',
    ),
    Achievement(
      id: 'streak_3',
      title: 'Lancé !',
      description: '3 jours d\'affilée',
      icon: Icons.local_fire_department_rounded,
      tier: AchievementTier.bronze,
      condition: 'Streak actuel ou passé >= 3',
    ),
    Achievement(
      id: 'streak_7',
      title: 'Habitude naissante',
      description: '7 jours consécutifs',
      icon: Icons.local_fire_department_rounded,
      tier: AchievementTier.silver,
      condition: 'Meilleur streak >= 7',
    ),
    Achievement(
      id: 'streak_14',
      title: 'Deux semaines',
      description: '14 jours sans briser la chaîne',
      icon: Icons.local_fire_department_rounded,
      tier: AchievementTier.silver,
      condition: 'Meilleur streak >= 14',
    ),
    Achievement(
      id: 'streak_30',
      title: 'Morning Champion',
      description: '30 jours de routine parfaite',
      icon: Icons.emoji_events_rounded,
      tier: AchievementTier.gold,
      condition: 'Meilleur streak >= 30',
    ),
    Achievement(
      id: 'streak_100',
      title: 'Légende',
      description: '100 jours. Tu n\'es plus humain.',
      icon: Icons.workspace_premium_rounded,
      tier: AchievementTier.platinum,
      condition: 'Meilleur streak >= 100',
    ),
    Achievement(
      id: 'perfect_score',
      title: 'Perfectionniste',
      description: 'Score 100% sur une routine',
      icon: Icons.star_rounded,
      tier: AchievementTier.silver,
      condition: 'Au moins 1 score à 100%',
    ),
    Achievement(
      id: 'five_perfect',
      title: 'Sans faute',
      description: '5 routines avec score 100%',
      icon: Icons.stars_rounded,
      tier: AchievementTier.gold,
      condition: '5 scores à 100%',
    ),
    Achievement(
      id: 'ten_routines',
      title: '10 matins',
      description: '10 routines complétées au total',
      icon: Icons.check_circle_rounded,
      tier: AchievementTier.bronze,
      condition: '>= 10 routines complétées',
    ),
    Achievement(
      id: 'thirty_routines',
      title: '30 matins',
      description: '30 routines réussies',
      icon: Icons.check_circle_rounded,
      tier: AchievementTier.silver,
      condition: '>= 30 routines réussies',
    ),
    Achievement(
      id: 'early_bird',
      title: 'Lève-tôt',
      description: 'Routine complétée avant 7h du matin',
      icon: Icons.wb_sunny_rounded,
      tier: AchievementTier.bronze,
      condition: 'Routine terminée avant 7h',
    ),
    Achievement(
      id: 'consistent_week',
      title: 'Semaine parfaite',
      description: '7 jours dans la même semaine, tous réussis',
      icon: Icons.calendar_today_rounded,
      tier: AchievementTier.gold,
      condition: '7 jours consécutifs dans la même semaine ISO',
    ),
  ];

  // ─── Unlock logic ─────────────────────────────────────────────────────────

  Set<String> getUnlockedIds(List<DailyScore> scores) {
    final unlocked = <String>{};

    if (scores.isEmpty) return unlocked;

    final successfulScores =
        scores.where((s) => s.isSuccessful).toList();
    final perfectScores =
        scores.where((s) => s.scorePercent == 100).toList();

    final bestStreak = StreakCalculator.calculateBestStreak(scores);

    // first_routine — any completed routine (isSuccessful)
    if (successfulScores.isNotEmpty) {
      unlocked.add('first_routine');
    }

    // streak_3 — best streak >= 3
    if (bestStreak >= 3) unlocked.add('streak_3');

    // streak_7 — best streak >= 7
    if (bestStreak >= 7) unlocked.add('streak_7');

    // streak_14 — best streak >= 14
    if (bestStreak >= 14) unlocked.add('streak_14');

    // streak_30 — best streak >= 30
    if (bestStreak >= 30) unlocked.add('streak_30');

    // streak_100 — best streak >= 100
    if (bestStreak >= 100) unlocked.add('streak_100');

    // perfect_score — at least one 100% score
    if (perfectScores.isNotEmpty) {
      unlocked.add('perfect_score');
    }

    // five_perfect — at least five 100% scores
    if (perfectScores.length >= 5) {
      unlocked.add('five_perfect');
    }

    // ten_routines — at least 10 successful routines
    if (successfulScores.length >= 10) {
      unlocked.add('ten_routines');
    }

    // thirty_routines — at least 30 successful routines
    if (successfulScores.length >= 30) {
      unlocked.add('thirty_routines');
    }

    // early_bird — at least one score with date.hour < 7
    final hasEarlyBird = scores.any((s) => s.date.hour < 7);
    if (hasEarlyBird) unlocked.add('early_bird');

    // consistent_week — 7 successful scores within the same ISO week
    if (_hasPerfectIsoWeek(successfulScores)) {
      unlocked.add('consistent_week');
    }

    return unlocked;
  }

  // Returns true if there exists an ISO week that contains 7 distinct
  // days all marked successful.
  bool _hasPerfectIsoWeek(List<DailyScore> successfulScores) {
    if (successfulScores.length < 7) return false;

    // Group by ISO year-week key (Monday = day 1 of ISO week)
    final weekDays = <String, Set<int>>{};

    for (final score in successfulScores) {
      final date = score.date;
      // ISO week number: shift weekday so Monday = 0
      final mondayOffset = date.weekday - 1; // weekday: 1=Mon, 7=Sun
      final monday =
          DateTime(date.year, date.month, date.day)
              .subtract(Duration(days: mondayOffset));
      final weekKey =
          '${monday.year}-${monday.month.toString().padLeft(2, '0')}-'
          '${monday.day.toString().padLeft(2, '0')}';

      weekDays.putIfAbsent(weekKey, () => <int>{});
      weekDays[weekKey]!.add(date.weekday); // 1–7, unique per day
    }

    return weekDays.values.any((days) => days.length >= 7);
  }
}
