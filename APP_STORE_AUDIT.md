# APP STORE AUDIT — Morning Routine Builder

> Dernière mise à jour : Mars 2026
> Statut actuel : **En cours de préparation**

---

## RÉSUMÉ EXÉCUTIF

| Critère | Statut | Priorité |
|---------|--------|----------|
| Compilation | ✅ Corrigé | P0 |
| RevenueCat + Paywall | ✅ Intégré | P0 |
| Politique de confidentialité | ✅ Créée | P1 |
| Privacy Labels (App Store) | ⚠️ À remplir | P1 |
| Firebase Crashlytics | ❌ À faire | P2 |
| Screenshots App Store | ❌ À faire | P2 |
| Privacy Manifest (iOS 17+) | ❌ À faire | P1 |
| Info.plist Notifications | ✅ OK | P0 |

---

## 1. COMPILATION — PROBLÈMES CORRIGÉS

### 1.1 `IOSFlutterLocalNotificationsPlugin` → `DarwinFlutterLocalNotificationsPlugin`
- **Fichier** : `lib/features/notifications/data/notification_service.dart`
- **Cause** : Supprimé dans `flutter_local_notifications` v14+
- **Fix** : Renommé en `DarwinFlutterLocalNotificationsPlugin` ✅

### 1.2 Dossiers `assets/` manquants
- **Fichiers** : `assets/images/` et `assets/sounds/` absents
- **Cause** : Référencés dans `pubspec.yaml` mais non créés
- **Fix** : Dossiers créés avec `.gitkeep` ✅

### 1.3 Adapters Hive non enregistrés
- **Fichier** : `lib/main.dart`
- **Cause** : `BlockModelAdapter` et `RoutineModelAdapter` générés mais pas enregistrés
- **Fix** : Ajoutés dans `main.dart` ✅
  *(Note : Les repos utilisent JSON manuel, donc non bloquant, mais bonne pratique)*

---

## 2. MONÉTISATION — REVENUECAT PAYWALL

### 2.1 Ce qui a été implémenté
- `purchases_flutter: ^7.0.0` ajouté dans `pubspec.yaml` ✅
- Initialisation RevenueCat dans `main.dart` ✅
- `PremiumController` avec Riverpod ✅
- `PaywallScreen` avec toggle mensuel/annuel ✅
- Gate paywall dans `RoutineBuilderScreen` (limite 3 blocs gratuits) ✅
- Banner "Passe à Pro" dans les Réglages ✅
- Route `/paywall` ajoutée ✅

### 2.2 Configuration RevenueCat requise (MANUEL)

**Étapes à faire dans la console RevenueCat :**

