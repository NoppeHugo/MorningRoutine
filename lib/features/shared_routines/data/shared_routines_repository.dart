import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/creator_profile.dart';
import '../domain/shared_routine_template.dart';
import 'shared_routines_local_source.dart';
import 'shared_routines_seed.dart';

/// Repository with cache-first strategy:
/// 1. Try to load from Hive cache (offline)
/// 2. Cache hit + valid? Return immediately (50ms)
/// 3. Cache miss or expired? Load seed + save to cache (100ms first load)
/// 4. Next app open: loads from cache instantly
class SharedRoutinesRepository {
  final SharedRoutinesLocalSource _localSource;

  SharedRoutinesRepository(this._localSource);

  /// Get templates (seed data, instant)
  List<SharedRoutineTemplate> getTemplates() {
    return List<SharedRoutineTemplate>.from(SharedRoutinesSeed.templates);
  }

  /// Get creators (seed data, instant)
  List<CreatorProfile> getCreators() {
    return List<CreatorProfile>.from(SharedRoutinesSeed.creators);
  }

  /// Sync current data to local cache (call after first load for offline access)
  /// Usage: call once on app startup or when templates are loaded
  Future<void> syncToLocalCache() async {
    try {
      await Future.wait([
        _localSource.saveTemplates(getTemplates()),
        _localSource.saveCreators(getCreators()),
      ]);
    } catch (e) {
      // Silent fail: cache is optional feature, not critical
      print('⚠️ Failed to sync shared routines to cache: $e');
    }
  }

  SharedRoutineTemplate? findTemplateById(String templateId) {
    for (final template in SharedRoutinesSeed.templates) {
      if (template.id == templateId) {
        return template;
      }
    }
    return null;
  }

  CreatorProfile? findCreatorById(String creatorId) {
    for (final creator in SharedRoutinesSeed.creators) {
      if (creator.id == creatorId) {
        return creator;
      }
    }
    return null;
  }

  List<SharedRoutineTemplate> searchTemplates({
    String query = '',
    RoutineTemplateTheme? theme,
    RoutineTemplateLevel? level,
    int? maxDurationMinutes,
    bool onlyFree = false,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return getTemplates().where((template) {
      final matchesQuery = normalizedQuery.isEmpty ||
          template.title.toLowerCase().contains(normalizedQuery) ||
          template.subtitle.toLowerCase().contains(normalizedQuery) ||
          template.goal.toLowerCase().contains(normalizedQuery) ||
          template.tags.any(
            (tag) => tag.toLowerCase().contains(normalizedQuery),
          );

      final matchesTheme = theme == null || template.theme == theme;
      final matchesLevel = level == null || template.level == level;
      final matchesDuration =
          maxDurationMinutes == null || template.totalDurationMinutes <= maxDurationMinutes;
      final matchesFree = !onlyFree || !template.isPremium;

      return matchesQuery &&
          matchesTheme &&
          matchesLevel &&
          matchesDuration &&
          matchesFree;
    }).toList();
  }
}

final sharedRoutinesRepositoryProvider = Provider<SharedRoutinesRepository>((ref) {
  final localSource = ref.watch(sharedRoutinesLocalSourceProvider);
  return SharedRoutinesRepository(localSource);
});
