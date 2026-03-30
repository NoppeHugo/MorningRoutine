# 🌅 MORNING ROUTINE BUILDER — MVP SPECIFICATION

> **Version**: 1.0
> **Dernière mise à jour**: Mars 2026
> **Objectif**: Spécification complète pour qu'une IA puisse coder le MVP module par module

---

## 📋 TABLE DES MATIÈRES

1. [Vision Produit](#1-vision-produit)
2. [Stack Technique](#2-stack-technique)
3. [Architecture](#3-architecture)
4. [Ordre de Développement](#4-ordre-de-développement)
5. [Module M1 — Core Setup](#5-module-m1--core-setup)
6. [Module M2 — Onboarding](#6-module-m2--onboarding)
7. [Module M3 — Routine Builder](#7-module-m3--routine-builder)
8. [Module M4 — Timer Engine](#8-module-m4--timer-engine)
9. [Module M5 — Scoring System](#9-module-m5--scoring-system)
10. [Module M6 — Home Dashboard](#10-module-m6--home-dashboard)
11. [Module M7 — Settings](#11-module-m7--settings)
12. [Module M8 — Notifications](#12-module-m8--notifications)
13. [Modèles de Données](#13-modèles-de-données)
14. [Assets Requis](#14-assets-requis)
15. [Critères de Validation](#15-critères-de-validation)

---

## 1. VISION PRODUIT

### 1.1 Pitch

**Morning Routine Builder** est une app iOS qui permet de :
1. **Créer** sa routine matinale bloc par bloc
2. **Suivre** cette routine chaque matin avec un timer en temps réel
3. **Tracker** sa progression avec scores et streaks
4. **Acheter** des routines d'experts (V2)

### 1.1.1 Extension strategique

Le cahier des charges detaille pour la section "routines partagees / createurs inspirants" est documente dans:
- `ROUTINES_PARTAGEES_CAHIER_DES_CHARGES.md`
petit extrait : 
(## 1. Vision produit

Permettre a l'utilisateur de suivre des routines inspirees de createurs connus (sport, productivite, bien-etre, business, spiritualite), avec un cadre motivant et credibilise.

Objectif principal:
- Transformer l'intention "je veux une routine comme X" en execution quotidienne simple dans l'app.

Objectifs secondaires:
- Augmenter l'activation de routine en onboarding.
- Ameliorer la retention D7 et D30.
- Creer une base premium autour de routines curateurs/expertes.

## 2. Problemes a resoudre

- L'utilisateur debutant ne sait pas quoi mettre dans sa routine.
- Les routines libres demandent trop de decisions au demarrage.
- Le manque de modele inspirant reduit l'adherence a long terme.

## 3. Positionnement et principes

### 3.1 Positionnement

- "Inspiree de" et non "copie officielle" par defaut.
- Focus execution pratique: blocs concrets, durees claires, ordre logique.
- Identite narrative: chaque routine doit raconter un style de vie.

### 3.2 Principes produit

- Simplicite d'adoption: import en 1 tap.
- Personnalisation immediate: edition avant activation.
- Transparence: source de la routine et niveau de verification visibles.
- Ethique: pas de promesse medicale ni performance irrealiste.

## 4. Personas cibles

- Debutant motive (18-35): veut une routine prete a l'emploi.
- Fan d'un createur: cherche un cadre identitaire fort.
- Utilisateur avance: veut partir d'une base experte puis adapter.)

### 1.2 Scope MVP (V1)

| Inclus dans le MVP ✅ | Exclu (V2+) ❌ |
|----------------------|----------------|
| Créer 1 routine | Multi-routines (semaine/weekend) |
| Max 10 blocs | Blocs illimités |
| Timer avec guidage | Musique/ambiance intégrée |
| Score du jour + streak | Graphiques avancés |
| 15 blocs prédéfinis | Blocs personnalisés |
| Stockage local | Backend / Cloud sync |
| Thème dark uniquement | Multi-thèmes |
| Notifications basiques | Alarme intégrée |
| — | Marketplace Pro |
| — | Social / Partage |
| — | Apple Watch |
| — | Widgets iOS |

### 1.3 User Flow MVP

```
[Première ouverture]
    ↓
[Onboarding: 4 écrans]
    ↓
[Home Dashboard: routine vide]
    ↓
[Routine Builder: créer sa routine]
    ↓
[Home Dashboard: routine prête]
    ↓
[Le matin: notification]
    ↓
[Timer: suivre la routine bloc par bloc]
    ↓
[Completion: score affiché]
    ↓
[Home Dashboard: streak mis à jour]
```

---

## 2. STACK TECHNIQUE

### 2.1 Framework

| Composant | Choix | Raison |
|-----------|-------|--------|
| **Framework** | Flutter 3.x | Cross-platform, preview web sur PC |
| **Langage** | Dart | Natif Flutter |
| **State Management** | Riverpod 2.x | Moderne, testable, scalable |
| **Navigation** | Go Router | Déclaratif, deep links ready |
| **Storage local** | Hive | Rapide, NoSQL, pas de setup |
| **Notifications** | flutter_local_notifications | Standard, fiable |
| **Animations** | Flutter Animate | API simple, performant |
| **Icons** | Lucide Icons (lucide_icons) | Cohérent, moderne |
| **Fonts** | Inter (Google Fonts) | Moderne, lisible |

### 2.2 Versions minimales 

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.16.0'
```

### 2.3 Dépendances pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  
  # Navigation
  go_router: ^13.0.0
  
  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Notifications
  flutter_local_notifications: ^16.0.0
  timezone: ^0.9.2
  
  # UI
  google_fonts: ^6.1.0
  lucide_icons: ^0.257.0
  flutter_animate: ^4.3.0
  
  # Utils
  uuid: ^4.2.1
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.0
```

---

## 3. ARCHITECTURE

### 3.1 Structure des dossiers

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_spacing.dart
│   │
│   ├── router/
│   │   └── app_router.dart
│   │
│   ├── constants/
│   │   └── app_constants.dart
│   │
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── duration_utils.dart
│   │
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── app_icon_button.dart
│       └── app_scaffold.dart
│
├── features/
│   ├── onboarding/
│   │   ├── data/
│   │   │   └── onboarding_repository.dart
│   │   ├── domain/
│   │   │   └── onboarding_state.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── onboarding_screen.dart
│   │       ├── widgets/
│   │       │   ├── onboarding_page.dart
│   │       │   └── time_picker_wheel.dart
│   │       └── onboarding_controller.dart
│   │
│   ├── routine_builder/
│   │   ├── data/
│   │   │   ├── routine_repository.dart
│   │   │   └── blocks_repository.dart
│   │   ├── domain/
│   │   │   ├── routine_model.dart
│   │   │   └── block_model.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── routine_builder_screen.dart
│   │       │   └── block_selector_screen.dart
│   │       ├── widgets/
│   │       │   ├── routine_block_card.dart
│   │       │   └── block_duration_picker.dart
│   │       └── routine_builder_controller.dart
│   │
│   ├── timer/
│   │   ├── data/
│   │   │   └── timer_repository.dart
│   │   ├── domain/
│   │   │   └── timer_state.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── timer_screen.dart
│   │       │   └── completion_screen.dart
│   │       ├── widgets/
│   │       │   ├── circular_timer.dart
│   │       │   ├── block_progress_bar.dart
│   │       │   └── timer_controls.dart
│   │       └── timer_controller.dart
│   │
│   ├── scoring/
│   │   ├── data/
│   │   │   └── scoring_repository.dart
│   │   ├── domain/
│   │   │   ├── score_model.dart
│   │   │   └── streak_model.dart
│   │   └── presentation/
│   │       └── widgets/
│   │           ├── score_display.dart
│   │           └── streak_badge.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── home_screen.dart
│   │       └── widgets/
│   │           ├── routine_preview_card.dart
│   │           ├── today_stats_card.dart
│   │           └── start_routine_button.dart
│   │
│   └── settings/
│       ├── data/
│       │   └── settings_repository.dart
│       ├── domain/
│       │   └── settings_model.dart
│       └── presentation/
│           ├── screens/
│           │   └── settings_screen.dart
│           └── widgets/
│               └── settings_tile.dart
│
└── shared/
    ├── models/
    │   └── time_of_day_adapter.dart
    └── providers/
        └── storage_provider.dart
```

### 3.2 Principes architecturaux

| Principe | Règle |
|----------|-------|
| **Séparation** | data / domain / presentation par feature |
| **State** | Riverpod providers, immutable states |
| **Navigation** | Go Router, routes nommées |
| **Widgets** | Petits, réutilisables, dans `/widgets` |
| **Pas de logique dans les widgets** | Toute logique dans les controllers |
| **Modèles immutables** | Classes avec `copyWith`, `@immutable` |

---

## 4. ORDRE DE DÉVELOPPEMENT

> ⚠️ **IMPORTANT**: Coder les modules dans cet ordre exact. Chaque module dépend des précédents.

| Ordre | Module | Dépendances | Temps estimé |
|-------|--------|-------------|--------------|
| 1 | **M1 — Core Setup** | Aucune | 2-3h |
| 2 | **M2 — Onboarding** | M1 | 3-4h |
| 3 | **M3 — Routine Builder** | M1, M2 | 4-5h |
| 4 | **M4 — Timer Engine** | M1, M3 | 4-5h |
| 5 | **M5 — Scoring System** | M1, M4 | 2-3h |
| 6 | **M6 — Home Dashboard** | M1, M3, M5 | 3-4h |
| 7 | **M7 — Settings** | M1 | 2h |
| 8 | **M8 — Notifications** | M1, M3, M7 | 2-3h |

**Total estimé**: 22-29 heures de développement

---

## 5. MODULE M1 — CORE SETUP

### 5.1 Objectif

Mettre en place l'architecture de base : thème, navigation, storage, widgets réutilisables.

### 5.2 Fichiers à créer

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_spacing.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── constants/
│   │   └── app_constants.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart
│       └── app_scaffold.dart
└── shared/
    └── providers/
        └── storage_provider.dart
```

### 5.3 Spécifications détaillées

#### main.dart

```dart
// - Initialise Hive avec HiveFlutter
// - Enregistre les adapters Hive (à ajouter plus tard)
// - Lance l'app avec ProviderScope (Riverpod)
// - Appelle runApp(ProviderScope(child: App()))
```

#### app.dart

```dart
// - ConsumerWidget
// - Retourne MaterialApp.router
// - Utilise GoRouter depuis le provider
// - Applique AppTheme.dark
// - Désactive le banner debug
```

#### app_colors.dart

```dart
abstract class AppColors {
  // Primary
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFFA29BFE);
  
  // Secondary
  static const secondary = Color(0xFF00D9A5);
  
  // Backgrounds
  static const background = Color(0xFF0F0F1A);
  static const surface = Color(0xFF1A1A2E);
  static const surfaceLight = Color(0xFF252542);
  
  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8E8E9A);
  
  // Status
  static const error = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFECA57);
  static const success = Color(0xFF00D9A5); // same as secondary
}
```

#### app_typography.dart

```dart
// Utilise Google Fonts Inter
// Définit tous les TextStyles:
// - headingLarge: 28px, Bold
// - headingMedium: 22px, SemiBold
// - headingSmall: 18px, SemiBold
// - bodyLarge: 16px, Regular
// - bodyMedium: 14px, Regular
// - bodySmall: 12px, Regular
// - labelMedium: 14px, Medium
// - timer: 64px, Bold, monospace (utiliser RobotoMono)
```

#### app_spacing.dart

```dart
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  
  // Border radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusFull = 9999;
}
```

#### app_theme.dart

```dart
// Crée ThemeData dark avec:
// - scaffoldBackgroundColor: AppColors.background
// - colorScheme: ColorScheme.dark avec primary, secondary, etc.
// - textTheme: utilise AppTypography
// - appBarTheme: transparent, no elevation
// - elevatedButtonTheme: style avec primary, borderRadius large
// - inputDecorationTheme: filled, surfaceLight background
// - cardTheme: surface color, radiusMedium
```

#### app_router.dart

```dart
// Routes à définir:
// - '/': HomeScreen (ou OnboardingScreen si premier lancement)
// - '/onboarding': OnboardingScreen
// - '/builder': RoutineBuilderScreen
// - '/builder/blocks': BlockSelectorScreen
// - '/timer': TimerScreen
// - '/completion': CompletionScreen
// - '/settings': SettingsScreen

// Utilise redirect pour checker si onboarding completed
```

#### app_button.dart

```dart
// Widget AppButton avec:
// - Paramètres: label, onPressed, isLoading, variant (primary/secondary/text)
// - Style primary: fond primary, texte blanc
// - Style secondary: fond transparent, bordure primary
// - Style text: fond transparent, texte primary
// - Loading state avec CircularProgressIndicator
// - Animation scale on press (0.95)
// - Padding: 16 vertical, 24 horizontal
// - BorderRadius: radiusLarge
```

#### app_card.dart

```dart
// Widget AppCard avec:
// - Paramètres: child, onTap (optionnel), padding
// - Fond: surface
// - BorderRadius: radiusMedium
// - Si onTap: InkWell avec splash
// - Padding par défaut: lg
```

#### app_scaffold.dart

```dart
// Widget AppScaffold avec:
// - Paramètres: body, title (optionnel), showBackButton, actions
// - SafeArea automatique
// - AppBar optionnel si title fourni
// - Background: AppColors.background
```

#### storage_provider.dart

```dart
// Provider Riverpod pour accéder aux boxes Hive
// - routineBox: Box<RoutineModel>
// - scoresBox: Box<ScoreModel>
// - settingsBox: Box<SettingsModel>
```

### 5.4 Critères de validation M1

- [ ] L'app se lance sans erreur
- [ ] Le thème dark s'applique correctement
- [ ] La navigation fonctionne entre les routes
- [ ] Les widgets AppButton, AppCard, AppScaffold fonctionnent
- [ ] Hive est initialisé correctement

---

## 6. MODULE M2 — ONBOARDING

### 6.1 Objectif

Guider le nouvel utilisateur à travers 4 écrans pour configurer sa première routine.

### 6.2 Écrans

| Écran | Contenu | Interaction |
|-------|---------|-------------|
| **1. Welcome** | Titre + illustration + texte accroche | Bouton "Commencer" |
| **2. Wake Time** | "À quelle heure te réveilles-tu ?" | Time picker (scroll wheel) |
| **3. Duration** | "Combien de temps pour ta routine ?" | 4 choix: 15/30/45/60 min |
| **4. Goals** | "Quels sont tes objectifs ?" | Multi-select: Énergie/Focus/Calme/Forme/Productivité |

### 6.3 Fichiers à créer

```
lib/features/onboarding/
├── data/
│   └── onboarding_repository.dart
├── domain/
│   └── onboarding_state.dart
└── presentation/
    ├── screens/
    │   └── onboarding_screen.dart
    ├── widgets/
    │   ├── onboarding_page.dart
    │   ├── time_picker_wheel.dart
    │   ├── duration_selector.dart
    │   └── goals_selector.dart
    └── onboarding_controller.dart
```

### 6.4 Spécifications détaillées

#### onboarding_state.dart

```dart
@immutable
class OnboardingState {
  final int currentPage; // 0-3
  final TimeOfDay? wakeTime;
  final int? routineDurationMinutes; // 15, 30, 45, 60
  final List<String> selectedGoals;
  final bool isCompleted;
  
  // Constructor avec valeurs par défaut
  // copyWith method
}
```

#### onboarding_controller.dart

```dart
// StateNotifier<OnboardingState>
// Méthodes:
// - nextPage()
// - previousPage()
// - setWakeTime(TimeOfDay)
// - setDuration(int minutes)
// - toggleGoal(String goal)
// - completeOnboarding() -> sauvegarde en local, navigue vers Home
```

#### onboarding_screen.dart

```dart
// PageView avec 4 pages
// Indicateurs de progression en haut (dots)
// Bouton "Suivant" / "Terminer" en bas
// Animation de transition entre pages
// Gère le back button pour revenir à la page précédente
```

#### Écran 1 — Welcome

```
┌─────────────────────────────┐
│                             │
│         🌅 (icon)           │
│                             │
│   Morning Routine Builder   │
│                             │
│   Construis ta matinée      │
│   parfaite, bloc par bloc   │
│                             │
│                             │
│      [ Commencer ]          │
│                             │
│          • ○ ○ ○            │
└─────────────────────────────┘
```

#### Écran 2 — Wake Time

```
┌─────────────────────────────┐
│       ← (back)              │
│                             │
│   À quelle heure            │
│   te réveilles-tu ?         │
│                             │
│      ┌───────────┐          │
│      │    05     │          │
│      │  → 06 ←   │          │
│      │    07     │          │
│      └───────────┘          │
│            :                │
│      ┌───────────┐          │
│      │    00     │          │
│      │  → 30 ←   │          │
│      │    45     │          │
│      └───────────┘          │
│                             │
│        [ Suivant ]          │
│          ● • ○ ○            │
└─────────────────────────────┘
```

#### Écran 3 — Duration

```
┌─────────────────────────────┐
│       ← (back)              │
│                             │
│   Combien de temps          │
│   pour ta routine ?         │
│                             │
│   ┌─────────┐ ┌─────────┐   │
│   │  15min  │ │  30min  │   │
│   │  Express│ │ Standard│   │
│   └─────────┘ └─────────┘   │
│                             │
│   ┌─────────┐ ┌─────────┐   │
│   │  45min  │ │  60min  │   │
│   │Complète │ │ Warrior │   │
│   └─────────┘ └─────────┘   │
│                             │
│        [ Suivant ]          │
│          ● ● • ○            │
└─────────────────────────────┘
```

#### Écran 4 — Goals

```
┌─────────────────────────────┐
│       ← (back)              │
│                             │
│   Quels sont tes            │
│   objectifs ?               │
│   (choisis-en plusieurs)    │
│                             │
│   ┌─────────────────────┐   │
│   │ ⚡ Énergie          │   │
│   └─────────────────────┘   │
│   ┌─────────────────────┐   │
│   │ 🎯 Focus            │   │
│   └─────────────────────┘   │
│   ┌─────────────────────┐   │
│   │ 🧘 Calme            │   │
│   └─────────────────────┘   │
│   ┌─────────────────────┐   │
│   │ 💪 Forme            │   │
│   └─────────────────────┘   │
│   ┌─────────────────────┐   │
│   │ 📈 Productivité     │   │
│   └─────────────────────┘   │
│                             │
│        [ Terminer ]         │
│          ● ● ● •            │
└─────────────────────────────┘
```

### 6.5 Comportements

- Les chips de goals changent de couleur quand sélectionnés (primary)
- Le bouton "Terminer" est disabled si aucun goal sélectionné
- À la fin, sauvegarder `isOnboardingCompleted = true` dans Hive
- Naviguer vers HomeScreen

### 6.6 Critères de validation M2

- [ ] Les 4 écrans s'affichent correctement
- [ ] Le time picker fonctionne
- [ ] Les sélecteurs de durée et goals fonctionnent
- [ ] Les données sont sauvegardées localement
- [ ] La navigation vers Home fonctionne après completion

---

## 7. MODULE M3 — ROUTINE BUILDER

### 7.1 Objectif

Permettre à l'utilisateur de créer/modifier sa routine en ajoutant des blocs.

### 7.2 Blocs prédéfinis (MVP)

| ID | Nom | Icône | Durée par défaut |
|----|-----|-------|------------------|
| `water` | Verre d'eau | 💧 | 2 min |
| `meditation` | Méditation | 🧘 | 10 min |
| `journaling` | Journaling | 📝 | 5 min |
| `gratitude` | Gratitude | 🙏 | 3 min |
| `stretching` | Étirements | 🤸 | 10 min |
| `exercise` | Sport | 💪 | 20 min |
| `cold_shower` | Douche froide | 🧊 | 3 min |
| `skincare` | Skincare | ✨ | 5 min |
| `breakfast` | Petit-déjeuner | 🍳 | 15 min |
| `reading` | Lecture | 📚 | 15 min |
| `affirmations` | Affirmations | 💬 | 3 min |
| `breathing` | Respiration | 🌬️ | 5 min |
| `visualization` | Visualisation | 🎯 | 5 min |
| `walk` | Marche | 🚶 | 15 min |
| `planning` | Planning | 📋 | 5 min |

### 7.3 Fichiers à créer

```
lib/features/routine_builder/
├── data/
│   ├── routine_repository.dart
│   └── blocks_repository.dart
├── domain/
│   ├── routine_model.dart
│   └── block_model.dart
└── presentation/
    ├── screens/
    │   ├── routine_builder_screen.dart
    │   └── block_selector_screen.dart
    ├── widgets/
    │   ├── routine_block_card.dart
    │   ├── block_duration_picker.dart
    │   └── empty_routine_placeholder.dart
    └── routine_builder_controller.dart
```

### 7.4 Modèles de données

#### block_model.dart

```dart
@HiveType(typeId: 0)
class BlockModel {
  @HiveField(0)
  final String id; // UUID
  
  @HiveField(1)
  final String templateId; // ex: "meditation"
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String emoji;
  
  @HiveField(4)
  final int durationMinutes;
  
  @HiveField(5)
  final int order; // position dans la routine
  
  // Constructor, copyWith, toJson, fromJson
}
```

#### routine_model.dart

```dart
@HiveType(typeId: 1)
class RoutineModel {
  @HiveField(0)
  final String id; // UUID
  
  @HiveField(1)
  final String name; // "Ma routine du matin"
  
  @HiveField(2)
  final TimeOfDay wakeTime;
  
  @HiveField(3)
  final List<BlockModel> blocks;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime updatedAt;
  
  // Getters calculés:
  int get totalDurationMinutes => blocks.fold(0, (sum, b) => sum + b.durationMinutes);
  TimeOfDay get endTime => // wakeTime + totalDuration
  
  // Constructor, copyWith
}
```

### 7.5 Écrans

#### routine_builder_screen.dart

```
┌─────────────────────────────┐
│  ←    Ma Routine    ✓(save)│
├─────────────────────────────┤
│                             │
│  Réveil: 06:00              │
│  Durée totale: 45 min       │
│  Fin estimée: 06:45         │
│                             │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐    │
│  │ ≡ 💧 Verre d'eau    │ ✕  │
│  │      2 min          │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ ≡ 🧘 Méditation     │ ✕  │
│  │      10 min   [+-]  │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ ≡ 📝 Journaling     │ ✕  │
│  │      5 min    [+-]  │    │
│  └─────────────────────┘    │
│                             │
│       [ + Ajouter ]         │
│                             │
└─────────────────────────────┘
```

#### block_selector_screen.dart

```
┌─────────────────────────────┐
│  ←    Ajouter un bloc       │
├─────────────────────────────┤
│                             │
│  ┌─────────┐ ┌─────────┐    │
│  │ 💧      │ │ 🧘      │    │
│  │ Eau     │ │Méditer  │    │
│  └─────────┘ └─────────┘    │
│                             │
│  ┌─────────┐ ┌─────────┐    │
│  │ 📝      │ │ 🙏      │    │
│  │Journali.│ │Gratitude│    │
│  └─────────┘ └─────────┘    │
│                             │
│  ┌─────────┐ ┌─────────┐    │
│  │ 🤸      │ │ 💪      │    │
│  │Étirement│ │ Sport   │    │
│  └─────────┘ └─────────┘    │
│                             │
│  ... (grid de tous les      │
│       blocs disponibles)    │
│                             │
└─────────────────────────────┘
```

### 7.6 Comportements

| Action | Comportement |
|--------|--------------|
| **Drag & drop** | Réorganiser les blocs (ReorderableListView) |
| **Tap sur bloc** | Ouvre le duration picker |
| **Bouton ✕** | Supprime le bloc (avec confirmation) |
| **Bouton +** | Navigue vers block_selector_screen |
| **Tap sur bloc template** | Ajoute à la routine avec durée par défaut |
| **Bouton ✓ (save)** | Sauvegarde et retourne à Home |
| **Max 10 blocs** | Afficher message si limite atteinte |

### 7.7 Critères de validation M3

- [ ] Liste des blocs s'affiche correctement
- [ ] Drag & drop fonctionne
- [ ] Ajout/suppression de blocs fonctionne
- [ ] Modification de durée fonctionne
- [ ] Calcul automatique de l'heure de fin
- [ ] Sauvegarde dans Hive fonctionne
- [ ] Maximum 10 blocs respecté

---

## 8. MODULE M4 — TIMER ENGINE

### 8.1 Objectif

Guider l'utilisateur à travers sa routine avec des timers en temps réel.

### 8.2 Fichiers à créer

```
lib/features/timer/
├── data/
│   └── timer_repository.dart
├── domain/
│   └── timer_state.dart
└── presentation/
    ├── screens/
    │   ├── timer_screen.dart
    │   └── completion_screen.dart
    ├── widgets/
    │   ├── circular_timer.dart
    │   ├── block_progress_bar.dart
    │   ├── timer_controls.dart
    │   └── current_block_card.dart
    └── timer_controller.dart
```

### 8.3 État du timer

#### timer_state.dart

```dart
enum TimerStatus { idle, running, paused, completed, skipped }

@immutable
class TimerState {
  final RoutineModel routine;
  final int currentBlockIndex;
  final int secondsRemaining;
  final TimerStatus status;
  final List<BlockResult> completedBlocks;
  final DateTime? startedAt;
  
  // Getters:
  BlockModel get currentBlock => routine.blocks[currentBlockIndex];
  bool get isLastBlock => currentBlockIndex == routine.blocks.length - 1;
  double get progress => 1 - (secondsRemaining / (currentBlock.durationMinutes * 60));
  int get totalBlocksCount => routine.blocks.length;
  int get completedBlocksCount => completedBlocks.length;
}

class BlockResult {
  final String blockId;
  final bool completed; // true = done, false = skipped
  final int actualDurationSeconds;
}
```

### 8.4 Écran Timer

```
┌─────────────────────────────┐
│                        ✕    │
│                             │
│      Bloc 2 sur 6           │
│   ━━━━━━━━━━○━━━━━━━━━━━    │
│                             │
│                             │
│        ┌─────────┐          │
│       ╱           ╲         │
│      │    4:32    │         │
│      │            │         │
│       ╲    🧘    ╱          │
│        └─────────┘          │
│                             │
│        Méditation           │
│                             │
│                             │
│   ┌───────────────────┐     │
│   │ Prochain: 📝      │     │
│   │ Journaling (5min) │     │
│   └───────────────────┘     │
│                             │
│   [Skip]    ▶️/⏸️    [Done]  │
│                             │
└─────────────────────────────┘
```

### 8.5 Composants

#### circular_timer.dart

```dart
// CustomPainter qui dessine:
// - Cercle de fond (surfaceLight)
// - Arc de progression (primary, animé)
// - Texte du temps au centre (MM:SS)
// - Emoji du bloc en dessous du temps
// - Animation smooth du stroke
```

#### block_progress_bar.dart

```dart
// Barre horizontale montrant:
// - Tous les blocs en petits points/segments
// - Blocs complétés: secondary (vert)
// - Bloc actuel: primary (violet), pulsing
// - Blocs restants: surfaceLight (gris)
```

#### timer_controls.dart

```dart
// 3 boutons:
// - Skip: saute le bloc (icône forward)
// - Play/Pause: toggle le timer (icône play/pause)
// - Done: termine le bloc en avance (icône check)
```

### 8.6 Comportements

| Événement | Action |
|-----------|--------|
| **Timer atteint 0** | Son/vibration, passe au bloc suivant auto |
| **Bouton Done** | Marque complété, passe au bloc suivant |
| **Bouton Skip** | Marque skipped, passe au bloc suivant |
| **Bouton Pause** | Pause le timer, bouton devient Play |
| **Dernier bloc terminé** | Navigue vers CompletionScreen |
| **Bouton ✕ (close)** | Confirmation "Quitter la routine ?" |
| **App en background** | Timer continue (avec notification) |

### 8.7 Écran Completion

```
┌─────────────────────────────┐
│                             │
│           🎉                │
│                             │
│     Routine terminée !      │
│                             │
│      ┌─────────────┐        │
│      │     85%     │        │
│      │   Score     │        │
│      └─────────────┘        │
│                             │
│   6/7 blocs complétés       │
│   1 bloc skippé             │
│   Durée: 42 min             │
│                             │
│      🔥 5 jours             │
│        de streak            │
│                             │
│                             │
│    [ Retour à l'accueil ]   │
│                             │
└─────────────────────────────┘
```

### 8.8 Critères de validation M4

- [ ] Timer compte à rebours correctement
- [ ] Animation du cercle fluide
- [ ] Transitions entre blocs fonctionnent
- [ ] Boutons Play/Pause/Skip/Done fonctionnent
- [ ] Son/vibration à la fin de chaque bloc
- [ ] Écran completion s'affiche avec bon score
- [ ] Timer continue en background

---

## 9. MODULE M5 — SCORING SYSTEM

### 9.1 Objectif

Calculer et persister les scores quotidiens et le streak.

### 9.2 Fichiers à créer

```
lib/features/scoring/
├── data/
│   └── scoring_repository.dart
├── domain/
│   ├── score_model.dart
│   └── streak_calculator.dart
└── presentation/
    └── widgets/
        ├── score_display.dart
        ├── streak_badge.dart
        └── score_history_chart.dart
```

### 9.3 Modèles

#### score_model.dart

```dart
@HiveType(typeId: 2)
class DailyScore {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime date;
  
  @HiveField(2)
  final int totalBlocks;
  
  @HiveField(3)
  final int completedBlocks;
  
  @HiveField(4)
  final int skippedBlocks;
  
  @HiveField(5)
  final int totalDurationSeconds;
  
  @HiveField(6)
  final int actualDurationSeconds;
  
  // Getters
  int get scorePercent => (completedBlocks / totalBlocks * 100).round();
  bool get isSuccessful => scorePercent >= 80;
}
```

### 9.4 Calcul du Streak

```dart
class StreakCalculator {
  // Règles:
  // - Un jour compte si score >= 80%
  // - Le streak se reset si un jour est manqué
  // - Le streak compte les jours consécutifs
  
  int calculateStreak(List<DailyScore> scores) {
    // Trier par date décroissante
    // Compter les jours consécutifs avec score >= 80%
    // S'arrêter au premier jour sans score ou < 80%
  }
}
```

### 9.5 Repository

```dart
class ScoringRepository {
  // Méthodes:
  Future<void> saveScore(DailyScore score);
  Future<DailyScore?> getScoreForDate(DateTime date);
  Future<List<DailyScore>> getScoresForRange(DateTime start, DateTime end);
  Future<int> getCurrentStreak();
  Future<int> getBestStreak();
  Future<DailyScore?> getTodayScore();
}
```

### 9.6 Critères de validation M5

- [ ] Score calculé correctement après routine
- [ ] Score sauvegardé dans Hive
- [ ] Streak calculé correctement
- [ ] Streak se reset si jour manqué
- [ ] Historique des scores accessible

---

## 10. MODULE M6 — HOME DASHBOARD

### 10.1 Objectif

Écran principal avec résumé de la routine et bouton pour la lancer.

### 10.2 Fichiers à créer

```
lib/features/home/
└── presentation/
    ├── screens/
    │   └── home_screen.dart
    └── widgets/
        ├── routine_preview_card.dart
        ├── today_stats_card.dart
        ├── streak_display.dart
        └── start_routine_button.dart
```

### 10.3 Layout

```
┌─────────────────────────────┐
│  Bonjour ! ☀️          ⚙️   │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │ 🔥 5 jours de streak  │  │
│  │    Meilleur: 12 jours │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ Aujourd'hui           │  │
│  │ ○ Pas encore fait     │  │
│  │ ou                    │  │
│  │ ✓ 85% - Bien joué !   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ Ma Routine (45min)    │  │
│  │                       │  │
│  │ 💧 Eau         2min   │  │
│  │ 🧘 Méditation  10min  │  │
│  │ 📝 Journaling  5min   │  │
│  │ ... +3 autres         │  │
│  │                       │  │
│  │      [✏️ Modifier]    │  │
│  └───────────────────────┘  │
│                             │
│                             │
│  ╔═══════════════════════╗  │
│  ║   ▶️  Commencer       ║  │
│  ╚═══════════════════════╝  │
│                             │
└─────────────────────────────┘
```

### 10.4 États

| État | Affichage |
|------|-----------|
| **Pas de routine** | Message + bouton "Créer ma routine" |
| **Routine existe, pas faite aujourd'hui** | Preview + bouton "Commencer" |
| **Routine faite aujourd'hui** | Score du jour + bouton "Refaire" (grisé) |

### 10.5 Comportements

| Action | Navigation |
|--------|------------|
| Tap ⚙️ | → SettingsScreen |
| Tap "Modifier" | → RoutineBuilderScreen |
| Tap "Commencer" | → TimerScreen |
| Tap "Créer ma routine" | → RoutineBuilderScreen |

### 10.6 Critères de validation M6

- [ ] Affichage correct selon l'état
- [ ] Preview de la routine lisible
- [ ] Streak affiché correctement
- [ ] Score du jour affiché si routine faite
- [ ] Navigation vers les autres écrans fonctionne

---

## 11. MODULE M7 — SETTINGS

### 11.1 Objectif

Permettre à l'utilisateur de modifier ses préférences.

### 11.2 Paramètres MVP

| Paramètre | Type | Description |
|-----------|------|-------------|
| `wakeTime` | TimeOfDay | Heure de réveil |
| `notificationsEnabled` | bool | Activer les rappels |
| `notificationTime` | TimeOfDay | Heure du rappel |
| `soundEnabled` | bool | Sons de fin de bloc |
| `vibrationEnabled` | bool | Vibrations de fin de bloc |

### 11.3 Fichiers à créer

```
lib/features/settings/
├── data/
│   └── settings_repository.dart
├── domain/
│   └── settings_model.dart
└── presentation/
    ├── screens/
    │   └── settings_screen.dart
    └── widgets/
        └── settings_tile.dart
```

### 11.4 Layout

```
┌─────────────────────────────┐
│  ←        Réglages          │
├─────────────────────────────┤
│                             │
│  ROUTINE                    │
│  ┌───────────────────────┐  │
│  │ Heure de réveil       │  │
│  │                 06:00>│  │
│  └───────────────────────┘  │
│                             │
│  NOTIFICATIONS              │
│  ┌───────────────────────┐  │
│  │ Rappel matinal    🔘  │  │
│  ├───────────────────────┤  │
│  │ Heure du rappel       │  │
│  │                 05:55>│  │
│  └───────────────────────┘  │
│                             │
│  SONS & VIBRATIONS          │
│  ┌───────────────────────┐  │
│  │ Sons               🔘 │  │
│  ├───────────────────────┤  │
│  │ Vibrations         🔘 │  │
│  └───────────────────────┘  │
│                             │
│  À PROPOS                   │
│  ┌───────────────────────┐  │
│  │ Version          1.0.0│  │
│  ├───────────────────────┤  │
│  │ Réinitialiser données │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 11.5 Critères de validation M7

- [ ] Tous les paramètres s'affichent
- [ ] Toggle switches fonctionnent
- [ ] Time pickers fonctionnent
- [ ] Paramètres sauvegardés dans Hive
- [ ] Reset des données fonctionne (avec confirmation)

---

## 12. MODULE M8 — NOTIFICATIONS

### 12.1 Objectif

Envoyer des rappels pour la routine matinale.

### 12.2 Fichiers à créer

```
lib/features/notifications/
├── data/
│   └── notification_service.dart
└── domain/
    └── notification_scheduler.dart
```

### 12.3 Types de notifications

| Type | Quand | Message |
|------|-------|---------|
| **Rappel matin** | X minutes avant wakeTime | "🌅 Ta routine t'attend !" |
| **Streak reminder** | Si pas de routine à 20h | "🔥 N'oublie pas ta routine pour garder ton streak !" |

### 12.4 Implémentation

```dart
class NotificationService {
  // Utilise flutter_local_notifications
  
  Future<void> initialize();
  Future<void> requestPermissions();
  Future<void> schedulemorningReminder(TimeOfDay time);
  Future<void> cancelAll();
  Future<void> showInstant(String title, String body);
}
```

### 12.5 Critères de validation M8

- [ ] Permission demandée au bon moment
- [ ] Notification programmée à la bonne heure
- [ ] Notification s'affiche correctement
- [ ] Annulation fonctionne
- [ ] Tap sur notification ouvre l'app

---

## 13. MODÈLES DE DONNÉES

### 13.1 Résumé des modèles Hive

| TypeId | Modèle | Description |
|--------|--------|-------------|
| 0 | BlockModel | Un bloc de routine |
| 1 | RoutineModel | La routine complète |
| 2 | DailyScore | Score d'un jour |
| 3 | SettingsModel | Préférences utilisateur |

### 13.2 Adapters Hive à générer

```dart
// Dans main.dart, avant runApp:
Hive.registerAdapter(BlockModelAdapter());
Hive.registerAdapter(RoutineModelAdapter());
Hive.registerAdapter(DailyScoreAdapter());
Hive.registerAdapter(SettingsModelAdapter());
Hive.registerAdapter(TimeOfDayAdapter()); // Custom adapter
```

### 13.3 TimeOfDayAdapter custom

```dart
class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final typeId = 100;
  
  @override
  TimeOfDay read(BinaryReader reader) {
    return TimeOfDay(hour: reader.readInt(), minute: reader.readInt());
  }
  
  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }
}
```

---

## 14. ASSETS REQUIS

### 14.1 Structure des assets

```
assets/
├── images/
│   └── onboarding_illustration.svg (ou .png)
├── sounds/
│   ├── block_complete.mp3
│   └── routine_complete.mp3
└── fonts/
    └── (Google Fonts chargées dynamiquement)
```

### 14.2 pubspec.yaml assets

```yaml
flutter:
  assets:
    - assets/images/
    - assets/sounds/
```

---

## 15. CRITÈRES DE VALIDATION

### 15.1 Checklist finale

#### Fonctionnel
- [ ] Onboarding complet fonctionne
- [ ] Création de routine fonctionne
- [ ] Timer avec guidage fonctionne
- [ ] Score calculé et affiché correctement
- [ ] Streak fonctionne
- [ ] Settings sauvegardés
- [ ] Notifications programmées

#### UI/UX
- [ ] Thème dark appliqué partout
- [ ] Typographie cohérente
- [ ] Espacements cohérents
- [ ] Animations fluides
- [ ] Pas de overflow / erreurs de layout
- [ ] Responsive sur différentes tailles d'écran

#### Technique
- [ ] Pas de warnings Dart
- [ ] Pas de memory leaks
- [ ] Timer fonctionne en background
- [ ] Données persistées après kill de l'app
- [ ] Build iOS réussit

### 15.2 Tests à effectuer

| Scénario | Attendu |
|----------|---------|
| Premier lancement | Onboarding s'affiche |
| Créer routine 5 blocs | Routine sauvegardée |
| Lancer routine | Timer démarre |
| Compléter tous les blocs | Score 100% |
| Skip 2 blocs sur 5 | Score 60% |
| Faire routine 3 jours de suite | Streak = 3 |
| Manquer un jour | Streak reset à 0 |
| Kill app pendant timer | Timer reprend (ou reset) |
| Changer heure de réveil | Notification reprogrammée |

---

## 🚀 PRÊT À CODER !

Ce document contient tout ce dont l'IA a besoin pour coder le MVP. Procéder module par module dans l'ordre indiqué.

**Rappel**: Toujours se référer à `GUIDELINES.md` pour les conventions de code et `DESIGN_SYSTEM.md` pour les styles.