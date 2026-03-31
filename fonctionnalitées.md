# Inventaire Complet des Fonctionnalités — Morning Routine

Date de l'audit: 31/03/2026  
Base: code réellement implémenté dans le dossier lib/ + intégration iOS widget

## 1) Vue d'ensemble (ce que l'app permet de faire)

- Créer et gérer plusieurs routines matinales locales.
- Construire une routine bloc par bloc (ajout, suppression, réordre, durée).
- Lancer une session de routine en 2 modes:
  - Checklist (gratuit): validation manuelle des blocs.
  - Guided (premium): timer bloc par bloc avec progression automatique.
- Calculer un score quotidien, persister l'historique local et calculer les streaks.
- Consulter des routines partagées (catalogue + détail) puis les importer.
- Débloquer des fonctions premium via paywall (RevenueCat).
- Configurer les réglages (heure, notifications, son, vibration, langue, reset).
- Utiliser l'app en FR/NL/EN.
- Afficher une politique de confidentialité localisée.
- Utiliser une base de succès (achievements) calculés depuis l'historique.

## 2) Cartographie des modules

- Core app
  - Initialisation Hive + orientation portrait + thème dark unique.
  - Routing GoRouter (12 routes).
  - i18n custom FR/NL/EN.
- Onboarding
  - 4 étapes (welcome, réveil, durée, objectifs) + choix de langue 1er lancement.
- Home
  - Tableau principal, streak semaine, CTA démarrage/édition.
- Routine Builder
  - Multi-routines + activation immédiate/demain + édition blocs.
- Timer
  - Checklist / Guided + mood avant session (premium) + completion.
- Scoring / History
  - Sauvegarde score journalier + streak + écran historique premium.
- Shared Routines
  - Catalogue filtrable + détail + import dans routine.
- Paywall / Premium
  - Offres mensuelles/annuelles + achat/restauration.
- Settings
  - Préférences complètes + reset data + privacy.
- Achievements
  - 12 succès calculés à partir des scores.
- Notifications
  - Rappel quotidien local planifié.
- Widgets iOS
  - Service et extension présents, intégration Flutter partielle (voir limites).

## 3) Fonctionnalités détaillées (avec sous-fonctionnalités)

### A. Démarrage, initialisation, architecture

- L'app démarre en mode portrait uniquement.
- UI status bar configurée en mode clair sur fond transparent.
- Hive est initialisé et ouvre 3 boxes principales:
  - routines
  - scores
  - settings
- Adapters Hive enregistrés:
  - TimeOfDayAdapter
  - BlockModelAdapter
  - RoutineModelAdapter
- Reset one-shot au premier lancement technique:
  - efface routines/scores/settings
  - force isOnboardingCompleted=false
  - marqueur __fresh_reset_done__=true
- NotificationService initialisé au démarrage.
- SharedRoutinesLocalSource initialisé au démarrage.
- RevenueCat configuré uniquement mobile (Android/iOS), pas web/desktop.

### B. Navigation (routes)

Routes GoRouter implémentées:

- /
- /onboarding
- /builder
- /builder/blocks
- /templates
- /shared-routines
- /shared-routines/:templateId
- /timer
- /completion
- /settings
- /paywall
- /privacy-policy

Règle de redirection globale:

- Si onboarding non terminé: toute navigation redirige vers /onboarding (sauf si déjà sur /onboarding).

### C. Onboarding (4 pages)

#### C1. Etape 1 — Welcome

- Affiche titre/sous-titre localisés.
- Bouton principal Start/Next selon état.

#### C2. Etape 2 — Wake Time

- Sélecteur TimePickerWheel.
- Valeur par défaut: 06:30.
- Back button dédié.

#### C3. Etape 3 — Duration

- Sélection durée parmi options fixes (15/30/45/60).
- Cartes visuelles de choix.

#### C4. Etape 4 — Goals

- Multi-sélection d'objectifs:
  - energy, focus, calm, fitness, productivity
- Fin activable uniquement si conditions state.canProceed remplies.

#### C5. Fin d'onboarding

- Persiste:
  - isOnboardingCompleted=true
  - wakeTimeHour/wakeTimeMinute
  - routineDurationMinutes
  - selectedGoals
