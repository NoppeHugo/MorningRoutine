import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../scoring/data/scoring_repository.dart';
import '../data/achievements_repository.dart';
import '../domain/achievement_model.dart';

@immutable
class AchievementsState {
  const AchievementsState({
    this.all = const [],
    this.unlockedIds = const {},
    this.isLoading = false,
  });

  final List<Achievement> all;
  final Set<String> unlockedIds;
  final bool isLoading;

  // Computed — achievements that are currently unlocked
  List<Achievement> get unlocked =>
      all.where((a) => unlockedIds.contains(a.id)).toList();

  // Computed — achievements that are still locked
  List<Achievement> get locked =>
      all.where((a) => !unlockedIds.contains(a.id)).toList();

  // Computed — count of unlocked achievements
  int get unlockedCount => unlockedIds.length;

  AchievementsState copyWith({
    List<Achievement>? all,
    Set<String>? unlockedIds,
    bool? isLoading,
  }) {
    return AchievementsState(
      all: all ?? this.all,
      unlockedIds: unlockedIds ?? this.unlockedIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AchievementsController extends StateNotifier<AchievementsState> {
  AchievementsController(this._scoringRepository, this._achievementsRepository)
      : super(const AchievementsState(isLoading: true)) {
    _loadData();
  }

  final ScoringRepository _scoringRepository;
  final AchievementsRepository _achievementsRepository;

  void _loadData() {
    final scores = _scoringRepository.getAllScores();
    final unlockedIds = _achievementsRepository.getUnlockedIds(scores);

    state = AchievementsState(
      all: AchievementsRepository.allAchievements,
      unlockedIds: unlockedIds,
    );
  }

  void refresh() {
    _loadData();
  }
}

final achievementsControllerProvider =
    StateNotifierProvider<AchievementsController, AchievementsState>((ref) {
  return AchievementsController(
    scoringRepositoryInstance,
    const AchievementsRepository(),
  );
});
