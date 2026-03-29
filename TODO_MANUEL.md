# TODO MANUEL — Actions à faire (hors code)

> Ce fichier liste tout ce que tu dois faire toi-même.
> Le code est prêt. Il ne manque que ces configurations externes.

---

## ÉTAPE 1 — Obtenir un Mac (obligatoire pour iOS)

Tu ne peux pas compiler une app iOS sans macOS + Xcode.

### Options :
| Option | Prix | Délai |
|--------|------|-------|
| **MacInCloud** (macincloud.com) | ~1$/heure | Immédiat |
| **Codemagic** (codemagic.io) | 500 min/mois gratuit | Immédiat |
| **GitHub Actions** + certificat | Gratuit (2000 min/mois) | Setup 1h |
| **Xcode Cloud** (Apple) | 25h gratuit/mois | Setup 30min |

**Recommandation rapide** : Codemagic ou MacInCloud.
Sur Codemagic tu envoies le code, il compile et te renvoie l'IPA à uploader.

---

## ÉTAPE 2 — App Store Connect (compte Apple Developer)

**Prérequis** : Compte Apple Developer à 99$/an sur developer.apple.com

1. Connecte-toi sur [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Clique **"Mes apps"** → **"+"** → **"Nouvelle app"**
3. Remplis :
   - Plateforme : iOS
   - Nom : `Morning Routine Builder`
   - Langue : Français
   - Bundle ID : créer sur developer.apple.com → Identifiers → App IDs
   - SKU : `morning-routine-builder` (identifiant interne, peu importe)
4. Clique **Créer**

---

## ÉTAPE 3 — Créer les produits d'abonnement (App Store Connect)

Dans ton app → **Fonctionnalités** → **Achats intégrés** → **"+"**

### Produit 1 : Mensuel
- Type : **Abonnement auto-renouvelable**
- Nom de référence : `Pro Monthly`
- ID produit : `morning_routine_monthly`
- Durée : **1 mois**
- Prix : **4,99 €** (Tier 5 environ)
- Nom affiché (FR) : `Morning Routine Pro — Mensuel`
- Description (FR) : `Blocs illimités, historique complet et plus encore.`

### Produit 2 : Annuel
- Type : **Abonnement auto-renouvelable**
- Nom de référence : `Pro Annual`
- ID produit : `morning_routine_annual`
- Durée : **1 an**
- Prix : **29,99 €** (Tier 30 environ)
- Nom affiché (FR) : `Morning Routine Pro — Annuel`
- Description (FR) : `Blocs illimités, historique complet. Économise 50%.`

> ⚠️ Les deux doivent être dans le même **groupe d'abonnements**.
> Nomme le groupe : `Morning Routine Pro`

---

## ÉTAPE 4 — Configurer RevenueCat

1. Crée un compte sur [app.revenuecat.com](https://app.revenuecat.com) (gratuit)
2. **New Project** → Nom : `Morning Routine`
3. **Add app** → iOS → entre ton Bundle ID
4. Récupère la **clé API iOS** (commence par `appl_`)
5. **Remplace dans le code** :
   ```
   Fichier : lib/core/constants/app_constants.dart
   Ligne : static const String revenueCatApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';
   Remplace par : static const String revenueCatApiKey = 'appl_XXXXXXXXXXXXXXXX';
   ```

6. Dans RevenueCat → **Entitlements** → **"+"**
   - Identifier : `pro`
   - Description : `Morning Routine Pro`

7. Dans RevenueCat → **Products** → **"+"**
   - Ajoute `morning_routine_monthly`
   - Ajoute `morning_routine_annual`
   - Associe chacun à l'entitlement `pro`

8. Dans RevenueCat → **Offerings** → **"+"**
   - Identifier : `default`
   - Ajoute un Package mensuel et un Package annuel
   - Lie-les aux products créés ci-dessus

9. Dans RevenueCat → **App Store Connect API** → connecte ton compte Apple
   (pour que RevenueCat vérifie les achats)

---

## ÉTAPE 5 — Héberger la politique de confidentialité

Apple **exige** une URL de politique de confidentialité pour toute app avec abonnement.

### Option gratuite : GitHub Pages
1. Crée un repo GitHub : `morning-routine-privacy`
2. Crée un fichier `index.html` avec le texte de la politique
   (copie le texte de l'écran de confidentialité de l'app)
3. Active GitHub Pages dans Settings → Pages
4. URL obtenue : `https://tonpseudo.github.io/morning-routine-privacy`

### Option encore plus simple : notion.site
- Crée une page Notion → rends-la publique → copie l'URL

---

## ÉTAPE 6 — Xcode : Ajouter le Privacy Manifest

À faire sur le Mac (Codemagic ou MacInCloud) :

1. Ouvre le projet dans Xcode : `ios/Runner.xcworkspace`
2. Dans le navigator → clic droit sur `Runner` → **Add Files to "Runner"**
3. Sélectionne `ios/Runner/PrivacyInfo.xcprivacy` (déjà créé dans le code)
4. Assure-toi qu'il est coché pour le target `Runner`

---

## ÉTAPE 7 — Compiler et uploader

Sur le Mac (avec Flutter installé) :

```bash
# Dans le dossier MorningRoutine/
flutter pub get
flutter build ipa --release
```

Si ça échoue sur CocoaPods :
```bash
cd ios
pod install
cd ..
flutter build ipa --release
```

L'IPA se trouve dans : `build/ios/ipa/morning_routine.ipa`

Upload sur App Store Connect :
- Via **Transporter** (app Mac gratuite sur Mac App Store)
- Ou via **Xcode** → Product → Archive → Distribute

---

## ÉTAPE 8 — Screenshots (sur le Mac avec simulateur)

```bash
# Ouvrir le simulateur iPhone 15 Pro Max
open -a Simulator
# Choisir iPhone 15 Pro Max dans Hardware → Device

flutter run
# Naviguer dans l'app et prendre les captures (Cmd+S dans le simulateur)
```

**5 captures minimum :**
1. Onboarding (écran de bienvenue)
2. Home avec streak et score
3. Routine Builder avec des blocs
4. Timer en cours (bloc méditation par exemple)
5. Completion screen avec score 100%

---

## ÉTAPE 9 — App Privacy Labels (App Store Connect)

Dans ton app → **App Privacy** → **Démarrer**

Réponds :
- Collectes-tu des données ? → **Non** (pour presque tout)
- Exception : **Identifiants** → Oui (RevenueCat utilise un ID anonyme d'appareil)
  - Sélectionne : **Identifiant de l'appareil**
  - Usage : **Achats intégrés**
  - Lié à l'identité : **Non**
  - Tracking : **Non**

---

## ÉTAPE 10 — Soumettre pour review

1. App Store Connect → ton app → **"+"** à côté de iOS
2. Sélectionne la version uploadée
3. Remplis :
   - Notes pour l'examinateur : `Vous pouvez tester avec identifiants sandbox RevenueCat`
   - URL de la politique de confidentialité : ton URL hébergée
   - Informations de contact
4. Clique **Soumettre pour review**

Délai habituel : **1-3 jours ouvrables**

---

## RÉSUMÉ DES PRIORITÉS

```
Semaine 1 :
  □ Obtenir accès Mac (Codemagic recommandé)
  □ Créer compte Apple Developer (si pas fait)
  □ Créer app sur App Store Connect
  □ Créer les 2 produits d'abonnement
  □ Configurer RevenueCat + remplacer la clé dans le code

Semaine 2 :
  □ Héberger politique de confidentialité
  □ Compiler l'app (flutter build ipa)
  □ Faire les screenshots
  □ Uploader + remplir les métadonnées
  □ Soumettre pour review Apple
```
