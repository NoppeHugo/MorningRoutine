import 'package:flutter/material.dart';

/// Block categories for grouping in the catalogue.
enum BlockCategory {
  mindfulness,
  mouvement,
  nutrition,
  developpementPersonnel,
  hygieneSoin,
  productivite,
}

extension BlockCategoryExtension on BlockCategory {
  String get label {
    switch (this) {
      case BlockCategory.mindfulness:
        return 'Mindfulness';
      case BlockCategory.mouvement:
        return 'Mouvement';
      case BlockCategory.nutrition:
        return 'Nutrition';
      case BlockCategory.developpementPersonnel:
        return 'Développement personnel';
      case BlockCategory.hygieneSoin:
        return 'Hygiène & Soin';
      case BlockCategory.productivite:
        return 'Productivité';
    }
  }

  /// Accent color per category.
  Color get color {
    switch (this) {
      case BlockCategory.mindfulness:
        return const Color(0xFF5E5CE6); // iOS indigo
      case BlockCategory.mouvement:
        return const Color(0xFFFF6B00); // orange primary
      case BlockCategory.nutrition:
        return const Color(0xFF34C759); // iOS green
      case BlockCategory.developpementPersonnel:
        return const Color(0xFF007AFF); // iOS blue
      case BlockCategory.hygieneSoin:
        return const Color(0xFF30B0C7); // iOS teal
      case BlockCategory.productivite:
        return const Color(0xFFFF9500); // iOS amber
    }
  }
}

/// Provides the predefined block templates for the MVP.
class BlockTemplate {
  const BlockTemplate({
    required this.id,
    required this.name,
    required this.emoji,
    required this.defaultDurationMinutes,
    required this.category,
    required this.icon,
  });

  final String id;
  final String name;
  final String emoji;
  final int defaultDurationMinutes;
  final BlockCategory category;
  final IconData icon;
}

