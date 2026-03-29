import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../routine_builder/data/routine_repository.dart';
import '../../routine_builder/domain/block_model.dart';
import '../../routine_builder/domain/routine_model.dart';
import '../data/marketplace_repository.dart';
import '../data/purchase_repository.dart';
import '../domain/expert_pack_model.dart';
import '../domain/purchase_state.dart';

// ── State ─────────────────────────────────────────────────────────────────

class MarketplaceState {
  final List<ExpertPack> featuredPacks;
  final List<ExpertPack> filteredPacks;
  final List<ExpertPack> allPacks;
  final String? selectedCategory;
  final bool isLoading;
  final String? errorMessage;
  final PurchaseState purchaseState;

  const MarketplaceState({
    this.featuredPacks = const [],
    this.filteredPacks = const [],
    this.allPacks = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.errorMessage,
    this.purchaseState = const PurchaseState(),
  });

  MarketplaceState copyWith({
    List<ExpertPack>? featuredPacks,
    List<ExpertPack>? filteredPacks,
    List<ExpertPack>? allPacks,
    String? selectedCategory,
    bool? isLoading,
    String? errorMessage,
    PurchaseState? purchaseState,
    bool clearError = false,
    bool clearCategory = false,
  }) {
    return MarketplaceState(
      featuredPacks: featuredPacks ?? this.featuredPacks,
      filteredPacks: filteredPacks ?? this.filteredPacks,
      allPacks: allPacks ?? this.allPacks,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      purchaseState: purchaseState ?? this.purchaseState,
    );
  }
}

// ── Controller ────────────────────────────────────────────────────────────

class MarketplaceController extends StateNotifier<MarketplaceState> {
  MarketplaceController(
    this._marketplace,
    this._purchase,
    this._routineRepo,
  ) : super(const MarketplaceState());

  final MarketplaceRepository _marketplace;
  final PurchaseRepository _purchase;
  final RoutineRepository _routineRepo;

  static const _uuid = Uuid();

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadPacks() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final featured = await _marketplace.getFeaturedPacks();
      final all = await _marketplace.getPacksByCategory(null);
      state = state.copyWith(
        featuredPacks: featured,
        allPacks: all,
        filteredPacks: all,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible de charger le catalogue. Réessaie plus tard.',
      );
    }
  }

  // ── Filter ────────────────────────────────────────────────────────────────

  Future<void> filterByCategory(String? category) async {
    state = state.copyWith(
      selectedCategory: category,
      clearCategory: category == null,
      isLoading: true,
    );

    try {
      final packs = await _marketplace.getPacksByCategory(category);
      state = state.copyWith(filteredPacks: packs, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        filteredPacks: state.allPacks,
        isLoading: false,
      );
    }
  }

  // ── Purchase ──────────────────────────────────────────────────────────────

  Future<void> unlockPack(ExpertPack pack) async {
    if (pack.isFree) {
      _markPackUnlocked(pack.id);
      return;
    }

    if (pack.storeKitProductId == null) return;

    state = state.copyWith(
      purchaseState: state.purchaseState.copyWith(
        status: PurchaseStatus.loading,
      ),
    );

    try {
      final initiated = await _purchase.buyPack(pack.storeKitProductId!);
      if (!initiated) {
        state = state.copyWith(
          purchaseState: state.purchaseState.copyWith(
            status: PurchaseStatus.error,
            errorMessage: 'Achat impossible. Vérifiez votre connexion.',
          ),
        );
      }
      // On success, stream listener will call _markPackUnlocked
    } catch (e) {
      state = state.copyWith(
        purchaseState: state.purchaseState.copyWith(
          status: PurchaseStatus.error,
          errorMessage: 'Une erreur est survenue lors de l\'achat.',
        ),
      );
    }
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(
      purchaseState: state.purchaseState.copyWith(
        status: PurchaseStatus.loading,
      ),
    );
    try {
      await _purchase.restorePurchases();
      state = state.copyWith(
        purchaseState: state.purchaseState.copyWith(
          status: PurchaseStatus.idle,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        purchaseState: state.purchaseState.copyWith(
          status: PurchaseStatus.error,
          errorMessage: 'Restauration impossible. Réessaie plus tard.',
        ),
      );
    }
  }

  void _markPackUnlocked(String packId) {
    final updatedIds = {...state.purchaseState.unlockedPackIds, packId};
    state = state.copyWith(
      purchaseState: state.purchaseState.copyWith(
        status: PurchaseStatus.owned,
        unlockedPackIds: updatedIds,
      ),
    );
  }

  bool isPackUnlocked(String packId) {
    return state.purchaseState.isPremiumSubscriber ||
        state.purchaseState.unlockedPackIds.contains(packId);
  }

  // ── Import as routine ─────────────────────────────────────────────────────

  Future<void> importPackAsRoutine(ExpertPack pack) async {
    final blocks = pack.blocks.asMap().entries.map((entry) {
      final i = entry.key;
      final b = entry.value;
      return BlockModel(
        id: _uuid.v4(),
        templateId: b.id,
        name: b.name,
        emoji: b.emoji,
        durationMinutes: b.durationMinutes,
        order: i,
      );
    }).toList();

    final settingsBox = Hive.box(AppConstants.settingsBoxName);
    final hour = settingsBox.get('wakeTimeHour', defaultValue: 6) as int;
    final minute = settingsBox.get('wakeTimeMinute', defaultValue: 30) as int;

    final now = DateTime.now();
    final routine = RoutineModel(
      id: _uuid.v4(),
      name: pack.title,
      wakeTimeHour: hour,
      wakeTimeMinute: minute,
      blocks: blocks,
      createdAt: now,
      updatedAt: now,
    );

    await _routineRepo.saveRoutine(routine);
  }
}

// ── Providers ─────────────────────────────────────────────────────────────

final _routineRepoForMarketplaceProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(Hive.box(AppConstants.routineBoxName));
});

final marketplaceControllerProvider =
    StateNotifierProvider<MarketplaceController, MarketplaceState>((ref) {
  final marketplace = ref.watch(marketplaceRepositoryProvider);
  final purchase = ref.watch(purchaseRepositoryProvider);
  final routineRepo = ref.watch(_routineRepoForMarketplaceProvider);
  return MarketplaceController(marketplace, purchase, routineRepo);
});
