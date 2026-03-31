# Morning Routine — Marketing & Brand Strategy v2

**Version:** v2 (Final with all refinements + PARTIE C DA)  
**Last updated:** Current session  
**Status:** Complete, ready for landing page coding + asset development

---

## PARTIE A: Brand Positioning

### Core Positioning
**"A calmer way to start your day."**

Not a generic productivity hack. Not a gamified routine builder. Not a guru ritual system.

Morning Routine is **specifically built for morning execution**—the part where 80% of people fail, not planning.

### Brand Belief
We believe:
- Better mornings don't require perfect routines
- Consistency beats perfection
- Structure reduces decision fatigue (especially at low energy)
- Guided execution works better than motivation at 6 AM
- Real life mornings are 15-60 minutes, not 90-minute rituals

### Who We're For
People who:
- Wake up and immediately lose momentum
- Want a calmer first hour but won't commit to fantasy routines
- Like clean, useful apps (iOS-native, not overwhelming)
- Believe the routine should serve them, not the reverse

### Who We're NOT For
- 5 AM bio-optimization guru followers
- People who need hand-holding motivation and affirmation
- Perfectionism-driven productivity obsessives
- Minimalists (they won't use timers)

### Brand Personality
**Quiet premium + pragmatic calm**
- Confident but not pushy
- Clear but not dogmatic
- Helpful but not salesy
- Elegant but not precious

---

## PARTIE B: Brand Voice & Messaging

### Core Brand Line
**"Structure, not pressure."**

### Key Message Pillars

#### 1. Anti-Bullshit (Trust Builder)
"Built for real mornings, not fantasy routines."
- Real timeframes (15-60 min, not 90)
- No guru mythology
- Flexible not fragile
- For people who actually wake up

#### 2. Future Pacing (Desirability)
"Tomorrow morning will feel lighter."
- Sell the feeling, not the feature
- "Know what's next" reduces morning anxiety
- "Follow the routine" means no half-asleep decisions
- "Clear momentum" before the day gets chaotic

#### 3. User-Life Focus (Benefit-Led)
Not what the app does → What the user's life feels like
- "Wake up knowing exactly what to do"
- "Open your routine and everything else disappears"
- "Your morning is your foundation"

#### 4. Consistency Over Perfection (Stress Reduction)
- Miss a day, reset, keep going
- No guilt loops
- Just a clear system you can trust

---

## PARTIE C: Direction Artistique (Design System)

Complete 14-section design system for Apple utility + calm wellness aesthetic.

### CA.1 Ambiance générale
**"Apple utility app meets calm wellness minimalism."**
Quiet premium: white cassé + muted teals + warm taupes, soft diffuse glows.
Feeling: "I'm ready. I'm calm. I trust this."

### CA.2 Palette
- `--bg: #f2f0eb` — background (off-white cassé)
- `--paper: #fbfaf7` — card base (ivory)
- `--ink: #18212a` — text primary (deep blue-black)
- `--muted: #4f5b67` — text secondary (soft slate)
- `--accent: #c76639` — warm coral (action, warmth)
- `--accent-2: #3f7c87` — cool teal (secondary, calm)

### CA.3 Background & Atmospherics
Soft radial gradients (teal top-left, terra top-right, taupe bottom) layered over warm linear base.
Effect: Non-intrusive color bleed, very translucent.

### CA.4 Typography
- Headers: Space Grotesk (700/600)
- Body: Instrument Sans (400)
- Line-height: 1.6 body, 1.1 headers
- Letter-spacing: -0.02em on headers

### CA.5 Cards & Panel Styling
- Border-radius: 28px (lg) / 18px (md)
- Backdrop: blur(8px), frosted appearance
- Shadow: 0 10px 40px rgba(24, 33, 42, 0.08) soft
- Hover: 0 12px 48px, translateY(-2px)

### CA.6 Mockup Staging & Perspective
- 3D perspective: 1400px
- Phone 1: rotate(-5deg) translateX(-40px)
- Phone 2: rotate(8deg) translateX(45px) translateY(42px)
- Phone specs: 300px width, 42px radius, 9px dark border

### CA.7 Animation & Motion
- Reveal pattern: opacity 0 → 1, translateY(+16px) → 0
- Duration: 650ms ease-in-out
- Stagger: 50ms increments per element (cap 200ms)
- Threshold: 0.12 intersection ratio
- No gimmicks: fade-up only, no bounce/parallax

### CA.8 Button & CTA Styling
- Primary: dark gradient (140deg #1a2332 → #2c3e50), ivory text, shadow soft
- Secondary: transparent, 1px border, dark text
- Both: pill-shaped (999px radius), hover lift translateY(-1px)

### CA.9 Density & Spacing
- Section padding: 5rem desktop, 3.8rem tablet
- Panel padding: clamp(1.4rem, 3vw, 2.1rem)
- Container: min(1140px, calc(100% - 2.5rem))
- Grid gaps: 2.5rem hero, 1.2rem features, 1rem cards

### CA.10 Micro-typography
- Tags: ALL CAPS, 0.78rem, letter-spacing 0.08em, muted
- Badges: 0.78rem, uppercase, soft border
- Microcopy: 0.92rem, muted, light weight

### CA.11 Buttons & Form Elements
- All pill-shaped, text-based CTAs
- All have hover lift effect
- Interactive: links at opacity 0.85, 1 on hover
- FAQ: ::after pseudo for +/− toggle

### CA.12 Breakpoints & Responsive
- Desktop (1000px+): Full layouts as designed
- Tablet (640-1000px): Single column, nav links hidden
- Mobile (<640px): Tight margins, all 1-col, full-width buttons

### CA.13 Design References
- Apple iOS utility apps (iOS-native)
- Calm (but NOT as soft/blurred)
- Loom (simple, purposeful, premium)
- NotePlan (structured routine UX, warm minimalism)

### CA.14 Implementation Checklist
- [x] CSS variables set
- [x] Background gradients 4-layer
- [x] Card blur(8px) + shadows
- [x] Phone mockups positioned
- [x] Animations 650ms fade-up
- [x] Typography hierarchy
- [x] Mobile breakpoints
- [x] Landing page rendered

---

## PARTIE D: Landing Page Structure

### Section Flow (Hero → CTA)
1. Hero — Desirable headline, value points, phone stack
2. Pill strip — Three quick value signals
3. Built for real mornings — Anti-bullshit trust-builder + 3 cards
4. Who it's for — Quick identification bullets
5. Problem — Before/after with specific chaos → clarity
6. How it works — 3-step flow
7. Features — 4 key feature cards
8. Spotlight — Widgets + Guided mode
9. Progress — 4 tracking cards
10. Premium — 4 upgrade reasons
11. Pricing — 2-tier (Free + Premium featured)
12. FAQ — 6 Q&A pairs
13. Final CTA — Strong close

### Key Conversion Mechanics
- **Above fold:** Hero + primary CTA
- **Friction-kill:** "Who it's for"
- **Trust-build:** "Built for real mornings"
- **Desire:** Features + Spotlight sections
- **Urgency:** Pricing + Premium frame
- **Last chance:** Final CTA

---

## PARTIE E: Copywriting & Messaging Script

### Hero Section
**Headline:** "A calmer way to start your day."
**Subheadline:** "Build a realistic routine, follow it step by step, and stop improvising your first hour."

**Value points:**
- See what's next (no decisions half-asleep)
- Realistic routines that actually stick
- Guided when your energy is low

**Microcopy:** "Structure, not pressure."

### Built for Real Mornings
**Headline:** "Built for real mornings (not fantasy routines)."
**Intro:** "Morning Routine is designed for mornings that need to fit real life: rushed schedules, low energy, imperfect days."

**3 cards:**
1. Short by design → 15-60 min actual schedules
2. Guided when energy is low → no half-asleep decisions
3. Flexible, not fragile → consistency without perfectionism

### Who It's For
**Headlines:** "Made for people who want better mornings—without turning life into a project."

**Bullets:**
- Wake up and immediately lose momentum
- Want a calmer first hour
- Struggle to stick to fantasy routines
- Like clean, useful apps (iOS-native)
- Believe consistency beats perfection

### Problem Section
**Headline:** "Your mornings are just chaotic."
**Subheadline:** "You wake up. You open your phone. Next thing you know, it's 8:30 and you haven't started."

**Before:** Wake groggy → open phone → 45 min gone → not ready
**After:** Wake → know what's next → follow blocks → feel ready → clear momentum

### How It Works
**Step 1:** Build your routine (realistic sequence, clear timing)
**Step 2:** Run your morning flow (Checklist free, Guided premium)
**Step 3:** Keep momentum (score, streak, plan tomorrow)

### Features
- Multi-routines (switch instantly)
- Plan for tomorrow (remove guesswork)
- Templates & shared routines (start faster)
- Post-session reflection (improve system)

### Spotlight
**Widgets:** "Keep your morning visible before your day gets noisy"
- Quick visual cues, stronger trigger, iOS-native

**Guided Mode:** "Guided mode keeps you moving"
- Auto progression, play/pause/skip, better follow-through

### Progress
- Daily completion score
- Current and best streak
- History view and trends
- Mood-based insights

### Premium Upgrade
**Headline:** "Upgrade to make mornings feel easier."

**4 reasons:**
1. Follow, don't think (no decisions when energy is low)
2. Build deeper routines (up to 10 blocks)
3. See what actually works (full history + insights)
4. Save time with premium routines (ready-made templates)

### Pricing
**Free:** $0 → Checklist mode, up to 3 blocks, basic tracking
**Premium:** $4.99/mo or $39.99/yr → Guided mode, 10 blocks, premium routines, full history

### Final CTA
**Headline:** "Your best mornings do not need more motivation. They need a better system."
**Microcopy:** "Start free. Upgrade when you are ready."

---

## PARTIE F: Visual Assets & Mockup Cadrage

### Hero Section Mockups
**Phone 1 (main, left):**
- Today's flow: Hydrate 3m, Stretch 7m, Deep Work 10m
- Momentum: Score 92%, Streak 9 days

**Phone 2 (secondary, right):**
- Guided Mode: Current Focus Plan, Remaining 5:22
- Plan for Tomorrow: Active at 06:45

### Visual References
- Apple iOS utility apps
- Calm (meditation app)
- Loom (SaaS clarity)
- NotePlan (routine UX)

---

## PARTIE G: Monetization & Business Model

### Pricing Strategy
**Free:** Core builder, checklist, up to 3 blocks
**Premium:** $4.99/mo or $39.99/yr (40% savings on annual)
- Guided mode, up to 10 blocks, premium templates, full history

**Psychology:**
- "Best for consistency" badge on Premium (lifestyle frame)
- Annual pricing emphasizes commitment + savings
- No upsell pressure (free genuinely usable)

---

## PARTIE H: SEO, Performance & Conversion Metrics

### SEO
**Meta title:** "Morning Routine | A Calmer Way to Start Your Day"
**Meta description:** "Build a realistic routine, follow it step by step, and stop improvising your first hour. Free app with guided execution."

**Keywords:** morning routine app, morning routine builder, guided morning routine

### Performance
- Landing: <3s load
- Animations: CSS-based, 60fps
- Mobile-first design
- Lighthouse: 90+ target

### Conversion Funnel
Hero → How It Works → Built for Real Mornings → Who It's For → Features → Pricing → Final CTA

---

## Status: COMPLETE

✅ Brand positioning finalized  
✅ Design system (14 sections) complete  
✅ Copywriting script ready  
✅ Landing page structure finalized  
✅ CSS variables & responsive design  
✅ Hero desirability tested  
✅ Future pacing language embedded  
✅ Anti-bullshit positioning set  
✅ Who it's for section added  
✅ Pricing psychology enhanced  
✅ Animations tuned (650ms fade-up, 50ms stagger)  

**Ready for launch & analytics monitoring.**
