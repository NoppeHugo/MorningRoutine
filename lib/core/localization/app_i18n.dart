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
    'settings.section.language': {
      'fr': 'LANGUE',
      'nl': 'TAAL',
      'en': 'LANGUAGE',
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
    'common.free': {
      'fr': 'Gratuit',
      'nl': 'Gratis',
      'en': 'Free',
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
    'common.next': {
      'fr': 'Suivant',
      'nl': 'Volgende',
      'en': 'Next',
    },
    'common.start': {
      'fr': 'Commencer',
      'nl': 'Starten',
      'en': 'Start',
    },
    'common.finish': {
      'fr': 'Terminer',
      'nl': 'Afronden',
      'en': 'Finish',
    },
    'onboarding.title': {
      'fr': 'Morning Routine\nBuilder',
        'fr': 'Cree une matinee\nqui te fait gagner la journee',
        'nl': 'Bouw een ochtend\ndie je dag laat winnen',
        'en': 'Build a morning\nthat wins your day',
    'onboarding.subtitle': {
      'fr': 'Construis ta matinee\nparfaite, bloc par bloc',
        'fr': 'Pret a prendre l avantage ce matin ?',
        'nl': 'Klaar om deze ochtend voorsprong te nemen?',
        'en': 'Ready to take the lead this morning?',
    'onboarding.wakeTime': {
      'fr': 'A quelle heure\nte reveilles-tu ?',
        'fr': 'Comment s est passee ta routine aujourd hui ?',
        'nl': 'Hoe verliep je routine vandaag?',
        'en': 'How did your routine go today?',
    'onboarding.duration': {
      'fr': 'Combien de temps\npour ta routine ?',
        'fr': 'Assemble ta routine ideale\net passe a l action des demain',
        'nl': 'Stel je ideale routine samen\nen start morgen meteen',
        'en': 'Build your ideal routine\nand start as early as tomorrow',
    'onboarding.goals': {
      'fr': 'Quels sont tes\nobjectifs ?',
        'fr': 'Creer ma routine maintenant',
        'nl': 'Mijn routine nu maken',
        'en': 'Create my routine now',
    'onboarding.goalsSub': {
      'fr': '(choisis-en plusieurs)',
        'fr': 'Mode guide, routines de createurs et analytics avances pour des matins solides.',
        'nl': 'Begeleide modus, creator-routines en geavanceerde analytics voor sterke ochtenden.',
        'en': 'Guided mode, creator routines, and advanced analytics for stronger mornings.',
    'onboarding.languageTitle': {
      'fr': 'Choisis ta langue',
        'fr': 'Suis scores, regularite et taux de completion sur 30 jours.',
        'nl': 'Volg scores, consistentie en completion rate over 30 dagen.',
        'en': 'Track scores, consistency, and completion rate over 30 days.',
    'onboarding.languageSub': {
      'fr': 'Tu pourras la changer plus tard dans Reglages.',
        'fr': 'Demarre en 1 tap. Annule quand tu veux.',
        'nl': 'Start in 1 tik. Op elk moment opzegbaar.',
        'en': 'Start in 1 tap. Cancel anytime.',
    'onboarding.languageContinue': {
      'fr': 'Continuer',
        'fr': 'Excellent, routine validee !',
        'nl': 'Top, routine afgerond!',
        'en': 'Great, routine completed!',
    'home.hello': {
      'fr': 'Bonjour',
        'fr': 'Score du jour',
      'en': 'Hello',
        'en': 'Today score',
    'home.subtitleMorning': {
      'fr': 'Pret pour ta matinee ?',
      'nl': 'Klaar voor je ochtend?',
      'en': 'Ready for your morning?',
        'en': 'Finish and go home',
    'home.subtitleAfter': {
      'fr': 'Comment s est passee ta matinee ?',
        'fr': 'Impact energie',
        'nl': 'Energie-impact',
        'en': 'Energy impact',
    'home.createRoutine': {
      'fr': 'Cree ta routine',
      'nl': 'Maak je routine',
        'nl': 'Gemiddelde energieboost na routine: {delta}',
        'en': 'Average energy boost after routine: {delta}',
    'home.createRoutineSub': {
      'fr': 'Construis ta matinee parfaite\nbloc par bloc',
        'fr': 'Mode le plus performant: {mode}',
        'nl': 'Best presterende modus: {mode}',
        'en': 'Best-performing mode: {mode}',
    'home.createRoutineButton': {
      'fr': 'Creer ma routine',
        'fr': 'Mode guide, blocs illimites et historique complet',
        'nl': 'Begeleide modus, onbeperkte blokken en volledige geschiedenis',
        'en': 'Guided mode, unlimited blocks, and full history',
    'home.inspiredTitle': {
      'fr': 'Routines de createurs inspirants',
      'nl': 'Routines van inspirerende makers',
      'en': 'Routines from inspiring creators',
    },
    'home.inspiredSub': {
      'fr': 'Choisis une routine inspiree et importe-la en un tap.',
      'nl': 'Kies een inspirerende routine en importeer met 1 tik.',
      'en': 'Pick an inspiring routine and import it in one tap.',
    },
    'home.inspiredButton': {
      'fr': 'Decouvrir les routines inspirees',
      'nl': 'Ontdek inspirerende routines',
      'en': 'Discover inspiring routines',
    },
    'home.streak': {
      'fr': 'Serie',
      'nl': 'Reeks',
      'en': 'Streak',
    },
    'home.today': {
      'fr': 'Aujourd hui',
      'nl': 'Vandaag',
      'en': 'Today',
    },
    'home.waiting': {
      'fr': 'En attente',
      'nl': 'In afwachting',
      'en': 'Pending',
    },
    'home.launchNow': {
      'fr': 'Lance ta routine !',
      'nl': 'Start je routine!',
      'en': 'Start your routine!',
    },
    'home.week': {
      'fr': 'Cette semaine',
      'nl': 'Deze week',
      'en': 'This week',
    },
    'home.daysFmt': {
      'fr': '{done} / 7 jours',
      'nl': '{done} / 7 dagen',
      'en': '{done} / 7 days',
    },
    'home.motivationStart': {
      'fr': 'Commence aujourd hui !',
      'nl': 'Begin vandaag!',
      'en': 'Start today!',
    },
    'home.motivationKeep': {
      'fr': 'Continue sur ta lancee !',
      'nl': 'Ga zo door!',
      'en': 'Keep it going!',
    },
    'home.motivationFireFmt': {
      'fr': 'Tu es en feu ! {streak} jours de suite !',
      'nl': 'Je bent on fire! {streak} dagen op rij!',
      'en': 'You are on fire! {streak} days in a row!',
    },
    'start.launch': {
      'fr': 'Lancer ma routine',
      'nl': 'Start mijn routine',
      'en': 'Start my routine',
    },
    'start.redo': {
      'fr': 'Refaire ma routine',
      'nl': 'Routine opnieuw doen',
      'en': 'Redo my routine',
    },
    'preview.totalDurationFmt': {
      'fr': '{minutes} min au total',
      'nl': '{minutes} min totaal',
      'en': '{minutes} min total',
    },
    'preview.moreBlocksFmt': {
      'fr': '+{count} autre{suffix} blocs',
      'nl': '+{count} extra blokken',
      'en': '+{count} more blocks',
    },
    'builder.title': {
      'fr': 'Ma Routine',
      'nl': 'Mijn routine',
      'en': 'My Routine',
    },
    'builder.loadError': {
      'fr': 'Erreur de chargement',
      'nl': 'Laadfout',
      'en': 'Loading error',
    },
    'builder.wakeFmt': {
      'fr': 'Reveil: {time}',
      'nl': 'Wekker: {time}',
      'en': 'Wake-up: {time}',
    },
    'builder.endFmt': {
      'fr': 'Fin estimee: {time}',
      'nl': 'Geschat einde: {time}',
      'en': 'Estimated end: {time}',
    },
    'builder.manage': {
      'fr': 'Gestion des routines',
      'nl': 'Routinebeheer',
      'en': 'Routine management',
    },
    'builder.new': {
      'fr': 'Nouvelle',
      'nl': 'Nieuw',
      'en': 'New',
    },
    'builder.activateNow': {
      'fr': 'Activer maintenant',
      'nl': 'Nu activeren',
      'en': 'Activate now',
    },
    'builder.activateTomorrow': {
      'fr': 'Activer cette routine demain',
      'nl': 'Deze routine morgen activeren',
      'en': 'Activate this routine tomorrow',
    },
    'builder.activeToday': {
      'fr': 'Routine active aujourd hui',
      'nl': 'Routine vandaag actief',
      'en': 'Routine active today',
    },
    'builder.cancelScheduled': {
      'fr': 'Annuler l activation planifiee',
      'nl': 'Geplande activatie annuleren',
      'en': 'Cancel scheduled activation',
    },
    'builder.activeFmt': {
      'fr': 'Routine active: {name}',
      'nl': 'Actieve routine: {name}',
      'en': 'Active routine: {name}',
    },
    'builder.tomorrowFmt': {
      'fr': 'Demain ({date}): {name}',
      'nl': 'Morgen ({date}): {name}',
      'en': 'Tomorrow ({date}): {name}',
    },
    'builder.maxBlocksFmt': {
      'fr': 'Maximum {max} blocs atteint',
      'nl': 'Maximum {max} blokken bereikt',
      'en': 'Maximum {max} blocks reached',
    },
    'builder.addBlock': {
      'fr': '+ Ajouter un bloc',
      'nl': '+ Blok toevoegen',
      'en': '+ Add a block',
    },
    'builder.proBlocksFmt': {
      'fr': 'Passe a Pro pour ajouter plus de {count} blocs',
      'nl': 'Ga Pro om meer dan {count} blokken toe te voegen',
      'en': 'Go Pro to add more than {count} blocks',
    },
    'builder.confirmDeleteBlock': {
      'fr': 'Supprimer ce bloc ?',
      'nl': 'Dit blok verwijderen?',
      'en': 'Delete this block?',
    },
    'builder.confirmDeleteRoutine': {
      'fr': 'Supprimer cette routine ?',
      'nl': 'Deze routine verwijderen?',
      'en': 'Delete this routine?',
    },
    'builder.deleteBlockIrreversible': {
      'fr': 'Cette action est irreversible.',
      'nl': 'Deze actie kan niet ongedaan worden gemaakt.',
      'en': 'This action is irreversible.',
    },
    'builder.deleteRoutineHint': {
      'fr': 'Si c est ta seule routine, elle sera simplement videe.',
      'nl': 'Als dit je enige routine is, wordt ze alleen leeggemaakt.',
      'en': 'If this is your only routine, it will just be emptied.',
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
    'templates.title': {
      'fr': 'Routines expertes',
      'nl': 'Expert-routines',
      'en': 'Expert routines',
    },
    'timer.blockFmt': {
      'fr': 'Bloc {current} sur {total}',
      'nl': 'Blok {current} van {total}',
      'en': 'Block {current} of {total}',
    },
    'timer.modeTitle': {
      'fr': 'Choisis ton mode',
      'nl': 'Kies je modus',
      'en': 'Choose your mode',
    },
    'timer.modeChecklist': {
      'fr': 'Checklist',
      'nl': 'Checklist',
      'en': 'Checklist',
    },
    'timer.modeChecklistSub': {
      'fr': 'Tu coches les blocs a ton rythme.',
      'nl': 'Je vinkt blokken af op je eigen tempo.',
      'en': 'Check blocks at your own pace.',
    },
    'timer.modeGuided': {
      'fr': 'Mode guide pas a pas',
      'nl': 'Begeleide modus',
      'en': 'Guided mode',
    },
    'timer.modeGuidedSub': {
      'fr': 'Timers, transitions et encouragements.',
      'nl': 'Timers, overgangen en mini-boosts.',
      'en': 'Timers, transitions, and mini boosts.',
    },
    'timer.howFeelBefore': {
      'fr': 'Comment te sens-tu avant la routine ?',
      'nl': 'Hoe voel je je voor de routine?',
      'en': 'How do you feel before the routine?',
    },
    'timer.howFeelAfter': {
      'fr': 'Comment te sens-tu apres la routine ?',
      'nl': 'Hoe voel je je na de routine?',
      'en': 'How do you feel after the routine?',
    },
    'timer.doneCountFmt': {
      'fr': '{done}/{total} faits',
      'nl': '{done}/{total} gedaan',
      'en': '{done}/{total} done',
    },
    'timer.checklistEncourageFmt': {
      'fr': 'Progression: {done} sur {total}. Continue, tu geres.',
      'nl': 'Voortgang: {done} van {total}. Ga zo door.',
      'en': 'Progress: {done} of {total}. Keep going.',
    },
    'timer.finishChecklist': {
      'fr': 'Terminer la routine',
      'nl': 'Routine afronden',
      'en': 'Finish routine',
    },
    'mood.tired': {
      'fr': 'Fatigue',
      'nl': 'Moe',
      'en': 'Tired',
    },
    'mood.calm': {
      'fr': 'Calme',
      'nl': 'Rustig',
      'en': 'Calm',
    },
    'mood.stressed': {
      'fr': 'Stresse',
      'nl': 'Gestrest',
      'en': 'Stressed',
    },
    'mood.focused': {
      'fr': 'Concentre',
      'nl': 'Gefocust',
      'en': 'Focused',
    },
    'mood.energized': {
      'fr': 'Energise',
      'nl': 'Energiek',
      'en': 'Energized',
    },
    'timer.next': {
      'fr': 'Prochain :',
      'nl': 'Volgende:',
      'en': 'Next:',
    },
    'timer.skip': {
      'fr': 'Passer',
      'nl': 'Overslaan',
      'en': 'Skip',
    },
    'timer.done': {
      'fr': 'Valider',
      'nl': 'Klaar',
      'en': 'Complete',
    },
    'timer.quitTitle': {
      'fr': 'Quitter la routine ?',
      'nl': 'Routine verlaten?',
      'en': 'Leave the routine?',
    },
    'timer.quitBody': {
      'fr': 'Ta progression ne sera pas sauvegardee.',
      'nl': 'Je voortgang wordt niet opgeslagen.',
      'en': 'Your progress will not be saved.',
    },
    'timer.keep': {
      'fr': 'Continuer',
      'nl': 'Doorgaan',
      'en': 'Keep going',
    },
    'timer.quit': {
      'fr': 'Quitter',
      'nl': 'Verlaten',
      'en': 'Quit',
    },
    'completion.title': {
      'fr': 'Routine terminee !',
      'nl': 'Routine voltooid!',
      'en': 'Routine completed!',
    },
    'completion.finishSave': {
      'fr': 'Terminer et revenir a l accueil',
      'nl': 'Afronden en terug naar start',
      'en': 'Finish and return home',
    },
    'completion.journalTitle': {
      'fr': 'Mini bilan',
      'nl': 'Mini-reflectie',
      'en': 'Quick reflection',
    },
    'completion.promptReflection': {
      'fr': 'Qu est-ce qui a bien marche ?',
      'nl': 'Wat werkte goed?',
      'en': 'What worked well?',
    },
    'completion.promptIntention': {
      'fr': 'Ton intention du jour',
      'nl': 'Je intentie voor vandaag',
      'en': 'Your intention for today',
    },
    'completion.promptPriority': {
      'fr': 'Ta priorite numero 1 aujourd hui',
      'nl': 'Je nummer 1 prioriteit vandaag',
      'en': 'Your #1 priority today',
    },
    'completion.proInsightsTitle': {
      'fr': 'Debloque suivi humeur et mini journal',
      'nl': 'Ontgrendel stemmingscheck en mini-journal',
      'en': 'Unlock mood check and quick journal',
    },
    'completion.proInsightsSub': {
      'fr': 'Suis ton energie et identifie les matins les plus efficaces.',
      'nl': 'Volg je energie en ontdek welke ochtenden het best werken.',
      'en': 'Track your energy and spot which mornings work best.',
    },
    'completion.saveError': {
      'fr': 'Impossible d enregistrer cette session.',
      'nl': 'Deze sessie kon niet worden opgeslagen.',
      'en': 'Could not save this session.',
    },
    'completion.score': {
      'fr': 'Score',
      'nl': 'Score',
      'en': 'Score',
    },
    'completion.completedBlocks': {
      'fr': 'blocs completes',
      'nl': 'voltooide blokken',
      'en': 'completed blocks',
    },
    'completion.skippedBlocks': {
      'fr': 'blocs passes',
      'nl': 'overgeslagen blokken',
      'en': 'skipped blocks',
    },
    'completion.duration': {
      'fr': 'duree',
      'nl': 'duur',
      'en': 'duration',
    },
    'completion.streakFmt': {
      'fr': '{count} jours de serie',
      'nl': '{count} dagen op rij',
      'en': '{count} days streak',
    },
    'completion.streakSuffix': {
      'fr': 'de streak',
      'nl': 'streak',
      'en': 'streak',
    },
    'completion.home': {
      'fr': 'Retour a l accueil',
      'nl': 'Terug naar home',
      'en': 'Back to home',
    },
    'settings.section.routine': {
      'fr': 'ROUTINE',
      'nl': 'ROUTINE',
      'en': 'ROUTINE',
    },
    'settings.section.notifications': {
      'fr': 'NOTIFICATIONS',
      'nl': 'MELDINGEN',
      'en': 'NOTIFICATIONS',
    },
    'settings.section.sound': {
      'fr': 'SONS & VIBRATIONS',
      'nl': 'GELUID & TRILLINGEN',
      'en': 'SOUND & VIBRATION',
    },
    'settings.section.about': {
      'fr': 'A PROPOS',
      'nl': 'OVER',
      'en': 'ABOUT',
    },
    'settings.wakeTime': {
      'fr': 'Heure de reveil',
      'nl': 'Wektijd',
      'en': 'Wake-up time',
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
      'nl': 'Trillingen',
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
    'settings.resetTitle': {
      'fr': 'Reinitialiser ?',
      'nl': 'Resetten?',
      'en': 'Reset?',
    },
    'settings.resetBody': {
      'fr': 'Toutes tes donnees seront supprimees (routine, scores, streak). Cette action est irreversible.',
      'nl': 'Al je gegevens worden verwijderd (routine, scores, streak). Deze actie is onomkeerbaar.',
      'en': 'All your data will be deleted (routine, scores, streak). This action is irreversible.',
    },
    'settings.goPro': {
      'fr': 'Passe a Pro',
      'nl': 'Ga naar Pro',
      'en': 'Go Pro',
    },
    'settings.goProSub': {
      'fr': 'Blocs illimites + historique complet',
      'nl': 'Onbeperkte blokken + volledige geschiedenis',
      'en': 'Unlimited blocks + full history',
    },
    'privacy.title': {
      'fr': 'Confidentialite',
      'nl': 'Privacy',
      'en': 'Privacy',
    },
    'privacy.heading': {
      'fr': 'Politique de confidentialite',
      'nl': 'Privacybeleid',
      'en': 'Privacy policy',
    },
    'privacy.updated': {
      'fr': 'Derniere mise a jour : Mars 2026',
      'nl': 'Laatste update: Maart 2026',
      'en': 'Last update: March 2026',
    },
    'privacy.summary.title': {
      'fr': 'Resume',
      'nl': 'Samenvatting',
      'en': 'Summary',
    },
    'privacy.summary.body': {
      'fr': 'Morning Routine ne collecte aucune donnee personnelle. Toutes tes donnees restent sur ton appareil. Nous ne vendons, ne partageons et ne transmettons aucune information a des tiers.',
      'nl': 'Morning Routine verzamelt geen persoonlijke gegevens. Al je gegevens blijven op je toestel. We verkopen, delen of verzenden geen informatie naar derden.',
      'en': 'Morning Routine does not collect personal data. All your data stays on your device. We do not sell, share, or transmit information to third parties.',
    },
    'privacy.collected.title': {
      'fr': '1. Donnees collectees',
      'nl': '1. Verzamelde gegevens',
      'en': '1. Collected data',
    },
    'privacy.collected.body': {
      'fr': 'Morning Routine ne collecte aucune donnee personnelle identifiable.\n\nLes seules donnees creees sont :\n- Ta routine (blocs, durees), stockee localement\n- Tes scores quotidiens et streak, stockes localement\n- Tes preferences (heure de reveil, notifications), stockees localement\n\nAucune de ces donnees ne quitte ton appareil.',
      'nl': 'Morning Routine verzamelt geen persoonlijk identificeerbare gegevens.\n\nDe enige gegevens die worden aangemaakt zijn:\n- Je routine (blokken, duur), lokaal opgeslagen\n- Je dagelijkse scores en streak, lokaal opgeslagen\n- Je voorkeuren (wektijd, meldingen), lokaal opgeslagen\n\nGeen van deze gegevens verlaat je toestel.',
      'en': 'Morning Routine does not collect personally identifiable data.\n\nThe only data created is:\n- Your routine (blocks, durations), stored locally\n- Your daily scores and streak, stored locally\n- Your preferences (wake time, notifications), stored locally\n\nNone of this data leaves your device.',
    },
    'privacy.subscriptions.title': {
      'fr': '2. Abonnements (RevenueCat)',
      'nl': '2. Abonnementen (RevenueCat)',
      'en': '2. Subscriptions (RevenueCat)',
    },
    'privacy.subscriptions.body': {
      'fr': 'Si tu souscris a Morning Routine Pro, ta transaction est geree par Apple via l App Store. RevenueCat est utilise uniquement pour verifier le statut de ton abonnement et peut recevoir un identifiant anonyme d appareil a cet effet. Consulte la politique RevenueCat : revenuecat.com/privacy',
      'nl': 'Als je een Morning Routine Pro-abonnement neemt, wordt je transactie beheerd door Apple via de App Store. RevenueCat wordt alleen gebruikt om je abonnementsstatus te controleren en kan hiervoor een anonieme apparaat-ID ontvangen. Zie het RevenueCat privacybeleid: revenuecat.com/privacy',
      'en': 'If you subscribe to Morning Routine Pro, your transaction is handled by Apple via the App Store. RevenueCat is used only to verify your subscription status and may receive an anonymous device identifier for that purpose. See RevenueCat privacy policy: revenuecat.com/privacy',
    },
    'privacy.notifications.title': {
      'fr': '3. Notifications',
      'nl': '3. Meldingen',
      'en': '3. Notifications',
    },
    'privacy.notifications.body': {
      'fr': 'Les notifications sont gerees localement par iOS. Aucune notification n est envoyee depuis nos serveurs. Tu peux desactiver les notifications a tout moment dans les Reglages iOS.',
      'nl': 'Meldingen worden lokaal beheerd door iOS. Er worden geen meldingen vanaf onze servers verstuurd. Je kunt meldingen op elk moment uitschakelen in iOS-instellingen.',
      'en': 'Notifications are managed locally by iOS. No notifications are sent from our servers. You can disable notifications at any time in iOS Settings.',
    },
    'privacy.ads.title': {
      'fr': '4. Publicite et tracking',
      'nl': '4. Advertenties en tracking',
      'en': '4. Ads and tracking',
    },
    'privacy.ads.body': {
      'fr': 'Morning Routine ne contient aucune publicite. Aucun SDK de tracking publicitaire (Facebook, Google Ads, etc.) n est integre.',
      'nl': 'Morning Routine bevat geen advertenties. Er is geen advertentie-tracking SDK (Facebook, Google Ads, enz.) geintegreerd.',
      'en': 'Morning Routine contains no ads. No advertising tracking SDKs (Facebook, Google Ads, etc.) are integrated.',
    },
    'privacy.minors.title': {
      'fr': '5. Mineurs',
      'nl': '5. Minderjarigen',
      'en': '5. Minors',
    },
    'privacy.minors.body': {
      'fr': 'Morning Routine ne collecte pas de donnees. L application est utilisable par tous les ages.',
      'nl': 'Morning Routine verzamelt geen gegevens. De app kan door alle leeftijden gebruikt worden.',
      'en': 'Morning Routine does not collect data. The app can be used by all ages.',
    },
    'privacy.contact.title': {
      'fr': '6. Contact',
      'nl': '6. Contact',
      'en': '6. Contact',
    },
    'privacy.contact.body': {
      'fr': 'Pour toute question concernant ta confidentialite, contacte-nous a :\nprivacy@morningroutineapp.com',
      'nl': 'Voor vragen over privacy kun je contact opnemen via:\nprivacy@morningroutineapp.com',
      'en': 'For any privacy questions, contact us at:\nprivacy@morningroutineapp.com',
    },
    'privacy.badge': {
      'fr': 'Aucune donnee personnelle collectee.\nTout reste sur ton iPhone.',
      'nl': 'Geen persoonlijke data verzameld.\nAlles blijft op je iPhone.',
      'en': 'No personal data collected.\nEverything stays on your iPhone.',
    },
    'paywall.trial': {
      'fr': 'Essai gratuit 3 jours',
      'nl': '3 dagen gratis proef',
      'en': '3-day free trial',
    },
    'paywall.trialSub': {
      'fr': 'Pas de carte bancaire requise. Annule quand tu veux.',
      'nl': 'Geen creditcard nodig. Op elk moment opzegbaar.',
      'en': 'No credit card required. Cancel anytime.',
    },
    'paywall.title': {
      'fr': 'Deviens Invincible le Matin',
      'nl': 'Word Onverslaanbaar in de Ochtend',
      'en': 'Become Unstoppable in the Morning',
    },
    'paywall.subtitle': {
      'fr': 'Routines de createurs + sans limite = victoires garanties',
      'nl': 'Creator-routines + onbeperkt = gegarandeerde progressie',
      'en': 'Creator routines + unlimited = consistent wins',
    },
    'paywall.feature.unlimited.title': {
      'fr': 'Blocs illimites',
      'nl': 'Onbeperkte blokken',
      'en': 'Unlimited blocks',
    },
    'paywall.feature.unlimited.sub': {
      'fr': 'De 3 a 10 blocs. Fais ta propre routine complexe.',
      'nl': 'Van 3 tot 10 blokken. Bouw je eigen complexe routine.',
      'en': 'From 3 to 10 blocks. Build your own complex routine.',
    },
    'paywall.feature.creators.title': {
      'fr': 'Routines de createurs',
      'nl': 'Creator-routines',
      'en': 'Creator routines',
    },
    'paywall.feature.creators.sub': {
      'fr': '5AM Club, Wim Hof, Atomic Habits... importe et maitrise.',
      'nl': '5AM Club, Wim Hof, Atomic Habits... importeer en beheers.',
      'en': '5AM Club, Wim Hof, Atomic Habits... import and master.',
    },
    'paywall.feature.analytics.title': {
      'fr': 'Analytics 30 jours',
      'nl': '30-dagen analytics',
      'en': '30-day analytics',
    },
    'paywall.feature.analytics.sub': {
      'fr': 'Vois tes progres reels : scores, streaks, completion rate.',
      'nl': 'Zie je echte vooruitgang: scores, streaks, completion rate.',
      'en': 'See your real progress: scores, streaks, completion rate.',
    },
    'paywall.feature.offline.title': {
      'fr': 'Fonctionne offline',
      'nl': 'Werkt offline',
      'en': 'Works offline',
    },
    'paywall.feature.offline.sub': {
      'fr': 'Ton app, ton data. Pas de cloud, pas d intrusion.',
      'nl': 'Jouw app, jouw data. Geen cloud, geen gedoe.',
      'en': 'Your app, your data. No cloud, no intrusion.',
    },
    'shared.creatorFallback': {
      'fr': 'Createur',
      'nl': 'Maker',
      'en': 'Creator',
    },
    'templates.blocksFmt': {
      'fr': '{count} blocs',
      'nl': '{count} blokken',
      'en': '{count} blocks',
    },
    'paywall.monthly': {
      'fr': 'Mensuel',
      'nl': 'Maandelijks',
      'en': 'Monthly',
    },
    'paywall.yearly': {
      'fr': 'Annuel',
      'nl': 'Jaarlijks',
      'en': 'Yearly',
    },
    'paywall.bestOffer': {
      'fr': 'MEILLEURE OFFRE',
      'nl': 'BESTE AANBOD',
      'en': 'BEST OFFER',
    },
    'paywall.save50': {
      'fr': 'Economise 50% par rapport au mensuel',
      'nl': 'Bespaar 50% vergeleken met maandelijks',
      'en': 'Save 50% compared to monthly',
    },
    'paywall.ctaAnnual': {
      'fr': 'Activer essai gratuit 3j - Annuel',
      'nl': 'Start 3-daagse proef - Jaarlijks',
      'en': 'Start 3-day trial - Yearly',
    },
    'paywall.ctaMonthly': {
      'fr': 'Activer essai gratuit 3j - Mensuel',
      'nl': 'Start 3-daagse proef - Maandelijks',
      'en': 'Start 3-day trial - Monthly',
    },
    'paywall.processing': {
      'fr': 'Traitement...',
      'nl': 'Bezig...',
      'en': 'Processing...',
    },
    'paywall.restore': {
      'fr': 'Restaurer mes achats',
      'nl': 'Aankopen herstellen',
      'en': 'Restore purchases',
    },
    'paywall.cancelAnytime': {
      'fr': 'Annulation possible a tout moment depuis les Reglages iOS.',
      'nl': 'Je kunt op elk moment opzeggen via iOS-instellingen.',
      'en': 'Cancel anytime from iOS Settings.',
    },
    'paywall.noOffers': {
      'fr': 'Impossible de charger les offres. Reessaie plus tard.',
      'nl': 'Aanbiedingen laden mislukt. Probeer later opnieuw.',
      'en': 'Unable to load offers. Try again later.',
    },
    'paywall.alreadyPro': {
      'fr': 'Tu es deja Pro !',
      'nl': 'Je bent al Pro!',
      'en': 'You are already Pro!',
    },
    'paywall.alreadyProSub': {
      'fr': 'Profite de toutes les fonctionnalites sans limite.',
      'nl': 'Geniet van alle functies zonder limiet.',
      'en': 'Enjoy all features without limits.',
    },
    'shared.catalogTitle': {
      'fr': 'Routines inspirantes',
      'nl': 'Inspirerende routines',
      'en': 'Inspiring routines',
    },
    'shared.searchHint': {
      'fr': 'Rechercher un createur ou un objectif',
      'nl': 'Zoek een maker of doel',
      'en': 'Search a creator or a goal',
    },
    'shared.theme': {
      'fr': 'Theme',
      'nl': 'Thema',
      'en': 'Theme',
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
      'en': 'Well-being',
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
    'shared.level': {
      'fr': 'Niveau',
      'nl': 'Niveau',
      'en': 'Level',
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
    'shared.all': {
      'fr': 'Tous',
      'nl': 'Alles',
      'en': 'All',
    },
    'shared.freeOnly': {
      'fr': 'Gratuit seulement',
      'nl': 'Alleen gratis',
      'en': 'Free only',
    },
    'shared.emptyTitle': {
      'fr': 'Aucune routine trouvee',
      'nl': 'Geen routine gevonden',
      'en': 'No routine found',
    },
    'shared.emptySub': {
      'fr': 'Essaie d ajuster tes filtres pour voir plus de resultats.',
      'nl': 'Pas je filters aan om meer resultaten te zien.',
      'en': 'Try adjusting your filters to see more results.',
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
      'fr': 'Cette routine n est plus disponible.',
      'nl': 'Deze routine is niet meer beschikbaar.',
      'en': 'This routine is no longer available.',
    },
    'shared.sequence': {
      'fr': 'Sequence',
      'nl': 'Volgorde',
      'en': 'Sequence',
    },
    'shared.unlockPro': {
      'fr': 'Debloquer avec Pro',
      'nl': 'Ontgrendel met Pro',
      'en': 'Unlock with Pro',
    },
    'shared.proOnly': {
      'fr': 'Cette routine est reservee aux membres Pro.',
      'nl': 'Deze routine is alleen voor Pro-leden.',
      'en': 'This routine is reserved for Pro members.',
    },
      'shared.max30': {
        'fr': '<=30 min',
        'nl': '<=30 min',
        'en': '<=30 min',
      },
      'shared.max45': {
        'fr': '<=45 min',
        'nl': '<=45 min',
        'en': '<=45 min',
      },
    'shared.duplicate': {
      'fr': 'Dupliquer et personnaliser',
      'nl': 'Dupliceren en aanpassen',
      'en': 'Duplicate and customize',
    },
      'score.notDoneToday': {
        'fr': 'Pas encore fait aujourd hui',
        'nl': 'Nog niet gedaan vandaag',
        'en': 'Not done yet today',
      },
      'score.goodJob': {
        'fr': 'Bien joue !',
        'nl': 'Goed gedaan!',
        'en': 'Great job!',
      },
      'score.canImprove': {
        'fr': 'Peut mieux faire',
        'nl': 'Kan beter',
        'en': 'Can improve',
      },
      'score.blocksDoneFmt': {
        'fr': '{completed}/{total} blocs completes',
        'nl': '{completed}/{total} blokken voltooid',
        'en': '{completed}/{total} blocks completed',
      },
    'shared.tryTomorrow': {
      'fr': 'Essayer demain',
      'nl': 'Morgen proberen',
      'en': 'Try tomorrow',
    },
    'shared.inspiredRoutine': {
      'fr': 'Routine inspiree',
      'nl': 'Geinspireerde routine',
      'en': 'Inspired routine',
    },
    'shared.inspiredByFmt': {
      'fr': 'Inspire de {creator}',
      'nl': 'Geinspireerd door {creator}',
      'en': 'Inspired by {creator}',
    },
    'emptyRoutine.title': {
      'fr': 'Ta routine est vide',
      'nl': 'Je routine is leeg',
      'en': 'Your routine is empty',
    },
    'emptyRoutine.sub': {
      'fr': 'Ajoute des blocs pour construire\nta matinee parfaite !',
      'nl': 'Voeg blokken toe om je\nperfecte ochtend te bouwen!',
      'en': 'Add blocks to build your\nperfect morning!',
    },
    'history.title': {
      'fr': 'Historique',
      'nl': 'Geschiedenis',
      'en': 'History',
    },
    'history.recent': {
      'fr': 'Dernieres sessions',
      'nl': 'Recente sessies',
      'en': 'Recent sessions',
    },
    'history.bestStreak': {
      'fr': 'Meilleur\nstreak',
      'nl': 'Beste\nstreak',
      'en': 'Best\nstreak',
    },
    'history.completed': {
      'fr': 'Routines\ncompletees',
      'nl': 'Voltooide\nroutines',
      'en': 'Completed\nroutines',
    },
    'history.avgScore': {
      'fr': 'Score\nmoyen',
      'nl': 'Gemiddelde\nscore',
      'en': 'Average\nscore',
    },
    'history.activeDays': {
      'fr': 'Jours actifs\nce mois',
      'nl': 'Actieve dagen\ndeze maand',
      'en': 'Active days\nthis month',
    },
    'history.monthOverview': {
      'fr': 'Vue du mois',
      'nl': 'Maandoverzicht',
      'en': 'Month overview',
    },
    'history.legend.done': {
      'fr': 'Routine faite',
      'nl': 'Routine gedaan',
      'en': 'Routine done',
    },
    'history.legend.missed': {
      'fr': 'Routine non faite',
      'nl': 'Routine gemist',
      'en': 'Routine missed',
    },
    'history.fullTitle': {
      'fr': 'Historique complet',
      'nl': 'Volledige geschiedenis',
      'en': 'Full history',
    },
    'history.fullSub': {
      'fr': 'Suis tes 30 derniers jours: progression, scores passes et statistiques detaillees.',
      'nl': 'Bekijk je laatste 30 dagen: voortgang, eerdere scores en detailstatistieken.',
      'en': 'Review your last 30 days: progress, past scores, and detailed stats.',
    },
    'history.unlockPro': {
      'fr': 'Debloquer avec Pro',
      'nl': 'Ontgrendel met Pro',
      'en': 'Unlock with Pro',
    },
    'history.energyTitle': {
      'fr': 'Energie et humeur',
      'nl': 'Energie en stemming',
      'en': 'Energy and mood',
    },
    'history.energyAvgDeltaFmt': {
      'fr': 'Gain energie moyen apres routine: {delta}',
      'nl': 'Gemiddelde verandering na routine: {delta}',
      'en': 'Average post-routine change: {delta}',
    },
    'history.bestModeFmt': {
      'fr': 'Mode le plus efficace: {mode}',
      'nl': 'Meest effectieve modus: {mode}',
      'en': 'Most effective mode: {mode}',
    },
    'history.energyNoData': {
      'fr': 'Pas assez de donnees mood pour calculer la tendance.',
      'nl': 'Nog niet genoeg mood-data om een trend te tonen.',
      'en': 'Not enough mood data yet to show a trend.',
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
