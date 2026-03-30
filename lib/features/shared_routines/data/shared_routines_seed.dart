import 'package:flutter/material.dart';

import '../domain/creator_profile.dart';
import '../domain/shared_routine_template.dart';

abstract class SharedRoutinesSeed {
  static const creators = <CreatorProfile>[
    CreatorProfile(
      id: 'robin-sharma',
      displayName: 'Robin Sharma',
      slug: 'robin-sharma',
      avatarEmoji: '🌅',
      bioShort: 'Auteur du 5 AM Club, focus discipline et clarté mentale.',
      domains: ['Productivite', 'Discipline'],
      verificationStatus: CreatorVerificationStatus.inspired,
    ),
    CreatorProfile(
      id: 'wim-hof',
      displayName: 'Wim Hof',
      slug: 'wim-hof',
      avatarEmoji: '🧊',
      bioShort: 'Approche respiration + froid pour energie et resilience.',
      domains: ['Energie', 'Respiration'],
      verificationStatus: CreatorVerificationStatus.inspired,
    ),
    CreatorProfile(
      id: 'james-clear',
      displayName: 'James Clear',
      slug: 'james-clear',
      avatarEmoji: '📚',
      bioShort: 'Habitudes atomiques, progression quotidienne progressive.',
      domains: ['Habitudes', 'Performance'],
      verificationStatus: CreatorVerificationStatus.verified,
    ),
    CreatorProfile(
      id: 'andrews-huberman',
      displayName: 'Andrew Huberman',
      slug: 'andrew-huberman',
      avatarEmoji: '🔬',
      bioShort: 'Routines basees sur la physiologie et les rythmes biologiques.',
      domains: ['Science', 'Focus'],
      verificationStatus: CreatorVerificationStatus.inspired,
    ),
  ];

  static const templates = <SharedRoutineTemplate>[
    SharedRoutineTemplate(
      id: 'five-am-club-inspired',
      creatorId: 'robin-sharma',
      title: '5AM Focus Builder',
      subtitle: 'Clarte, energie, execution avant 7h',
      goal: 'Demarrer la journee avec intention et priorites nettes.',
      icon: Icons.wb_sunny_rounded,
      theme: RoutineTemplateTheme.productivite,
      level: RoutineTemplateLevel.intermediate,
      status: RoutineTemplateStatus.inspired,
      tags: ['Matin tot', 'Focus', 'Execution'],
      sourceLabel: 'Inspire du concept 20/20/20',
      disclaimer:
          'Routine motivationnelle. Adapte selon ton sommeil et ton etat de sante.',
      isPremium: false,
      blocks: [
        SharedRoutineBlockTemplate(
          templateId: 'water',
          durationMinutes: 2,
          note: 'Rehydrater apres le reveil.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'exercise',
          durationMinutes: 20,
          note: 'Activer le corps rapidement.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'journaling',
          durationMinutes: 20,
          note: 'Clarifier pensees et intentions.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'reading',
          durationMinutes: 20,
          note: 'Nourrir la progression quotidienne.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'planning',
          durationMinutes: 5,
          note: 'Fixer ton Top 3 du jour.',
        ),
      ],
    ),
    SharedRoutineTemplate(
      id: 'wim-hof-inspired',
      creatorId: 'wim-hof',
      title: 'Energie Froid + Souffle',
      subtitle: 'Respiration, mouvement et douche froide',
      goal: 'Monter ton energie mentale et physique en moins de 30 min.',
      icon: Icons.ac_unit_rounded,
      theme: RoutineTemplateTheme.fitness,
      level: RoutineTemplateLevel.intermediate,
      status: RoutineTemplateStatus.inspired,
      tags: ['Respiration', 'Resilience', 'Energie'],
      sourceLabel: 'Inspire de pratiques publiques de respiration',
      disclaimer:
          'Ne pas pratiquer la retention de souffle en milieu aquatique ou en conduisant.',
      isPremium: true,
      blocks: [
        SharedRoutineBlockTemplate(
          templateId: 'breathing',
          durationMinutes: 10,
          note: 'Respiration controlee.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'stretching',
          durationMinutes: 10,
          note: 'Mobilite generale.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'cold_shower',
          durationMinutes: 3,
          note: 'Exposition graduelle au froid.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'planning',
          durationMinutes: 5,
        ),
      ],
    ),
    SharedRoutineTemplate(
      id: 'atomic-habits-inspired',
      creatorId: 'james-clear',
      title: 'Atomic Start',
      subtitle: 'Petites actions, gros impact cumule',
      goal: 'Construire une routine durable sans surcharge.',
      icon: Icons.auto_awesome_rounded,
      theme: RoutineTemplateTheme.leadership,
      level: RoutineTemplateLevel.beginner,
      status: RoutineTemplateStatus.verified,
      tags: ['Habitudes', 'Progression', 'Debutant'],
      sourceLabel: 'Curation edito inspiree des principes Atomic Habits',
      disclaimer:
          'La constance vaut plus que la perfection. Ajuste les durees a ton contexte.',
      isPremium: false,
      blocks: [
        SharedRoutineBlockTemplate(
          templateId: 'water',
          durationMinutes: 2,
        ),
        SharedRoutineBlockTemplate(
          templateId: 'meditation',
          durationMinutes: 5,
        ),
        SharedRoutineBlockTemplate(
          templateId: 'journaling',
          durationMinutes: 5,
        ),
        SharedRoutineBlockTemplate(
          templateId: 'top3',
          durationMinutes: 5,
        ),
      ],
    ),
    SharedRoutineTemplate(
      id: 'huberman-inspired',
      creatorId: 'andrews-huberman',
      title: 'Sunlight & Focus',
      subtitle: 'Reset circadien et concentration profonde',
      goal: 'Optimiser vigilance et focus des premieres heures.',
      icon: Icons.light_mode_rounded,
      theme: RoutineTemplateTheme.spiritualite,
      level: RoutineTemplateLevel.advanced,
      status: RoutineTemplateStatus.inspired,
      tags: ['Focus', 'Rythme', 'Science'],
      sourceLabel: 'Inspire de recommandations d hygiene circadienne',
      disclaimer:
          'Cette routine ne remplace pas un avis medical. Adapte selon tes besoins.',
      isPremium: true,
      blocks: [
        SharedRoutineBlockTemplate(
          templateId: 'walk',
          durationMinutes: 15,
          note: 'Exposition lumiere naturelle.',
        ),
        SharedRoutineBlockTemplate(
          templateId: 'water',
          durationMinutes: 2,
        ),
        SharedRoutineBlockTemplate(
          templateId: 'breathing',
          durationMinutes: 5,
        ),
        SharedRoutineBlockTemplate(
          templateId: 'planning',
          durationMinutes: 10,
        ),
        SharedRoutineBlockTemplate(
          templateId: 'reading',
          durationMinutes: 15,
        ),
      ],
    ),
  ];
}
