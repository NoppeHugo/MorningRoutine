import 'package:flutter/material.dart';

enum AchievementTier { bronze, silver, gold, platinum }

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tier,
    required this.condition,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AchievementTier tier;
  final String condition;
}
