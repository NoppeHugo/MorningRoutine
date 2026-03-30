import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../paywall/presentation/premium_controller.dart';
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
    // Initialize session flow (mode + mood before)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareSession();
    });
  }

  Future<void> _prepareSession() async {
    if (!mounted) return;
    final premiumState = ref.read(premiumControllerProvider);
    final isPremium = premiumState.isPremium;
    final langCode = Localizations.localeOf(context).languageCode;
    final controller = ref.read(timerControllerProvider.notifier);

    if (isPremium) {
      final mood = await _pickMood(
        title: AppI18n.t('timer.howFeelBefore', langCode),
      );
      if (!mounted) return;
      if (mood != null) controller.setMoodBefore(mood);
    }

    final mode = await _pickMode(isPremium: isPremium, langCode: langCode);
    if (!mounted || mode == null) return;

    controller.setSessionMode(mode);
    if (mode == RoutineSessionMode.guided) {
      controller.start();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final state = ref.watch(timerControllerProvider);
    final controller = ref.read(timerControllerProvider.notifier);
 
    ref.listen(timerControllerProvider, (prev, next) {
      if (next.isRoutineCompleted) {
        context.go(AppRoutes.completion);
      }
    });
 
    final currentBlock = state.currentBlock;
    final totalSeconds = currentBlock.durationMinutes * 60;

    if (state.sessionMode == RoutineSessionMode.checklist) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const Positioned.fill(child: AppAtmosphericBackground()),
            SafeArea(
              child: Column(
                children: [
              _buildCloseButton(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppGlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  color: const Color(0x24F8FAFF),
                  borderColor: const Color(0x66F2F5FA),
                  child: Row(
                    children: [
                      AppGlassContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        radius: AppSpacing.radiusSmall,
                        color: const Color(0x30F6F8FF),
                        borderColor: const Color(0x80F2F5FA),
                        child: Text(
                          AppI18n.t('timer.modeChecklist', langCode),
                          style: AppTypography.bodySmall.copyWith(
                            color: const Color(0xFFF2F5FA),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppI18n.tf('timer.doneCountFmt', langCode, {
                          'done': '${state.completedBlocks.where((b) => b.completed).length}',
                          'total': '${state.totalBlocksCount}',
                        }),
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xDCE3EAF5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  AppI18n.tf('timer.checklistEncourageFmt', langCode, {
                    'done': '${state.completedBlocks.where((b) => b.completed).length}',
                    'total': '${state.totalBlocksCount}',
                  }),
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xDCE3EAF5),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: state.routine.blocks.length,
                  itemBuilder: (context, index) {
                    final block = state.routine.blocks[index];
                    final isDone = state.completedBlocks.any(
                      (r) => r.blockId == block.id && r.completed,
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppGlassContainer(
                        padding: EdgeInsets.zero,
                        radius: AppSpacing.radiusLarge,
                        color: const Color(0x26F8FAFF),
                        borderColor: const Color(0x66F2F5FA),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            checkboxTheme: CheckboxThemeData(
                              fillColor: WidgetStateProperty.resolveWith(
                                (states) => const Color(0xFFF2F5FA),
                              ),
                              checkColor: WidgetStateProperty.resolveWith(
                                (states) => const Color(0xFF273043),
                              ),
                            ),
                          ),
                          child: CheckboxListTile(
                            value: isDone,
                            onChanged: (value) => controller.toggleChecklistBlock(
                              block.id,
                              value ?? false,
                            ),
                            title: Text(
                              '${block.emoji} ${block.name}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: const Color(0xFFF3F6FB),
                              ),
                            ),
                            subtitle: Text(
                              '${block.durationMinutes} min',
                              style: AppTypography.bodySmall.copyWith(
                                color: const Color(0xDCE3EAF5),
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: const Color(0xFFF2F5FA),
                            side: const BorderSide(color: Color(0xA7EEF3FB)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: AppButton(
                  label: AppI18n.t('timer.finishChecklist', langCode),
                  onPressed: () => controller.finishChecklist(),
                ),
              ),
                ],
              ),
            ),
          ],
        ),
      );
    }
 
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: AppAtmosphericBackground()),
          SafeArea(
            child: Column(
              children: [
            _buildCloseButton(),
 
            const SizedBox(height: AppSpacing.md),
 
            // Block counter
            Text(
              AppI18n.tf('timer.blockFmt', langCode, {
                'current': '${state.currentBlockIndex + 1}',
                'total': '${state.totalBlocksCount}',
              }),
              style: AppTypography.bodyMedium.copyWith(
                color: const Color(0xDCE3EAF5),
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
                langCode: langCode,
              ),
            ),
 
            const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
        ),
    );
  }

  Future<RoutineSessionMode?> _pickMode({
    required bool isPremium,
    required String langCode,
  }) {
    return showModalBottomSheet<RoutineSessionMode>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppGlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppI18n.t('timer.modeTitle', langCode),
                    style: AppTypography.headingSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ListTile(
                    leading: const Icon(Icons.checklist_rounded, color: Color(0xFFEFF3FA)),
                    title: Text(AppI18n.t('timer.modeChecklist', langCode)),
                    subtitle: Text(AppI18n.t('timer.modeChecklistSub', langCode)),
                    onTap: () => Navigator.of(ctx).pop(RoutineSessionMode.checklist),
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined, color: Color(0xFFEFF3FA)),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(AppI18n.t('timer.modeGuided', langCode)),
                        ),
                        if (!isPremium)
                          AppGlassContainer(
                            radius: AppSpacing.radiusSmall,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            color: const Color(0x30F6F8FF),
                            borderColor: const Color(0x80F2F5FA),
                            child: Text(
                              AppI18n.t('common.pro', langCode),
                              style: AppTypography.bodySmall.copyWith(
                                color: const Color(0xFFF2F5FA),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(AppI18n.t('timer.modeGuidedSub', langCode)),
                    onTap: () async {
                      if (isPremium) {
                        if (ctx.mounted) {
                          Navigator.of(ctx).pop(RoutineSessionMode.guided);
                        }
                        return;
                      }

                      if (ctx.mounted) Navigator.of(ctx).pop();
                      final unlocked = await context.push(AppRoutes.paywall);
                      if (!mounted) return;
                      if (unlocked == true) {
                        final updatedPremium =
                            ref.read(premiumControllerProvider).isPremium;
                        if (updatedPremium) {
                          ref
                              .read(timerControllerProvider.notifier)
                              .setSessionMode(RoutineSessionMode.guided);
                          ref.read(timerControllerProvider.notifier).start();
                          return;
                        }
                      }
                      ref
                          .read(timerControllerProvider.notifier)
                          .setSessionMode(RoutineSessionMode.checklist);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _pickMood({required String title}) {
    final langCode = Localizations.localeOf(context).languageCode;
    final moods = ['tired', 'calm', 'stressed', 'focused', 'energized'];

    return showModalBottomSheet<String>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppGlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.headingSmall),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: moods
                        .map(
                          (mood) => ActionChip(
                            label: Text(AppI18n.t('mood.$mood', langCode)),
                            backgroundColor: const Color(0x26F8FAFF),
                            side: const BorderSide(color: Color(0x66F2F5FA)),
                            onPressed: () => Navigator.of(ctx).pop(mood),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
 
  Widget _buildNextBlockPreview(TimerState state) {
    final langCode = ref.read(appLanguageProvider).languageCode;
    final nextBlock = state.routine.blocks[state.currentBlockIndex + 1];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppGlassContainer(
        padding: const EdgeInsets.all(AppSpacing.md),
        color: const Color(0x24F8FAFF),
        borderColor: const Color(0x66F2F5FA),
        child: Row(
          children: [
            const Icon(
              Icons.skip_next_rounded,
              size: 18,
              color: Color(0xDCE3EAF5),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              AppI18n.t('timer.next', langCode),
              style: AppTypography.bodyMedium.copyWith(
                color: const Color(0xDCE3EAF5),
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
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: IconButton(
          onPressed: () => _confirmQuit(context),
          icon: const Icon(
            Icons.close,
            color: Color(0xFFEFF2F6),
          ),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0x2EF6F8FF),
            side: const BorderSide(color: Color(0x66F2F5FA)),
          ),
        ),
      ),
    );
  }
 
  void _confirmQuit(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppI18n.t('timer.quitTitle', langCode)),
        content: Text(AppI18n.t('timer.quitBody', langCode)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppI18n.t('timer.keep', langCode)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.home);
            },
            child: Text(
              AppI18n.t('timer.quit', langCode),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
