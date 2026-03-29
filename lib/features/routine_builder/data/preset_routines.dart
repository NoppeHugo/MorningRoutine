import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Represents a pre-built expert routine that users can load in one tap.
class PresetRoutine {
  const PresetRoutine({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.blockIds,
    required this.isPro,
    required this.authorLabel,
    required this.accentColor,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<String> blockIds;
  final bool isPro;
  final String authorLabel;
  final Color accentColor;

  int get totalDurationMinutes => blockIds.length; // computed dynamically
}

abstract class PresetRoutines {
  static const List<PresetRoutine> all = [
    PresetRoutine(
      id: 'five_am',
      name: '5h du matin',
      description: 'La routine des top performers. Énergie maximale dès l\'aube.',
      icon: Icons.wb_sunny_rounded,
      blockIds: [
        'water',
        'stretching',
        'exercise',
        'cold_shower',
        'journaling',
        'planning',
      ],
      isPro: false,
      authorLabel: 'Inspiré du "5 AM Club"',
      accentColor: AppColors.primary,
    ),
    PresetRoutine(
      id: 'minimalist',
      name: 'Minimaliste 20min',
      description: 'L\'essentiel en 20 minutes. Idéal pour commencer.',
      icon: Icons.spa_rounded,
      blockIds: [
        'water',
        'meditation',
        'breakfast',
        'planning',
      ],
      isPro: false,
      authorLabel: 'Pour les débutants',
      accentColor: AppColors.secondary,
    ),
    PresetRoutine(
      id: 'athlete',
      name: 'Athlète',
      description: 'Corps et esprit au sommet. La routine des sportifs de haut niveau.',
      icon: Icons.fitness_center_rounded,
      blockIds: [
        'water',
        'stretching',
        'exercise',
        'cold_shower',
        'breakfast',
        'visualization',
      ],
      isPro: true,
      authorLabel: 'Pour les sportifs',
      accentColor: AppColors.primary,
    ),
    PresetRoutine(
      id: 'entrepreneur',
      name: 'Entrepreneur focalisé',
      description: 'Clarté mentale et intention forte. Optimisé pour la productivité.',
      icon: Icons.rocket_launch_rounded,
      blockIds: [
        'water',
        'meditation',
        'journaling',
        'planning',
        'reading',
        'affirmations',
      ],
      isPro: true,
      authorLabel: 'Par les entrepreneurs',
      accentColor: AppColors.info,
    ),
    PresetRoutine(
      id: 'wellness',
      name: 'Bien-être complet',
      description: 'La routine équilibrée pour corps, mental et âme.',
      icon: Icons.favorite_rounded,
      blockIds: [
        'meditation',
        'breathing',
        'journaling',
        'gratitude',
        'stretching',
        'breakfast',
        'walk',
      ],
      isPro: true,
      authorLabel: 'Pour le bien-être',
      accentColor: AppColors.secondary,
    ),
    PresetRoutine(
      id: 'stoic',
      name: 'Stoïcien',
      description: 'Discipline, réflexion, action. Inspiré des philosophes stoïciens.',
      icon: Icons.architecture_rounded,
      blockIds: [
        'water',
        'cold_shower',
        'journaling',
        'reading',
        'planning',
      ],
      isPro: false,
      authorLabel: 'Inspiré des stoïciens',
      accentColor: AppColors.textSecondary,
    ),
  ];
}
