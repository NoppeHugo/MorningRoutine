import 'package:hive/hive.dart';
 
import '../../../core/constants/app_constants.dart';
import '../domain/score_model.dart';
import '../domain/streak_calculator.dart';
 
class ScoringRepository {
  ScoringRepository(this._box);
 
  final Box _box;
 
  Future<void> saveScore(DailyScore score) async {
    await _box.put(score.dateKey, score.toMap());
  }
 
  DailyScore? getScoreForDate(DateTime date) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final data = _box.get(key);
    if (data == null) return null;
    return DailyScore.fromMap(Map<String, dynamic>.from(data as Map));
  }
 
  List<DailyScore> getAllScores() {
    final scores = <DailyScore>[];
    for (final key in _box.keys) {
      final data = _box.get(key);
      if (data != null && data is Map) {
        try {
          scores.add(DailyScore.fromMap(Map<String, dynamic>.from(data)));
        } catch (_) {
          // Skip invalid entries
        }
      }
    }
    return scores;
  }
 
  DailyScore? getTodayScore() {
    return getScoreForDate(DateTime.now());
  }
 
  int getCurrentStreak() {
    return StreakCalculator.calculateStreak(getAllScores());
  }
 
  int getBestStreak() {
    return StreakCalculator.calculateBestStreak(getAllScores());
  }
}
 
final scoringRepositoryInstance =
    ScoringRepository(Hive.box(AppConstants.scoresBoxName));
