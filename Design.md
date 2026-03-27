# 🎨 DESIGN SYSTEM — Morning Routine Builder

> **Version**: 1.0
> **Ce document définit TOUS les éléments visuels du projet.**
> **L'IA DOIT utiliser ces tokens — aucune valeur en dur autorisée.**

---

## 📋 TABLE DES MATIÈRES

1. [Couleurs](#1-couleurs)
2. [Typographie](#2-typographie)
3. [Espacements](#3-espacements)
4. [Bordures & Ombres](#4-bordures--ombres)
5. [Icônes](#5-icônes)
6. [Composants](#6-composants)
7. [Animations](#7-animations)
8. [Layout Patterns](#8-layout-patterns)
9. [Implémentation Flutter](#9-implémentation-flutter)

---

## 1. COULEURS

### 1.1 Palette Principale

| Nom | Hex | Usage |
|-----|-----|-------|
| `primary` | `#6C5CE7` | Boutons principaux, accents, liens |
| `primaryLight` | `#A29BFE` | Hover states, badges, backgrounds légers |
| `primaryDark` | `#5B4BC4` | Pressed states |
| `secondary` | `#00D9A5` | Succès, validations, streaks |
| `secondaryLight` | `#5EFFC1` | Badges succès |

### 1.2 Backgrounds

| Nom | Hex | Usage |
|-----|-----|-------|
| `background` | `#0F0F1A` | Fond principal de l'app |
| `surface` | `#1A1A2E` | Cartes, modales, bottom sheets |
| `surfaceLight` | `#252542` | Inputs, éléments surélevés |
| `surfaceHighlight` | `#2F2F4A` | Hover sur surface |

### 1.3 Texte

| Nom | Hex | Usage |
|-----|-----|-------|
| `textPrimary` | `#FFFFFF` | Titres, texte principal |
| `textSecondary` | `#8E8E9A` | Sous-titres, labels, hints |
| `textTertiary` | `#5E5E6A` | Texte désactivé |
| `textOnPrimary` | `#FFFFFF` | Texte sur boutons primary |
| `textOnSecondary` | `#0F0F1A` | Texte sur boutons secondary |

### 1.4 États & Feedback

| Nom | Hex | Usage |
|-----|-----|-------|
| `error` | `#FF6B6B` | Erreurs, alertes critiques |
| `errorLight` | `#FFA8A8` | Background erreur |
| `warning` | `#FECA57` | Warnings, attention |
| `warningLight` | `#FFE8B8` | Background warning |
| `success` | `#00D9A5` | Succès (= secondary) |
| `info` | `#54A0FF` | Informations |

### 1.5 Couleurs spéciales

| Nom | Hex | Usage |
|-----|-----|-------|
| `streak` | `#FF6B35` | Badge de streak (orange feu) |
| `timerProgress` | `#6C5CE7` | Cercle de progression du timer |
| `timerBackground` | `#252542` | Fond du cercle timer |
| `blockCompleted` | `#00D9A5` | Bloc terminé |
| `blockSkipped` | `#FF6B6B` | Bloc skippé |
| `blockCurrent` | `#6C5CE7` | Bloc en cours |
| `blockPending` | `#3E3E5A` | Bloc à venir |

### 1.6 Gradients

```dart
// Gradient principal (pour backgrounds hero)
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF6C5CE7),
    Color(0xFF8B7CF7),
  ],
)

// Gradient de succès
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF00D9A5),
    Color(0xFF00B894),
  ],
)
```

---

## 2. TYPOGRAPHIE

### 2.1 Font Family

| Usage | Font | Fallback |
|-------|------|----------|
| UI générale | Inter | SF Pro, system |
| Timer / Nombres | Roboto Mono | Menlo, monospace |

### 2.2 Échelle typographique

| Token | Taille | Poids | Line Height | Usage |
|-------|--------|-------|-------------|-------|
| `displayLarge` | 48px | Bold (700) | 1.2 | Splash, hero |
| `displayMedium` | 36px | Bold (700) | 1.2 | Écran completion |
| `headingLarge` | 28px | Bold (700) | 1.3 | Titres de page |
| `headingMedium` | 22px | SemiBold (600) | 1.3 | Titres de section |
| `headingSmall` | 18px | SemiBold (600) | 1.4 | Titres de carte |
| `bodyLarge` | 16px | Regular (400) | 1.5 | Texte principal |
| `bodyMedium` | 14px | Regular (400) | 1.5 | Texte secondaire |
| `bodySmall` | 12px | Regular (400) | 1.5 | Captions, hints |
| `labelLarge` | 16px | Medium (500) | 1.4 | Boutons |
| `labelMedium` | 14px | Medium (500) | 1.4 | Labels, tags |
| `labelSmall` | 12px | Medium (500) | 1.4 | Badges |
| `timer` | 64px | Bold (700) | 1.0 | Timer principal |
| `timerSmall` | 32px | Bold (700) | 1.0 | Timer secondaire |

### 2.3 Couleurs de texte par contexte

| Contexte | Couleur |
|----------|---------|
| Heading sur background | `textPrimary` (#FFFFFF) |
| Body sur background | `textPrimary` (#FFFFFF) |
| Secondary text | `textSecondary` (#8E8E9A) |
| Disabled text | `textTertiary` (#5E5E6A) |
| Text sur primary button | `textOnPrimary` (#FFFFFF) |
| Link text | `primary` (#6C5CE7) |
| Error text | `error` (#FF6B6B) |
| Success text | `success` (#00D9A5) |

---

## 3. ESPACEMENTS

### 3.1 Échelle d'espacement

| Token | Valeur | Usage |
|-------|--------|-------|
| `xxs` | 2px | Micro-ajustements |
| `xs` | 4px | Entre icône et texte |
| `sm` | 8px | Padding interne compact |
| `md` | 16px | Padding standard, gaps |
| `lg` | 24px | Sections, padding de carte |
| `xl` | 32px | Entre sections majeures |
| `xxl` | 48px | Marges de page, hero spacing |
| `xxxl` | 64px | Espacement dramatique |

### 3.2 Padding de composants

| Composant | Padding |
|-----------|---------|
| Bouton | 16px vertical, 24px horizontal |
| Carte | 24px (lg) |
| Input | 16px (md) |
| Chip/Badge | 4px vertical, 12px horizontal |
| Liste item | 16px vertical, 16px horizontal |
| Page | 24px horizontal (lg) |
| Bottom sheet | 24px (lg) |
| Modal | 24px (lg) |

### 3.3 Gaps entre éléments

| Contexte | Gap |
|----------|-----|
| Items dans une liste | 12px |
| Cartes dans une grille | 16px |
| Sections de page | 32px |
| Champs de formulaire | 16px |
| Boutons adjacents | 12px |
| Icône et texte | 8px |

---

## 4. BORDURES & OMBRES

### 4.1 Border Radius

| Token | Valeur | Usage |
|-------|--------|-------|
| `radiusNone` | 0px | Éléments carrés |
| `radiusSmall` | 8px | Badges, chips, inputs |
| `radiusMedium` | 12px | Cartes, boutons |
| `radiusLarge` | 16px | Modales, bottom sheets |
| `radiusXLarge` | 24px | Hero cards |
| `radiusFull` | 9999px | Cercles, pills |

### 4.2 Bordures

| Type | Style |
|------|-------|
| Default | 1px solid `surfaceLight` |
| Focus | 2px solid `primary` |
| Error | 1px solid `error` |
| Success | 1px solid `success` |
| Divider | 1px solid `surfaceLight` |

### 4.3 Ombres (Elevations)

```dart
// Elevation 1 - Cartes légères
BoxShadow(
  color: Color(0x1A000000), // 10% black
  offset: Offset(0, 2),
  blurRadius: 8,
)

// Elevation 2 - Cartes standards
BoxShadow(
  color: Color(0x26000000), // 15% black
  offset: Offset(0, 4),
  blurRadius: 12,
)

// Elevation 3 - Modales, FAB
BoxShadow(
  color: Color(0x33000000), // 20% black
  offset: Offset(0, 8),
  blurRadius: 24,
)

// Glow effect (pour boutons primary)
BoxShadow(
  color: Color(0x406C5CE7), // 25% primary
  offset: Offset(0, 4),
  blurRadius: 16,
)
```

---

## 5. ICÔNES

### 5.1 Bibliothèque

**Utiliser Lucide Icons** (package `lucide_icons`)

### 5.2 Tailles

| Token | Taille | Usage |
|-------|--------|-------|
| `iconXs` | 16px | Dans le texte, badges |
| `iconSm` | 20px | Boutons compacts, inputs |
| `iconMd` | 24px | Standard, listes |
| `iconLg` | 32px | Headers, actions principales |
| `iconXl` | 48px | Hero, empty states |
| `iconXxl` | 64px | Illustrations |

### 5.3 Icônes des blocs

| Block ID | Emoji | Icône Lucide alternative |
|----------|-------|--------------------------|
| `water` | 💧 | `Droplets` |
| `meditation` | 🧘 | `Brain` |
| `journaling` | 📝 | `PenLine` |
| `gratitude` | 🙏 | `Heart` |
| `stretching` | 🤸 | `Sparkles` |
| `exercise` | 💪 | `Dumbbell` |
| `cold_shower` | 🧊 | `Snowflake` |
| `skincare` | ✨ | `Sparkle` |
| `breakfast` | 🍳 | `UtensilsCrossed` |
| `reading` | 📚 | `BookOpen` |
| `affirmations` | 💬 | `MessageCircle` |
| `breathing` | 🌬️ | `Wind` |
| `visualization` | 🎯 | `Target` |
| `walk` | 🚶 | `Footprints` |
| `planning` | 📋 | `ClipboardList` |

### 5.4 Couleurs des icônes

| Contexte | Couleur |
|----------|---------|
| Sur background | `textSecondary` |
| Sur surface (interactive) | `textPrimary` |
| Accent/Action | `primary` |
| Succès | `success` |
| Erreur | `error` |
| Désactivé | `textTertiary` |

---

## 6. COMPOSANTS

### 6.1 Boutons

#### Primary Button

```
┌─────────────────────────────┐
│                             │
│     [ Label du bouton ]     │  ← textOnPrimary
│                             │
└─────────────────────────────┘
        ↑ background: primary
        ↑ borderRadius: radiusMedium
        ↑ padding: 16px 24px
        ↑ shadow: glow effect
```

**États:**
- Default: `primary` background
- Pressed: `primaryDark` background, scale 0.98
- Disabled: `surfaceLight` background, `textTertiary` text
- Loading: CircularProgressIndicator blanc

#### Secondary Button

```
┌─────────────────────────────┐
│                             │
│     [ Label du bouton ]     │  ← primary
│                             │
└─────────────────────────────┘
        ↑ background: transparent
        ↑ border: 1.5px solid primary
        ↑ borderRadius: radiusMedium
```

#### Text Button

```
[ Label du bouton ]  ← primary, no background
```

#### Icon Button

```
    ┌───┐
    │ ⚙ │  ← 40x40px touch target minimum
    └───┘
        ↑ Splash effect on tap
```

### 6.2 Cartes

#### Standard Card

```
┌─────────────────────────────────┐
│                                 │
│  Contenu de la carte            │
│                                 │
│                                 │
└─────────────────────────────────┘
        ↑ background: surface
        ↑ borderRadius: radiusMedium
        ↑ padding: lg (24px)
        ↑ shadow: elevation 1
```

#### Interactive Card

```
┌─────────────────────────────────┐
│                                 │  ← ripple effect on tap
│  Contenu cliquable              │  ← background: surfaceHighlight on hover
│                             >   │  ← chevron optionnel
└─────────────────────────────────┘
```

### 6.3 Inputs

#### Text Field

```
┌─────────────────────────────────┐
│ Label                           │  ← textSecondary, bodySmall
├─────────────────────────────────┤
│                                 │
│ Placeholder ou valeur           │  ← bodyLarge
│                                 │
└─────────────────────────────────┘
        ↑ background: surfaceLight
        ↑ borderRadius: radiusSmall
        ↑ padding: md (16px)
        ↑ border: 1px transparent (default), primary (focus), error (erreur)
```

### 6.4 Chips / Badges

#### Selection Chip

```
Non sélectionné:
┌─────────────┐
│ 🧘 Calme    │  ← textSecondary
└─────────────┘
    ↑ background: surfaceLight
    ↑ border: 1px surfaceLight

Sélectionné:
┌─────────────┐
│ 🧘 Calme ✓  │  ← textOnPrimary
└─────────────┘
    ↑ background: primary
    ↑ border: none
```

#### Badge

```
┌───────┐
│ 5 🔥  │  ← labelSmall, textOnPrimary
└───────┘
    ↑ background: streak (orange)
    ↑ borderRadius: radiusFull
    ↑ padding: xs vertical, sm horizontal
```

### 6.5 Progress Indicators

#### Circular Timer

```
         ╭───────────────╮
       ╱                   ╲
      │                     │
      │      04:32          │  ← timer font
      │        🧘           │  ← emoji du bloc
      │                     │
       ╲                   ╱
         ╰───────────────╯

    ↑ Cercle fond: timerBackground
    ↑ Arc progression: timerProgress (primary)
    ↑ Stroke width: 8px
    ↑ Diamètre: 240px
```

#### Block Progress Bar

```
    ●────●────◉────○────○
    ↑    ↑    ↑    ↑
    completed  current  pending
    (success)  (primary, (surfaceLight)
               pulsing)
```

#### Linear Progress

```
┌════════════════════░░░░░░░░┐
        ↑ filled: primary
        ↑ empty: surfaceLight
        ↑ height: 4px
        ↑ borderRadius: radiusFull
```

### 6.6 Listes

#### List Item

```
┌────────────────────────────────────┐
│ 🧘  Méditation              10min  │
│     Description courte         >   │
└────────────────────────────────────┘
    ↑ padding: md vertical, lg horizontal
    ↑ divider en bas: 1px surfaceLight
```

#### Reorderable Block Card

```
┌────────────────────────────────────┐
│ ≡  🧘  Méditation           10min ✕│
└────────────────────────────────────┘
  ↑  ↑                           ↑
  drag  emoji                  delete
  handle                       button
    ↑ background: surface
    ↑ borderRadius: radiusSmall
    ↑ margin bottom: sm
```

### 6.7 Modales & Overlays

#### Bottom Sheet

```
┌─────────────────────────────────────┐
│                 ═══                 │  ← drag handle
├─────────────────────────────────────┤
│                                     │
│  Titre du bottom sheet              │  ← headingMedium
│                                     │
│  Contenu...                         │
│                                     │
│  [ Action principale ]              │
│                                     │
└─────────────────────────────────────┘
        ↑ background: surface
        ↑ borderRadius: radiusLarge (top only)
        ↑ padding: lg
```

#### Dialog

```
        ┌───────────────────────┐
        │                       │
        │      Titre            │  ← headingSmall
        │                       │
        │  Message du dialog    │  ← bodyMedium
        │                       │
        │  [Annuler]  [Confirmer]│
        │                       │
        └───────────────────────┘
            ↑ background: surface
            ↑ borderRadius: radiusLarge
            ↑ shadow: elevation 3
```

---

## 7. ANIMATIONS

### 7.1 Durées

| Token | Durée | Usage |
|-------|-------|-------|
| `durationFast` | 150ms | Micro-interactions, hovers |
| `durationNormal` | 300ms | Transitions standard |
| `durationSlow` | 500ms | Modales, page transitions |
| `durationVerySlow` | 800ms | Animations dramatiques |

### 7.2 Courbes (Easing)

| Courbe | Valeur | Usage |
|--------|--------|-------|
| `easeOut` | `Curves.easeOut` | Entrées, apparitions |
| `easeIn` | `Curves.easeIn` | Sorties, disparitions |
| `easeInOut` | `Curves.easeInOut` | Transitions bidirectionnelles |
| `spring` | `Curves.elasticOut` | Rebonds, accomplissements |

### 7.3 Animations spécifiques

| Animation | Paramètres |
|-----------|------------|
| **Button press** | Scale 0.95, duration 150ms, easeOut |
| **Card appear** | FadeIn + SlideUp 20px, duration 300ms, staggered 50ms |
| **Page transition** | SlideRight, duration 300ms, easeInOut |
| **Timer circle** | Stroke animation, continuous, linear |
| **Streak fire** | Pulse scale 1.0→1.1→1.0, duration 800ms, repeat |
| **Completion confetti** | Particle system, duration 2000ms |
| **Block complete** | Checkmark draw + scale bounce |

### 7.4 Implémentation Flutter Animate

```dart
// Card apparition avec stagger
ListView.builder(
  itemBuilder: (context, index) => Card()
    .animate(delay: Duration(milliseconds: 50 * index))
    .fadeIn(duration: 300.ms)
    .slideY(begin: 0.1, curve: Curves.easeOut),
)

// Bouton press
GestureDetector(
  onTapDown: (_) => controller.forward(),
  onTapUp: (_) => controller.reverse(),
  child: AnimatedBuilder(
    animation: controller,
    builder: (context, child) => Transform.scale(
      scale: 1.0 - (controller.value * 0.05),
      child: child,
    ),
  ),
)

// Streak badge pulse
Container()
  .animate(onPlay: (c) => c.repeat(reverse: true))
  .scale(begin: 1.0, end: 1.1, duration: 800.ms)
```

---

## 8. LAYOUT PATTERNS

### 8.1 Page Structure

```
┌─────────────────────────────────┐
│         Safe Area Top           │
├─────────────────────────────────┤
│                                 │
│  [←]     Page Title      [⚙️]   │  ← AppBar optionnel
│                                 │
├─────────────────────────────────┤
│                                 │
│                                 │
│         Page Content            │  ← ScrollView généralement
│                                 │
│                                 │
│                                 │
├─────────────────────────────────┤
│                                 │
│      [ Primary Action ]         │  ← Sticky bottom si nécessaire
│                                 │
├─────────────────────────────────┤
│         Safe Area Bottom        │
└─────────────────────────────────┘
```

### 8.2 Marges de page

```dart
// Padding horizontal standard
EdgeInsets.symmetric(horizontal: AppSpacing.lg) // 24px

// Avec safe area
EdgeInsets.only(
  left: AppSpacing.lg,
  right: AppSpacing.lg,
  bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
)
```

### 8.3 Grilles

```dart
// Grille de blocs (2 colonnes)
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: AppSpacing.md, // 16px
    mainAxisSpacing: AppSpacing.md,  // 16px
    childAspectRatio: 1.0,           // Carrés
  ),
)

// Grille de durées (2x2)
GridView.count(
  crossAxisCount: 2,
  crossAxisSpacing: AppSpacing.md,
  mainAxisSpacing: AppSpacing.md,
  childAspectRatio: 1.5,
)
```

---

## 9. IMPLÉMENTATION FLUTTER

### 9.1 Fichier app_colors.dart

```dart
import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color primaryDark = Color(0xFF5B4BC4);
  
  // Secondary
  static const Color secondary = Color(0xFF00D9A5);
  static const Color secondaryLight = Color(0xFF5EFFC1);
  
  // Backgrounds
  static const Color background = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF252542);
  static const Color surfaceHighlight = Color(0xFF2F2F4A);
  
  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E9A);
  static const Color textTertiary = Color(0xFF5E5E6A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF0F0F1A);
  
  // Status
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFFA8A8);
  static const Color warning = Color(0xFFFECA57);
  static const Color warningLight = Color(0xFFFFE8B8);
  static const Color success = Color(0xFF00D9A5);
  static const Color info = Color(0xFF54A0FF);
  
  // Special
  static const Color streak = Color(0xFFFF6B35);
  static const Color timerProgress = Color(0xFF6C5CE7);
  static const Color timerBackground = Color(0xFF252542);
  static const Color blockCompleted = Color(0xFF00D9A5);
  static const Color blockSkipped = Color(0xFFFF6B6B);
  static const Color blockCurrent = Color(0xFF6C5CE7);
  static const Color blockPending = Color(0xFF3E3E5A);
}
```

### 9.2 Fichier app_spacing.dart

```dart
abstract class AppSpacing {
  // Spacing scale
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
  
  // Border radius
  static const double radiusNone = 0;
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;
  static const double radiusFull = 9999;
  
  // Icon sizes
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;
  static const double iconXxl = 64;
}
```

### 9.3 Fichier app_typography.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get headingMedium => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get headingSmall => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get timer => GoogleFonts.robotoMono(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );
  
  static TextStyle get timerSmall => GoogleFonts.robotoMono(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );
}
```

### 9.4 Fichier app_theme.dart

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

abstract class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnSecondary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        elevation: 0,
        textStyle: AppTypography.labelLarge,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.labelLarge,
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      hintStyle: AppTypography.bodyLarge.copyWith(
        color: AppColors.textTertiary,
      ),
    ),
    
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      margin: EdgeInsets.zero,
    ),
    
    dividerTheme: const DividerThemeData(
      color: AppColors.surfaceLight,
      thickness: 1,
      space: 0,
    ),
    
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surface,
      contentTextStyle: AppTypography.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
    ),
    
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      titleTextStyle: AppTypography.headingSmall,
      contentTextStyle: AppTypography.bodyMedium,
    ),
  );
}
```

---

## 🎯 RÈGLE D'OR

> **TOUJOURS utiliser les tokens définis dans ce document.**
> 
> ```dart
> // ✅ BON
> Container(
>   padding: const EdgeInsets.all(AppSpacing.lg),
>   decoration: BoxDecoration(
>     color: AppColors.surface,
>     borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
>   ),
>   child: Text('Hello', style: AppTypography.bodyLarge),
> )
> 
> // ❌ INTERDIT
> Container(
>   padding: const EdgeInsets.all(24),
>   decoration: BoxDecoration(
>     color: Color(0xFF1A1A2E),
>     borderRadius: BorderRadius.circular(12),
>   ),
>   child: Text('Hello', style: TextStyle(fontSize: 16)),
> )
> ```

---

**Ce Design System est la source de vérité pour tout le visuel de l'application.**