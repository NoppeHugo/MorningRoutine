# 📏 GUIDELINES — Conventions de Code

> **Version**: 1.0
> **Projet**: Morning Routine Builder
> **Ce document définit les règles OBLIGATOIRES pour tout le code du projet.**

---

## 📋 TABLE DES MATIÈRES

1. [Principes Généraux](#1-principes-généraux)
2. [Architecture & Structure](#2-architecture--structure)
3. [Conventions de Nommage](#3-conventions-de-nommage)
4. [Dart & Flutter Spécifique](#4-dart--flutter-spécifique)
5. [State Management (Riverpod)](#5-state-management-riverpod)
6. [Widgets & UI](#6-widgets--ui)
7. [Navigation](#7-navigation)
8. [Gestion des Données](#8-gestion-des-données)
9. [Gestion des Erreurs](#9-gestion-des-erreurs)
10. [Performance](#10-performance)
11. [Commentaires & Documentation](#11-commentaires--documentation)
12. [Interdictions](#12-interdictions)
13. [Checklist Avant Commit](#13-checklist-avant-commit)

---

## 1. PRINCIPES GÉNÉRAUX

### 1.1 Philosophie

```
✅ Simple > Complexe
✅ Explicite > Implicite
✅ Lisible > Concis
✅ Consistant > Original
✅ Composable > Monolithique
```

### 1.2 Règle d'or

> **Si un fichier dépasse 300 lignes, il doit être découpé.**

### 1.3 Langue

| Élément | Langue |
|---------|--------|
| Code (variables, fonctions, classes) | 🇬🇧 Anglais |
| Commentaires | 🇬🇧 Anglais |
| Strings UI (affichées à l'user) | 🇫🇷 Français |
| Commits | 🇬🇧 Anglais |

---

## 2. ARCHITECTURE & STRUCTURE

### 2.1 Clean Architecture par Feature

Chaque feature suit cette structure :

```
lib/features/[feature_name]/
├── data/                    # Couche données
│   ├── repositories/        # Implémentation des repos
│   └── sources/             # Sources de données (local, remote)
├── domain/                  # Couche métier
│   ├── models/              # Modèles de données
│   ├── entities/            # Entités métier
│   └── usecases/            # Cas d'utilisation (optionnel MVP)
└── presentation/            # Couche UI
    ├── screens/             # Écrans complets
    ├── widgets/             # Widgets spécifiques à la feature
    └── controllers/         # StateNotifiers / Controllers
```

### 2.2 Dossier Core

```
lib/core/
├── theme/           # AppColors, AppTypography, AppSpacing, AppTheme
├── router/          # GoRouter configuration
├── constants/       # Constantes globales
├── utils/           # Fonctions utilitaires
├── extensions/      # Extensions Dart
└── widgets/         # Widgets réutilisables globaux
```

### 2.3 Dossier Shared

```
lib/shared/
├── models/          # Modèles partagés entre features
├── providers/       # Providers globaux (storage, etc.)
└── services/        # Services globaux (notifications, etc.)
```

### 2.4 Règles d'import

```dart
// ✅ ORDRE DES IMPORTS (séparés par ligne vide)

// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Packages externes (ordre alphabétique)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

// 4. Imports du projet (relatifs, ordre alphabétique)
import '../../../core/theme/app_colors.dart';
import '../widgets/my_widget.dart';
import 'another_file.dart';
```

```dart
// ❌ INTERDIT
import 'package:morning_routine/features/...'; // Pas d'imports absolus internes
```

---

## 3. CONVENTIONS DE NOMMAGE

### 3.1 Fichiers

| Type | Convention | Exemple |
|------|------------|---------|
| Fichiers Dart | snake_case | `routine_builder_screen.dart` |
| Widgets | snake_case | `circular_timer.dart` |
| Models | snake_case + `_model` | `routine_model.dart` |
| Controllers | snake_case + `_controller` | `timer_controller.dart` |
| Repositories | snake_case + `_repository` | `scoring_repository.dart` |
| Providers | snake_case + `_provider` | `storage_provider.dart` |

### 3.2 Classes & Types

| Type | Convention | Exemple |
|------|------------|---------|
| Classes | PascalCase | `RoutineBuilderScreen` |
| Widgets | PascalCase | `CircularTimer` |
| Enums | PascalCase | `TimerStatus` |
| Enum values | camelCase | `TimerStatus.running` |
| Typedefs | PascalCase | `JsonMap` |

### 3.3 Variables & Fonctions

| Type | Convention | Exemple |
|------|------------|---------|
| Variables | camelCase | `currentBlockIndex` |
| Constantes | camelCase | `maxBlocks` |
| Fonctions | camelCase | `calculateStreak()` |
| Paramètres | camelCase | `void setWakeTime(TimeOfDay time)` |
| Privés | _camelCase | `_internalState` |
| Providers | camelCase + Provider | `routineProvider` |

### 3.4 Constantes globales

```dart
// ✅ Dans un fichier dédié (app_constants.dart)
abstract class AppConstants {
  static const int maxBlocks = 10;
  static const int minBlockDurationMinutes = 1;
  static const int maxBlockDurationMinutes = 60;
  static const int successScoreThreshold = 80;
}
```

### 3.5 Nommage sémantique

```dart
// ✅ BON - Noms descriptifs
final int completedBlocksCount;
final bool isRoutineCompleted;
final void Function() onBlockCompleted;

// ❌ MAUVAIS - Noms vagues
final int count;
final bool flag;
final void Function() callback;
```

---

## 4. DART & FLUTTER SPÉCIFIQUE

### 4.1 Types explicites

```dart
// ✅ BON - Types explicites pour les déclarations publiques
final List<BlockModel> blocks;
String get formattedTime => '${hour}:${minute}';
Future<void> saveRoutine(RoutineModel routine) async { }

// ✅ OK - var pour les variables locales évidentes
var score = calculateScore();
final items = <String>[];

// ❌ MAUVAIS - dynamic
dynamic getData(); // INTERDIT
```

### 4.2 Null Safety

```dart
// ✅ Utiliser required pour les paramètres obligatoires
const MyWidget({
  required this.title,
  required this.onTap,
  this.subtitle, // Optionnel = nullable
});

// ✅ Utiliser ?? pour les valeurs par défaut
final name = user?.name ?? 'Anonyme';

// ✅ Utiliser ?. pour le chaînage sécurisé
final length = list?.length;

// ❌ INTERDIT - ! sans vérification préalable
final name = user!.name; // Dangereux
```

### 4.3 Collections

```dart
// ✅ Utiliser les collection literals
final list = <String>[];
final map = <String, int>{};
final set = <int>{};

// ✅ Utiliser spread et if/for dans les collections
final combined = [...list1, ...list2];
final filtered = [for (var item in items) if (item.isActive) item];

// ❌ MAUVAIS
final list = List<String>(); // Ancien style
```

### 4.4 Fonctions

```dart
// ✅ Arrow functions pour les one-liners
int get totalMinutes => blocks.fold(0, (sum, b) => sum + b.duration);

// ✅ Fonctions nommées pour la lisibilité
void handleBlockCompleted({
  required String blockId,
  required int actualDuration,
}) { }

// ❌ MAUVAIS - Fonctions trop longues inline
onPressed: () {
  // 20 lignes de code...
}
```

### 4.5 Async/Await

```dart
// ✅ Toujours utiliser async/await (pas .then())
Future<void> loadData() async {
  try {
    final data = await repository.fetchData();
    state = state.copyWith(data: data);
  } catch (e) {
    state = state.copyWith(error: e.toString());
  }
}

// ❌ MAUVAIS - .then() chains
repository.fetchData().then((data) {
  // ...
}).catchError((e) {
  // ...
});
```

---

## 5. STATE MANAGEMENT (RIVERPOD)

### 5.1 Structure des Providers

```dart
// ✅ Un fichier par controller/provider
// fichier: timer_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// State immutable
@immutable
class TimerState {
  final int secondsRemaining;
  final TimerStatus status;
  
  const TimerState({
    this.secondsRemaining = 0,
    this.status = TimerStatus.idle,
  });
  
  TimerState copyWith({
    int? secondsRemaining,
    TimerStatus? status,
  }) {
    return TimerState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      status: status ?? this.status,
    );
  }
}

// Controller
class TimerController extends StateNotifier<TimerState> {
  TimerController() : super(const TimerState());
  
  void start() {
    state = state.copyWith(status: TimerStatus.running);
  }
  
  void tick() {
    state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
  }
}

// Provider
final timerControllerProvider = 
    StateNotifierProvider<TimerController, TimerState>((ref) {
  return TimerController();
});
```

### 5.2 Règles Riverpod

```dart
// ✅ Utiliser ref.watch pour les rebuilds réactifs
final state = ref.watch(timerControllerProvider);

// ✅ Utiliser ref.read pour les actions one-shot
ref.read(timerControllerProvider.notifier).start();

// ✅ Utiliser ref.listen pour les side effects
ref.listen(timerControllerProvider, (prev, next) {
  if (next.status == TimerStatus.completed) {
    context.go('/completion');
  }
});

// ❌ MAUVAIS - watch dans les callbacks
onPressed: () {
  final state = ref.watch(provider); // ERREUR
}
```

### 5.3 Providers avec dépendances

```dart
// ✅ Injecter les dépendances via le provider
final scoringControllerProvider = 
    StateNotifierProvider<ScoringController, ScoringState>((ref) {
  final repository = ref.watch(scoringRepositoryProvider);
  return ScoringController(repository);
});
```

---

## 6. WIDGETS & UI

### 6.1 Structure d'un Widget

```dart
/// Description courte du widget.
class MyWidget extends ConsumerWidget {
  const MyWidget({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // ...
    );
  }
}
```

### 6.2 Règles de Composition

```dart
// ✅ Extraire les widgets complexes en méthodes ou classes séparées
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Column(
    children: [
      _buildHeader(),
      _buildContent(),
      _buildFooter(),
    ],
  );
}

Widget _buildHeader() {
  return Container(/* ... */);
}

// ✅ MIEUX - Widgets séparés pour la réutilisabilité
class MyWidgetHeader extends StatelessWidget { }
```

### 6.3 Utilisation du Design System

```dart
// ✅ TOUJOURS utiliser les tokens du Design System
Container(
  padding: const EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
  ),
  child: Text(
    'Hello',
    style: AppTypography.bodyLarge,
  ),
)

// ❌ INTERDIT - Valeurs en dur
Container(
  padding: const EdgeInsets.all(16), // MAUVAIS
  decoration: BoxDecoration(
    color: Color(0xFF1A1A2E), // MAUVAIS
    borderRadius: BorderRadius.circular(12), // MAUVAIS
  ),
)
```

### 6.4 Responsive Design

```dart
// ✅ Utiliser LayoutBuilder pour le responsive
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return WideLayout();
    }
    return NarrowLayout();
  },
)

// ✅ Utiliser MediaQuery avec parcimonie
final screenHeight = MediaQuery.of(context).size.height;
final bottomPadding = MediaQuery.of(context).padding.bottom;
```

### 6.5 Const Constructors

```dart
// ✅ TOUJOURS utiliser const quand possible
const SizedBox(height: AppSpacing.md);
const Icon(Icons.check);
const EdgeInsets.all(16);

// Le widget doit avoir un const constructor si possible
class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // ✅
}
```

---

## 7. NAVIGATION

### 7.1 Configuration GoRouter

```dart
// ✅ Routes nommées avec constantes
abstract class AppRoutes {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const builder = '/builder';
  static const builderBlocks = '/builder/blocks';
  static const timer = '/timer';
  static const completion = '/completion';
  static const settings = '/settings';
}
```

### 7.2 Navigation

```dart
// ✅ Utiliser context.go pour la navigation
context.go(AppRoutes.timer);

// ✅ Utiliser context.push pour empiler
context.push(AppRoutes.builderBlocks);

// ✅ Utiliser context.pop pour revenir
context.pop();

// ✅ Passer des paramètres via extra
context.go(AppRoutes.completion, extra: score);

// ❌ MAUVAIS - Navigator.push direct
Navigator.push(context, MaterialPageRoute(...));
```

### 7.3 Deep Links & Redirects

```dart
// ✅ Gérer les redirects dans GoRouter
redirect: (context, state) {
  final isLoggedIn = // ...
  final isOnboarding = state.matchedLocation == AppRoutes.onboarding;
  
  if (!isLoggedIn && !isOnboarding) {
    return AppRoutes.onboarding;
  }
  return null;
},
```

---

## 8. GESTION DES DONNÉES

### 8.1 Models Immutables

```dart
@immutable
@HiveType(typeId: 0)
class BlockModel {
  const BlockModel({
    required this.id,
    required this.name,
    required this.durationMinutes,
  });

  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int durationMinutes;

  BlockModel copyWith({
    String? id,
    String? name,
    int? durationMinutes,
  }) {
    return BlockModel(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlockModel &&
        other.id == id &&
        other.name == name &&
        other.durationMinutes == durationMinutes;
  }

  @override
  int get hashCode => Object.hash(id, name, durationMinutes);
}
```

### 8.2 Repositories

```dart
// ✅ Interface abstraite (optionnel pour MVP, mais recommandé)
abstract class RoutineRepository {
  Future<RoutineModel?> getRoutine();
  Future<void> saveRoutine(RoutineModel routine);
  Future<void> deleteRoutine();
}

// ✅ Implémentation concrète
class HiveRoutineRepository implements RoutineRepository {
  HiveRoutineRepository(this._box);
  
  final Box<RoutineModel> _box;
  
  @override
  Future<RoutineModel?> getRoutine() async {
    return _box.get('current_routine');
  }
  
  @override
  Future<void> saveRoutine(RoutineModel routine) async {
    await _box.put('current_routine', routine);
  }
}
```

### 8.3 Hive Best Practices

```dart
// ✅ Ouvrir les boxes une seule fois au démarrage
Future<void> initHive() async {
  await Hive.initFlutter();
  
  // Enregistrer les adapters
  Hive.registerAdapter(BlockModelAdapter());
  Hive.registerAdapter(RoutineModelAdapter());
  
  // Ouvrir les boxes
  await Hive.openBox<RoutineModel>('routines');
  await Hive.openBox<DailyScore>('scores');
}

// ✅ Accéder via provider
final routineBoxProvider = Provider<Box<RoutineModel>>((ref) {
  return Hive.box<RoutineModel>('routines');
});
```

---

## 9. GESTION DES ERREURS

### 9.1 Try-Catch structuré

```dart
// ✅ Toujours catcher les erreurs spécifiques
Future<void> saveData() async {
  try {
    await repository.save(data);
  } on HiveError catch (e) {
    // Erreur de stockage
    _handleStorageError(e);
  } on FormatException catch (e) {
    // Erreur de format
    _handleFormatError(e);
  } catch (e, stackTrace) {
    // Erreur inattendue
    _handleUnexpectedError(e, stackTrace);
  }
}
```

### 9.2 États d'erreur dans le State

```dart
@immutable
class DataState {
  final List<Item> items;
  final bool isLoading;
  final String? errorMessage;
  
  bool get hasError => errorMessage != null;
}
```

### 9.3 Affichage des erreurs

```dart
// ✅ Utiliser des SnackBars pour les erreurs non-bloquantes
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(errorMessage),
    backgroundColor: AppColors.error,
  ),
);

// ✅ Utiliser des dialogs pour les erreurs critiques
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Erreur'),
    content: Text(errorMessage),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('OK'),
      ),
    ],
  ),
);
```

---

## 10. PERFORMANCE

### 10.1 Rebuilds optimisés

```dart
// ✅ Utiliser const widgets
const SizedBox(height: 16);
const Divider();

// ✅ Sélectionner précisément ce qu'on watch
final score = ref.watch(
  timerControllerProvider.select((state) => state.score),
);

// ✅ Utiliser ConsumerWidget plutôt que Consumer partout
class MyScreen extends ConsumerWidget { } // ✅
```

### 10.2 Listes optimisées

```dart
// ✅ Utiliser ListView.builder pour les longues listes
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)

// ✅ Utiliser keys pour les listes réordonnables
ReorderableListView.builder(
  itemCount: blocks.length,
  itemBuilder: (context, index) => BlockCard(
    key: ValueKey(blocks[index].id), // ✅ Important
    block: blocks[index],
  ),
)
```

### 10.3 Images et Assets

```dart
// ✅ Précacher les images importantes
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(AssetImage('assets/images/logo.png'), context);
}

// ✅ Utiliser des tailles appropriées
Image.asset(
  'assets/images/illustration.png',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)
```

---

## 11. COMMENTAIRES & DOCUMENTATION

### 11.1 Quand commenter

```dart
// ✅ Commenter le POURQUOI, pas le QUOI
// We add 5 minutes buffer because users typically need time to wake up
final adjustedTime = wakeTime.add(Duration(minutes: 5));

// ❌ MAUVAIS - Commentaire inutile
// Add 5 to minutes
final adjustedTime = wakeTime.add(Duration(minutes: 5));
```

### 11.2 Documentation des classes publiques

```dart
/// A circular timer widget that displays remaining time.
/// 
/// The timer shows a circular progress indicator with the remaining
/// time displayed in the center. It supports customization of colors
/// and size.
/// 
/// Example:
/// ```dart
/// CircularTimer(
///   secondsRemaining: 120,
///   totalSeconds: 300,
///   onComplete: () => print('Done!'),
/// )
/// ```
class CircularTimer extends StatelessWidget {
  /// Creates a circular timer.
  /// 
  /// [secondsRemaining] must be less than or equal to [totalSeconds].
  const CircularTimer({
    super.key,
    required this.secondsRemaining,
    required this.totalSeconds,
    this.onComplete,
  }) : assert(secondsRemaining <= totalSeconds);
  
  /// The number of seconds remaining.
  final int secondsRemaining;
  
  /// The total duration in seconds.
  final int totalSeconds;
  
  /// Called when the timer reaches zero.
  final VoidCallback? onComplete;
}
```

### 11.3 TODOs

```dart
// ✅ Format des TODOs
// TODO(username): Description du travail à faire [#issue-number]
// TODO: Implement sound playback when block completes [#42]

// ❌ MAUVAIS
// TODO fix this
// todo - add feature
```

---

## 12. INTERDICTIONS

### 12.1 Code interdit

```dart
// ❌ JAMAIS de print() en production
print('Debug: $value'); // INTERDIT

// ❌ JAMAIS de ! sans vérification
final name = user!.name; // DANGEREUX

// ❌ JAMAIS de dynamic sans raison valable
dynamic getData(); // INTERDIT

// ❌ JAMAIS de setState() dans un projet Riverpod
setState(() { }); // INTERDIT (utiliser les providers)

// ❌ JAMAIS de GlobalKey sauf cas très spécifique
final GlobalKey key = GlobalKey(); // ÉVITER

// ❌ JAMAIS de couleurs/tailles en dur
Color(0xFF123456) // UTILISER AppColors
EdgeInsets.all(16) // UTILISER AppSpacing

// ❌ JAMAIS de logique métier dans les widgets
onPressed: () {
  // 50 lignes de logique... // INTERDIT
}

// ❌ JAMAIS de widgets de plus de 200 lignes
// Extraire en sous-widgets
```

### 12.2 Patterns interdits

```dart
// ❌ JAMAIS de FutureBuilder/StreamBuilder avec Riverpod
FutureBuilder( // UTILISER AsyncValue
  future: getData(),
  builder: ...,
)

// ❌ JAMAIS de Provider (package provider) avec Riverpod
// Utiliser uniquement Riverpod

// ❌ JAMAIS d'imports relatifs qui remontent trop
import '../../../../core/theme/colors.dart'; // MAX 3 niveaux
```

---

## 13. CHECKLIST AVANT COMMIT

### 13.1 Checklist Code

- [ ] Pas de `print()` statements
- [ ] Pas de `TODO` non documenté
- [ ] Pas de code commenté
- [ ] Pas de valeurs en dur (utiliser Design System)
- [ ] Types explicites sur les déclarations publiques
- [ ] `const` utilisé partout où possible
- [ ] Imports organisés et sans doublons
- [ ] Fichiers < 300 lignes
- [ ] Nommage conforme aux conventions

### 13.2 Checklist Flutter

- [ ] Pas de warnings dans `flutter analyze`
- [ ] Pas de overflow visuels
- [ ] Fonctionne sur différentes tailles d'écran
- [ ] Animations fluides (60fps)
- [ ] Pas de jank visible

### 13.3 Commande de vérification

```bash
# Lancer avant chaque commit
flutter analyze
flutter test
```

---

## 🎯 RÉSUMÉ

> **En cas de doute, toujours privilégier :**
> 1. La lisibilité
> 2. La consistance avec le reste du code
> 3. La simplicité
> 
> **Référence :** Ce document + `DESIGN_SYSTEM.md` + `MVP.md`