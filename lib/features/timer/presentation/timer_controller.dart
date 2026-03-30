import 'dart:async';
 
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../routine_builder/domain/routine_model.dart';
import '../../routine_builder/presentation/routine_builder_controller.dart';
import '../domain/timer_state.dart';
 
class TimerController extends StateNotifier<TimerState> {
  TimerController(RoutineModel routine)
      : super(TimerState(
          routine: routine,
          secondsRemaining: routine.blocks.isNotEmpty
              ? routine.blocks.first.durationMinutes * 60
              : 0,
        ));

  Timer? _timer;

  void setSessionMode(RoutineSessionMode mode) {
    state = state.copyWith(sessionMode: mode);
  }

  void setMoodBefore(String mood) {
    state = state.copyWith(moodBefore: mood);
  }

  void setCheckoutData({
    required String moodAfter,
    String? reflection,
    String? intention,
    String? topPriority,
  }) {
    state = state.copyWith(
      moodAfter: moodAfter,
      reflection: reflection,
      intention: intention,
      topPriority: topPriority,
    );
  }
 
  void start() {
    if (state.sessionMode != RoutineSessionMode.guided) return;
    if (state.status == TimerStatus.running) return;
 
    final now = DateTime.now();
    state = state.copyWith(
      status: TimerStatus.running,
      startedAt: state.startedAt ?? now,
      blockStartedAt: state.blockStartedAt ?? now,
    );
 
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }
 
  void pause() {
    if (state.status != TimerStatus.running) return;
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }
 
  void togglePlayPause() {
    if (state.status == TimerStatus.running) {
      pause();
    } else {
      start();
    }
  }
 
  void _tick() {
    if (state.secondsRemaining <= 1) {
      _completeCurrentBlock(completed: true);
      return;
    }
 
    state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
  }
 
  void completeBlock() {
    if (state.sessionMode != RoutineSessionMode.guided) return;
    _completeCurrentBlock(completed: true);
  }
 
  void skipBlock() {
    if (state.sessionMode != RoutineSessionMode.guided) return;
    _completeCurrentBlock(completed: false);
  }

  void toggleChecklistBlock(String blockId, bool done) {
    if (state.sessionMode != RoutineSessionMode.checklist) return;

    final existing = [...state.completedBlocks]
      ..removeWhere((result) => result.blockId == blockId);

    if (done) {
      final block = state.routine.blocks.firstWhere((b) => b.id == blockId);
      existing.add(
        BlockResult(
          blockId: blockId,
          completed: true,
          actualDurationSeconds: block.durationMinutes * 60,
        ),
      );
    }

    state = state.copyWith(
      completedBlocks: existing,
      status: TimerStatus.idle,
      startedAt: state.startedAt ?? DateTime.now(),
    );
  }

  void finishChecklist() {
    if (state.sessionMode != RoutineSessionMode.checklist) return;

    final doneIds = state.completedBlocks
        .where((b) => b.completed)
        .map((b) => b.blockId)
        .toSet();

    final results = state.routine.blocks
        .map(
          (block) => BlockResult(
            blockId: block.id,
            completed: doneIds.contains(block.id),
            actualDurationSeconds:
                doneIds.contains(block.id) ? block.durationMinutes * 60 : 0,
          ),
        )
        .toList();

    state = state.copyWith(
      completedBlocks: results,
      status: TimerStatus.completed,
      secondsRemaining: 0,
      startedAt: state.startedAt ?? DateTime.now(),
    );
  }
 
  void _completeCurrentBlock({required bool completed}) {
    _timer?.cancel();
 
    // Haptic feedback
    HapticFeedback.mediumImpact();
 
    final blockDuration = state.currentBlock.durationMinutes * 60;
    final actualDuration = state.blockStartedAt != null
        ? DateTime.now().difference(state.blockStartedAt!).inSeconds
        : blockDuration - state.secondsRemaining;
 
    final result = BlockResult(
      blockId: state.currentBlock.id,
      completed: completed,
      actualDurationSeconds: actualDuration,
    );
 
    final updatedResults = [...state.completedBlocks, result];
 
    if (state.isLastBlock) {
      // Routine finished
      state = state.copyWith(
        completedBlocks: updatedResults,
        status: TimerStatus.completed,
        secondsRemaining: 0,
      );
    } else {
      // Move to next block
      final nextIndex = state.currentBlockIndex + 1;
      final nextBlock = state.routine.blocks[nextIndex];
 
      state = state.copyWith(
        completedBlocks: updatedResults,
        currentBlockIndex: nextIndex,
        secondsRemaining: nextBlock.durationMinutes * 60,
        status: TimerStatus.running,
        blockStartedAt: DateTime.now(),
      );
 
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }
 
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
 
final timerControllerProvider =
    StateNotifierProvider.autoDispose<TimerController, TimerState>((ref) {
  final routineState = ref.read(routineBuilderControllerProvider);
  final routine = routineState.activeRoutine;
 
  if (routine == null || routine.blocks.isEmpty) {
    throw StateError('No routine available to start timer');
  }
 
  return TimerController(routine);
});
