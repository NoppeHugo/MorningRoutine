import 'package:home_widget/home_widget.dart';
import '../scoring/data/scoring_repository.dart';

class WidgetService {
  static const _appGroupId = 'group.com.morningroutine.app';
  static const _iOSWidgetName = 'MorningRoutineWidget';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Appelé après chaque complétion de routine et au démarrage de l'app
  static Future<void> updateWidget() async {
    final repo = scoringRepositoryInstance;
    final streak = repo.getCurrentStreak();
    final todayScore = repo.getTodayScore();
    final doneToday = todayScore != null;
    final scorePercent = todayScore?.scorePercent ?? 0;

    await HomeWidget.saveWidgetData<int>('streak', streak);
    await HomeWidget.saveWidgetData<bool>('doneToday', doneToday);
    await HomeWidget.saveWidgetData<int>('scorePercent', scorePercent);
    await HomeWidget.saveWidgetData<String>(
      'statusText',
      doneToday ? 'Routine du jour ✓' : 'À faire ce matin',
    );

    await HomeWidget.updateWidget(
      name: _iOSWidgetName,
      iOSName: _iOSWidgetName,
    );
  }
}
