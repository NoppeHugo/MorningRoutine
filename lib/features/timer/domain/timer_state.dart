import 'package:flutter/foundation.dart';
 
import '../../routine_builder/domain/block_model.dart';
import '../../routine_builder/domain/routine_model.dart';
 
enum TimerStatus { idle, running, paused, completed, skipped }
enum RoutineSessionMode { checklist, guided }
 
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
    this.sessionMode = RoutineSessionMode.checklist,
    this.completedBlocks = const [],
    this.startedAt,
    this.blockStartedAt,
    this.moodBefore,
    this.moodAfter,
    this.reflection,
    this.intention,
    this.topPriority,
  });
 
  final RoutineModel routine;
  final int currentBlockIndex;
  final int secondsRemaining;
  final TimerStatus status;
  final RoutineSessionMode sessionMode;
  final List<BlockResult> completedBlocks;
  final DateTime? startedAt;
  final DateTime? blockStartedAt;
  final String? moodBefore;
  final String? moodAfter;
  final String? reflection;
  final String? intention;
  final String? topPriority;
 
  BlockModel get currentBlock => routine.blocks[currentBlockIndex];
  bool get isLastBlock => currentBlockIndex == routine.blocks.length - 1;
 
  double get progress {
    final totalSeconds = currentBlock.durationMinutes * 60;
    if (totalSeconds == 0) return 1.0;
    return 1.0 - (secondsRemaining / totalSeconds);
  }
 
  int get totalBlocksCount => routine.blocks.length;
  int get completedBlocksCount => completedBlocks.length;
 
  bool get isRoutineCompleted => status == TimerStatus.completed;
 
  TimerState copyWith({
    RoutineModel? routine,
    int? currentBlockIndex,
    int? secondsRemaining,
    TimerStatus? status,
    RoutineSessionMode? sessionMode,
    List<BlockResult>? completedBlocks,
    DateTime? startedAt,
    DateTime? blockStartedAt,
    String? moodBefore,
    String? moodAfter,
    String? reflection,
    String? intention,
    String? topPriority,
  }) {
    return TimerState(
      routine: routine ?? this.routine,
      currentBlockIndex: currentBlockIndex ?? this.currentBlockIndex,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      status: status ?? this.status,
      sessionMode: sessionMode ?? this.sessionMode,
      completedBlocks: completedBlocks ?? this.completedBlocks,
      startedAt: startedAt ?? this.startedAt,
      blockStartedAt: blockStartedAt ?? this.blockStartedAt,
      moodBefore: moodBefore ?? this.moodBefore,
      moodAfter: moodAfter ?? this.moodAfter,
      reflection: reflection ?? this.reflection,
      intention: intention ?? this.intention,
      topPriority: topPriority ?? this.topPriority,
    );
  }
}
