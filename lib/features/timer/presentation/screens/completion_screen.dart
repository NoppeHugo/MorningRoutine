import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../scoring/presentation/scoring_controller.dart';
import '../../domain/timer_state.dart';
import '../timer_controller.dart';
 
class CompletionScreen extends ConsumerStatefulWidget {
  const CompletionScreen({super.key});
 
  @override
  ConsumerState<CompletionScreen> createState() => _CompletionScreenState();
}
 
class _CompletionScreenState extends ConsumerState<CompletionScreen> {
  @override
  void initState() {
    super.initState();
    // Save score after the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveScore();
    });
  }
 
  Future<void> _saveScore() async {
    try {
      final timerState = ref.read(timerControllerProvider);
      await ref
          .read(scoringControllerProvider.notifier)
          .saveRoutineResult(timerState);
    } catch (_) {
      // Timer provider may have been disposed already
    }
  }
 
  @override
  Widget build(BuildContext context) {
    late final TimerState timerState;
    try {
      timerState = ref.watch(timerControllerProvider);
    } catch (_) {
      // If timer was disposed, go home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(AppRoutes.home);
      });
      return const SizedBox.shrink();
    }
 
    final completedCount =
        timerState.completedBlocks.where((b) => b.completed).length;
    final skippedCount =
        timerState.completedBlocks.where((b) => !b.completed).length;
    final totalBlocks = timerState.totalBlocksCount;
    final scorePercent =
        totalBlocks > 0 ? (completedCount / totalBlocks * 100).round() : 0;
 
    final totalActualSeconds = timerState.completedBlocks
        .fold<int>(0, (sum, b) => sum + b.actualDurationSeconds);
    final totalMinutes = totalActualSeconds ~/ 60;
 
    final scoringState = ref.watch(scoringControllerProvider);
    final streak = scoringState.currentStreak;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
 
              // Celebration icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: const Center(
                  child: Icon(
                    Icons.emoji_events_outlined,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
 
              // Title
              Text(
                'Routine terminée !',
                style: AppTypography.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
 
              // Score card
              AppCard(
                child: Column(
                  children: [
                    Text(
                      '$scorePercent%',
                      style: AppTypography.displayLarge.copyWith(
                        color: scorePercent >= 80
                            ? AppColors.secondary
                            : AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Score',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
 
              // Stats
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '$completedCount/$totalBlocks',
                      label: 'blocs complétés',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      value: '$skippedCount',
                      label: 'blocs skippés',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      value: '${totalMinutes}min',
                      label: 'durée',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
 
              // Streak
              if (streak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.streak.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 28,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '$streak jour${streak > 1 ? 's' : ''}',
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.streak,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'de streak',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.streak,
                        ),
                      ),
                    ],
                  ),
                ),
 
              const Spacer(),
 
              // Return button
              AppButton(
                label: 'Retour à l\'accueil',
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
  });
 
  final String value;
  final String label;
 
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headingSmall,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
