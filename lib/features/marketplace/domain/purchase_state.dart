import 'package:flutter/foundation.dart';

enum PurchaseStatus { idle, loading, success, error, owned }

@immutable
class PurchaseState {
  final PurchaseStatus status;
  final String? errorMessage;
  final Set<String> unlockedPackIds;
  final bool isPremiumSubscriber;

  const PurchaseState({
    this.status = PurchaseStatus.idle,
    this.errorMessage,
    this.unlockedPackIds = const {},
    this.isPremiumSubscriber = false,
  });

  PurchaseState copyWith({
    PurchaseStatus? status,
    String? errorMessage,
    Set<String>? unlockedPackIds,
    bool? isPremiumSubscriber,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      unlockedPackIds: unlockedPackIds ?? this.unlockedPackIds,
      isPremiumSubscriber: isPremiumSubscriber ?? this.isPremiumSubscriber,
    );
  }

  bool isPackUnlocked(String packId) => unlockedPackIds.contains(packId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PurchaseState &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.unlockedPackIds == unlockedPackIds &&
        other.isPremiumSubscriber == isPremiumSubscriber;
  }

  @override
  int get hashCode => Object.hash(
        status,
        errorMessage,
        unlockedPackIds,
        isPremiumSubscriber,
      );
}
