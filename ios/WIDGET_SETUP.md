# Guide d'installation du Widget iOS — Morning Routine Builder

## Prérequis
- Xcode 14 ou supérieur (pour le support iOS 16 WidgetKit)
- Projet Flutter ouvert dans `ios/Runner.xcworkspace`

---

## Étape 1 — Ouvrir le projet dans Xcode

Ouvrir **`ios/Runner.xcworkspace`** (et non `Runner.xcodeproj`) dans Xcode.

---

## Étape 2 — Créer le Widget Extension Target

1. Dans Xcode : **File → New → Target**
2. Sélectionner **Widget Extension**
3. Remplir les champs :
   - **Product Name** : `MorningRoutineWidget`
   - **Language** : Swift
   - **Interface** : SwiftUI
4. **Ne PAS cocher** "Include Configuration Intent"
5. Cliquer sur **Finish**
6. Xcode demande si activer le scheme : cliquer **Activate**

---

## Étape 3 — Remplacer les fichiers Swift générés

Xcode a créé des fichiers Swift par défaut dans le target `MorningRoutineWidget`.
Il faut les **supprimer** et utiliser les fichiers fournis dans ce projet.

1. Dans le navigateur de fichiers Xcode, ouvrir le groupe `MorningRoutineWidget`
2. Supprimer les fichiers Swift générés automatiquement (Move to Trash)
3. **File → Add Files to "Runner"** (ou clic droit sur le groupe `MorningRoutineWidget`)
4. Sélectionner les deux fichiers suivants depuis le dossier `ios/MorningRoutineWidget/` :
   - `MorningRoutineWidget.swift`
   - `MorningRoutineWidgetBundle.swift`
5. S'assurer que la **cible (Target Membership)** est bien `MorningRoutineWidget` pour les deux fichiers

---

## Étape 4 — Configurer l'App Group (main app)

L'App Group permet à l'app principale et au widget de partager des données via `UserDefaults`.

1. Sélectionner le target **Runner** dans Xcode
2. Onglet **Signing & Capabilities**
3. Cliquer **+ Capability**
4. Chercher et ajouter **App Groups**
5. Dans la section App Groups apparue, cliquer **+**
6. Saisir l'identifiant : `group.com.morningroutine.app`
7. Valider

---

## Étape 5 — Configurer l'App Group (widget target)

Répéter la même opération pour le widget :

1. Sélectionner le target **MorningRoutineWidget**
2. Onglet **Signing & Capabilities**
3. Cliquer **+ Capability**
4. Ajouter **App Groups**
5. Cocher `group.com.morningroutine.app` (doit déjà apparaître dans la liste)

---

## Étape 6 — Vérifier le Deployment Target

1. Sélectionner le target **MorningRoutineWidget**
2. Onglet **General → Deployment Info**
3. Mettre le **iOS Deployment Target** à **16.0** minimum
   (requis pour les familles `accessoryCircular` et `accessoryRectangular`)

---

## Étape 7 — Configurer le home_widget Flutter

Dans `lib/main.dart`, appeler `WidgetService.initialize()` au démarrage de l'app :

```dart
import 'features/widgets/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WidgetService.initialize();
  // ... reste de l'initialisation
  runApp(const App());
}
```

Puis appeler `WidgetService.updateWidget()` après chaque complétion de routine (dans `ScoringController.saveRoutineResult()` par exemple).

---

## Étape 8 — Build & Run

1. Sélectionner le scheme **Runner** (app principale)
2. Choisir un simulateur iPhone (iOS 16+) ou un device physique
3. **Product → Run** (Cmd + R)
4. Une fois l'app lancée, aller sur l'écran d'accueil iOS → appuyer longuement → "+" → rechercher "Morning Routine"

---

## Récapitulatif des fichiers créés

| Fichier | Description |
|---|---|
| `lib/features/widgets/widget_service.dart` | Service Flutter qui écrit dans UserDefaults partagé et déclenche le refresh du widget |
| `ios/MorningRoutineWidget/MorningRoutineWidget.swift` | Code SwiftUI complet du widget (small, medium, lock screen) |
| `ios/MorningRoutineWidget/MorningRoutineWidgetBundle.swift` | Point d'entrée `@main` du Widget Extension |

---

## Tailles de widget supportées

| Famille | Emplacement | Contenu |
|---|---|---|
| `systemSmall` | Écran d'accueil — petit | Flamme + streak + statut |
| `systemMedium` | Écran d'accueil — moyen | Cercle streak + message motivant + score |
| `accessoryCircular` | Écran de verrouillage (iOS 16+) | Chiffre streak + flamme |
| `accessoryRectangular` | Écran de verrouillage (iOS 16+) | Streak ou statut + score |
