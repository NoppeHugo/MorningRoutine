import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
 
part 'block_model.g.dart';
 
@immutable
@HiveType(typeId: 0)
class BlockModel {
  const BlockModel({
    required this.id,
    required this.templateId,
    required this.name,
    required this.emoji,
    required this.durationMinutes,
    required this.order,
  });
 
  @HiveField(0)
  final String id;
 
  @HiveField(1)
  final String templateId;
 
  @HiveField(2)
  final String name;
 
  @HiveField(3)
  final String emoji;
 
  @HiveField(4)
  final int durationMinutes;
 
  @HiveField(5)
  final int order;
 
  BlockModel copyWith({
    String? id,
    String? templateId,
    String? name,
    String? emoji,
    int? durationMinutes,
    int? order,
  }) {
    return BlockModel(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      order: order ?? this.order,
    );
  }
 
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlockModel &&
        other.id == id &&
        other.templateId == templateId &&
        other.name == name &&
        other.emoji == emoji &&
        other.durationMinutes == durationMinutes &&
        other.order == order;
  }
 
  @override
  int get hashCode =>
      Object.hash(id, templateId, name, emoji, durationMinutes, order);
}
