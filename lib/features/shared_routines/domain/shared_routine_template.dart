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
  String get i18nKey {
    switch (this) {
      case RoutineTemplateStatus.inspired:
        return 'shared.status.inspired';
      case RoutineTemplateStatus.verified:
        return 'shared.status.verified';
      case RoutineTemplateStatus.official:
        return 'shared.status.official';
    }
  }
}

extension RoutineTemplateLevelLabel on RoutineTemplateLevel {
  String get i18nKey {
    switch (this) {
      case RoutineTemplateLevel.beginner:
        return 'shared.level.beginner';
      case RoutineTemplateLevel.intermediate:
        return 'shared.level.intermediate';
      case RoutineTemplateLevel.advanced:
        return 'shared.level.advanced';
    }
  }
}

extension RoutineTemplateThemeLabel on RoutineTemplateTheme {
  String get i18nKey {
    switch (this) {
      case RoutineTemplateTheme.productivite:
        return 'shared.theme.productivite';
      case RoutineTemplateTheme.fitness:
        return 'shared.theme.fitness';
      case RoutineTemplateTheme.bienEtre:
        return 'shared.theme.bienEtre';
      case RoutineTemplateTheme.spiritualite:
        return 'shared.theme.spiritualite';
      case RoutineTemplateTheme.leadership:
        return 'shared.theme.leadership';
    }
  }
}
