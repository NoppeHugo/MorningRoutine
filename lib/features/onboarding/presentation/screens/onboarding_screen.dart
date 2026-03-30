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
import '../../../settings/data/settings_repository.dart';
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
  bool _askedLanguage = false;
 
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _promptLanguageOnFirstOpen();
    });
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
      curve: Curves.easeInOut,
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLanguageProvider);
    final langCode = locale.languageCode;
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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: AppAtmosphericBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => _buildDot(index, state.currentPage),
                    ),
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppButton(
                    label: state.currentPage == 3
                        ? AppI18n.t('common.finish', langCode)
                        : state.currentPage == 0
                            ? AppI18n.t('common.start', langCode)
                            : AppI18n.t('common.next', langCode),
                    onPressed: state.canProceed
                        ? () {
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
        ],
      ),
    );
  }
 
  Widget _buildDot(int index, int currentPage) {
    final isActive = index <= currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      width: isActive ? 22 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF0F2F6) : const Color(0x66DEE3ED),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }
 
  Widget _buildWelcomePage() {
    final langCode = ref.read(appLanguageProvider).languageCode;
    return OnboardingPage(
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0x2EE8EDF8),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
          border: Border.all(color: const Color(0x66F2F5FA)),
        ),
        child: const Center(
          child: Icon(
            Icons.wb_sunny_rounded,
            size: 56,
            color: Color(0xFFF2F4F8),
          ),
        ),
      ),
      title: AppI18n.t('onboarding.title', langCode),
      subtitle: AppI18n.t('onboarding.subtitle', langCode),
    );
  }
 
  Widget _buildWakeTimePage(
    dynamic state,
    OnboardingController controller,
  ) {
    final langCode = ref.read(appLanguageProvider).languageCode;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        _buildBackButton(onPressed: controller.previousPage),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppI18n.t('onboarding.wakeTime', langCode),
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Expanded(
          child: TimePickerWheel(
            initialTime: state.wakeTime ?? const TimeOfDay(hour: 6, minute: 30),
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
    final langCode = ref.read(appLanguageProvider).languageCode;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        _buildBackButton(onPressed: controller.previousPage),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppI18n.t('onboarding.duration', langCode),
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
    final langCode = ref.read(appLanguageProvider).languageCode;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        _buildBackButton(onPressed: controller.previousPage),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppI18n.t('onboarding.goals', langCode),
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppI18n.t('onboarding.goalsSub', langCode),
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

  Future<void> _promptLanguageOnFirstOpen() async {
    if (_askedLanguage || !mounted) return;

    final settings = settingsRepositoryInstance.loadSettings();
    if (settings.hasChosenLanguage) return;

    _askedLanguage = true;
    final locale = ref.read(appLanguageProvider);
    String selected = settings.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppGlassContainer(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppI18n.t('onboarding.languageTitle', locale.languageCode),
                        style: AppTypography.headingSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppI18n.t('onboarding.languageSub', locale.languageCode),
                        style: AppTypography.bodySmall.copyWith(color: const Color(0xFFDCE1EA)),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...supportedLanguageCodes.map((code) {
                        final isSelected = selected == code;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                            onTap: () => setModalState(() => selected = code),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                                horizontal: AppSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      languageLabel(code),
                                      style: AppTypography.bodyMedium,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFFF2F5FB),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: AppI18n.t('onboarding.languageContinue', locale.languageCode),
                        onPressed: () async {
                          final current = settingsRepositoryInstance.loadSettings();
                          await settingsRepositoryInstance.saveSettings(
                            current.copyWith(
                              languageCode: selected,
                              hasChosenLanguage: true,
                            ),
                          );
                          await ref.read(appLanguageProvider.notifier).setLanguage(selected);
                          if (ctx.mounted) Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBackButton({required VoidCallback onPressed}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFFF2F4F8),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0x30ECF0F8),
            side: const BorderSide(color: Color(0x66F2F5FA)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
          ),
        ),
      ),
    );
  }
}
