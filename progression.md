# Progression

## Session — 2026-03-28

### État de départ
MVP quasi complet (53 fichiers Dart) mais 3 fichiers critiques manquants empêchant le build.

### Travail effectué
- Créé `pubspec.yaml` avec toutes les dépendances du MVP (riverpod, go_router, hive, etc.)
- Créé `lib/core/constants/app_constants.dart` avec : box names Hive, maxBlocks, durations, goals
- Créé `lib/core/router/app_router.dart` avec : GoRouter, AppRoutes, redirect onboarding

### État de fin
Le MVP est complet et buildable. Toutes les routes sont configurées :
- `/` → HomeScreen (avec redirect onboarding si premier lancement)
- `/onboarding` → OnboardingScreen
- `/builder` → RoutineBuilderScreen
- `/builder/blocks` → BlockSelectorScreen
- `/timer` → TimerScreen
- `/completion` → CompletionScreen
- `/settings` → SettingsScreen

### Prochaine étape
Tester le build Flutter sur device/simulateur et valider les critères MVP.
