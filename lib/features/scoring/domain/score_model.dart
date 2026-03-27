import 'package:flutter/foundation.dart';
 
@immutable
class DailyScore {
  const DailyScore({
    required this.id,
    required this.date,
    required this.totalBlocks,
    required this.completedBlocks,
    required this.skippedBlocks,
    required this.totalDurationSeconds,
    required this.actualDurationSeconds,
  });
 
  final String id;
  final DateTime date;
  final int totalBlocks;
  final int completedBlocks;
  final int skippedBlocks;
  final int totalDurationSeconds;
  final int actualDurationSeconds;
 
  int get scorePercent =>
      totalBlocks > 0 ? (completedBlocks / totalBlocks * 100).round() : 0;
 
  bool get isSuccessful => scorePercent >= 80;
 
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'totalBlocks': totalBlocks,
      'completedBlocks': completedBlocks,
      'skippedBlocks': skippedBlocks,
      'totalDurationSeconds': totalDurationSeconds,
      'actualDurationSeconds': actualDurationSeconds,
    };
  }
 
  factory DailyScore.fromMap(Map<String, dynamic> map) {
    return DailyScore(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      totalBlocks: map['totalBlocks'] as int,
      completedBlocks: map['completedBlocks'] as int,
      skippedBlocks: map['skippedBlocks'] as int,
      totalDurationSeconds: map['totalDurationSeconds'] as int,
      actualDurationSeconds: map['actualDurationSeconds'] as int,
    );
  }
 
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyScore && other.id == id;
  }
 
  @override
  int get hashCode => id.hashCode;
}
