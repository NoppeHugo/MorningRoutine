import 'package:flutter/material.dart';
 
abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color primaryDark = Color(0xFF5B4BC4);
 
  // Secondary
  static const Color secondary = Color(0xFF00D9A5);
  static const Color secondaryLight = Color(0xFF5EFFC1);
 
  // Backgrounds
  static const Color background = Color(0xFF000000);  // noir pur iOS
  static const Color surface = Color(0xFF1C1C1E);  // iOS systemGray6
  static const Color surfaceLight = Color(0xFF2C2C2E);  // iOS systemGray5
  static const Color surfaceHighlight = Color(0xFF2F2F4A);
 
  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E9A);
  static const Color textTertiary = Color(0xFF5E5E6A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF0F0F1A);
 
  // Status
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFFA8A8);
  static const Color warning = Color(0xFFFECA57);
  static const Color warningLight = Color(0xFFFFE8B8);
  static const Color success = Color(0xFF00D9A5);
  static const Color info = Color(0xFF54A0FF);
 
  // Special
  static const Color streak = Color(0xFFFF6B35);
  static const Color timerProgress = Color(0xFF6C5CE7);
  static const Color timerBackground = Color(0xFF252542);
  static const Color blockCompleted = Color(0xFF00D9A5);
  static const Color blockSkipped = Color(0xFFFF6B6B);
  static const Color blockCurrent = Color(0xFF6C5CE7);
  static const Color blockPending = Color(0xFF3E3E5A);
}