1. Créer un compte sur [app.revenuecat.com](https://app.revenuecat.com)
2. Créer un nouveau projet "Morning Routine"
3. Ajouter une app iOS → récupérer la **clé API iOS**
4. Remplacer dans `lib/core/constants/app_constants.dart` :
   ```dart
   static const String revenueCatApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';
   // → Remplace par ta vraie clé, ex: 'appl_xxxxxxxxxxxx'
   ```
5. Créer un **Entitlement** nommé `pro`
6. Créer deux **Products** dans App Store Connect :
   - `morning_routine_monthly` ($4.99/mois)
   - `morning_routine_annual` ($29.99/an)
7. Créer une **Offering** dans RevenueCat avec ces 2 packages
8. Associer les products à l'entitlement `pro`

### 2.3 Stratégie de prix recommandée
| Plan | Prix | Équivalent/mois |
|------|------|-----------------|
| Mensuel | 4,99 €/mois | 4,99 € |
| Annuel | 29,99 €/an | **2,50 €** (économie 50%) |

**Recommandation** : Mettre l'annuel en avant (badge "MEILLEURE OFFRE"). Déjà fait dans le code.

---

## 3. POLITIQUE DE CONFIDENTIALITÉ

### 3.1 Ce qui a été créé
- Écran `PrivacyPolicyScreen` dans l'app ✅
- Accessible depuis Réglages → Politique de confidentialité ✅

### 3.2 Ce qui reste à faire (MANUEL)

**App Privacy Labels** (obligatoires sur App Store Connect) :

L'app ne collecte aucune donnée personnelle. Voici quoi déclarer :

| Catégorie | Collecté ? | Tracking ? |
|-----------|-----------|------------|
| Données de contact | NON | NON |
| Identifiants | NON | NON |
| Achats | Via Apple/RevenueCat (anonyme) | NON |
| Données d'utilisation | NON | NON |
| Diagnostics | NON (sans Crashlytics) | NON |

→ Dans App Store Connect : **"No data collected"** pour tout (sauf si tu actives Crashlytics).

**URL Politique de confidentialité** :
- Héberge le texte de l'app sur : `https://tondomaine.com/privacy`
- Ou utilise GitHub Pages gratuitement
- L'URL est **obligatoire** pour les apps avec abonnement

---

## 4. FIREBASE CRASHLYTICS (À FAIRE)

### Pourquoi c'est important
- Détecte les crashs silencieux en production
- Obligatoire pour itérer rapidement post-lancement

### Étapes d'intégration

1. Créer un projet Firebase sur [console.firebase.google.com](https://console.firebase.google.com)
2. Ajouter une app iOS avec le bundle ID de ton app
3. Télécharger `GoogleService-Info.plist` → placer dans `ios/Runner/`
4. Ajouter dans `pubspec.yaml` :
   ```yaml
   firebase_core: ^3.0.0
   firebase_crashlytics: ^4.0.0
   ```
5. Modifier `main.dart` :
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'package:firebase_crashlytics/firebase_crashlytics.dart';

   await Firebase.initializeApp();
   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
   ```
6. Modifier `ios/Podfile` → minimum deployment target iOS 13.0
7. Ajouter dans `ios/Runner/AppDelegate.swift` (si nécessaire)

---

## 5. PRIVACY MANIFEST iOS 17+ (OBLIGATOIRE)

Depuis mai 2024, Apple exige un **Privacy Manifest** pour toute nouvelle soumission.

### Créer `ios/Runner/PrivacyInfo.xcprivacy`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "...">
<plist version="1.0">
<dict>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyTrackingDomains</key>
  <array/>
  <key>NSPrivacyCollectedDataTypes</key>
  <array/>
  <key>NSPrivacyAccessedAPITypes</key>
  <array>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array>
        <string>CA92.1</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
```

Ajoute ce fichier dans Xcode : File → Add Files → `PrivacyInfo.xcprivacy`

---

## 6. INFO.PLIST — CORRECTIONS RESTANTES

### 6.1 Orientation (cohérence)
Le code force le portrait dans `main.dart` mais `Info.plist` déclare aussi landscape.

**Fix** : Dans `ios/Runner/Info.plist`, supprimer ou laisser — Flutter gère par le code. OK tel quel.

### 6.2 Notifications (déjà OK)
`flutter_local_notifications` gère les permissions programmatiquement. Pas besoin d'entrée dans Info.plist pour iOS 14+.

---

## 7. SCREENSHOTS APP STORE

### Tailles requises
| Device | Taille | Obligatoire |
|--------|--------|-------------|
| iPhone 6.7" (iPhone 15 Pro Max) | 1290×2796 | OUI |
| iPhone 6.5" (iPhone 14 Plus) | 1242×2688 | OUI |
| iPhone 5.5" (iPhone 8 Plus) | 1242×2208 | Recommandé |
| iPad Pro 12.9" (si supporté) | 2048×2732 | Si universel |

### Écrans à capturer (5-10 max)
1. **Onboarding** — "Construis ta matinée parfaite"
2. **Home Dashboard** — Streak + score du jour
3. **Routine Builder** — Liste des blocs avec drag & drop
4. **Timer** — Timer circulaire en action (beau visuellement)
5. **Completion** — Score 100% + streak 🔥
6. **Paywall** — "Morning Routine Pro" (si applicable)

### Outil recommandé
- **Rotato** (rotato.app) — génère des mockups iPhone propres
- **AppLaunchpad** — gratuit, simple

---

## 8. METADATA APP STORE

### Nom de l'app
```
Morning Routine Builder
```
*(Max 30 caractères — OK)*

### Sous-titre (max 30 caractères)
```
Ta matinée parfaite, bloc par bloc
```

### Description courte (promotionnelle, 170 caractères)
```
Crée et suis ta routine matinale bloc par bloc. Timer, scores, streaks. Simple, beau, efficace.
```

### Description longue (4000 caractères)
```
Morning Routine Builder transforme tes matins chaotiques en rituels puissants.

🌅 COMMENT ÇA MARCHE
1. Crée ta routine : choisis tes blocs (méditation, sport, lecture...)
2. Configure la durée de chaque bloc
3. Lance le timer le matin — l'app te guide bloc par bloc
4. Reçois ton score et vois ton streak grandir

⚡ FONCTIONNALITÉS
• 15 types de blocs prédéfinis (méditation, sport, journaling, lecture...)
• Timer en temps réel avec guidage visuel
• Score quotidien et streak de jours consécutifs
• Notifications de rappel matinal
• 100% offline — tes données restent sur ton iPhone
• Design sombre élégant

⭐ MORNING ROUTINE PRO
• Jusqu'à 10 blocs dans ta routine
• Historique complet sur 30 jours
• Routines d'experts (bientôt)
• Rappels avancés (bientôt)

🔒 CONFIDENTIALITÉ
Aucune donnée collectée. Tout reste sur ton appareil. Pas de pub, pas de tracking.
```

### Keywords (max 100 caractères)
```
routine,matin,habitude,meditation,productivite,timer,streak,objectifs,bien-etre,sport
```

### Catégories
- Principale : **Health & Fitness**
- Secondaire : **Productivity**

### Âge minimum
- **4+** (aucun contenu sensible)

---

## 9. CHECKLIST FINALE AVANT SOUMISSION

- [ ] Remplacer `YOUR_REVENUECAT_IOS_API_KEY` par la vraie clé
- [ ] Créer les products dans App Store Connect
- [ ] Configurer RevenueCat (entitlement + offering)
- [ ] Héberger la politique de confidentialité en ligne
- [ ] Créer le Privacy Manifest (`PrivacyInfo.xcprivacy`)
- [ ] Configurer Firebase Crashlytics (optionnel mais recommandé)
- [ ] Faire les screenshots avec un vrai iPhone ou simulateur
- [ ] Uploader sur App Store Connect
- [ ] Remplir les App Privacy Labels (no data collected)
- [ ] Ajouter l'URL de la politique de confidentialité
- [ ] Tester l'achat in-app en mode sandbox
- [ ] Test complet sur iPhone réel (pas juste simulateur)
- [ ] Vérifier que `flutter run --release` compile sans erreur
- [ ] Soumettre pour review Apple

---

## 10. ESTIMATION DE REVENU

### Hypothèses (scénario réaliste 6 mois)
| Métrique | Valeur |
|---------|--------|
| Downloads/mois | 500-2000 |
| Taux de conversion free→pro | 2-5% |
| Utilisateurs pro après 6 mois | 150-600 |
| ARPU moyen annuel | ~15€ (mix mensuel/annuel) |
| **MRR estimé à 6 mois** | **~190-750 €/mois** |

### Pour maximiser les conversions
1. Montrer le paywall au bon moment (essai du 4e bloc = frustration → désir)
2. L'annuel doit être l'option par défaut (comme dans le code actuel)
3. Ajouter un essai gratuit de 7 jours (configurable dans RevenueCat, pas de code nécessaire)
4. Répondre rapidement aux reviews App Store
