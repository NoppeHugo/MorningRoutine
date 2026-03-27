import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
 
import '../../../features/timer/domain/timer_state.dart';
import '../data/scoring_repository.dart';
import '../domain/score_model.dart';
 
@immutable
class ScoringState {
  const ScoringState({
    this.todayScore,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.isLoading = false,
  });
 
  final DailyScore? todayScore;
  final int currentStreak;
  final int bestStreak;
  final bool isLoading;
 
  bool get hasCompletedToday => todayScore != null;
 
  ScoringState copyWith({
    DailyScore? todayScore,
    int? currentStreak,
    int? bestStreak,
    bool? isLoading,
  }) {
    return ScoringState(
      todayScore: todayScore ?? this.todayScore,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
 
class ScoringController extends StateNotifier<ScoringState> {
  ScoringController(this._repository)
      : super(const ScoringState(isLoading: true)) {
    _loadData();
  }
 
  final ScoringRepository _repository;
  static const _uuid = Uuid();
 
  void _loadData() {
    final todayScore = _repository.getTodayScore();
    final currentStreak = _repository.getCurrentStreak();
    final bestStreak = _repository.getBestStreak();
 
    state = ScoringState(
      todayScore: todayScore,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );
  }
 
  Future<void> saveRoutineResult(TimerState timerState) async {
    final completedCount =
        timerState.completedBlocks.where((b) => b.completed).length;
    final skippedCount =
        timerState.completedBlocks.where((b) => !b.completed).length;
    final totalDuration = timerState.routine.blocks
        .fold<int>(0, (sum, b) => sum + b.durationMinutes * 60);
    final actualDuration = timerState.completedBlocks
        .fold<int>(0, (sum, b) => sum + b.actualDurationSeconds);
 
    final score = DailyScore(
      id: _uuid.v4(),
      date: DateTime.now(),
      totalBlocks: timerState.totalBlocksCount,
      completedBlocks: completedCount,
      skippedBlocks: skippedCount,
      totalDurationSeconds: totalDuration,
      actualDurationSeconds: actualDuration,
    );
 
    await _repository.saveScore(score);
    _loadData();
  }
 
  void refresh() {
    _loadData();
  }
}
 
final scoringControllerProvider =
    StateNotifierProvider<ScoringController, ScoringState>((ref) {
  return ScoringController(scoringRepositoryInstance);
});
