import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../routine_builder/data/blocks_repository.dart';
import '../../../routine_builder/domain/routine_model.dart';
import '../../../routine_builder/presentation/routine_builder_controller.dart';
import '../../../scoring/data/scoring_repository.dart';
import '../../../scoring/domain/score_model.dart';
import '../../../scoring/presentation/scoring_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scoringControllerProvider.notifier).refresh();
      ref.read(routineBuilderControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(appLanguageProvider).languageCode;
    final routineState = ref.watch(routineBuilderControllerProvider);
    final scoringState = ref.watch(scoringControllerProvider);
    final routine = routineState.activeRoutine;
    final hasRoutine = routine != null && routine.blocks.isNotEmpty;
    final allScores = scoringRepositoryInstance.getAllScores();
    final greeting = AppI18n.t('home.hello', langCode);
    final subtitle = _morningSubtitle(langCode);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _AtmosphericBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopHeader(
                    greeting: greeting,
                    subtitle: subtitle,
                    onOpenSettings: () => context.push(AppRoutes.settings),
                    onOpenLibrary: () => context.push(AppRoutes.sharedRoutines),
                  ),
                  const SizedBox(height: 20),
                  _WeekStrip(
                    langCode: langCode,
                    scores: allScores,
                    currentStreak: scoringState.currentStreak,
                  ),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 14, end: 0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value),
                        child: Opacity(
                          opacity: (1 - (value / 14)).clamp(0, 1),
                          child: child,
                        ),
                      );
                    },
                    child: _MainRoutineCard(
                      langCode: langCode,
                      routine: routine,
                      hasRoutine: hasRoutine,
                      hasCompletedToday: scoringState.hasCompletedToday,
                      onStart: () => context.go(AppRoutes.timer),
                      onEdit: () => context.push(AppRoutes.builder),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _morningSubtitle(String langCode) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppI18n.t('home.subtitleMorning', langCode);
    }
    return AppI18n.t('home.subtitleAfter', langCode);
  }
}

class _AtmosphericBackground extends StatelessWidget {
  const _AtmosphericBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8A949F),
            Color(0xFF929AA2),
            Color(0xFF8C8483),
            Color(0xFF746563),
          ],
          stops: [0, 0.30, 0.66, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -90,
            child: _GlowBlob(
              size: 300,
              color: const Color(0xB8FFFFFF),
            ),
          ),
          Positioned(
            top: 210,
            right: -80,
            child: _GlowBlob(
              size: 240,
              color: const Color(0x70CFE5F4),
            ),
          ),
          Positioned(
            bottom: 130,
            left: -70,
            child: _GlowBlob(
              size: 260,
              color: const Color(0x66F6DFC1),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                color: const Color(0x1FFFFFFF),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0x24000000),
                      Colors.transparent,
                      const Color(0x18000000),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.greeting,
    required this.subtitle,
    required this.onOpenSettings,
    required this.onOpenLibrary,
  });

  final String greeting;
  final String subtitle;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenLibrary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: AppTypography.displayMedium.copyWith(
                  color: const Color(0xFFF4F5F7),
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.7,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xE8EEF0F4),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _ControlCapsule(
          onLeftTap: onOpenSettings,
          onRightTap: onOpenLibrary,
        ),
        const SizedBox(width: 12),
        const _ProfileOrb(),
      ],
    );
  }
}

class _ControlCapsule extends StatelessWidget {
  const _ControlCapsule({required this.onLeftTap, required this.onRightTap});

  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0x26F8FAFF),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0x66F2F5FA), width: 1),
          ),
          child: Row(
            children: [
              _MiniIconButton(
                icon: Icons.tune_rounded,
                onTap: onLeftTap,
              ),
              Container(
                width: 1,
                height: 20,
                color: const Color(0x40F4F6FA),
              ),
              _MiniIconButton(
                icon: Icons.grid_view_rounded,
                onTap: onRightTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 46,
        height: 40,
        child: Icon(
          icon,
          size: 20,
          color: const Color(0xFFF2F4F7),
        ),
      ),
    );
  }
}