- Met à jour provider onboarding global.
- Demande permission notifications.
- Programme rappel matinal à l'heure choisie.
- Navigue vers Home.

#### C6. Choix de langue premier lancement

- Modal bloquante si hasChosenLanguage=false.
- Langues: fr, nl, en.
- Persiste languageCode + hasChosenLanguage=true.
- Reconfigure locale app immédiatement.

### D. Home Dashboard

- Affichage greeting + sous-texte dépendant de l'heure (matin/après-midi).
- Header avec 2 actions:
  - ouvrir réglages
  - ouvrir catalogue routines partagées
- Bandeau semaine:
  - 7 points (lundi-dimanche)
  - statut done basé sur score isSuccessful
  - indication du jour courant
- Affichage streak actuel.
- Carte principale de routine:
  - si routine existe: nom, durée totale, CTA démarrer/redo
  - sinon: état vide + CTA création routine
- CTA:
  - Start -> /timer
  - Edit -> /builder
- Au montage, refresh scoring + routine builder.

### E. Routine Builder (gestion multi-routines)

#### E1. Gestion globale de routines

- Stockage V2 multi-routines dans routine_repository.
- Migration legacy depuis current_routine vers routines_v2.
- Sélection d'une routine active dans une dropdown.
- Création d'une nouvelle routine vide.
- Suppression de routine sélectionnée avec confirmation.
- Garantie: toujours au moins 1 routine (si dernière supprimée -> reset de son contenu).

#### E2. Activation des routines

- Active maintenant (setActiveRoutineNow).
- Planification pour demain (scheduleActiveRoutineForTomorrow).
- Annulation de planification.
- Résumé visuel:
  - routine active actuelle
  - routine planifiée + date
- Activation planifiée appliquée automatiquement à date due lors des lectures repository.

#### E3. Edition des blocs

- Réordonnancement drag-and-drop (ReorderableListView).
- Suppression bloc avec confirmation.
- Durée bloc modifiable.
- Bornes durée:
  - min 1 minute
  - max 60 minutes
- Calcul affiché:
  - wake time
  - end time (wake + total durée)
  - durée totale

#### E4. Ajout de bloc

- Ouvre /builder/blocks.
- Limites:
  - max technique global: 10 blocs
  - limite gratuite: 3 blocs (au-delà -> push /paywall)

#### E5. Sauvegarde

- Bouton check en header.
- Etat isSaving + spinner.
- Persiste routine modifiée et revient écran précédent.

### F. Bloc Selector

- Grille 2 colonnes des templates de blocs.
- 26 templates prédéfinis (catégorisés en data).
- Chaque carte montre emoji + nom + durée défaut.
- Empêche ajout de doublon template dans une même routine:
  - état alreadyAdded
  - carte désactivée
- Tap template -> ajoute bloc + retour builder.

### G. Presets de routine (/templates)

- Grille de presets prédéfinis (7 presets).
- Chaque preset affiche:
  - icône
  - nom
  - description
  - nombre de blocs
  - durée totale estimée
- Presets Pro verrouillés si non premium.
- Tap preset:
  - si autorisé -> charge preset dans routine courante
  - sinon -> ouvre paywall

### H. Shared Routines (catalogue créateurs)

#### H1. Catalogue

- Recherche texte (title, subtitle, goal, tags).
- Filtres:
  - thème
  - niveau
  - durée max (all, <=30, <=45)
  - only free
- Liste de templates filtrés dynamiquement.
- Empty state + bouton reset filtres.

#### H2. Détail routine partagée

- Header contexte créateur + sous-titre.
- Infos:
  - goal
  - thème
  - niveau
  - statut
  - durée totale
  - badge Free/Pro
  - source label
- Séquence complète des blocs:
  - numéro d'ordre
  - bloc référencé
  - durée
  - note optionnelle
- Disclaimer affiché.

#### H3. Import d'une routine partagée

Si routine non verrouillée:

- Dupliquer vers builder (navigation /builder).
- Importer et activer maintenant.
- Importer et programmer pour demain.

Si routine verrouillée (template premium + user non premium):

- CTA unlock pro -> /paywall.

