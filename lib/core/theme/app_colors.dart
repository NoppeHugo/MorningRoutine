import 'package:flutter/material.dart';

abstract class AppColors {
  // Premium dark foundations
  static const Color background = Color(0xFF0E121D);
  static const Color surface = Color(0xFF1A2132);
  static const Color surfaceLight = Color(0xFF252E43);
  static const Color surfaceElevated = Color(0xFF20283D);

  // Brand accents (subtle, not flashy)
  static const Color primary = Color(0xFF8A90FF);
  static const Color primaryLight = Color(0xFF2D3552);
  static const Color secondary = Color(0xFF68C9B4);

  // Text hierarchy
  static const Color textPrimary = Color(0xFFF2F4F8);
  static const Color textSecondary = Color(0xFFB7BDCB);
  static const Color textTertiary = Color(0xFF8A93A8);
  static const Color textOnPrimary = Color(0xFF131824);

  // Semantic colors
  static const Color error = Color(0xFFC95C76);
  static const Color success = Color(0xFF68C9B4);
  static const Color warning = Color(0xFFD6B07A);
  static const Color separator = Color(0xFF323B52);

  // Legacy aliases (used in existing widgets)
  static const Color surfaceHighlight = Color(0xFF2D3650);
  static const Color secondaryLight = Color(0xFF8CDBCB);
  static const Color primaryDark = Color(0xFF7178E6);
  static const Color streak = Color(0xFFD6B07A);
  static const Color textOnSecondary = Color(0xFF12211D);
  static const Color timerProgress = Color(0xFF8A90FF);
  static const Color timerBackground = Color(0xFF303A57);
  static const Color blockCompleted = Color(0xFF68C9B4);
  static const Color blockSkipped = Color(0xFFC95C76);
  static const Color blockCurrent = Color(0xFF8A90FF);
  static const Color blockPending = Color(0xFF2B3348);
  static const Color errorLight = Color(0xFF3A2730);
  static const Color warningLight = Color(0xFF3A3227);
  static const Color info = Color(0xFF7BB8FF);

  // Gradients helpers
  static const List<Color> primaryGradient = [Color(0xFF8A90FF), Color(0xFFA6AAFF)];
  static const List<Color> successGradient = [Color(0xFF68C9B4), Color(0xFF86D7C7)];
}
