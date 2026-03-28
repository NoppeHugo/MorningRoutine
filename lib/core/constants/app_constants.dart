abstract class AppConstants {
  // App
  static const String appName = 'Morning Routine';
  static const String appVersion = '1.0.0';

  // Hive box names
  static const String routineBoxName = 'routines';
  static const String scoresBoxName = 'scores';
  static const String settingsBoxName = 'settings';

  // Routine constraints
  static const int maxBlocks = 10;
  static const int minBlockDurationMinutes = 1;
  static const int maxBlockDurationMinutes = 60;
  static const int successScoreThreshold = 80;

  // Onboarding — duration options (minutes)
  static const List<int> durationOptions = [15, 30, 45, 60];

  static const Map<int, String> durationLabels = {
    15: 'Express',
    30: 'Standard',
    45: 'Complète',
    60: 'Warrior',
  };

  // Onboarding — goal options
  static const List<GoalOption> goalOptions = [
    GoalOption(id: 'energy', label: 'Énergie', emoji: '⚡'),
    GoalOption(id: 'focus', label: 'Focus', emoji: '🎯'),
    GoalOption(id: 'calm', label: 'Calme', emoji: '🧘'),
    GoalOption(id: 'fitness', label: 'Forme', emoji: '💪'),
    GoalOption(id: 'productivity', label: 'Productivité', emoji: '📈'),
  ];
}

class GoalOption {
  const GoalOption({
    required this.id,
    required this.label,
    required this.emoji,
  });

  final String id;
  final String label;
  final String emoji;
}
