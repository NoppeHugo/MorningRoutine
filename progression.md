# Progression — Morning Routine Builder

## Session : 29 Mars 2026 — Widgets iOS (écran d'accueil + écran de verrouillage)

### Ce qui a été fait cette session

#### 1. pubspec.yaml — Ajout home_widget
- Ajout de `home_widget: ^0.6.0` dans les dependencies (après `purchases_flutter`)

#### 2. lib/features/widgets/widget_service.dart — Service Flutter [NOUVEAU]
- `WidgetService.initialize()` : configure l'App Group `group.com.morningroutine.app`
- `WidgetService.updateWidget()` : lit streak, doneToday, scorePercent et statusText depuis `scoringRepositoryInstance`, écrit dans UserDefaults partagé via `HomeWidget.saveWidgetData`, déclenche `HomeWidget.updateWidget`

#### 3. ios/MorningRoutineWidget/MorningRoutineWidget.swift — Widget SwiftUI [NOUVEAU]
- `RoutineEntry` : TimelineEntry avec streak, doneToday, scorePercent, statusText
- `RoutineProvider` : lit UserDefaults suiteName `group.com.morningroutine.app`, refresh toutes les heures
- `SmallWidgetView` : cercle flamme + chiffre streak + "Fait ✓" / "À faire"
- `MediumWidgetView` : cercle streak + message motivant contextuel (0 / <7 / 7+) + score si fait
- `AccessoryCircularView` (iOS 16+) : chiffre streak + flamme pour écran de verrouillage
- `AccessoryRectangularView` (iOS 16+) : statut + score pour écran de verrouillage
- Guards `@available(iOSApplicationExtension 16.0, *)` sur les vues accessory et dans le Widget body

#### 4. ios/MorningRoutineWidget/MorningRoutineWidgetBundle.swift — Bundle [NOUVEAU]
- Point d'entrée `@main` du Widget Extension

#### 5. ios/WIDGET_SETUP.md — Guide Xcode [NOUVEAU]
- Guide étape par étape en français : création du target, remplacement des fichiers, App Group, Deployment Target 16.0, intégration Flutter (`WidgetService.initialize()` + `updateWidget()`), Build & Run

### Où on en est
Tous les fichiers widget sont en place. Il reste à :
1. Ouvrir Xcode et suivre `ios/WIDGET_SETUP.md` pour créer le target Widget Extension
2. Appeler `WidgetService.initialize()` dans `main.dart`
3. Appeler `WidgetService.updateWidget()` après `saveRoutineResult()` dans `ScoringController`

---


## Session : 29 Mars 2026 — Système de succès / Achievements

### Ce qui a été fait cette session

#### 1. `lib/features/achievements/domain/achievement_model.dart` — Modèle domaine
- Enum `AchievementTier` : bronze, silver, gold, platinum
- Classe `Achievement` immutable avec : id, title, description, icon, tier, condition

#### 2. `lib/features/achievements/data/achievements_repository.dart` — Données & logique
- Liste statique `allAchievements` (12 achievements)
- Méthode `getUnlockedIds(List<DailyScore>)` → `Set<String>` : calcule les achievements débloqués
- Utilise `StreakCalculator.calculateBestStreak` pour les conditions de streak
- Logique `_hasPerfectIsoWeek` pour l'achievement "Semaine parfaite" (7 jours ISO)

#### 3. `lib/features/achievements/presentation/achievements_controller.dart` — State management
- `AchievementsState` @immutable : all, unlockedIds, isLoading + computed unlocked, locked, unlockedCount
- `AchievementsController` StateNotifier : charge scores via `scoringRepositoryInstance`, calcule unlocks
- Provider `achievementsControllerProvider`

