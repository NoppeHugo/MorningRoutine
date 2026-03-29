# Progression — Morning Routine Builder

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
