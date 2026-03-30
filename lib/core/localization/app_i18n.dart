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
      'nl': 'Morning Routine\nBuilder',
      'en': 'Morning Routine\nBuilder',
    },
    'onboarding.subtitle': {
      'fr': 'Construis ta matinee\nparfaite, bloc par bloc',
      'nl': 'Bouw je perfecte\nochtend, blok per blok',
      'en': 'Build your perfect\nmorning, block by block',
    },
    'onboarding.wakeTime': {
      'fr': 'A quelle heure\nte reveilles-tu ?',
      'nl': 'Hoe laat\nword je wakker?',
      'en': 'What time\ndo you wake up?',
    },
    'onboarding.duration': {
      'fr': 'Combien de temps\npour ta routine ?',
      'nl': 'Hoeveel tijd\nvoor je routine?',
      'en': 'How much time\nfor your routine?',
    },
    'onboarding.goals': {
      'fr': 'Quels sont tes\nobjectifs ?',
      'nl': 'Wat zijn je\ndoelen?',
      'en': 'What are your\ngoals?',
    },
    'onboarding.goalsSub': {
      'fr': '(choisis-en plusieurs)',
      'nl': '(kies er meerdere)',
      'en': '(select multiple)',
    },
    'onboarding.languageTitle': {
      'fr': 'Choisis ta langue',
      'nl': 'Kies je taal',
      'en': 'Choose your language',
    },
    'onboarding.languageSub': {
      'fr': 'Tu pourras la changer plus tard dans Reglages.',
      'nl': 'Je kunt dit later wijzigen in Instellingen.',
      'en': 'You can change this later in Settings.',
    },
    'onboarding.languageContinue': {
      'fr': 'Continuer',
      'nl': 'Doorgaan',
      'en': 'Continue',
    },
    'home.hello': {
      'fr': 'Bonjour',
      'nl': 'Hallo',
      'en': 'Hello',
    },
    'home.subtitleMorning': {
      'fr': 'Pret pour ta matinee ?',
      'nl': 'Klaar voor je ochtend?',
      'en': 'Ready for your morning?',
    },
    'home.subtitleAfter': {
      'fr': 'Comment s est passee ta matinee ?',
      'nl': 'Hoe ging je ochtend?',
      'en': 'How did your morning go?',
    },
    'home.createRoutine': {
      'fr': 'Cree ta routine',
      'nl': 'Maak je routine',
      'en': 'Create your routine',
    },
    'home.createRoutineSub': {
      'fr': 'Construis ta matinee parfaite\nbloc par bloc',
      'nl': 'Bouw je perfecte ochtend\nblok per blok',
      'en': 'Build your perfect morning\nblock by block',
    },
    'home.createRoutineButton': {
      'fr': 'Creer ma routine',
      'nl': 'Maak mijn routine',
      'en': 'Create my routine',
    },
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
      'fr': 'Explorer les routines inspirees',
      'nl': 'Bekijk inspirerende routines',
      'en': 'Explore inspiring routines',
    },
    'home.streak': {
      'fr': 'Streak',
      'nl': 'Streak',
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
      'fr': 'Mode guide',
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
      'fr': 'Termine',
      'nl': 'Klaar',
      'en': 'Done',
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
      'fr': 'Enregistrer et revenir a l accueil',
      'nl': 'Opslaan en terug naar start',
      'en': 'Save and return home',
    },
    'completion.journalTitle': {
      'fr': 'Mini reflection',
      'nl': 'Mini-reflectie',
      'en': 'Mini reflection',
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
      'fr': 'Debloque le check humeur et le mini journal',
      'nl': 'Ontgrendel mood check en mini-journal',
      'en': 'Unlock mood check and mini journal',
    },
    'completion.proInsightsSub': {
      'fr': 'Observe ton energie et ce qui marche le mieux.',
      'nl': 'Volg je energie en wat het best werkt.',
      'en': 'Track your energy and what works best.',
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
      'fr': 'Commencer essai gratuit 3j - Annuel',
      'nl': 'Start 3-daagse proef - Jaarlijks',
      'en': 'Start 3-day trial - Yearly',
    },
    'paywall.ctaMonthly': {
      'fr': 'Commencer essai gratuit 3j - Mensuel',
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
      'fr': 'Vois ta progression sur 30 jours, tes scores passes et tes statistiques detaillees.',
      'nl': 'Bekijk je voortgang over 30 dagen, vorige scores en detailstatistieken.',
      'en': 'See your 30-day progress, past scores, and detailed stats.',
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
      'fr': 'Variation moyenne apres routine: {delta}',
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