#### 4. `lib/features/achievements/presentation/achievements_screen.dart` — UI
- `AppScaffold` titre "Succès", showBackButton: true
- Header avec barre de progression "X / 12 débloqués"
- Liste groupée par tier (Platinum → Gold → Silver → Bronze)
- `_AchievementCard` : badge circulaire coloré si débloqué, gris+opacité si locked
- Badge avec overlay `Icons.lock_outline` (size 10) sur petit cercle si locked
- Condition en italic gris si non débloqué
- Couleurs : platinum = `Color(0xFFB0C4DE)`, gold = warning, silver = textSecondary, bronze = `Color(0xFFCD7F32)`

### Où on en est
Les 4 fichiers du système d'achievements sont créés. Aucun fichier existant n'a été modifié.
Pour brancher l'écran, ajouter la route `/achievements` dans `app_router.dart` et un lien depuis Settings ou Home.

---

## Session : 29 Mars 2026 — Enrichissement Home Screen & Catalogue de blocs

### Ce qui a été fait cette session

#### 1. blocks_repository.dart — Catalogue enrichi
- Ajout du type `BlockCategory` (enum) avec 6 catégories : Mindfulness, Mouvement, Nutrition, Développement personnel, Hygiène & Soin, Productivité
- Extension `BlockCategoryExtension` : label FR + couleur accent par catégorie (iOS palette)
- `BlockTemplate` étendu : champs `category` (BlockCategory) et `icon` (IconData) en plus de l'existant
- 26 blocs au total (15 anciens remplacés/enrichis + 11 nouveaux) avec icônes Material et durées calibrées
- Helpers ajoutés : `templatesByCategory`, `findById(String)`

#### 2. home_screen.dart — Home screen enrichie
- Header : icône `wb_sunny_rounded` + "Bonjour" + sous-titre contextuel (matin/après-midi)
- `_StreakScoreCard` : carte deux colonnes (streak avec feu + score du jour), messages motivants si pas encore fait
- `_WeeklyTrackerCard` : 7 cercles L-D colorés vert si complété, avec compteur "X/7 jours", cercle du jour bordé en orange
- `_MotivationBanner` : message contextuel selon streak (0 / 1-6 / 7+) avec icône adaptée
- Bouton start déplacé en bas hors du scroll
- Imports ajoutés : `scoring_repository.dart`, `score_model.dart`

#### 3. routine_preview_card.dart — Amélioration visuelle
- Chaque bloc affiche son icône Material (via `BlocksRepository.findById`) dans un pill coloré par catégorie
- Durée en chip arrondi gris
- Header avec nom de routine + durée totale + bouton edit compact
- Séparateur entre header et liste de blocs

#### 4. start_routine_button.dart — Bouton Apple-like
- Gradient orange (primaryGradient) au lieu de violet
- Taille augmentée (padding vertical `AppSpacing.lg`)
- Sous-titre durée totale de la routine (paramètre optionnel `totalDurationMinutes`)
- Icône `play_circle_filled_rounded` plus imposante
- Ombre portée plus prononcée (blurRadius 20, spreadRadius 0)

### Où on en est
Les 4 fichiers ciblés sont modifiés. Le catalogue passe de 15 à 26 blocs avec catégories et icônes Material. La home screen a maintenant 4 sections visuelles riches. Les widgets preview et bouton sont plus soignés iOS.

**Bugs préexistants non résolus** (hors scope, fichiers en lecture seule) :
- `AppColors.streak` référencé dans `streak_badge.dart` et `completion_screen.dart` mais absent de `app_colors.dart`
- `AppColors.surfaceHighlight` référencé dans `app_card.dart` mais absent de `app_colors.dart`

---

## Session : 29 Mars 2026 — Conversion Light Mode (iOS HIG)

### Ce qui a été fait cette session

#### Design system converti vers iOS Light Mode
- `app_colors.dart` : palette complètement remplacée — dark (violet/vert néon) → iOS light (orange sunrise + blancs systèmes + labels iOS)
- `app_theme.dart` : thème renommé `dark` → `light`, brightness light, fond `#F2F2F7`, AppBar blanche, cards radius 16, boutons radius 14
- `app.dart` : `AppTheme.dark` → `AppTheme.light`, ajout `themeMode: ThemeMode.light`, suppression darkTheme

