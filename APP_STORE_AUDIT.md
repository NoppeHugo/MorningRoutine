# Audit App Store - Morning Routine
*Analyse du 29 mars 2026*

---

## TL;DR

L'app a une **bonne base architecturale et un design solide**, mais elle est **non compilable en l'etat** (3 fichiers critiques manquants) et **non monetisee**. Avec 2-3 semaines de travail cible, elle peut etre prete pour l'App Store.

**Etat global : 30% pret pour la soumission**

---

## 1. Ce que fait l'app

Application Flutter de **construction et suivi de routine matinale** :
- Creation de routines personnalisees avec des blocs de taches
- Timer pas-a-pas pour executer la routine
- Systeme de streaks/scores pour la gamification
- Notifications locales (rappels)
- Onboarding en 4 etapes
- Persistence locale via Hive (aucun compte requis, aucun serveur)

**Langue UI** : Francais
**Plateformes cibles** : iOS, Android (+ Web, macOS, Windows, Linux supportes par Flutter)

---

## 2. Stack technique

| Composant | Technologie |
|-----------|-------------|
| Framework | Flutter |
| State Management | Riverpod |
| Navigation | GoRouter |
| Base de donnees | Hive (local, offline-first) |
| Notifications | flutter_local_notifications |
| UI/Icons | Lucide Icons + Google Fonts (Inter) |
| Animations | flutter_animate |

Architecture **Clean Architecture** par feature — bien structuree.

---

## 3. Analyse du code : ce qui fonctionne

### Onboarding - PRESENT et bien fait
- Flux en 4 etapes : Accueil > Heure de reveil > Duree routine > Objectifs
- Indicateur de progression anime
- Navigation avant/arriere
- Sauvegarde en Hive a la completion
- Redirection automatique vers l'accueil

### Features implementees
- Routine builder (creation de blocs personnalises)
- Timer pas-a-pas avec completion par bloc
- Scoring et streaks (gamification)
- Notifications locales
- Settings (heure de reveil, notifs, son, vibration)
- Design system complet (couleurs, typographie, espacement)
- Icones app iOS/Android toutes les tailles presentes
- Dark theme

---

## 4. Problemes critiques (bloquants - app ne compile pas)

### CRITIQUE 1 : `pubspec.yaml` manquant
Seul le `pubspec.lock` existe. Sans `pubspec.yaml`, Flutter ne peut pas resoudre les dependances. **L'app ne peut pas etre buildee.**

### CRITIQUE 2 : `/lib/core/router/app_router.dart` manquant
Referenced dans `app.dart` et tous les ecrans. Doit definir `appRouterProvider` et la classe `AppRoutes`.

### CRITIQUE 3 : `/lib/core/constants/app_constants.dart` manquant
Referenced dans `main.dart`, les repositories, les widgets. Doit definir les noms des boites Hive, les listes de durees et d'objectifs.

**Ces 3 fichiers doivent etre crees avant tout le reste.**

---

## 5. Problemes de code (non-bloquants)

| Probleme | Severite | Fichier concerne |
|----------|----------|-----------------|
| Catch vides (`catch (_) {}`) | Moyen | `completion_screen.dart` |
| Pas de gestion d'erreur dans les repositories | Moyen | `onboarding_repository`, `settings_repository`, `scoring_repository` |
| Constantes hardcodees dans les widgets | Faible | `duration_selector`, `goals_selector` |
| `dynamic state` dans l'onboarding screen | Faible | `onboarding_screen.dart` |
| Aucun test (dossier `test/` vide) | Moyen | Global |

---

## 6. Ce qui manque pour l'App Store

### OBLIGATOIRE (Apple rejettera sans ca)

| Element | Statut | Priorite |
|---------|--------|----------|
| App compilable (3 fichiers manquants) | MANQUANT | CRITIQUE |
| Bouton "Restaurer les achats" | MANQUANT | CRITIQUE si IAP |
| Politique de confidentialite (URL accessible in-app) | MANQUANT | BLOQUANT |
| App Privacy Labels dans App Store Connect | A faire | BLOQUANT |
| Usage descriptions dans Info.plist (notifs, etc.) | A verifier | BLOQUANT |
| Screenshots App Store qui correspondent a l'app reelle | A faire | BLOQUANT |

### IMPORTANT (rejet probable ou mauvaise note)

| Element | Statut | Notes |
|---------|--------|-------|
| Monetisation (IAP / Abonnement) | MANQUANT | 0 revenus sans ca |
| Analytics (Firebase ou equivalent) | MANQUANT | Aveugle en prod |
| Crash reporting (Crashlytics) | MANQUANT | Bugs invisibles |
| Widget iOS (Home Screen) | MANQUANT | Attendu dans cette categorie |
| Conditions d'utilisation | MANQUANT | Recommande |

### NICE TO HAVE (differenciateurs)

| Element | Notes |
|---------|-------|
| Apple Watch complication | Top apps l'ont |
| HealthKit integration | Apple pousse ca |
| iCloud sync | Retention elevee |
| Streak freeze / grace days | Reduit le churn |
| Export CSV | Demande des power users |
| Siri Shortcuts | Ecosystem Apple |

---

## 7. Monetisation : ce qui marche dans cette categorie

### Modele gagnant : Freemium + Abonnement annuel + Achat definitif

**Benchmark de reference : HabitKit**
- 1 developpeur, Flutter, donnees locales (pas de compte)
- Meme positioning que votre app
- **30 000$/mois de revenus**
- Classement top-5 "habit tracker" sur l'App Store US

