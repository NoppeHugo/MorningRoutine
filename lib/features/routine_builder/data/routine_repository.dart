import 'package:hive/hive.dart';

import '../domain/block_model.dart';
import '../domain/routine_model.dart';

class ScheduledRoutineActivation {
  const ScheduledRoutineActivation({
    required this.routineId,
    required this.activationDate,
  });

  final String routineId;
  final DateTime activationDate;
}
 
class RoutineRepository {
  RoutineRepository(this._box);
 
  final Box _box;

  static const _legacyCurrentRoutineKey = 'current_routine';
  static const _routinesKey = 'routines_v2';
  static const _activeRoutineIdKey = 'active_routine_id';
  static const _pendingRoutineIdKey = 'pending_active_routine_id';
  static const _pendingActivationDateKey = 'pending_active_routine_date';

  Future<void> _migrateLegacyStorage() async {
    final hasNewStorage = _box.get(_routinesKey) != null;
    if (hasNewStorage) return;

    final legacyData = _box.get(_legacyCurrentRoutineKey);
    if (legacyData == null) {
      await _saveRoutines(const []);
      return;
    }

    final legacyRoutine = _decodeRoutine(
      Map<String, dynamic>.from(legacyData as Map),
    );
    await _saveRoutines([legacyRoutine]);
    await _box.put(_activeRoutineIdKey, legacyRoutine.id);
    await _box.delete(_legacyCurrentRoutineKey);
  }

  Future<void> _applyScheduledActivationIfDue({DateTime? now}) async {
    await _migrateLegacyStorage();

    final pendingRoutineId = _box.get(_pendingRoutineIdKey) as String?;
    final pendingDateValue = _box.get(_pendingActivationDateKey) as String?;

    if (pendingRoutineId == null || pendingDateValue == null) {
      return;
    }

    final pendingDate = _parseDateKey(pendingDateValue);
    if (pendingDate == null) {
      await clearScheduledActivation();
      return;
    }

    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final canActivate = !today.isBefore(pendingDate);

    if (!canActivate) return;

    final routines = await getAllRoutines();
    final targetExists = _findById(routines, pendingRoutineId) != null;

    if (targetExists) {
      await _box.put(_activeRoutineIdKey, pendingRoutineId);
    }
    await clearScheduledActivation();
  }

