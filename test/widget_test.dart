import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:morning_routine/app.dart';
import 'package:morning_routine/core/constants/app_constants.dart';

void main() {
  setUpAll(() async {
    final hiveDir = await Directory.systemTemp.createTemp('morning_routine_test_');
    Hive.init(hiveDir.path);
    await Hive.openBox(AppConstants.settingsBoxName);
    await Hive.openBox(AppConstants.routineBoxName);
    await Hive.openBox(AppConstants.scoresBoxName);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );

    expect(find.byType(App), findsOneWidget);
  });
}
