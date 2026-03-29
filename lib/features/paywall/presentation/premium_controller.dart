import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/constants/app_constants.dart';

@immutable
class PremiumState {
  const PremiumState({
    this.isPremium = false,
    this.isLoading = true,
    this.offerings,
  });

  final bool isPremium;
  final bool isLoading;
  final Offerings? offerings;

  PremiumState copyWith({
    bool? isPremium,
    bool? isLoading,
    Offerings? offerings,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      offerings: offerings ?? this.offerings,
    );
  }
}

class PremiumController extends StateNotifier<PremiumState> {
  PremiumController() : super(const PremiumState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final results = await Future.wait([
        Purchases.getCustomerInfo(),
        Purchases.getOfferings(),
      ]);
      final customerInfo = results[0] as CustomerInfo;
      final offerings = results[1] as Offerings;
      state = state.copyWith(
        isPremium: customerInfo.entitlements.active
            .containsKey(AppConstants.premiumEntitlementId),
        offerings: offerings,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> purchase(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      final isPremium = customerInfo.entitlements.active
          .containsKey(AppConstants.premiumEntitlementId);
      state = state.copyWith(isPremium: isPremium);
      return isPremium;
    } catch (_) {
      return false;
    }
  }

  Future<void> restore() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      state = state.copyWith(
        isPremium: customerInfo.entitlements.active
            .containsKey(AppConstants.premiumEntitlementId),
      );
    } catch (_) {}
  }
}

final premiumControllerProvider =
    StateNotifierProvider<PremiumController, PremiumState>(
  (_) => PremiumController(),
);