### Où on en est
Les 3 fichiers du design system sont migrés. Le reste du code (widgets, screens) utilise les constantes `AppColors.*` qui existent toujours avec les mêmes noms — aucune casse attendue.

---

## Session : Mars 2026 — Préparation App Store

### Ce qui a été fait cette session

#### 1. Fixes compilation (3 bloquants résolus)
- `notification_service.dart` : `IOSFlutterLocalNotificationsPlugin` → `DarwinFlutterLocalNotificationsPlugin` (supprimé en v16)
- Créé `assets/images/.gitkeep` et `assets/sounds/.gitkeep` (dossiers manquants référencés dans pubspec.yaml)
- `main.dart` : ajout de `BlockModelAdapter` et `RoutineModelAdapter` (bonne pratique Hive)

#### 2. RevenueCat + Paywall
- Ajouté `purchases_flutter: ^7.0.0` dans pubspec.yaml
- Initialisé RevenueCat dans `main.dart`
- Créé `lib/features/paywall/presentation/premium_controller.dart` (state management Riverpod)
- Créé `lib/features/paywall/presentation/paywall_screen.dart` (UI paywall complet, toggle mensuel/annuel)
- Ajouté constantes dans `app_constants.dart` : `freeBlockLimit = 3`, `revenueCatApiKey`, `premiumEntitlementId = 'pro'`
- Gate paywall dans `routine_builder_screen.dart` : après 3 blocs → bouton avec lock → redirect paywall
- Banner "Passe à Pro" dans les Réglages
- Routes `/paywall` et `/privacy-policy` ajoutées dans `app_router.dart`

#### 3. Politique de confidentialité
- Créé `lib/features/settings/presentation/screens/privacy_policy_screen.dart`
- Accessible depuis Réglages
- Conforme App Store (pas de collecte de données)

#### 4. Privacy Manifest iOS
- Créé `ios/Runner/PrivacyInfo.xcprivacy` (obligatoire iOS 17+ pour App Store)
- **À ajouter manuellement dans Xcode** : File → Add Files to Runner → PrivacyInfo.xcprivacy

#### 5. APP_STORE_AUDIT.md
- Créé à la racine du projet
- Détaille : compilation, RevenueCat setup, privacy labels, Crashlytics, screenshots, metadata, checklist

---

### Ce qui reste à faire (hors code)

1. **RevenueCat** : Remplacer `YOUR_REVENUECAT_IOS_API_KEY` dans `app_constants.dart`
   - Créer products dans App Store Connect (monthly + annual)
   - Créer entitlement `pro` + offering dans RevenueCat

2. **Politique de confidentialité** : Héberger en ligne (GitHub Pages ou autre)

3. **Firebase Crashlytics** : Optionnel — voir APP_STORE_AUDIT.md section 4

4. **Privacy Manifest** : Ajouter `PrivacyInfo.xcprivacy` dans Xcode (target Runner)

5. **Screenshots** : Capturer sur iPhone 15 Pro Max + iPhone 14 Plus

6. **App Store Connect** : Remplir metadata, privacy labels, soumettre

---

### Architecture actuelle
```
lib/
  core/
    constants/app_constants.dart  ← freeBlockLimit, RevenueCat keys
    router/app_router.dart         ← /paywall, /privacy-policy ajoutés
    theme/                         ← Design system complet
    widgets/                       ← Composants partagés
  features/
    home/                          ← Dashboard
    notifications/                 ← Notifications locales
    onboarding/                    ← 4 écrans onboarding
    paywall/                       ← [NOUVEAU] RevenueCat + Paywall UI
    routine_builder/               ← Builder + gate paywall
    scoring/                       ← Scores + streaks
    settings/                      ← Réglages + Pro banner + Privacy Policy
    timer/                         ← Timer + Completion
  shared/                          ← Providers partagés
```

