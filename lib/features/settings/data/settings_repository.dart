import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
 
import '../../../core/constants/app_constants.dart';
import '../domain/settings_model.dart';
 
class SettingsRepository {
  SettingsRepository(this._box);
 
  final Box _box;
 
  SettingsModel loadSettings() {
    return SettingsModel(
      wakeTime: TimeOfDay(
        hour: _box.get('wakeTimeHour', defaultValue: 6) as int,
        minute: _box.get('wakeTimeMinute', defaultValue: 30) as int,
      ),
      notificationsEnabled:
          _box.get('notificationsEnabled', defaultValue: true) as bool,
      notificationTime: TimeOfDay(
        hour: _box.get('notificationTimeHour', defaultValue: 6) as int,
        minute: _box.get('notificationTimeMinute', defaultValue: 25) as int,
      ),
      soundEnabled: _box.get('soundEnabled', defaultValue: true) as bool,
      vibrationEnabled:
          _box.get('vibrationEnabled', defaultValue: true) as bool,
    );
  }
 
  Future<void> saveSettings(SettingsModel settings) async {
    await _box.put('wakeTimeHour', settings.wakeTime.hour);
    await _box.put('wakeTimeMinute', settings.wakeTime.minute);
    await _box.put('notificationsEnabled', settings.notificationsEnabled);
    await _box.put('notificationTimeHour', settings.notificationTime.hour);
    await _box.put(
        'notificationTimeMinute', settings.notificationTime.minute);
    await _box.put('soundEnabled', settings.soundEnabled);
    await _box.put('vibrationEnabled', settings.vibrationEnabled);
  }
 
  Future<void> resetAllData() async {
    await Hive.box(AppConstants.routineBoxName).clear();
    await Hive.box(AppConstants.scoresBoxName).clear();
    await _box.clear();
  }
}
 
final settingsRepositoryInstance =
    SettingsRepository(Hive.box(AppConstants.settingsBoxName));
