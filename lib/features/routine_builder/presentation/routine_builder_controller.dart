import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
 
import '../../../core/constants/app_constants.dart';
import '../data/blocks_repository.dart';
import '../data/routine_repository.dart';
import '../domain/block_model.dart';
import '../domain/routine_model.dart';
 
@immutable
class RoutineBuilderState {
  const RoutineBuilderState({
    this.routine,
    this.isLoading = false,
    this.isSaving = false,
  });
 
  final RoutineModel? routine;
  final bool isLoading;
  final bool isSaving;
 
  RoutineBuilderState copyWith({
    RoutineModel? routine,
    bool? isLoading,
    bool? isSaving,
  }) {
    return RoutineBuilderState(
      routine: routine ?? this.routine,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
 
class RoutineBuilderController extends StateNotifier<RoutineBuilderState> {
  RoutineBuilderController(this._repository)
      : super(const RoutineBuilderState(isLoading: true)) {
    _loadRoutine();
  }
 
  final RoutineRepository _repository;
  static const _uuid = Uuid();
 
  Future<void> _loadRoutine() async {
    final routine = await _repository.getRoutine();
    if (routine != null) {
      state = state.copyWith(routine: routine, isLoading: false);
    } else {
      // Create a default routine from onboarding data
      final settingsBox = Hive.box(AppConstants.settingsBoxName);
      final hour = settingsBox.get('wakeTimeHour', defaultValue: 6) as int;
      final minute = settingsBox.get('wakeTimeMinute', defaultValue: 30) as int;
 
      state = state.copyWith(
        routine: RoutineModel(
          id: _uuid.v4(),
          name: 'Ma routine du matin',
          wakeTimeHour: hour,
          wakeTimeMinute: minute,
          blocks: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        isLoading: false,
      );
    }
  }
 
  void addBlock(BlockTemplate template) {
    final routine = state.routine;
    if (routine == null) return;
    if (routine.blocks.length >= AppConstants.maxBlocks) return;
 
    final block = BlockModel(
      id: _uuid.v4(),
      templateId: template.id,
      name: template.name,
      emoji: template.emoji,
      durationMinutes: template.defaultDurationMinutes,
      order: routine.blocks.length,
    );
 
    final updatedBlocks = [...routine.blocks, block];
    state = state.copyWith(
      routine: routine.copyWith(
        blocks: updatedBlocks,
        updatedAt: DateTime.now(),
      ),
    );
  }
 
  void removeBlock(String blockId) {
    final routine = state.routine;
    if (routine == null) return;
 
    final updatedBlocks = routine.blocks
        .where((b) => b.id != blockId)
        .toList()
        .asMap()
        .entries
        .map((e) => e.value.copyWith(order: e.key))
        .toList();
 
    state = state.copyWith(
      routine: routine.copyWith(
        blocks: updatedBlocks,
        updatedAt: DateTime.now(),
      ),
    );
  }
 
  void reorderBlocks(int oldIndex, int newIndex) {
    final routine = state.routine;
    if (routine == null) return;
 
    final blocks = List<BlockModel>.from(routine.blocks);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, item);
 
    final reordered = blocks
        .asMap()
        .entries
        .map((e) => e.value.copyWith(order: e.key))
        .toList();
 
    state = state.copyWith(
      routine: routine.copyWith(
        blocks: reordered,
        updatedAt: DateTime.now(),
      ),
    );
  }
 
  void updateBlockDuration(String blockId, int newDuration) {
    final routine = state.routine;
    if (routine == null) return;
 
    final updatedBlocks = routine.blocks.map((b) {
      if (b.id == blockId) {
        return b.copyWith(
          durationMinutes: newDuration.clamp(
            AppConstants.minBlockDurationMinutes,
            AppConstants.maxBlockDurationMinutes,
          ),
        );
      }
      return b;
    }).toList();
 
    state = state.copyWith(
      routine: routine.copyWith(
        blocks: updatedBlocks,
        updatedAt: DateTime.now(),
      ),
    );
  }
 
  Future<void> saveRoutine() async {
    final routine = state.routine;
    if (routine == null) return;
 
    state = state.copyWith(isSaving: true);
    await _repository.saveRoutine(routine);
    state = state.copyWith(isSaving: false);
  }
}
 
final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(Hive.box(AppConstants.routineBoxName));
});
 
final routineBuilderControllerProvider =
    StateNotifierProvider<RoutineBuilderController, RoutineBuilderState>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  return RoutineBuilderController(repository);
});
