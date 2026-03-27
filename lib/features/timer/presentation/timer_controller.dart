import 'dart:async';
 
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../routine_builder/domain/routine_model.dart';
import '../../routine_builder/presentation/routine_builder_controller.dart';
import '../domain/timer_state.dart';
 
class TimerController extends StateNotifier<TimerState> {
  TimerController(this._routine)
      : super(TimerState(
          routine: _routine,
          secondsRemaining: _routine.blocks.isNotEmpty
              ? _routine.blocks.first.durationMinutes * 60
              : 0,
        ));
 
  final RoutineModel _routine;
  Timer? _timer;
 
  void start() {
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
    _completeCurrentBlock(completed: true);
  }
 
  void skipBlock() {
    _completeCurrentBlock(completed: false);
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
  final routine = routineState.routine;
 
  if (routine == null || routine.blocks.isEmpty) {
    throw StateError('No routine available to start timer');
  }
 
  return TimerController(routine);
});
