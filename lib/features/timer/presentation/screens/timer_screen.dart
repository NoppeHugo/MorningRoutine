import 'package:flutter/material.dart';
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
        context.go(AppRoutes.completion);
      }
    });
 
    final currentBlock = state.currentBlock;
    final totalSeconds = currentBlock.durationMinutes * 60;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  onPressed: () => _confirmQuit(context),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
 
            const SizedBox(height: AppSpacing.md),
 
            // Block counter
            Text(
              'Bloc ${state.currentBlockIndex + 1} sur ${state.totalBlocksCount}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
 
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: BlockProgressBar(
                totalBlocks: state.totalBlocksCount,
                currentBlockIndex: state.currentBlockIndex,
                completedBlockResults: state.completedBlocks
                    .map((r) => r.completed)
                    .toList(),
              ),
            ),
 
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
 
            // Next block preview
            if (!state.isLastBlock) _buildNextBlockPreview(state),
 
            const SizedBox(height: AppSpacing.xl),
 
            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: TimerControls(
                status: state.status,
                onPlayPause: controller.togglePlayPause,
                onSkip: controller.skipBlock,
                onDone: controller.completeBlock,
              ),
            ),
 
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
 
  Widget _buildNextBlockPreview(TimerState state) {
    final nextBlock = state.routine.blocks[state.currentBlockIndex + 1];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          Text(
            'Prochain: ${nextBlock.emoji}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${nextBlock.name} (${nextBlock.durationMinutes}min)',
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
 
  void _confirmQuit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter la routine ?'),
        content: const Text('Ta progression ne sera pas sauvegardée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.home);
            },
            child: Text(
              'Quitter',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
