import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/timer_state.dart';
import '../timer_controller.dart';
import '../widgets/block_progress_bar.dart';
import '../widgets/circular_timer.dart';
import '../widgets/timer_controls.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-start the timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timerControllerProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timerControllerProvider);
    final controller = ref.read(timerControllerProvider.notifier);

    ref.listen(timerControllerProvider, (prev, next) {
      if (next.isRoutineCompleted) {
        HapticFeedback.heavyImpact();
        context.go(AppRoutes.completion);
      } else if (prev != null &&
          prev.currentBlockIndex != next.currentBlockIndex) {
        HapticFeedback.mediumImpact();
      }
    });

    final currentBlock = state.currentBlock;
    final totalSeconds = currentBlock.durationMinutes * 60;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with stop button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _confirmQuit(context),
                    child: Text(
                      'Arrêter',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Dots row for block progress
            _buildDotsRow(state),

            const Spacer(),

            // Circular timer
            CircularTimer(
              secondsRemaining: state.secondsRemaining,
              totalSeconds: totalSeconds,
              emoji: currentBlock.emoji,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Block name
            Text(
              currentBlock.name,
              style: AppTypography.headingMedium,
            ),

            const Spacer(),

            // Next block preview (pill)
            if (!state.isLastBlock) _buildNextBlockPreview(state),

            const SizedBox(height: AppSpacing.xl),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: TimerControls(
                status: state.status,
                onPlayPause: () {
                  HapticFeedback.lightImpact();
                  controller.togglePlayPause();
                },
                onSkip: () {
                  HapticFeedback.mediumImpact();
                  controller.skipBlock();
                },
                onDone: () {
                  HapticFeedback.mediumImpact();
                  controller.completeBlock();
                },
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildDotsRow(TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(state.totalBlocksCount, (index) {
        final isCompleted = index < state.currentBlockIndex;
        final isCurrent = index == state.currentBlockIndex;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isCompleted || isCurrent)
                ? AppColors.primary
                : AppColors.surfaceLight,
          ),
        );
      }),
    );
  }

  Widget _buildNextBlockPreview(TimerState state) {
    final nextBlock = state.routine.blocks[state.currentBlockIndex + 1];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Prochain: ${nextBlock.emoji}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${nextBlock.name} (${nextBlock.durationMinutes}min)',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _confirmQuit(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.home);
            },
            child: const Text('Arrêter la routine'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Continuer'),
        ),
      ),
    );
  }
}
