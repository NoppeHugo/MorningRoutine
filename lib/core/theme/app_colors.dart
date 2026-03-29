import 'package:flutter/material.dart';

abstract class AppColors {
  // Backgrounds (iOS system backgrounds)
  static const Color background = Color(0xFFF2F2F7);     // iOS grouped background
  static const Color surface = Color(0xFFFFFFFF);         // Cards / list items
  static const Color surfaceLight = Color(0xFFE5E5EA);   // Subtle separator / secondary surface
  static const Color surfaceElevated = Color(0xFFFFFFFF); // Elevated cards

  // Brand (morning sunrise palette)
  static const Color primary = Color(0xFFFF6B00);         // Warm orange — énergie du matin
  static const Color primaryLight = Color(0xFFFFE8D6);    // Orange très clair (tint backgrounds)
  static const Color secondary = Color(0xFF34C759);       // iOS green — succès / streak

  // Text (iOS system labels)
  static const Color textPrimary = Color(0xFF000000);     // iOS Label
  static const Color textSecondary = Color(0xFF636366);   // iOS Secondary Label
  static const Color textTertiary = Color(0xFFAEAEB2);    // iOS Tertiary Label
  static const Color textOnPrimary = Color(0xFFFFFFFF);   // Texte sur bouton orange

  // Semantic
  static const Color error = Color(0xFFFF3B30);           // iOS Red
  static const Color success = Color(0xFF34C759);         // iOS Green
  static const Color warning = Color(0xFFFF9500);         // iOS Orange
  static const Color separator = Color(0xFFC6C6C8);      // iOS separator

  // Legacy aliases (used in existing widgets)
  static const Color surfaceHighlight = Color(0xFFE5E5EA);  // = surfaceLight
  static const Color secondaryLight = Color(0xFF86E8A4);    // green tint
  static const Color primaryDark = Color(0xFFCC5500);       // darker orange
  static const Color streak = Color(0xFFFF9500);            // streak counter = iOS orange
  static const Color textOnSecondary = Color(0xFF000000);   // text on green
  static const Color timerProgress = Color(0xFFFF6B00);     // = primary
  static const Color timerBackground = Color(0xFFFFE8D6);   // = primaryLight
  static const Color blockCompleted = Color(0xFF34C759);    // = secondary
  static const Color blockSkipped = Color(0xFFFF3B30);      // = error
  static const Color blockCurrent = Color(0xFFFF6B00);      // = primary
  static const Color blockPending = Color(0xFFE5E5EA);      // = surfaceLight
  static const Color errorLight = Color(0xFFFFD0CE);        // red tint
  static const Color warningLight = Color(0xFFFFEDD0);      // orange tint
  static const Color info = Color(0xFF007AFF);              // iOS blue

  // Gradients helpers
  static const List<Color> primaryGradient = [Color(0xFFFF6B00), Color(0xFFFF9500)];
  static const List<Color> successGradient = [Color(0xFF34C759), Color(0xFF30D158)];
}
