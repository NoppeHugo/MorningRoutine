import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../../features/marketplace/presentation/screens/my_purchases_screen.dart';
import '../../features/marketplace/presentation/screens/pack_detail_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/routine_builder/presentation/screens/block_selector_screen.dart';
import '../../features/routine_builder/presentation/screens/routine_builder_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/timer/presentation/screens/completion_screen.dart';
import '../../features/timer/presentation/screens/timer_screen.dart';
import '../../shared/providers/storage_provider.dart';

abstract class AppRoutes {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const builder = '/builder';
  static const builderBlocks = '/builder/blocks';
  static const timer = '/timer';
  static const completion = '/completion';
  static const settings = '/settings';
  static const marketplace = '/marketplace';
  static const marketplacePurchases = '/marketplace/purchases';
  // Pack detail is dynamic: '/marketplace/$packId'
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final isOnboardingCompleted = ref.watch(isOnboardingCompletedProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      if (!isOnboardingCompleted && !isOnboarding) {
        return AppRoutes.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.builder,
        builder: (context, state) => const RoutineBuilderScreen(),
      ),
      GoRoute(
        path: AppRoutes.builderBlocks,
        builder: (context, state) => const BlockSelectorScreen(),
      ),
      GoRoute(
        path: AppRoutes.timer,
        builder: (context, state) => const TimerScreen(),
      ),
      GoRoute(
        path: AppRoutes.completion,
        builder: (context, state) => const CompletionScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.marketplace,
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: AppRoutes.marketplacePurchases,
        builder: (context, state) => const MyPurchasesScreen(),
      ),
      GoRoute(
        path: '/marketplace/:packId',
        builder: (context, state) => PackDetailScreen(
          packId: state.pathParameters['packId']!,
        ),
      ),
    ],
  );
});
