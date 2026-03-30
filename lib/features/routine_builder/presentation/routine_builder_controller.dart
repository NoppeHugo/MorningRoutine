import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
 
import '../../../core/constants/app_constants.dart';
import '../data/blocks_repository.dart';
import '../data/preset_routines.dart';
import '../data/routine_repository.dart';
import '../domain/block_model.dart';
import '../domain/routine_model.dart';
 
@immutable
class RoutineBuilderState {
  const RoutineBuilderState({
    this.routines = const [],
    this.selectedRoutineId,
    this.activeRoutineId,
    this.pendingActivation,
    this.isLoading = false,
    this.isSaving = false,
  });

  static const _unchanged = Object();

  final List<RoutineModel> routines;
  final String? selectedRoutineId;
  final String? activeRoutineId;
  final ScheduledRoutineActivation? pendingActivation;
  final bool isLoading;
  final bool isSaving;

  RoutineModel? get routine {
    if (routines.isEmpty) return null;
    final selectedId = selectedRoutineId ?? activeRoutineId;
    if (selectedId == null) return routines.first;
    for (final routine in routines) {
      if (routine.id == selectedId) return routine;
    }
    return routines.first;
  }

  RoutineModel? get activeRoutine {
    if (routines.isEmpty) return null;
    final id = activeRoutineId;
    if (id == null) return routines.first;
    for (final routine in routines) {
      if (routine.id == id) return routine;
    }
    return routines.first;
  }

  RoutineModel? get scheduledRoutine {
    final scheduledId = pendingActivation?.routineId;
    if (scheduledId == null) return null;
    for (final routine in routines) {
      if (routine.id == scheduledId) return routine;
    }
    return null;
  }

