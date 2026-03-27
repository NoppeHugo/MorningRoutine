import 'package:flutter/foundation.dart';
 
import '../../routine_builder/domain/block_model.dart';
import '../../routine_builder/domain/routine_model.dart';
 
enum TimerStatus { idle, running, paused, completed, skipped }
 
@immutable
class BlockResult {
  const BlockResult({
    required this.blockId,
    required this.completed,
    required this.actualDurationSeconds,
  });
 
  final String blockId;
  final bool completed;
  final int actualDurationSeconds;
}
 
@immutable
class TimerState {
  const TimerState({
    required this.routine,
    this.currentBlockIndex = 0,
    this.secondsRemaining = 0,
    this.status = TimerStatus.idle,
    this.completedBlocks = const [],
    this.startedAt,
    this.blockStartedAt,
  });
 
  final RoutineModel routine;
  final int currentBlockIndex;
  final int secondsRemaining;
  final TimerStatus status;
  final List<BlockResult> completedBlocks;
  final DateTime? startedAt;
  final DateTime? blockStartedAt;
 
  BlockModel get currentBlock => routine.blocks[currentBlockIndex];
  bool get isLastBlock => currentBlockIndex == routine.blocks.length - 1;
 
  double get progress {
    final totalSeconds = currentBlock.durationMinutes * 60;
    if (totalSeconds == 0) return 1.0;
    return 1.0 - (secondsRemaining / totalSeconds);
  }
 
  int get totalBlocksCount => routine.blocks.length;
  int get completedBlocksCount => completedBlocks.length;
 
  bool get isRoutineCompleted =>
      status == TimerStatus.completed &&
      currentBlockIndex >= routine.blocks.length - 1;
 
  TimerState copyWith({
    RoutineModel? routine,
    int? currentBlockIndex,
    int? secondsRemaining,
    TimerStatus? status,
    List<BlockResult>? completedBlocks,
    DateTime? startedAt,
    DateTime? blockStartedAt,
  }) {
    return TimerState(
      routine: routine ?? this.routine,
      currentBlockIndex: currentBlockIndex ?? this.currentBlockIndex,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      status: status ?? this.status,
      completedBlocks: completedBlocks ?? this.completedBlocks,
      startedAt: startedAt ?? this.startedAt,
      blockStartedAt: blockStartedAt ?? this.blockStartedAt,
    );
  }
}