### Structure recommandee

| Tier | Prix | Contenu |
|------|------|---------|
| Gratuit | 0€ | 2-3 routines max, pas d'historique avance |
| Mensuel | 4,99€/mois | Tout debloque |
| Annuel | 24,99€/an | Tout debloque — mettre en avant |
| A vie | 49,99€ | Tout debloque pour toujours |

**Essai gratuit : 7 jours** — multiplie les conversions par 2-3x vs paywall dur.

**Timing ideal : sortie ou mise a jour en decembre** — janvier est le pic de revenus pour les apps de routine/habitudes (resolutions du Nouvel An).

### Implementation recommandee : RevenueCat
- Cross-platform (iOS + Android)
- Gere la validation des recuts Apple/Google
- Dashboard analytics
- Flutter SDK disponible

---

## 8. Comparaison avec le marche

### Forces par rapport a la concurrence

| Avantage | Valeur |
|----------|--------|
| Offline-first (Hive, pas de compte) | Fort differenciateur — HabitKit en a fait son argument marketing |
| Timer integre pas-a-pas | Presente dans Routinery (5M users), validee par le marche |
| Design system coherent | Qualite visuelle superieure a beaucoup d'apps indie |
| Gamification (streaks + scoring) | Retention prouvee |
| Onboarding en 4 etapes | Reduit le churn initial |

### Faiblesses vs. la concurrence

| Faiblesse | Concurrent qui le fait bien |
|-----------|------------------------------|
| Pas de widget iOS | Productive, Streaks |
| Pas d'analytics utilisateur | Habitify |
| Pas de gestion de streak "compassionnelle" (freeze) | Habitica, Streaks |
| Pas de vue calendrier/historique visuelle | HabitKit (grille style GitHub) |
| Pas de partage de progression (social) | Habitica |
| Seulement en francais | Tous les concurrents top |

---

## 9. Problemes frequents des utilisateurs dans cette categorie (a eviter)

1. **Paywalls agressifs** — les utilisateurs detestent que des features passent du gratuit au payant dans une mise a jour
2. **Timer stressant** — donner une option pour desactiver le compte a rebours
3. **Reset brutal des streaks** — implementer une "grace period" ou "streak freeze"
4. **Problemes de facturation** — toujours diriger vers les settings Apple ID pour gerer l'abo
5. **Bugs sur appareils specifiques** — tester sur hardware reel, pas juste simulateur
6. **Dark mode qui ne persiste pas** — verifier la persistance des preferences

---

## 10. Checklist avant soumission App Store

### Phase 1 — Faire compiler l'app (URGENT)
- [ ] Recreer `pubspec.yaml` avec toutes les dependances
- [ ] Creer `/lib/core/constants/app_constants.dart`
- [ ] Creer `/lib/core/router/app_router.dart`
- [ ] Verifier : `flutter pub get && flutter analyze`
- [ ] Tester sur iOS simulator et Android emulateur

### Phase 2 — Monetisation
- [ ] Integrer RevenueCat (Flutter SDK)
- [ ] Definir les produits IAP dans App Store Connect
- [ ] Implementer le paywall (ecran premium)
- [ ] Ajouter le bouton "Restaurer les achats" dans Settings
- [ ] Tester le flow achat/restauration en sandbox

### Phase 3 — Legal & Privacy (OBLIGATOIRE)
- [ ] Rediger une politique de confidentialite (peut utiliser un generateur)
- [ ] Heberger la politique de confidentialite (URL publique)
- [ ] Ajouter le lien vers la politique dans Settings de l'app
- [ ] Remplir App Privacy Labels dans App Store Connect

### Phase 4 — Qualite & Monitoring
- [ ] Integrer Firebase Crashlytics
- [ ] Integrer Firebase Analytics (ou Mixpanel)
- [ ] Corriger les catch vides dans completion_screen.dart
- [ ] Ajouter gestion d'erreur dans les repositories

### Phase 5 — App Store
- [ ] Preparer screenshots (iPhone 6.7", 6.1", iPad si applicable)
- [ ] Rediger description App Store (francais + anglais recommande)
- [ ] Definir keywords ASO ("morning routine", "routine matinale", "habitudes")
- [ ] Tester sur TestFlight (version beta)
- [ ] Soumettre a Apple Review

---

## 11. Estimation effort

| Phase | Effort estime | Impact |
|-------|--------------|--------|
| Phase 1 (compilation) | 1-2 jours | Prerequis absolu |
| Phase 2 (monetisation) | 3-5 jours | Revenus |
| Phase 3 (legal) | 1 jour | Requis Apple |
| Phase 4 (qualite) | 2-3 jours | Stabilite prod |
| Phase 5 (App Store) | 1-2 jours | Soumission |
| **Total** | **~2 semaines** | **Pret a soumettre** |

---

## 12. Verdict final

L'app **a du potentiel reel**. Le marche est prouve (HabitKit = 30K$/mois avec le meme concept), l'architecture est solide, et l'onboarding est deja implemente. Les blockers sont surmontables.

**Ce n'est pas un probleme de concept — c'est un probleme d'execution finale.**

La priorite absolue est de faire compiler l'app, puis d'implementer la monetisation avant de soumettre. Sans paiement, c'est du travail gratuit.

---

*Document genere automatiquement apres analyse du code source et comparaison avec 20+ ressources marche (mars 2026).*
