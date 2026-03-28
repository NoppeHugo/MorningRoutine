import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../routine_builder/presentation/routine_builder_controller.dart';
import '../../../scoring/presentation/scoring_controller.dart';
import '../../../scoring/presentation/widgets/score_display.dart';
import '../../../scoring/presentation/widgets/streak_badge.dart';
import '../widgets/routine_preview_card.dart';
import '../widgets/start_routine_button.dart';
 
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
 
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh scoring data when returning to home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scoringControllerProvider.notifier).refresh();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour ☀️';
    if (hour < 18) return 'Bonne après-midi';
    return 'Bonsoir 🌙';
  }
 
  @override
  Widget build(BuildContext context) {
    final routineState = ref.watch(routineBuilderControllerProvider);
    final scoringState = ref.watch(scoringControllerProvider);
    final routine = routineState.routine;
    final hasRoutine = routine != null && routine.blocks.isNotEmpty;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getGreeting(),
                    style: AppTypography.headingLarge,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => context.push(AppRoutes.settings),
                    child: const Icon(
                      CupertinoIcons.settings,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
 
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Streak
                    StreakBadge(
                      currentStreak: scoringState.currentStreak,
                      bestStreak: scoringState.bestStreak,
                    ),
                    const SizedBox(height: AppSpacing.md),
 
                    // Today's score
                    ScoreDisplay(score: scoringState.todayScore),
                    const SizedBox(height: AppSpacing.md),
 
                    // Routine preview or create CTA
                    if (hasRoutine)
                      RoutinePreviewCard(
                        routine: routine,
                        onEdit: () => context.push(AppRoutes.builder),
                      )
                    else
                      _buildCreateRoutineCTA(context),
 
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
 
            // Start button
            if (hasRoutine)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: StartRoutineButton(
                  hasCompletedToday: scoringState.hasCompletedToday,
                  onPressed: () => context.go(AppRoutes.timer),
                ),
              ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildCreateRoutineCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text('🌅', style: TextStyle(fontSize: 48)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Crée ta routine',
            style: AppTypography.headingSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Construis ta matinée parfaite\nbloc par bloc',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Créer ma routine',
            onPressed: () => context.push(AppRoutes.builder),
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}