  RoutineBuilderState copyWith({
    List<RoutineModel>? routines,
    Object? selectedRoutineId = _unchanged,
    Object? activeRoutineId = _unchanged,
    Object? pendingActivation = _unchanged,
    bool? isLoading,
    bool? isSaving,
  }) {
    return RoutineBuilderState(
      routines: routines ?? this.routines,
      selectedRoutineId: selectedRoutineId == _unchanged
          ? this.selectedRoutineId
          : selectedRoutineId as String?,
      activeRoutineId: activeRoutineId == _unchanged
          ? this.activeRoutineId
          : activeRoutineId as String?,
      pendingActivation: pendingActivation == _unchanged
          ? this.pendingActivation
          : pendingActivation as ScheduledRoutineActivation?,
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
    var routines = await _repository.getAllRoutines();

    if (routines.isEmpty) {
      final defaultRoutine = _buildDefaultRoutine();
      await _repository.saveRoutine(defaultRoutine);
      routines = await _repository.getAllRoutines();
    }

    final activeId = await _repository.getActiveRoutineId();
    final scheduled = await _repository.getScheduledActivation();

    final selectedId = (activeId != null && _containsRoutine(routines, activeId))
        ? activeId
        : routines.first.id;

    state = state.copyWith(
      routines: routines,
      selectedRoutineId: selectedId,
      activeRoutineId: activeId ?? routines.first.id,
      pendingActivation: scheduled,
      isLoading: false,
    );
  }

  RoutineModel _buildDefaultRoutine() {
    final settingsBox = Hive.box(AppConstants.settingsBoxName);
    final hour = settingsBox.get('wakeTimeHour', defaultValue: 6) as int;
    final minute = settingsBox.get('wakeTimeMinute', defaultValue: 30) as int;

    final now = DateTime.now();
    return RoutineModel(
      id: _uuid.v4(),
      name: 'Ma routine du matin',
      wakeTimeHour: hour,
      wakeTimeMinute: minute,
      blocks: const [],
      createdAt: now,
      updatedAt: now,
    );
  }

  bool _containsRoutine(List<RoutineModel> routines, String routineId) {
    return routines.any((routine) => routine.id == routineId);
  }

  Future<void> _syncWithRepository({String? preferredSelectedId}) async {
    final routines = await _repository.getAllRoutines();
    if (routines.isEmpty) {
      final defaultRoutine = _buildDefaultRoutine();
      await _repository.saveRoutine(defaultRoutine);
      return _syncWithRepository(preferredSelectedId: defaultRoutine.id);
    }

    final activeId = await _repository.getActiveRoutineId();
    final scheduled = await _repository.getScheduledActivation();

    var selectedId = state.selectedRoutineId;
    if (preferredSelectedId != null && _containsRoutine(routines, preferredSelectedId)) {
      selectedId = preferredSelectedId;
    } else if (selectedId != null && !_containsRoutine(routines, selectedId)) {
      selectedId = null;
    }

    selectedId ??= (activeId != null && _containsRoutine(routines, activeId))
        ? activeId
        : routines.first.id;

    state = state.copyWith(
      routines: routines,
      selectedRoutineId: selectedId,
      activeRoutineId: activeId ?? routines.first.id,
      pendingActivation: scheduled,
      isSaving: false,
      isLoading: false,
    );
  }

  void selectRoutine(String routineId) {
    if (!_containsRoutine(state.routines, routineId)) return;
    state = state.copyWith(selectedRoutineId: routineId);
  }

  Future<void> createRoutine() async {
    final now = DateTime.now();
    final settingsBox = Hive.box(AppConstants.settingsBoxName);
    final hour = settingsBox.get('wakeTimeHour', defaultValue: 6) as int;
    final minute = settingsBox.get('wakeTimeMinute', defaultValue: 30) as int;

    final routine = RoutineModel(
      id: _uuid.v4(),
      name: 'Routine ${state.routines.length + 1}',
      wakeTimeHour: hour,
      wakeTimeMinute: minute,
      blocks: const [],
      createdAt: now,
      updatedAt: now,
    );

    await _repository.saveRoutine(routine);
    await _syncWithRepository(preferredSelectedId: routine.id);
  }

  Future<void> deleteSelectedRoutine() async {
    final routine = state.routine;
    if (routine == null) return;

    // Keep at least one routine available in the app.
    if (state.routines.length <= 1) {
      final resetRoutine = routine.copyWith(
        blocks: const [],
        updatedAt: DateTime.now(),
      );
      await _repository.saveRoutine(resetRoutine);
      await _syncWithRepository(preferredSelectedId: resetRoutine.id);
      return;
    }

    await _repository.deleteRoutineById(routine.id);
    await _syncWithRepository();
  }

  Future<void> activateSelectedRoutineNow() async {
    final routine = state.routine;
    if (routine == null) return;

    await _repository.setActiveRoutineNow(routine.id);
    await _syncWithRepository(preferredSelectedId: routine.id);
  }

  Future<void> scheduleSelectedRoutineForTomorrow() async {
    final routine = state.routine;
    if (routine == null) return;

    await _repository.scheduleActiveRoutineForTomorrow(routine.id);
    await _syncWithRepository(preferredSelectedId: routine.id);
  }

  Future<void> clearScheduledActivation() async {
    await _repository.clearScheduledActivation();
    await _syncWithRepository();
  }

  Future<void> refresh() async {
    await _syncWithRepository();
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
    final updatedRoutine = routine.copyWith(
      blocks: updatedBlocks,
      updatedAt: DateTime.now(),
    );

    final updatedRoutines = state.routines
        .map((r) => r.id == updatedRoutine.id ? updatedRoutine : r)
        .toList();

    state = state.copyWith(
      routines: updatedRoutines,
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
 
    final updatedRoutine = routine.copyWith(
      blocks: updatedBlocks,
      updatedAt: DateTime.now(),
    );

    final updatedRoutines = state.routines
        .map((r) => r.id == updatedRoutine.id ? updatedRoutine : r)
        .toList();

    state = state.copyWith(
      routines: updatedRoutines,
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
 
    final updatedRoutine = routine.copyWith(
      blocks: reordered,
      updatedAt: DateTime.now(),
    );

    final updatedRoutines = state.routines
        .map((r) => r.id == updatedRoutine.id ? updatedRoutine : r)
        .toList();

    state = state.copyWith(
      routines: updatedRoutines,
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

    final updatedRoutine = routine.copyWith(
      blocks: updatedBlocks,
      updatedAt: DateTime.now(),
    );

    final updatedRoutines = state.routines
        .map((r) => r.id == updatedRoutine.id ? updatedRoutine : r)
        .toList();
 
    state = state.copyWith(
      routines: updatedRoutines,
    );
  }
 
  Future<void> saveRoutine() async {
    final routine = state.routine;
    if (routine == null) return;

    state = state.copyWith(isSaving: true);
    final updated = routine.copyWith(updatedAt: DateTime.now());
    await _repository.saveRoutine(updated);
    await _syncWithRepository(preferredSelectedId: updated.id);
  }

  Future<void> loadPreset(PresetRoutine preset) async {
    final routine = state.routine;
    if (routine == null) return;

    final blocks = preset.blockIds
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final templateId = entry.value;
          final template = BlocksRepository.findById(templateId);
          if (template == null) return null;
          return BlockModel(
            id: _uuid.v4(),
            templateId: template.id,
            name: template.name,
            emoji: template.emoji,
            durationMinutes: template.defaultDurationMinutes,
            order: index,
          );
        })
        .whereType<BlockModel>()
        .toList();

    final updatedRoutine = routine.copyWith(
      blocks: blocks,
      updatedAt: DateTime.now(),
    );
    final updatedRoutines = state.routines
        .map((r) => r.id == updatedRoutine.id ? updatedRoutine : r)
        .toList();

    state = state.copyWith(routines: updatedRoutines);
    await saveRoutine();
  }

  Future<void> importSharedRoutineTemplate({
    required String routineName,
    required List<String> blockTemplateIds,
    List<int>? blockDurationsMinutes,
    bool activateNow = false,
    bool activateTomorrow = false,
  }) async {
    final settingsBox = Hive.box(AppConstants.settingsBoxName);
    final hour = settingsBox.get('wakeTimeHour', defaultValue: 6) as int;
    final minute = settingsBox.get('wakeTimeMinute', defaultValue: 30) as int;

    final blockIds = blockTemplateIds.take(AppConstants.maxBlocks).toList();
    final blocks = <BlockModel>[];

    for (var index = 0; index < blockIds.length; index++) {
      final templateId = blockIds[index];
      final template = BlocksRepository.findById(templateId);
      if (template == null) continue;

      final customDuration =
          blockDurationsMinutes != null && index < blockDurationsMinutes.length
              ? blockDurationsMinutes[index]
              : null;

      blocks.add(
        BlockModel(
          id: _uuid.v4(),
          templateId: template.id,
          name: template.name,
          emoji: template.emoji,
          durationMinutes: (customDuration ?? template.defaultDurationMinutes)
              .clamp(
                AppConstants.minBlockDurationMinutes,
                AppConstants.maxBlockDurationMinutes,
              )
              .toInt(),
          order: blocks.length,
        ),
      );
    }

    final now = DateTime.now();
    final importedRoutine = RoutineModel(
      id: _uuid.v4(),
      name: routineName,
      wakeTimeHour: hour,
      wakeTimeMinute: minute,
      blocks: blocks,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.saveRoutine(importedRoutine);

    if (activateNow) {
      await _repository.setActiveRoutineNow(importedRoutine.id);
    } else if (activateTomorrow) {
      await _repository.scheduleActiveRoutineForTomorrow(importedRoutine.id);
    }

    await _syncWithRepository(preferredSelectedId: importedRoutine.id);
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