class _ProfileOrb extends StatelessWidget {
  const _ProfileOrb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x80D8F2FF),
            Color(0x7AE3C6BA),
            Color(0x80EAA58A),
          ],
        ),
        border: Border.all(color: const Color(0x66F2F5FA), width: 1),
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.langCode,
    required this.scores,
    required this.currentStreak,
  });

  final String langCode;
  final List<DailyScore> scores;
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final labels = AppI18n.weekDayLabels(langCode);
    final byDate = <String, bool>{};
    for (final score in scores) {
      byDate[score.dateKey] = score.isSuccessful;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: List.generate(7, (index) {
            final day = monday.add(Duration(days: index));
            final key =
                '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
            final isDone = byDate[key] == true;
            final isToday = day.year == now.year &&
                day.month == now.month &&
                day.day == now.day;

            return Padding(
              padding: EdgeInsets.only(right: index == 6 ? 0 : 12),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: isToday ? 12 : 10,
                    height: isToday ? 12 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? const Color(0xFFF2F4F8)
                          : const Color(0x9AE3E5EA),
                      border: isToday
                          ? Border.all(
                              color: const Color(0xFFF7F8FA),
                              width: 1,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    labels[index],
                    style: AppTypography.labelSmall.copyWith(
                      color: const Color(0xBFE2E4E8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const Spacer(),
        Text(
          '$currentStreak',
          style: AppTypography.headingMedium.copyWith(
            color: const Color(0xFFEDEFF2),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          AppI18n.t('home.streak', langCode),
          style: AppTypography.bodySmall.copyWith(
            color: const Color(0xE3E7ECF2),
          ),
        ),
      ],
    );
  }
}

class _MainRoutineCard extends StatelessWidget {
  const _MainRoutineCard({
    required this.langCode,
    required this.routine,
    required this.hasRoutine,
    required this.hasCompletedToday,
    required this.onStart,
    required this.onEdit,
  });

  final String langCode;
  final RoutineModel? routine;
  final bool hasRoutine;
  final bool hasCompletedToday;
  final VoidCallback onStart;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final title = hasRoutine ? routine!.name : AppI18n.t('home.createRoutine', langCode);
    final subLabel = hasRoutine
        ? AppI18n.t('home.today', langCode)
        : AppI18n.t('home.createRoutineSub', langCode).replaceAll('\n', ' ');
    final duration = hasRoutine ? _formatDuration(routine!.totalDurationMinutes) : '10 min';
    final leadingIcon = _leadingIcon();

    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 380;

    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 34 : 42),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            compact ? 14 : 18,
            compact ? 14 : 16,
            compact ? 14 : 18,
            compact ? 14 : 18,
          ),
          decoration: BoxDecoration(
            color: const Color(0x38A59A92),
            borderRadius: BorderRadius.circular(compact ? 34 : 42),
            border: Border.all(color: const Color(0x9AF4E2D7), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                offset: Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            children: [
              _CardHeader(
                title: title,
                leadingIcon: leadingIcon,
                onEdit: onEdit,
              ),
              SizedBox(height: compact ? 18 : 26),
              _CenterOrb(icon: leadingIcon, compact: compact),
              const SizedBox(height: 18),
              Text(
                hasRoutine ? AppI18n.t('home.subtitleMorning', langCode) : 'Morning reset',
                textAlign: TextAlign.center,
                style: AppTypography.headingSmall.copyWith(
                  color: const Color(0xFFF0F2F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _PagerDot(active: true),
                  SizedBox(width: 8),
                  _PagerDot(active: false),
                  SizedBox(width: 8),
                  _PagerDot(active: false),
                ],
              ),
              const SizedBox(height: 20),
              _SecondaryPanel(
                title: subLabel,
                duration: duration,
              ),
              const SizedBox(height: 14),
              _PrimarySoftCTA(
                label: hasRoutine
                    ? (hasCompletedToday
                        ? AppI18n.t('start.redo', langCode)
                        : AppI18n.t('start.launch', langCode))
                    : AppI18n.t('home.createRoutineButton', langCode),
                onTap: hasRoutine ? onStart : onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _leadingIcon() {
    if (!hasRoutine || routine == null || routine!.blocks.isEmpty) {
      return Icons.self_improvement_rounded;
    }
    final template = BlocksRepository.findById(routine!.blocks.first.templateId);
    return template?.icon ?? Icons.self_improvement_rounded;
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}min';
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.title,
    required this.leadingIcon,
    required this.onEdit,
  });

  final String title;
  final IconData leadingIcon;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0x30F8FCFF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            leadingIcon,
            size: 17,
            color: const Color(0xFFF4F6FA),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headingMedium.copyWith(
              color: const Color(0xFFF1F3F6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0x26F8FCFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x52F4F7FB), width: 1),
            ),
            child: const Icon(
              Icons.tune_rounded,
              size: 18,
              color: Color(0xFFF2F4F7),
            ),
          ),
        ),
      ],
    );
  }
}

class _CenterOrb extends StatelessWidget {
  const _CenterOrb({required this.icon, required this.compact});

  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 176 : 210,
      height: compact ? 148 : 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: compact ? 128 : 150,
            height: compact ? 128 : 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x1FFFFFFF),
            ),
          ),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              width: compact ? 96 : 116,
              height: compact ? 96 : 116,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xA4FFF8E6),
                    Color(0x56E5F4FF),
                    Color(0x18FFFFFF),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: compact ? 66 : 78,
            height: compact ? 66 : 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x2EFFFFFF),
              border: Border.all(color: const Color(0x80FFFFFF), width: 1),
            ),
            child: Icon(
              icon,
              size: compact ? 30 : 34,
              color: const Color(0xFFF8FAFC),
            ),
          ),
        ],
      ),
    );
  }
}

class _PagerDot extends StatelessWidget {
  const _PagerDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 7 : 6,
      height: active ? 7 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xE7F6F7FA) : const Color(0x80EEF1F6),
      ),
    );
  }
}

class _SecondaryPanel extends StatelessWidget {
  const _SecondaryPanel({required this.title, required this.duration});

  final String title;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0x2EFFFFFF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelLarge.copyWith(
                color: const Color(0xFFF4F6F9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            duration,
            style: AppTypography.bodyLarge.copyWith(
              color: const Color(0xD8EEF1F5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xC8EDF0F4),
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _PrimarySoftCTA extends StatelessWidget {
  const _PrimarySoftCTA({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: const Color(0xEAF5F3EE),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.headingMedium.copyWith(
              color: const Color(0xFF6A6460),
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}
