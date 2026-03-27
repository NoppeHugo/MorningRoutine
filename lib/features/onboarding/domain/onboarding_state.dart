import 'package:flutter/material.dart';
 
@immutable
class OnboardingState {
  const OnboardingState({
    this.currentPage = 0,
    this.wakeTime,
    this.routineDurationMinutes,
    this.selectedGoals = const [],
    this.isCompleted = false,
  });
 
  final int currentPage;
  final TimeOfDay? wakeTime;
  final int? routineDurationMinutes;
  final List<String> selectedGoals;
  final bool isCompleted;
 
  bool get canProceed {
    switch (currentPage) {
      case 0:
        return true;
      case 1:
        return wakeTime != null;
      case 2:
        return routineDurationMinutes != null;
      case 3:
        return selectedGoals.isNotEmpty;
      default:
        return false;
    }
  }
 
  OnboardingState copyWith({
    int? currentPage,
    TimeOfDay? wakeTime,
    int? routineDurationMinutes,
    List<String>? selectedGoals,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      wakeTime: wakeTime ?? this.wakeTime,
      routineDurationMinutes:
          routineDurationMinutes ?? this.routineDurationMinutes,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
