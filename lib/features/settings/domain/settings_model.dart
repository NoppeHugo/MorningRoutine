import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
 
@immutable
class SettingsModel {
  const SettingsModel({
    this.wakeTime = const TimeOfDay(hour: 6, minute: 30),
    this.notificationsEnabled = true,
    this.notificationTime = const TimeOfDay(hour: 6, minute: 25),
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });
 
  final TimeOfDay wakeTime;
  final bool notificationsEnabled;
  final TimeOfDay notificationTime;
  final bool soundEnabled;
  final bool vibrationEnabled;
 
  SettingsModel copyWith({
    TimeOfDay? wakeTime,
    bool? notificationsEnabled,
    TimeOfDay? notificationTime,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return SettingsModel(
      wakeTime: wakeTime ?? this.wakeTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}