abstract class BlocksRepository {
  static const List<BlockTemplate> templates = [
    // ── MINDFULNESS ──────────────────────────────────────────────────────────
    BlockTemplate(
      id: 'meditation',
      name: 'Méditation guidée',
      emoji: '🧘',
      defaultDurationMinutes: 10,
      category: BlockCategory.mindfulness,
      icon: Icons.self_improvement_rounded,
    ),
    BlockTemplate(
      id: 'breathing',
      name: 'Respiration 4-7-8',
      emoji: '🌬️',
      defaultDurationMinutes: 5,
      category: BlockCategory.mindfulness,
      icon: Icons.air_rounded,
    ),
    BlockTemplate(
      id: 'gratitude',
      name: 'Gratitude journal',
      emoji: '🙏',
      defaultDurationMinutes: 5,
      category: BlockCategory.mindfulness,
      icon: Icons.volunteer_activism_rounded,
    ),
    BlockTemplate(
      id: 'visualization',
      name: 'Visualisation',
      emoji: '🎯',
      defaultDurationMinutes: 5,
      category: BlockCategory.mindfulness,
      icon: Icons.visibility_rounded,
    ),
    BlockTemplate(
      id: 'affirmations',
      name: 'Affirmations',
      emoji: '💬',
      defaultDurationMinutes: 3,
      category: BlockCategory.mindfulness,
      icon: Icons.record_voice_over_rounded,
    ),

    // ── MOUVEMENT ─────────────────────────────────────────────────────────────
    BlockTemplate(
      id: 'stretching',
      name: 'Étirements',
      emoji: '🤸',
      defaultDurationMinutes: 10,
      category: BlockCategory.mouvement,
      icon: Icons.accessibility_new_rounded,
    ),
    BlockTemplate(
      id: 'yoga',
      name: 'Yoga',
      emoji: '🧘',
      defaultDurationMinutes: 15,
      category: BlockCategory.mouvement,
      icon: Icons.self_improvement_rounded,
    ),
    BlockTemplate(
      id: 'hiit',
      name: 'HIIT',
      emoji: '⚡',
      defaultDurationMinutes: 15,
      category: BlockCategory.mouvement,
      icon: Icons.directions_run_rounded,
    ),
    BlockTemplate(
      id: 'walk',
      name: 'Marche',
      emoji: '🚶',
      defaultDurationMinutes: 15,
      category: BlockCategory.mouvement,
      icon: Icons.directions_walk_rounded,
    ),
    BlockTemplate(
      id: 'exercise',
      name: 'Pompes / musculation',
      emoji: '💪',
      defaultDurationMinutes: 10,
      category: BlockCategory.mouvement,
      icon: Icons.fitness_center_rounded,
    ),

    // ── NUTRITION ─────────────────────────────────────────────────────────────
    BlockTemplate(
      id: 'water',
      name: 'Verre d\'eau',
      emoji: '💧',
      defaultDurationMinutes: 2,
      category: BlockCategory.nutrition,
      icon: Icons.local_drink_rounded,
    ),
    BlockTemplate(
      id: 'breakfast',
      name: 'Petit-déjeuner sain',
      emoji: '🍳',
      defaultDurationMinutes: 15,
      category: BlockCategory.nutrition,
      icon: Icons.restaurant_menu_rounded,
    ),
    BlockTemplate(
      id: 'vitamins',
      name: 'Vitamines / compléments',
      emoji: '💊',
      defaultDurationMinutes: 2,
      category: BlockCategory.nutrition,
      icon: Icons.medication_rounded,
    ),
    BlockTemplate(
      id: 'coffee',
      name: 'Café / thé',
      emoji: '☕',
      defaultDurationMinutes: 5,
      category: BlockCategory.nutrition,
      icon: Icons.coffee_rounded,
    ),

    // ── DÉVELOPPEMENT PERSONNEL ───────────────────────────────────────────────
    BlockTemplate(
      id: 'reading',
      name: 'Lecture',
      emoji: '📚',
      defaultDurationMinutes: 15,
      category: BlockCategory.developpementPersonnel,
      icon: Icons.menu_book_rounded,
    ),
    BlockTemplate(
      id: 'podcast',
      name: 'Podcast / audio',
      emoji: '🎧',
      defaultDurationMinutes: 15,
      category: BlockCategory.developpementPersonnel,
      icon: Icons.headphones_rounded,
    ),
    BlockTemplate(
      id: 'learning',
      name: 'Apprentissage',
      emoji: '🎓',
      defaultDurationMinutes: 10,
      category: BlockCategory.developpementPersonnel,
      icon: Icons.school_rounded,
    ),
    BlockTemplate(
      id: 'goals_review',
      name: 'Révision objectifs',
      emoji: '🏹',
      defaultDurationMinutes: 5,
      category: BlockCategory.developpementPersonnel,
      icon: Icons.track_changes_rounded,
    ),
    BlockTemplate(
      id: 'journaling',
      name: 'Journaling',
      emoji: '📝',
      defaultDurationMinutes: 10,
      category: BlockCategory.developpementPersonnel,
      icon: Icons.edit_note_rounded,
    ),

    // ── HYGIÈNE & SOIN ────────────────────────────────────────────────────────
    BlockTemplate(
      id: 'cold_shower',
      name: 'Douche froide',
      emoji: '🧊',
      defaultDurationMinutes: 3,
      category: BlockCategory.hygieneSoin,
      icon: Icons.shower_rounded,
    ),
    BlockTemplate(
      id: 'skincare',
      name: 'Skincare',
      emoji: '✨',
      defaultDurationMinutes: 5,
      category: BlockCategory.hygieneSoin,
      icon: Icons.face_rounded,
    ),
    BlockTemplate(
      id: 'teeth',
      name: 'Brossage de dents',
      emoji: '🦷',
      defaultDurationMinutes: 2,
      category: BlockCategory.hygieneSoin,
      icon: Icons.medical_information_rounded,
    ),

    // ── PRODUCTIVITÉ ──────────────────────────────────────────────────────────
    BlockTemplate(
      id: 'planning',
      name: 'Planning du jour',
      emoji: '📋',
      defaultDurationMinutes: 5,
      category: BlockCategory.productivite,
      icon: Icons.today_rounded,
    ),
    BlockTemplate(
      id: 'emails',
      name: 'Emails / messages urgents',
      emoji: '📬',
      defaultDurationMinutes: 5,
      category: BlockCategory.productivite,
      icon: Icons.mail_outline_rounded,
    ),
    BlockTemplate(
      id: 'top3',
      name: 'Top 3 priorités',
      emoji: '🏆',
      defaultDurationMinutes: 3,
      category: BlockCategory.productivite,
      icon: Icons.format_list_numbered_rounded,
    ),
  ];

  /// Returns templates grouped by category, preserving the canonical order.
  static Map<BlockCategory, List<BlockTemplate>> get templatesByCategory {
    final map = <BlockCategory, List<BlockTemplate>>{};
    for (final t in templates) {
      map.putIfAbsent(t.category, () => []).add(t);
    }
    return map;
  }

  /// Returns the [BlockTemplate] matching a given [templateId], or null.
  static BlockTemplate? findById(String templateId) {
    try {
      return templates.firstWhere((t) => t.id == templateId);
    } catch (_) {
      return null;
    }
  }
}
