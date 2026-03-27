import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
 
import '../../core/constants/app_constants.dart';
 
/// Provider that exposes whether onboarding has been completed.
final isOnboardingCompletedProvider = StateProvider<bool>((ref) {
  final box = Hive.box(AppConstants.settingsBoxName);
  return box.get('isOnboardingCompleted', defaultValue: false) as bool;
});
 
/// Provider for the settings Hive box.
final settingsBoxProvider = Provider<Box>((ref) {
  return Hive.box(AppConstants.settingsBoxName);
});
 
/// Provider for the routines Hive box.
final routineBoxProvider = Provider<Box>((ref) {
  return Hive.box(AppConstants.routineBoxName);
});
 
/// Provider for the scores Hive box.
final scoresBoxProvider = Provider<Box>((ref) {
  return Hive.box(AppConstants.scoresBoxName);
});
