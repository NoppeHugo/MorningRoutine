import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
 
import '../../../core/constants/app_constants.dart';
 
class OnboardingRepository {
  OnboardingRepository(this._box);
 
  final Box _box;
 
  Future<void> completeOnboarding({
    required TimeOfDay wakeTime,
    required int durationMinutes,
    required List<String> goals,
  }) async {
    await _box.put('isOnboardingCompleted', true);
    await _box.put('wakeTimeHour', wakeTime.hour);
    await _box.put('wakeTimeMinute', wakeTime.minute);
    await _box.put('routineDurationMinutes', durationMinutes);
    await _box.put('selectedGoals', goals);
  }
 
  bool get isOnboardingCompleted {
    return _box.get('isOnboardingCompleted', defaultValue: false) as bool;
  }
 
  TimeOfDay? get savedWakeTime {
    final hour = _box.get('wakeTimeHour') as int?;
    final minute = _box.get('wakeTimeMinute') as int?;
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }
 
  int? get savedDurationMinutes {
    return _box.get('routineDurationMinutes') as int?;
  }
 
  List<String> get savedGoals {
    final goals = _box.get('selectedGoals');
    if (goals == null) return [];
    return List<String>.from(goals as List);
  }
}
 
final onboardingRepositoryProvider =
    OnboardingRepository(Hive.box(AppConstants.settingsBoxName));
