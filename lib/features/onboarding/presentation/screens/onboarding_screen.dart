import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../onboarding_controller.dart';
import '../widgets/duration_selector.dart';
import '../widgets/goals_selector.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/time_picker_wheel.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    ref.listen(onboardingControllerProvider, (prev, next) {
      if (prev?.currentPage != next.currentPage) {
        _goToPage(next.currentPage);
      }
      if (next.isCompleted) {
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Linear progress indicator (iOS style)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: LinearProgressIndicator(
                value: (state.currentPage + 1) / 4,
                minHeight: 2,
                backgroundColor: AppColors.surfaceLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomePage(),
                  _buildWakeTimePage(state, controller),
                  _buildDurationPage(state, controller),
                  _buildGoalsPage(state, controller),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: state.currentPage == 3
                    ? 'Terminer'
                    : state.currentPage == 0
                        ? 'Commencer'
                        : 'Suivant',
                onPressed: state.canProceed
                    ? () {
                        HapticFeedback.lightImpact();
                        if (state.currentPage == 3) {
                          controller.completeOnboarding(ref);
                        } else {
                          controller.nextPage();
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return OnboardingPage(
      icon: '🌅',
      title: 'Morning Routine\nBuilder',
      subtitle: 'Construis ta matinée\nparfaite, bloc par bloc',
    );
  }

  Widget _buildWakeTimePage(
    dynamic state,
    OnboardingController controller,
  ) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        // Back button (hidden on page 0, visible here)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: CupertinoButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.previousPage();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.chevron_back,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  Text(
                    'Retour',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'À quelle heure\nte réveilles-tu ?',
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Expanded(
          child: TimePickerWheel(
            initialTime:
                state.wakeTime ?? const TimeOfDay(hour: 6, minute: 30),
            onTimeChanged: controller.setWakeTime,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationPage(
    dynamic state,
    OnboardingController controller,
  ) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: CupertinoButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.previousPage();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.chevron_back,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  Text(
                    'Retour',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Combien de temps\npour ta routine ?',
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Expanded(
          child: DurationSelector(
            selectedDuration: state.routineDurationMinutes,
            onDurationSelected: controller.setDuration,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsPage(
    dynamic state,
    OnboardingController controller,
  ) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: CupertinoButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.previousPage();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.chevron_back,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  Text(
                    'Retour',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Quels sont tes\nobjectifs ?',
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '(choisis-en plusieurs)',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: GoalsSelector(
            selectedGoals: state.selectedGoals,
            onGoalToggled: controller.toggleGoal,
          ),
        ),
      ],
    );
  }
}
