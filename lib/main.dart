import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'features/notifications/data/notification_service.dart';
import 'features/routine_builder/domain/block_model.dart';
import 'features/routine_builder/domain/routine_model.dart';
import 'features/shared_routines/data/shared_routines_local_source.dart';
import 'shared/models/time_of_day_adapter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Register custom adapters
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(BlockModelAdapter());
  Hive.registerAdapter(RoutineModelAdapter());

  // Open boxes
  await Future.wait([
    Hive.openBox(AppConstants.routineBoxName),
    Hive.openBox(AppConstants.scoresBoxName),
    Hive.openBox(AppConstants.settingsBoxName),
  ]);

  // Initialize shared routines cache (offline access)
  final localSource = SharedRoutinesLocalSource();
  await localSource.initialize();

  // Initialize notifications
  await NotificationService.instance.initialize();

  // RevenueCat is not implemented on Windows/Linux/Web.
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await Purchases.configure(
      PurchasesConfiguration(AppConstants.revenueCatApiKey),
    );
  }

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}