---

## Session : 29 Mars 2026 — Écran Historique (feature Pro)

### Ce qui a été fait cette session

#### Créé `lib/features/scoring/presentation/screens/history_screen.dart`

Nouvel écran Pro "Historique" complet :

- **Gate paywall** : si `isPremium == false`, affiche `_buildPaywallGate` avec icône lock, titre, sous-titre et bouton "Débloquer avec Pro" → `/paywall`
- **Section A — 4 chips stats** dans une card blanche radius 16 :
  - Meilleur streak (Icons.local_fire_department_rounded, warning)
  - Total routines complétées (Icons.check_circle_outline_rounded, secondary)
  - Score moyen % (Icons.bar_chart_rounded, primary)
  - Jours actifs ce mois (Icons.calendar_today_rounded, info)
- **Section B — Calendrier 2 mois** (mois courant + mois précédent) via widget `_MonthCalendar` :
  - En-tête : nom du mois FR capitalisé (via `intl`) + rangée L M M J V S D
  - Cercles jours : vert+check si >= 80%, orange semi-opaque si 0-79%, gris si pas de donnée, bordé orange si aujourd'hui
- **Section C — 10 dernières sessions** triées date décroissante via `_SessionTile` :
  - Date formatée FR, badge score coloré, blocs X/Y, durée en min
- Widgets privés : `_StatChip`, `_MonthCalendar`, `_DayCell`, `_SessionTile`
- Utilise `scoringRepositoryInstance.getAllScores()` et `.getBestStreak()` directement

### Où on en est
Fichier créé uniquement, aucun fichier existant modifié. L'écran est prêt mais pas encore branché dans `app_router.dart` (route `/history` à ajouter + lien depuis Home/Settings si besoin).

---

## Session : 29 Mars 2026 — Feature A (Fix Notifications) + Feature C (Bibliotheque de routines)

### Ce qui a été fait cette session

#### Feature A — Fix Notifications (T1-A)
- `main.dart` : import + appel `NotificationService.instance.initialize()` après ouverture des Hive boxes, avant `runApp`
- `settings_screen.dart` : import `notification_service.dart` + callback `onChanged` du Switch "Rappel matinal" converti en async — appelle `requestPermissions()` + `scheduleMorningReminder()` si activé, `cancelAll()` si désactivé — callback `onPicked` de l'heure du rappel : appelle `scheduleMorningReminder(time)` si notifs actives
- `onboarding_controller.dart` : import + dans `completeOnboarding()` après `isOnboardingCompletedProvider = true` : `requestPermissions()` + `scheduleMorningReminder(wakeTime)` si wakeTime non null

#### Feature C — Bibliotheque de routines expertes (T1-C)
- Créé `lib/features/routine_builder/data/preset_routines.dart` : classe `PresetRoutine` + `PresetRoutines` avec 6 routines (5h du matin, Minimaliste 20min, Athlete, Entrepreneur focalisé, Bien-être complet, Stoicien)
- `routine_builder_controller.dart` : import + méthode `loadPreset(PresetRoutine preset)` — construit les BlockModel, met à jour state, appelle `saveRoutine()`
- Créé `lib/features/routine_builder/presentation/screens/template_chooser_screen.dart` : grille 2 colonnes, cards iOS, badge PRO avec cadenas si locked, gate paywall si isPro && !isPremium
- `app_router.dart` : `AppRoutes.templates = '/templates'` + `GoRoute` vers `TemplateChooserScreen`

### Ou on en est
Features A et C complètes. Notifications initialisées au démarrage, connectées à settings et onboarding. Route `/templates` disponible.

**A faire** : ajouter bouton dans `routine_builder_screen.dart` → `context.push(AppRoutes.templates)`.