#### H4. Données seed shared routines

- 4 créateurs seedés.
- 4 templates shared routines seedés actuellement.
- Statuts supportés (inspired/verified/official via enum).

#### H5. Cache local shared routines

- Source locale Hive dédiée:
  - shared_routines_templates
  - shared_routines_creators
  - shared_routines_metadata
- TTL cache: 120 minutes.
- Sérialisation JSON templates/créateurs.
- syncToLocalCache appelée en background.
- Limite actuelle importante:
  - repository lit directement les seeds pour affichage;
  - le chemin de lecture depuis cache existe mais n'est pas branché dans le flux principal.

### I. Timer Engine

#### I1. Pré-session

- Modal choix de mode obligatoire:
  - Checklist (gratuit)
  - Guided (premium)
- Si utilisateur premium:
  - mood avant session demandé (tired/calm/stressed/focused/energized)

#### I2. Mode Checklist (gratuit)

- Liste de tous les blocs avec checkbox.
- Toggle done par bloc.
- Compteur done/total en direct.
- Message d'encouragement dynamique.
- Bouton Finish Checklist -> clôture session.
- Pas de countdown automatique.

#### I3. Mode Guided (premium)

- Compteur bloc courant sur total.
- Barre de progression multi-blocs.
- Timer circulaire (secondsRemaining / totalSeconds).
- Affichage bloc actuel + preview prochain bloc.
- Contrôles:
  - Play/Pause
  - Skip
  - Done
- Tick toutes les secondes.
- Fin de bloc automatique à 0.
- Passage automatique au bloc suivant.

#### I4. Données de session stockées en mémoire

- sessionMode
- moodBefore
- moodAfter
- reflection
- intention
- topPriority
- completedBlocks avec actualDurationSeconds par bloc
- startedAt / blockStartedAt

#### I5. Quitter session

- Confirmation via dialog (keep/quit).
- Quit retourne Home.

### J. Completion & checkout post-routine

- Affiche score % calculé à partir completed/total.
- Affiche:
  - blocs complétés
  - blocs skippés
  - durée réelle
  - streak actuel
- Sauvegarde brouillon immédiate au montage (draft save).
- Si premium:
  - mood après
  - champ réflexion
  - champ intention
  - champ priorité #1
- Si free:
  - carte upsell insights pro
- Bouton finish/save:
  - injecte checkout data dans timer state
  - persiste score final
  - retour Home
- Gestion erreur sauvegarde via SnackBar.

### K. Scoring, streaks et historique

#### K1. Modèle DailyScore persisté

- Champs:
  - id
  - date
  - totalBlocks
  - completedBlocks
  - skippedBlocks
  - totalDurationSeconds
  - actualDurationSeconds
  - sessionMode
  - moodBefore/moodAfter
  - reflection/intention/topPriority
- Propriétés calculées:
  - scorePercent
  - isSuccessful (>= 80)
  - dateKey yyyy-MM-dd

#### K2. Persistance

- Sauvegarde key-value par dateKey dans box scores.
- Un score par jour (écrasement clé du jour).

#### K3. Streak logic

- Current streak: consécutif basé sur jours réussis.
- Best streak: meilleur run historique.

#### K4. Écran History (premium)

- Gated: non premium -> écran verrouillé + CTA paywall.
- Si premium:
  - résumé 4 stats:
    - best streak
    - total jours réussis
    - score moyen
    - jours actifs du mois
  - calendriers 2 mois:
    - mois courant
    - mois précédent
  - section énergie/humeur:
    - delta moyen moodBefore->moodAfter
    - mode le plus efficace (guided/checklist) si assez de données
  - liste des 10 dernières sessions

### L. Achievements

- 12 achievements définis en dur.
- Tiers:
  - bronze
  - silver
  - gold
  - platinum
- Conditions couvertes:
  - première routine réussie
  - streaks (3/7/14/30/100)
  - scores parfaits (1 puis 5)
  - volume de routines réussies (10/30)
  - early bird (session avant 7h)
  - semaine parfaite ISO (7/7)
- Écran succès:
  - progression unlock X/Y
  - barre de progression
  - regroupement par tier
  - affichage lock/unlock + condition

