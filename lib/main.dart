import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
 
import 'app.dart';
import 'core/constants/app_constants.dart';
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
 
  // Open boxes
  await Future.wait([
    Hive.openBox(AppConstants.routineBoxName),
    Hive.openBox(AppConstants.scoresBoxName),
    Hive.openBox(AppConstants.settingsBoxName),
  ]);
 
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}