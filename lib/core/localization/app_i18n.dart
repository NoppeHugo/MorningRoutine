import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/settings_repository.dart';

const List<String> supportedLanguageCodes = ['fr', 'nl', 'en'];

String languageLabel(String code) {
  switch (code) {
    case 'fr':
      return 'Francais';
    case 'nl':
      return 'Nederlands';
    case 'en':
    default:
      return 'English';
  }
}

class AppLanguageController extends StateNotifier<Locale> {
  AppLanguageController() : super(Locale(_initialLanguageCode()));

  static String _initialLanguageCode() {
    final code = settingsRepositoryInstance.loadSettings().languageCode;
    return supportedLanguageCodes.contains(code) ? code : 'fr';
  }

  Future<void> setLanguage(String code) async {
    if (!supportedLanguageCodes.contains(code)) return;

    state = Locale(code);
    final current = settingsRepositoryInstance.loadSettings();
    await settingsRepositoryInstance.saveSettings(
      current.copyWith(languageCode: code),
    );
  }
}

final appLanguageProvider =
    StateNotifierProvider<AppLanguageController, Locale>((ref) {
  return AppLanguageController();
});

class AppI18n {
  AppI18n._();

  static const Map<String, Map<String, String>> _values = {
    'app.title': {
      'fr': 'Morning Routine',
      'nl': 'Morning Routine',
      'en': 'Morning Routine',
    },
    'settings.title': {
      'fr': 'Reglages',
      'nl': 'Instellingen',
      'en': 'Settings',
    },
    'settings.language': {
      'fr': 'Langue',
      'nl': 'Taal',
      'en': 'Language',
    },
    'common.cancel': {
      'fr': 'Annuler',
      'nl': 'Annuleren',
      'en': 'Cancel',
    },
    'common.delete': {
      'fr': 'Supprimer',
      'nl': 'Verwijderen',
      'en': 'Delete',
    },
    'common.close': {
      'fr': 'Fermer',
      'nl': 'Sluiten',
      'en': 'Close',
    },
    'common.save': {
      'fr': 'Enregistrer',
      'nl': 'Opslaan',
      'en': 'Save',
    },
    'common.min': {
      'fr': 'min',
      'nl': 'min',
      'en': 'min',
    },
    'common.pro': {
      'fr': 'PRO',
      'nl': 'PRO',
      'en': 'PRO',
    },
    'home.hello': {
      'fr': 'Bonjour',
      'nl': 'Goedemorgen',
      'en': 'Hello',
    },
    'home.subtitleMorning': {
      'fr': 'Pret pour ta matinee ?',
      'nl': 'Klaar voor jouw ochtend?',
      'en': 'Ready for your morning?',
    },
    'home.subtitleAfter': {
      'fr': 'Comment s\'est passee ta matinee ?',
      'nl': 'Hoe verliep je ochtend?',
      'en': 'How was your morning?',
    },
    'home.createRoutine': {
      'fr': 'Cree ta routine',
      'nl': 'Maak je routine',
      'en': 'Create your routine',
    },
    'home.createRoutineSub': {
      'fr': 'Construis ta matinee parfaite\nbloc par bloc',
      'nl': 'Bouw je perfecte ochtend\nblok voor blok',
      'en': 'Build your perfect morning\nblock by block',
    },
    'home.createRoutineButton': {
      'fr': 'Creer ma routine',
      'nl': 'Mijn routine maken',
      'en': 'Create my routine',
    },
    'home.streak': {
      'fr': 'jours',
      'nl': 'dagen',
      'en': 'days',
    },
    'home.today': {
      'fr': 'Aujourd\'hui',
      'nl': 'Vandaag',
      'en': 'Today',
    },
    'start.launch': {
      'fr': 'Lancer',
      'nl': 'Starten',
      'en': 'Start',
    },
    'start.redo': {
      'fr': 'Relancer',
      'nl': 'Opnieuw starten',
      'en': 'Redo',
    },
    'timer.howFeelBefore': {
      'fr': 'Comment te sens-tu avant ?',
      'nl': 'Hoe voel je je daarvoor?',
      'en': 'How do you feel before?',
    },
    'timer.howFeelAfter': {
      'fr': 'Comment te sens-tu apres ?',
      'nl': 'Hoe voel je je daarna?',
      'en': 'How do you feel after?',
    },
    'mood.tired': {
      'fr': 'Fatigué',
      'nl': 'Moe',
      'en': 'Tired',
    },
    'mood.calm': {
      'fr': 'Calme',
      'nl': 'Rustig',
      'en': 'Calm',
    },
    'mood.stressed': {
      'fr': 'Stressé',
      'nl': 'gestrest',
      'en': 'Stressed',
    },
    'mood.focused': {
      'fr': 'Focalisé',
      'nl': 'Gefocust',
      'en': 'Focused',
    },
    'mood.energized': {
      'fr': 'Énergisé',
      'nl': 'Energiek',
      'en': 'Energized',
    },
    'completion.title': {
      'fr': 'Routine terminée !',
      'nl': 'Routine voltooid!',
      'en': 'Routine completed!',
    },
    'completion.score': {
      'fr': 'Score',
      'nl': 'Score',
      'en': 'Score',
    },
    'completion.completedBlocks': {
      'fr': 'blocs complétés',
      'nl': 'blokken voltooid',
      'en': 'blocks completed',
    },
    'completion.skippedBlocks': {
      'fr': 'blocs skippés',
      'nl': 'blokken overgeslagen',
      'en': 'blocks skipped',
    },
    'completion.duration': {
      'fr': 'durée',
      'nl': 'duur',
      'en': 'duration',
    },
    'completion.finishSave': {
      'fr': 'Retour à l\'accueil',
      'nl': 'Terug naar start',
      'en': 'Back home',
    },
    'completion.journalTitle': {
      'fr': 'Journal',
      'nl': 'Dagboek',
      'en': 'Journal',
    },
    'completion.promptReflection': {
      'fr': 'Qu\'as-tu appris?',
      'nl': 'Wat heb je geleerd?',
      'en': 'What did you learn?',
    },
    'completion.promptIntention': {
      'fr': 'Demain, je vais...',
      'nl': 'Morgen ga ik...',
      'en': 'Tomorrow I will...',
    },
    'completion.promptPriority': {
      'fr': 'Ma priorité est...',
      'nl': 'Mijn prioriteit is...',
      'en': 'My priority is...',
    },
    'completion.streakFmt': {
      'fr': '{count} jour de streak',
      'nl': '{count} dagen serie',
      'en': '{count} day streak',
    },
    'completion.proInsightsTitle': {
      'fr': 'Journal & Insights Pro',
      'nl': 'Dagboek & Pro Inzichten',
      'en': 'Journal & Pro Insights',
    },
    'completion.proInsightsSub': {
      'fr': 'Débloque Pro pour suivre humeur, réflexions et priorités',
      'nl': 'Ontgrendel Pro om stemming, reflexies en prioriteiten bij te houden',
      'en': 'Unlock Pro to track mood, reflections and priorities',
    },
    'completion.saveError': {
      'fr': 'Erreur en sauvegardant',
      'nl': 'Fout bij opslaan',
      'en': 'Error saving',
    },
    'paywall.processing': {
      'fr': 'Traitement...',
      'nl': 'Verwerking...',
      'en': 'Processing...',
    },
    'onboarding.title': {
      'fr': 'Morning Routine Builder',
      'nl': 'Morning Routine Builder',
      'en': 'Morning Routine Builder',
    },
    'builder.title': {
      'fr': 'Construire ma routine',
      'nl': 'Mijn routine bouwen',
      'en': 'Build my routine',
    },
    'builder.new': {
      'fr': 'Ajouter un bloc',
      'nl': 'Blok toevoegen',
      'en': 'Add a block',
    },
    'builder.templates': {
      'fr': 'Routines modèles',
      'nl': 'Sjablonen Routines',
      'en': 'Template routines',
    },
    'builder.loadError': {
      'fr': 'Erreur de chargement',
      'nl': 'Laadfout',
      'en': 'Loading error',
    },
    'builder.manage': {
      'fr': 'Gestion des routines',
      'nl': 'Routinebeheer',
      'en': 'Routine management',
    },
    'builder.wakeFmt': {
      'fr': 'Reveil: {time}',
      'nl': 'Wektijd: {time}',
      'en': 'Wake time: {time}',
    },
    'builder.endFmt': {
      'fr': 'Fin estimee: {time}',
      'nl': 'Geschatte eindtijd: {time}',
      'en': 'Estimated end: {time}',
    },
    'builder.confirmDeleteBlock': {
      'fr': 'Supprimer ce bloc ?',
      'nl': 'Dit blok verwijderen?',
      'en': 'Delete this block?',
    },
    'builder.deleteBlockIrreversible': {
      'fr': 'Cette action est irreversible.',
      'nl': 'Deze actie kan niet ongedaan worden gemaakt.',
      'en': 'This action cannot be undone.',
    },
    'builder.confirmDeleteRoutine': {
      'fr': 'Supprimer cette routine ?',
      'nl': 'Deze routine verwijderen?',
      'en': 'Delete this routine?',
    },
    'builder.deleteRoutineHint': {
      'fr': 'La routine et ses blocs seront supprimes.',
      'nl': 'De routine en blokken worden verwijderd.',
      'en': 'The routine and its blocks will be deleted.',
    },
    'builder.activeToday': {
      'fr': 'Active aujourd\'hui',
      'nl': 'Vandaag actief',
      'en': 'Active today',
    },
    'builder.activateNow': {
      'fr': 'Activer maintenant',
      'nl': 'Nu activeren',
      'en': 'Activate now',
    },
    'builder.activateTomorrow': {
      'fr': 'Activer demain',
      'nl': 'Morgen activeren',
      'en': 'Activate tomorrow',
    },
    'builder.cancelScheduled': {
      'fr': 'Annuler la planification',
      'nl': 'Planning annuleren',
      'en': 'Cancel schedule',
    },
    'builder.activeFmt': {
      'fr': 'Active: {name}',
      'nl': 'Actief: {name}',
      'en': 'Active: {name}',
    },
    'builder.tomorrowFmt': {
      'fr': 'Demain ({date}): {name}',
      'nl': 'Morgen ({date}): {name}',
      'en': 'Tomorrow ({date}): {name}',
    },
    'builder.maxBlocksFmt': {
      'fr': 'Maximum {max} blocs atteint',
      'nl': 'Maximum van {max} blokken bereikt',
      'en': 'Maximum {max} blocks reached',
    },
    'builder.addBlock': {
      'fr': 'Ajouter un bloc',
      'nl': 'Blok toevoegen',
      'en': 'Add block',
    },
    'builder.proBlocksFmt': {
      'fr': 'Version gratuite: {count} blocs max',
      'nl': 'Gratis versie: max {count} blokken',
      'en': 'Free version: max {count} blocks',
    },
    'blocks.addTitle': {
      'fr': 'Ajouter un bloc',
      'nl': 'Blok toevoegen',
      'en': 'Add a block',
    },
    'blocks.alreadyAdded': {
      'fr': 'Deja ajoute',
      'nl': 'Al toegevoegd',
      'en': 'Already added',
    },
    'emptyRoutine.title': {
      'fr': 'Ta routine est vide',
      'nl': 'Je routine is leeg',
      'en': 'Your routine is empty',
    },
    'emptyRoutine.sub': {
      'fr': 'Ajoute des blocs pour construire ta matinee parfaite.',
      'nl': 'Voeg blokken toe om je perfecte ochtend op te bouwen.',
      'en': 'Add blocks to build your perfect morning.',
    },
    'shared.catalogTitle': {
      'fr': 'Bibliotheque partagee',
      'nl': 'Gedeelde bibliotheek',
      'en': 'Shared library',
    },
    'shared.searchHint': {
      'fr': 'Rechercher une routine',
      'nl': 'Zoek een routine',
      'en': 'Search a routine',
    },
    'shared.creatorFallback': {
      'fr': 'Createur',
      'nl': 'Maker',
      'en': 'Creator',
    },
    'shared.theme': {
      'fr': 'Theme',
      'nl': 'Thema',
      'en': 'Theme',
    },
    'shared.level': {
      'fr': 'Niveau',
      'nl': 'Niveau',
      'en': 'Level',
    },
    'shared.all': {
      'fr': 'Tous',
      'nl': 'Alles',
      'en': 'All',
    },
    'shared.max30': {
      'fr': '30 min max',
      'nl': 'max 30 min',
      'en': 'max 30 min',
    },
    'shared.max45': {
      'fr': '45 min max',
      'nl': 'max 45 min',
      'en': 'max 45 min',
    },
    'shared.freeOnly': {
      'fr': 'Gratuit uniquement',
      'nl': 'Alleen gratis',
      'en': 'Free only',
    },
    'shared.emptyTitle': {
      'fr': 'Aucun resultat',
      'nl': 'Geen resultaten',
      'en': 'No results',
    },
    'shared.emptySub': {
      'fr': 'Essaie de modifier les filtres ou la recherche.',
      'nl': 'Pas je filters of zoekterm aan.',
      'en': 'Try changing filters or search.',
    },
    'shared.resetFilters': {
      'fr': 'Reinitialiser les filtres',
      'nl': 'Filters resetten',
      'en': 'Reset filters',
    },
    'shared.notFoundTitle': {
      'fr': 'Routine introuvable',
      'nl': 'Routine niet gevonden',
      'en': 'Routine not found',
    },
    'shared.notFoundSub': {
      'fr': 'Cette routine n\'existe pas ou n\'est plus disponible.',
      'nl': 'Deze routine bestaat niet of is niet meer beschikbaar.',
      'en': 'This routine does not exist or is no longer available.',
    },
    'shared.sequence': {
      'fr': 'Sequence',
      'nl': 'Volgorde',
      'en': 'Sequence',
    },
    'shared.unlockPro': {
      'fr': 'Debloquer Pro',
      'nl': 'Ontgrendel Pro',
      'en': 'Unlock Pro',
    },
    'shared.proOnly': {
      'fr': 'Routine reservee aux membres Pro',
      'nl': 'Routine alleen voor Pro-leden',
      'en': 'Routine for Pro members only',
    },
    'shared.inspiredRoutine': {
      'fr': 'Routine inspiree',
      'nl': 'Geinspireerde routine',
      'en': 'Inspired routine',
    },
    'shared.inspiredByFmt': {
      'fr': 'Inspiree par {name}',
      'nl': 'Geinspireerd door {name}',
      'en': 'Inspired by {name}',
    },
    'shared.duplicate': {
      'fr': 'Dupliquer',
      'nl': 'Dupliceren',
      'en': 'Duplicate',
    },
    'shared.tryTomorrow': {
      'fr': 'Tester demain',
      'nl': 'Morgen proberen',
      'en': 'Try tomorrow',
    },
    'shared.status.inspired': {
      'fr': 'Inspiree',
      'nl': 'Geinspireerd',
      'en': 'Inspired',
    },
    'shared.status.verified': {
      'fr': 'Verifiee',
      'nl': 'Geverifieerd',
      'en': 'Verified',
    },
    'shared.status.official': {
      'fr': 'Officielle',
      'nl': 'Officieel',
      'en': 'Official',
    },
    'shared.level.beginner': {
      'fr': 'Debutant',
      'nl': 'Beginner',
      'en': 'Beginner',
    },
    'shared.level.intermediate': {
      'fr': 'Intermediaire',
      'nl': 'Gemiddeld',
      'en': 'Intermediate',
    },
    'shared.level.advanced': {
      'fr': 'Avance',
      'nl': 'Gevorderd',
      'en': 'Advanced',
    },
    'shared.theme.productivite': {
      'fr': 'Productivite',
      'nl': 'Productiviteit',
      'en': 'Productivity',
    },
    'shared.theme.fitness': {
      'fr': 'Fitness',
      'nl': 'Fitness',
      'en': 'Fitness',
    },
    'shared.theme.bienEtre': {
      'fr': 'Bien-etre',
      'nl': 'Welzijn',
      'en': 'Wellness',
    },
    'shared.theme.spiritualite': {
      'fr': 'Spiritualite',
      'nl': 'Spiritualiteit',
      'en': 'Spirituality',
    },
    'shared.theme.leadership': {
      'fr': 'Leadership',
      'nl': 'Leiderschap',
      'en': 'Leadership',
    },
    'settings.section.routine': {
      'fr': 'Routine',
      'nl': 'Routine',
      'en': 'Routine',
    },
    'settings.section.notifications': {
      'fr': 'Notifications',
      'nl': 'Meldingen',
      'en': 'Notifications',
    },
    'settings.section.sound': {
      'fr': 'Sons & vibrations',
      'nl': 'Geluid & trillen',
      'en': 'Sound & vibration',
    },
    'settings.section.language': {
      'fr': 'Langue',
      'nl': 'Taal',
      'en': 'Language',
    },
    'settings.section.about': {
      'fr': 'A propos',
      'nl': 'Over',
      'en': 'About',
    },
    'settings.wakeTime': {
      'fr': 'Heure de reveil',
      'nl': 'Wektijd',
      'en': 'Wake time',
    },
    'settings.morningReminder': {
      'fr': 'Rappel matinal',
      'nl': 'Ochtendherinnering',
      'en': 'Morning reminder',
    },
    'settings.reminderTime': {
      'fr': 'Heure du rappel',
      'nl': 'Herinneringstijd',
      'en': 'Reminder time',
    },
    'settings.sound': {
      'fr': 'Sons',
      'nl': 'Geluid',
      'en': 'Sound',
    },
    'settings.vibration': {
      'fr': 'Vibrations',
      'nl': 'Trillen',
      'en': 'Vibration',
    },
    'settings.version': {
      'fr': 'Version',
      'nl': 'Versie',
      'en': 'Version',
    },
    'settings.privacyPolicy': {
      'fr': 'Politique de confidentialite',
      'nl': 'Privacybeleid',
      'en': 'Privacy policy',
    },
    'settings.resetData': {
      'fr': 'Reinitialiser les donnees',
      'nl': 'Gegevens resetten',
      'en': 'Reset data',
    },
    'settings.goPro': {
      'fr': 'Passer a Pro',
      'nl': 'Ga naar Pro',
      'en': 'Go Pro',
    },
    'settings.goProSub': {
      'fr': 'Debloque les templates premium et analytics avances',
      'nl': 'Ontgrendel premium templates en geavanceerde analytics',
      'en': 'Unlock premium templates and advanced analytics',
    },
    'settings.resetTitle': {
      'fr': 'Reinitialiser ?',
      'nl': 'Resetten?',
      'en': 'Reset?',
    },
    'settings.resetBody': {
      'fr': 'Toutes tes donnees seront supprimees. Cette action est irreversible.',
      'nl': 'Al je gegevens worden verwijderd. Deze actie is onomkeerbaar.',
      'en': 'All your data will be deleted. This action cannot be undone.',
    },
    'history.title': {
      'fr': 'Historique',
      'nl': 'Geschiedenes',
      'en': 'History',
    },
    'achievements.title': {
      'fr': 'Succès',
      'nl': 'Prestaties',
      'en': 'Achievements',
    },
  };

  static String t(String key, String code) {
    final normalized = supportedLanguageCodes.contains(code) ? code : 'fr';
    return _values[key]?[normalized] ?? _values[key]?['fr'] ?? key;
  }

  static String tf(String key, String code, Map<String, String> values) {
    var text = t(key, code);
    values.forEach((k, v) {
      text = text.replaceAll('{$k}', v);
    });
    return text;
  }

  static List<String> weekDayLabels(String code) {
    switch (code) {
      case 'nl':
        return const ['M', 'D', 'W', 'D', 'V', 'Z', 'Z'];
      case 'en':
        return const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      case 'fr':
      default:
        return const ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    }
  }

  static String monthLabel(DateTime month, String code) {
    const fr = [
      'janvier',
      'fevrier',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'aout',
      'septembre',
      'octobre',
      'novembre',
      'decembre',
    ];
    const nl = [
      'januari',
      'februari',
      'maart',
      'april',
      'mei',
      'juni',
      'juli',
      'augustus',
      'september',
      'oktober',
      'november',
      'december',
    ];
    const en = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final index = month.month - 1;
    final names = switch (code) {
      'nl' => nl,
      'en' => en,
      _ => fr,
    };

    return '${names[index]} ${month.year}';
  }
}