### M. Paywall, abonnement et premium

- Contrôle premium via RevenueCat entitlement id: pro.
- PremiumState:
  - isPremium
  - isLoading
  - offerings
- Ecran paywall:
  - bannière trial
  - liste de features pro
  - toggle mensuel/annuel
  - prix dynamiques RevenueCat si dispos sinon fallback texte
  - CTA achat
  - bouton restore
  - vue spéciale déjà premium
- Retour d'achat:
  - pop(true) en cas succès pour débloquer flux appelant.
- Particularité debug:
  - sur web/linux/windows/macos en debug: premium forcé à true.

### N. Settings

- Wake time editable (time picker).
- Notifications:
  - toggle enable/disable
  - time picker rappel
  - enable -> requestPermissions + scheduleMorningReminder
  - disable -> cancelAll
- Sound toggle.
- Vibration toggle.
- Langue:
  - fr/nl/en
  - persistance immédiate
  - hasChosenLanguage=true au changement
- About:
  - version app (1.0.0)
- Privacy Policy route.
- Reset data:
  - confirmation
  - clear routines/scores/settings
  - force retour onboarding

### O. Notifications locales

- Service singleton basé sur flutter_local_notifications + timezone.
- scheduleMorningReminder:
  - annule existant
  - planifie rappel quotidien (matchDateTimeComponents.time)
  - si heure passée -> programme lendemain
- requestPermissions iOS/macOS/Android.
- showInstant disponible.
- Message de notification actuellement codé en français (pas localisé dynamiquement).

### P. Localisation

- Langues supportées:
  - Français
  - Nederlands
  - English
- Locale branchée sur MaterialApp.
- Dictionnaire AppI18n utilisé dans la majorité des écrans clés.
- Language provider Riverpod + persistance settings.

### Q. Politique de confidentialité

- Écran dédié /privacy-policy.
- Sections localisées:
  - heading
  - date de mise à jour
  - résumé
  - données collectées
  - abonnements
  - notifications
  - pub
  - mineurs
  - contact
  - badge de confiance

### R. Widget iOS

- Côté iOS natif et service Flutter présents.
- WidgetService prévoit:
  - partage app group
  - envoi streak / doneToday / scorePercent / statusText
  - refresh widget
- Limite d'intégration actuelle:
  - aucun appel effectif à WidgetService.initialize() ou WidgetService.updateWidget() dans le flux app actif.
  - donc fonctionnalité widget codée mais non branchée en production Flutter actuelle.

## 4) Matrice free vs premium

- Gratuit
  - Checklist mode
  - Création routine
  - Jusqu'à 3 blocs par routine
  - Shared routines free
  - Settings complets de base
- Premium
  - Guided mode (timer avancé)
  - Jusqu'à 10 blocs
  - Import de templates/presets pro
  - History complet
  - Mood + journal post-session

## 5) Points partiellement implémentés ou non branchés

- Widget iOS: code présent mais non branché côté Flutter (pas d'update effectif).
- Cache shared routines: écriture cache OK, lecture cache non utilisée dans le repository principal.
- Écrans History et Achievements: implémentés, mais pas de route dédiée dans app_router.
- Notification message: contenu hardcodé FR (pas localisé selon langue active).
- Timer background OS: pas de mécanisme de reprise/rattrapage persistant si app tuée en milieu de session (timer en mémoire).
- RevenueCat: clé API placeholder dans constantes (nécessite valeur réelle en prod).

## 6) Détails chiffrés vérifiés

- Routes GoRouter: 12
- Templates de blocs: 26
- Presets routines: 7
- Shared routines seedées: 4
- Créateurs seedés: 4
- Achievements: 12
- Langues supportées: 3

## 7) Conclusion opérationnelle

L'app est déjà bien au-delà d'un simple MVP de routine matinale: elle couvre la création multi-routines, l'exécution de session en deux modes, la monétisation premium, l'historique, les routines inspirées de créateurs, les réglages avancés et la localisation trilingue.

Les principaux écarts à traiter pour une version encore plus robuste sont surtout de câblage final (widget iOS, accès/routing à certains écrans secondaires, usage réel du cache shared routines, i18n complet des notifications).
