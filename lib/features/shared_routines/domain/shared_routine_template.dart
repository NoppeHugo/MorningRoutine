import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum RoutineTemplateStatus {
  inspired,
  verified,
  official,
}

enum RoutineTemplateLevel {
  beginner,
  intermediate,
  advanced,
}

enum RoutineTemplateTheme {
  productivite,
  fitness,
  bienEtre,
  spiritualite,
  leadership,
}

@immutable
class SharedRoutineBlockTemplate {
  const SharedRoutineBlockTemplate({
    required this.templateId,
    required this.durationMinutes,
    this.note,
  });

  final String templateId;
  final int durationMinutes;
  final String? note;
}

@immutable
class SharedRoutineTemplate {
  const SharedRoutineTemplate({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.subtitle,
    required this.goal,
    required this.icon,
    required this.theme,
    required this.level,
    required this.status,
    required this.tags,
    required this.blocks,
    required this.sourceLabel,
    required this.disclaimer,
    required this.isPremium,
  });

  final String id;
  final String creatorId;
  final String title;
  final String subtitle;
  final String goal;
  final IconData icon;
  final RoutineTemplateTheme theme;
  final RoutineTemplateLevel level;
  final RoutineTemplateStatus status;
  final List<String> tags;
  final List<SharedRoutineBlockTemplate> blocks;
  final String sourceLabel;
  final String disclaimer;
  final bool isPremium;

  int get totalDurationMinutes {
    return blocks.fold(0, (sum, block) => sum + block.durationMinutes);
  }
}

extension RoutineTemplateStatusLabel on RoutineTemplateStatus {
  String get label {
    switch (this) {
      case RoutineTemplateStatus.inspired:
        return 'Inspiree';
      case RoutineTemplateStatus.verified:
        return 'Verifiee';
      case RoutineTemplateStatus.official:
        return 'Officielle';
    }
  }
}

extension RoutineTemplateLevelLabel on RoutineTemplateLevel {
  String get label {
    switch (this) {
      case RoutineTemplateLevel.beginner:
        return 'Debutant';
      case RoutineTemplateLevel.intermediate:
        return 'Intermediaire';
      case RoutineTemplateLevel.advanced:
        return 'Avance';
    }
  }
}

extension RoutineTemplateThemeLabel on RoutineTemplateTheme {
  String get label {
    switch (this) {
      case RoutineTemplateTheme.productivite:
        return 'Productivite';
      case RoutineTemplateTheme.fitness:
        return 'Fitness';
      case RoutineTemplateTheme.bienEtre:
        return 'Bien-etre';
      case RoutineTemplateTheme.spiritualite:
        return 'Spiritualite';
      case RoutineTemplateTheme.leadership:
        return 'Leadership';
    }
  }
}