  Future<List<RoutineModel>> getAllRoutines() async {
    await _migrateLegacyStorage();

    final data = _box.get(_routinesKey);
    if (data == null) return const [];

    final rawList = List<Map<String, dynamic>>.from(
      (data as List).map((item) => Map<String, dynamic>.from(item as Map)),
    );

    return rawList.map(_decodeRoutine).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<String?> getActiveRoutineId({DateTime? now}) async {
    await _applyScheduledActivationIfDue(now: now);
    return _box.get(_activeRoutineIdKey) as String?;
  }

  Future<RoutineModel?> getActiveRoutine({DateTime? now}) async {
    final routines = await getAllRoutines();
    if (routines.isEmpty) return null;

    final activeId = await getActiveRoutineId(now: now);
    if (activeId == null) return routines.first;
    return _findById(routines, activeId) ?? routines.first;
  }

  Future<ScheduledRoutineActivation?> getScheduledActivation() async {
    await _migrateLegacyStorage();
    final routineId = _box.get(_pendingRoutineIdKey) as String?;
    final activationDateKey = _box.get(_pendingActivationDateKey) as String?;
    if (routineId == null || activationDateKey == null) return null;

    final activationDate = _parseDateKey(activationDateKey);
    if (activationDate == null) return null;

    return ScheduledRoutineActivation(
      routineId: routineId,
      activationDate: activationDate,
    );
  }

  Future<void> scheduleActiveRoutineForTomorrow(
    String routineId, {
    DateTime? now,
  }) async {
    await _migrateLegacyStorage();

    final routines = await getAllRoutines();
    if (_findById(routines, routineId) == null) {
      throw StateError('Routine introuvable: $routineId');
    }

    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final tomorrow = today.add(const Duration(days: 1));

    await _box.put(_pendingRoutineIdKey, routineId);
    await _box.put(_pendingActivationDateKey, _formatDateKey(tomorrow));
  }

  Future<void> clearScheduledActivation() async {
    await _box.delete(_pendingRoutineIdKey);
    await _box.delete(_pendingActivationDateKey);
  }

  Future<void> setActiveRoutineNow(String routineId) async {
    await _migrateLegacyStorage();

    final routines = await getAllRoutines();
    if (_findById(routines, routineId) == null) {
      throw StateError('Routine introuvable: $routineId');
    }

    await _box.put(_activeRoutineIdKey, routineId);
    await clearScheduledActivation();
  }
 
  Future<RoutineModel?> getRoutine() async {
    return getActiveRoutine();
  }
 
  Future<void> saveRoutine(RoutineModel routine) async {
    final routines = await getAllRoutines();
    final index = routines.indexWhere((r) => r.id == routine.id);
    if (index == -1) {
      routines.add(routine);
    } else {
      routines[index] = routine;
    }

    await _saveRoutines(routines);

    final activeId = _box.get(_activeRoutineIdKey) as String?;
    if (activeId == null) {
      await _box.put(_activeRoutineIdKey, routine.id);
    }
  }
 
  Future<void> deleteRoutine() async {
    final activeId = await getActiveRoutineId();
    if (activeId == null) return;
    await deleteRoutineById(activeId);
  }

  Future<void> deleteRoutineById(String routineId) async {
    final routines = await getAllRoutines();
    final updated = routines.where((r) => r.id != routineId).toList();
    await _saveRoutines(updated);

    if (updated.isEmpty) {
      await _box.delete(_activeRoutineIdKey);
      await clearScheduledActivation();
      return;
    }

    final activeId = await getActiveRoutineId();
    if (activeId == routineId) {
      await _box.put(_activeRoutineIdKey, updated.first.id);
    }

    final scheduled = await getScheduledActivation();
    if (scheduled?.routineId == routineId) {
      await clearScheduledActivation();
    }
  }

  Future<void> _saveRoutines(List<RoutineModel> routines) async {
    final encoded = routines.map(_encodeRoutine).toList();
    await _box.put(_routinesKey, encoded);
  }

  RoutineModel? _findById(List<RoutineModel> routines, String routineId) {
    for (final routine in routines) {
      if (routine.id == routineId) return routine;
    }
    return null;
  }

  String _formatDateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime? _parseDateKey(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return null;

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;

    return DateTime(year, month, day);
  }
 
  Map<String, dynamic> _encodeRoutine(RoutineModel routine) {
    return {
      'id': routine.id,
      'name': routine.name,
      'wakeTimeHour': routine.wakeTimeHour,
      'wakeTimeMinute': routine.wakeTimeMinute,
      'blocks': routine.blocks.map((b) => _encodeBlock(b)).toList(),
      'createdAt': routine.createdAt.toIso8601String(),
      'updatedAt': routine.updatedAt.toIso8601String(),
    };
  }
 
  Map<String, dynamic> _encodeBlock(BlockModel block) {
    return {
      'id': block.id,
      'templateId': block.templateId,
      'name': block.name,
      'emoji': block.emoji,
      'durationMinutes': block.durationMinutes,
      'order': block.order,
    };
  }
 
  RoutineModel _decodeRoutine(Map<String, dynamic> data) {
    return RoutineModel(
      id: data['id'] as String,
      name: data['name'] as String,
      wakeTimeHour: data['wakeTimeHour'] as int,
      wakeTimeMinute: data['wakeTimeMinute'] as int,
      blocks: (data['blocks'] as List)
          .map((b) => _decodeBlock(Map<String, dynamic>.from(b as Map)))
          .toList(),
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }
 
  BlockModel _decodeBlock(Map<String, dynamic> data) {
    return BlockModel(
      id: data['id'] as String,
      templateId: data['templateId'] as String,
      name: data['name'] as String,
      emoji: data['emoji'] as String,
      durationMinutes: data['durationMinutes'] as int,
      order: data['order'] as int,
    );
  }
}
