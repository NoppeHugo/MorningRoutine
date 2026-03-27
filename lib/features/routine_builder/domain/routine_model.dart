import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
 
import 'block_model.dart';
 
part 'routine_model.g.dart';
 
@immutable
@HiveType(typeId: 1)
class RoutineModel {
  const RoutineModel({
    required this.id,
    required this.name,
    required this.wakeTimeHour,
    required this.wakeTimeMinute,
    required this.blocks,
    required this.createdAt,
    required this.updatedAt,
  });
 
  @HiveField(0)
  final String id;
 
  @HiveField(1)
  final String name;
 
  @HiveField(2)
  final int wakeTimeHour;
 
  @HiveField(3)
  final int wakeTimeMinute;
 
  @HiveField(4)
  final List<BlockModel> blocks;
 
  @HiveField(5)
  final DateTime createdAt;
 
  @HiveField(6)
  final DateTime updatedAt;
 
  TimeOfDay get wakeTime => TimeOfDay(hour: wakeTimeHour, minute: wakeTimeMinute);
 
  int get totalDurationMinutes =>
      blocks.fold(0, (sum, b) => sum + b.durationMinutes);
 
  TimeOfDay get endTime {
    final totalMinutes =
        wakeTimeHour * 60 + wakeTimeMinute + totalDurationMinutes;
    return TimeOfDay(
      hour: (totalMinutes ~/ 60) % 24,
      minute: totalMinutes % 60,
    );
  }
 
  RoutineModel copyWith({
    String? id,
    String? name,
    int? wakeTimeHour,
    int? wakeTimeMinute,
    List<BlockModel>? blocks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      wakeTimeHour: wakeTimeHour ?? this.wakeTimeHour,
      wakeTimeMinute: wakeTimeMinute ?? this.wakeTimeMinute,
      blocks: blocks ?? this.blocks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
 
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoutineModel && other.id == id;
  }
 
  @override
  int get hashCode => id.hashCode;
}
