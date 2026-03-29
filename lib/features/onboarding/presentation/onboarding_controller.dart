import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/storage_provider.dart';
import '../../notifications/data/notification_service.dart';
import '../data/onboarding_repository.dart';
import '../domain/onboarding_state.dart';
 
class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._repository)
      : super(const OnboardingState(
          wakeTime: TimeOfDay(hour: 6, minute: 30),
        ));
 
  final OnboardingRepository _repository;
 
  void nextPage() {
    if (state.currentPage < 3) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }
 
  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }
 
  void setWakeTime(TimeOfDay time) {
    state = state.copyWith(wakeTime: time);
  }
 
  void setDuration(int minutes) {
    state = state.copyWith(routineDurationMinutes: minutes);
  }
 
  void toggleGoal(String goalId) {
    final goals = List<String>.from(state.selectedGoals);
    if (goals.contains(goalId)) {
      goals.remove(goalId);
    } else {
      goals.add(goalId);
    }
    state = state.copyWith(selectedGoals: goals);
  }
 
  Future<void> completeOnboarding(WidgetRef ref) async {
    if (state.wakeTime == null || state.routineDurationMinutes == null) return;
 
    await _repository.completeOnboarding(
      wakeTime: state.wakeTime!,
      durationMinutes: state.routineDurationMinutes!,
      goals: state.selectedGoals,
    );
 
    ref.read(isOnboardingCompletedProvider.notifier).state = true;
    await NotificationService.instance.requestPermissions();
    if (state.wakeTime != null) {
      await NotificationService.instance
          .scheduleMorningReminder(state.wakeTime!);
    }
    state = state.copyWith(isCompleted: true);
  }
}
 
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(onboardingRepositoryProvider);
});
