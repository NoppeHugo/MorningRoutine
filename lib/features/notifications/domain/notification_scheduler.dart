import 'package:flutter/material.dart';
 
import '../data/notification_service.dart';
 
/// Handles scheduling and cancelling notifications based on settings.
abstract class NotificationScheduler {
  static Future<void> updateMorningReminder({
    required bool enabled,
    required TimeOfDay time,
  }) async {
    final service = NotificationService.instance;
    await service.initialize();
 
    if (enabled) {
      await service.requestPermissions();
      await service.scheduleMorningReminder(time);
    } else {
      await service.cancelAll();
    }
  }
 
  static Future<void> cancelAll() async {
    await NotificationService.instance.cancelAll();
  }
}
