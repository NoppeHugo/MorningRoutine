import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseRepository {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const String _monthlySubId = 'com.morningroutine.premium.monthly';
  static const String _yearlySubId = 'com.morningroutine.premium.yearly';

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  /// Initialise the StoreKit purchase listener.
  Future<void> init() async {
    final isAvailable = await _iap.isAvailable();
    if (!isAvailable) return;

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        // Log error — StoreKit not available or network issue
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  // ── Purchase ──────────────────────────────────────────────────────────────

  /// Attempts to buy a non-consumable pack.
  /// Returns true if the purchase flow was initiated.
  Future<bool> buyPack(String productId) async {
    final isAvailable = await _iap.isAvailable();
    if (!isAvailable) return false;

    final response = await _iap.queryProductDetails({productId});
    if (response.productDetails.isEmpty) return false;

    final param = PurchaseParam(
      productDetails: response.productDetails.first,
    );
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Starts a subscription purchase (monthly or yearly).
  Future<bool> subscribe(bool isYearly) async {
    final isAvailable = await _iap.isAvailable();
    if (!isAvailable) return false;

    final productId = isYearly ? _yearlySubId : _monthlySubId;
    final response = await _iap.queryProductDetails({productId});
    if (response.productDetails.isEmpty) return false;

    final param = PurchaseParam(
      productDetails: response.productDetails.first,
    );
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Restores previous purchases (required by App Store Review).
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Checks whether a specific pack is unlocked for a user.
  Future<bool> isPackUnlocked(String packId, String userId) async {
    // TODO: Check Firestore /users/{userId}/purchases/{packId}
    return false;
  }

  // ── Stream ────────────────────────────────────────────────────────────────

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
  ) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // TODO: Verify receipt via Firebase Functions
          // TODO: Persist to Firestore /users/{uid}/purchases/{packId}
          await _iap.completePurchase(purchase);
        case PurchaseStatus.error:
          // Handle error — surface to UI via stream or callback
          await _iap.completePurchase(purchase);
        case PurchaseStatus.pending:
          // Payment pending (e.g. Ask to Buy) — nothing to do yet
          break;
        case PurchaseStatus.canceled:
          // User dismissed — nothing to do
          break;
      }
    }
  }
}

final purchaseRepositoryProvider = Provider<PurchaseRepository>(
  (ref) {
    final repo = PurchaseRepository();
    ref.onDispose(repo.dispose);
    return repo;
  },
);
