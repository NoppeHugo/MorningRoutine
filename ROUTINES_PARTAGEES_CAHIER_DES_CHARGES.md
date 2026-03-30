# Cahier Des Charges - Routines Partagees (Createurs Inspirants)

## 1. Vision produit

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
- Utilisateur avance: veut partir d'une base experte puis adapter.

## 5. Scope fonctionnel

## 5.1 MVP de la section (V1)

### Catalogue routines inspirees
- Liste de routines classees par themes et objectifs.
- Cartes avec:
  - nom de routine
  - createur/source affichee
  - duree totale
  - niveau (debutant/intermediaire/avance)
  - objectif principal
  - badge "Verifiee" ou "Inspiree"

### Fiche detail routine
- Hero avec narrative courte "pour qui / pourquoi".
- Timeline des blocs (ordre + duree + intention).
- Contraintes requises (materiel, lieu, pre-requis).
- Variante courte (15-20 min) si disponible.
- CTA:
  - "Essayer demain" (active pour le lendemain)
  - "Dupliquer et personnaliser"

### Import dans le builder
- Creation d'une nouvelle routine locale a partir du template.
- Mapping sur les blocs existants de l'app (pas de nouveaux moteurs).
- L'utilisateur peut renommer et ajuster avant sauvegarde.

### Activation planifiee
- Compatible avec le systeme ajoute:
  - activer maintenant
  - activer demain

### Recherche et filtres
- Recherche textuelle (nom routine/createur/objectif).
- Filtres: duree, objectif, niveau, categorie.
- Tri: populaire, recent, duree croissante.

## 5.2 Hors scope V1

- UGC libre (utilisateurs qui publient eux-memes).
- Commentaires sociaux.
- Notes audio/video integrees dans les blocs.
- Edition collaborative.
- Licences individuelles par createur (si non signees).

## 5.3 V2+

- Profils createurs verifies.
- Collections officielles (partenariats).
- Challenges communautaires "30 jours routine X".
- Recommandations personalisees (ML simple).

## 6. Exigences de contenu et legal

## 6.1 Statut de contenu

Chaque routine doit avoir un statut:
- inspiree
- verifiee
- officielle

Definition:
- inspiree: reconstruction editoriale a partir de sources publiques.
- verifiee: revue par equipe interne + references tracees.
- officielle: publiee avec accord explicite du createur/ayant droit.

## 6.2 Metadonnees obligatoires

- source_url (ou reference media)
- date de collecte
- auteur interne (curateur)
- niveau de confiance (1 a 5)
- disclaimer associe

## 6.3 Disclaimers obligatoires

- "Routine a but motivationnel, adaptez selon votre sante et contraintes."
- "Cette routine est [inspiree/verifiee/officielle]."

## 7. Data model (propose)

## 7.1 Entites

CreatorProfile
- id
- displayName
- slug
- avatarUrl
- bioShort
- domains[]
- verificationStatus (none/verified/official)

SharedRoutineTemplate
- id
- creatorId
- title
- subtitle
- goal
- level
- totalDurationMinutes
- tags[]
- status (inspired/verified/official)
- sourceRefs[]
- requiredEquipment[]
- blocks[] (templateId + duration + note)
- shortVariantBlocks[]
- language
- locale
- publishedAt
- isPremium

TemplateImportEvent
- id
- templateId
- userRoutineId
- importedAt
- activationMode (now/tomorrow)

## 7.2 Stockage et architecture

V1 recommande:
- Catalogue remote (JSON via API/CDN) pour iteration rapide.
- Cache local Hive pour consultation offline partielle.
- Import cree une RoutineModel locale independante.

## 8. UX/UI detaillee

## 8.1 Navigation

Nouvelle entree dans Home/Builder:
- "Routines inspirees"

Arborescence:
- Catalogue routines inspirees
- Detail routine
- Preview import
- Builder (edition finale)

## 8.2 Parcours principal

1. Ouvrir catalogue.
2. Filtrer "Productivite - 30 min - Debutant".
3. Ouvrir detail "Routine du createur X".
4. Choisir "Essayer demain".
5. Confirmer.
6. L'app affiche "Routine active demain".

## 8.3 Etats ecran

- Empty: aucune routine disponible (fallback templates locaux).
- Loading: skeleton cards.
- Error: retry + fallback local.
- Premium locked: preview partielle + CTA paywall.

## 9. Regles produit

- Une routine importee ne doit jamais ecraser sans confirmation.
- Si activation demain existe deja: demander remplacement.
- Si utilisateur modifie une routine importee: elle devient "personnalisee".
- Les mises a jour du template source n'ecrasent jamais automatiquement la copie utilisateur.

## 10. Moderation et qualite

## 10.1 Pipeline editorial minimal

1. Selection createur et theme.
2. Collecte de sources publiques.
3. Structuration en blocs compatibles app.
4. Relecture qualite (faisabilite + clarte + securite).
5. Publication avec statut.

## 10.2 Check qualite routine

- Duree realiste (pas de bloc absurde).
- Enchainement logique des blocs.
- Pas de recommandation medicale sensible.
- Formulation claire et motivante.

## 11. KPI et analytics

Activation et usage:
- template_view_rate
- template_import_rate
- import_to_first_completion_rate
- tomorrow_activation_rate

Retention et monetisation:
- d7_retention_after_import
- d30_retention_after_import
- premium_conversion_from_templates

Qualite produit:
- edit_rate_after_import
- drop_off_on_detail_screen
- support_reports_per_template

## 12. Architecture technique cible (MorningRoutine)

## 12.1 Structure fichiers proposee

lib/features/shared_routines/
- data/
  - shared_routines_repository.dart
  - creators_repository.dart
  - shared_routines_remote_source.dart
- domain/
  - creator_profile.dart
  - shared_routine_template.dart
- presentation/
  - shared_routines_controller.dart
  - screens/
    - shared_routines_catalog_screen.dart
    - shared_routine_detail_screen.dart
  - widgets/
    - creator_chip.dart
    - routine_template_card.dart
    - template_filters_bar.dart

## 12.2 Integrations internes

- Reutiliser RoutineBuilderController pour import -> creation routine locale.
- Reutiliser activation "activer demain" deja implementee.
- Reutiliser PremiumController pour lock contenu premium.

## 13. Roadmap implementation

## Sprint 1 - Foundations
- Data models template/createur.
- Repository remote + cache local.
- Catalogue simple + detail simple.

## Sprint 2 - Import et activation
- Import vers routine locale.
- CTA activer maintenant / demain.
- Tracking analytics principal.

## Sprint 3 - Premium et qualite
- Locks premium.
- Fallback offline robuste.
- Ajout statuts inspiree/verifiee/officielle.

## 14. Criteres d'acceptation (DoD)

Fonctionnel:
- Un utilisateur peut importer une routine inspiree en moins de 30 secondes.
- L'utilisateur peut planifier son activation pour le lendemain.
- La routine importee est editable sans impacter le template source.

Qualite:
- Tous les templates affichent source + statut + disclaimer.
- 0 crash sur flux catalogue -> detail -> import -> activation.
- Temps de chargement catalogue < 2 s avec cache chaud.

Business:
- Taux d'import >= 20% des vues detail apres 30 jours.
- +10% de completion J+1 sur users ayant importe au moins 1 template.

## 15. Backlog priorise

P0
- Catalogue + detail + import + activation demain.
- Statut et disclaimers.
- Tracking analytics.

P1
- Filtres avances + recherche performante.
- Curations thematiques hebdo.
- Better ranking (popularite + completion).

P2
- Profils createurs enrichis.
- Collections officielles partenariat.
- Recommandation personnalisee.
