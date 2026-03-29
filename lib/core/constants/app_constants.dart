abstract class AppConstants {
  static const int maxBlocks = 10;
  static const int freeBlockLimit = 3;
  static const int minBlockDurationMinutes = 1;
  static const int maxBlockDurationMinutes = 60;
  static const int successScoreThreshold = 80;
  static const String appName = 'Morning Routine';
  static const String appVersion = '1.0.0';

  // RevenueCat
  static const String revenueCatApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';
  static const String premiumEntitlementId = 'pro';

  // Hive box names
  static const String routineBoxName = 'routines';
  static const String scoresBoxName = 'scores';
  static const String settingsBoxName = 'settings';

  // Duration options for onboarding
  static const List<int> durationOptions = [15, 30, 45, 60];

  // Duration labels
  static const Map<int, String> durationLabels = {
    15: 'Express',
    30: 'Standard',
    45: 'Complète',
    60: 'Warrior',
  };

  // Goal options
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
