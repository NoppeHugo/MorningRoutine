import 'package:hive/hive.dart';
 
import '../../../core/constants/app_constants.dart';
import '../domain/block_model.dart';
import '../domain/routine_model.dart';
 
class RoutineRepository {
  RoutineRepository(this._box);
 
  final Box _box;
 
  Future<RoutineModel?> getRoutine() async {
    final data = _box.get('current_routine');
    if (data == null) return null;
    return _decodeRoutine(Map<String, dynamic>.from(data as Map));
  }
 
  Future<void> saveRoutine(RoutineModel routine) async {
    await _box.put('current_routine', _encodeRoutine(routine));
  }
 
  Future<void> deleteRoutine() async {
    await _box.delete('current_routine');
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
