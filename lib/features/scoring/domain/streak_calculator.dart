import 'score_model.dart';
 
abstract class StreakCalculator {
  /// Calculates current streak from a list of daily scores.
  /// A day counts if score >= 80%.
  /// Streak resets if a day is missed.
  static int calculateStreak(List<DailyScore> scores) {
    if (scores.isEmpty) return 0;
 
    // Sort by date descending
    final sorted = List<DailyScore>.from(scores)
      ..sort((a, b) => b.date.compareTo(a.date));
 
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
 
    int streak = 0;
    var expectedDate = todayDate;
 
    for (final score in sorted) {
      final scoreDate =
          DateTime(score.date.year, score.date.month, score.date.day);
 
      // Allow checking today or the expected date
      final diff = expectedDate.difference(scoreDate).inDays;
 
      if (diff == 0 && score.isSuccessful) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else if (diff == 0 && !score.isSuccessful) {
        // Today's score exists but not successful
        break;
      } else if (diff > 0) {
        // Missed a day
        break;
      }
    }
 
    return streak;
  }
 
  /// Calculates best ever streak from a list of daily scores.
  static int calculateBestStreak(List<DailyScore> scores) {
    if (scores.isEmpty) return 0;
 
    final sorted = List<DailyScore>.from(scores)
      ..sort((a, b) => a.date.compareTo(b.date));
 
    int bestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;
 
    for (final score in sorted) {
      if (!score.isSuccessful) {
        currentStreak = 0;
        lastDate = null;
        continue;
      }
 
      final scoreDate =
          DateTime(score.date.year, score.date.month, score.date.day);
 
      if (lastDate == null) {
        currentStreak = 1;
      } else {
        final diff = scoreDate.difference(lastDate!).inDays;
        if (diff == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
      }
 
      lastDate = scoreDate;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }
    }
 
    return bestStreak;
  }
}
