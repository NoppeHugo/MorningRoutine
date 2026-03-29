import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
 
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
 
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
 
  bool _initialized = false;
 
  Future<void> initialize() async {
    if (_initialized) return;
 
    tz_data.initializeTimeZones();
 
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
 
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
 
    await _plugin.initialize(settings);
    _initialized = true;
  }
 
  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }
 
    final darwin = _plugin.resolvePlatformSpecificImplementation<
        DarwinFlutterLocalNotificationsPlugin>();
    if (darwin != null) {
      final granted = await darwin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
 
    return true;
  }
 
  Future<void> scheduleMorningReminder(TimeOfDay time) async {
    await cancelAll();
 
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
 
    // If the time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
 
    const androidDetails = AndroidNotificationDetails(
      'morning_reminder',
      'Rappel matinal',
      channelDescription: 'Rappel pour ta routine du matin',
      importance: Importance.high,
      priority: Priority.high,
    );
 
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
 
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
 
    await _plugin.zonedSchedule(
      0,
      '🌅 Ta routine t\'attend !',
      'C\'est l\'heure de commencer ta matinée parfaite.',
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
 
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
 
  Future<void> showInstant(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'instant',
      'Notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
 
    const details = NotificationDetails(android: androidDetails);
 
    await _plugin.show(99, title, body, details);
  }
}
