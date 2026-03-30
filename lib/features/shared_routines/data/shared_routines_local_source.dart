import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../domain/creator_profile.dart';
import '../domain/shared_routine_template.dart';

/// Local Hive storage for shared routines catalog (offline cache)
/// - Stores templates + creators fetched from seed/remote
/// - Enables app to work without internet after first load
/// - 2-hour expiry: after 2h, will fallback to seed if network is down
class SharedRoutinesLocalSource {
  static const String _templatesBoxName = 'shared_routines_templates';
  static const String _creatorsBoxName = 'shared_routines_creators';
  static const String _metadataBoxName = 'shared_routines_metadata';
  static const String _lastFetchKey = 'last_fetch_timestamp';
  static const int _cacheExpiryMinutes = 120;

  static const String _materialIconsFamily = 'MaterialIcons';

  late Box<String> _templatesBox;
  late Box<String> _creatorsBox;
  late Box _metadataBox;

  /// Initialize Hive boxes for shared routines
  Future<void> initialize() async {
    _templatesBox = await Hive.openBox<String>(_templatesBoxName);
    _creatorsBox = await Hive.openBox<String>(_creatorsBoxName);
    _metadataBox = await Hive.openBox(_metadataBoxName);
  }

  /// Save templates to local cache
  Future<void> saveTemplates(List<SharedRoutineTemplate> templates) async {
    final payload = templates.map(_encodeTemplate).toList();
    await _templatesBox.put('all', jsonEncode(payload));
    await _updateLastFetchTime();
  }

  /// Save creators to local cache
  Future<void> saveCreators(List<CreatorProfile> creators) async {
    final payload = creators.map(_encodeCreator).toList();
    await _creatorsBox.put('all', jsonEncode(payload));
  }

  /// Load templates from cache (returns null if empty or expired)
  List<SharedRoutineTemplate>? loadTemplates() {
    final cached = _templatesBox.get('all');
    if (cached == null || _isCacheExpired()) return null;

    try {
      final raw = jsonDecode(cached) as List<dynamic>;
      return raw
          .map((item) => _decodeTemplate(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Load creators from cache
  List<CreatorProfile>? loadCreators() {
    final cached = _creatorsBox.get('all');
    if (cached == null || _isCacheExpired()) return null;

    try {
      final raw = jsonDecode(cached) as List<dynamic>;
      return raw
          .map((item) => _decodeCreator(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Check if cache is still valid (not expired)
  bool _isCacheExpired() {
    final lastFetch = _metadataBox.get(_lastFetchKey) as int?;
    if (lastFetch == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMinutes = (now - lastFetch) ~/ (1000 * 60);
    return diffMinutes > _cacheExpiryMinutes;
  }

  /// Update last fetch timestamp
  Future<void> _updateLastFetchTime() async {
    await _metadataBox.put(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get time since last successful cache (for debug/UI)
  Duration? getTimeSinceLastFetch() {
    final lastFetch = _metadataBox.get(_lastFetchKey) as int?;
    if (lastFetch == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    return Duration(milliseconds: now - lastFetch);
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await Future.wait([
      _templatesBox.clear(),
      _creatorsBox.clear(),
      _metadataBox.clear(),
    ]);
  }

  Map<String, dynamic> _encodeTemplate(SharedRoutineTemplate template) {
    return {
      'id': template.id,
      'creatorId': template.creatorId,
      'title': template.title,
      'subtitle': template.subtitle,
      'goal': template.goal,
      'iconCodePoint': template.icon.codePoint,
      'theme': template.theme.index,
      'level': template.level.index,
      'status': template.status.index,
      'tags': template.tags,
      'sourceLabel': template.sourceLabel,
      'disclaimer': template.disclaimer,
      'isPremium': template.isPremium,
      'blocks': template.blocks
          .map(
            (block) => {
              'templateId': block.templateId,
              'durationMinutes': block.durationMinutes,
              'note': block.note,
            },
          )
          .toList(),
    };
  }

  SharedRoutineTemplate _decodeTemplate(Map<String, dynamic> map) {
    return SharedRoutineTemplate(
      id: map['id'] as String,
      creatorId: map['creatorId'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      goal: map['goal'] as String,
      icon: IconData(
        map['iconCodePoint'] as int,
        fontFamily: _materialIconsFamily,
      ),
      theme: RoutineTemplateTheme.values[map['theme'] as int],
      level: RoutineTemplateLevel.values[map['level'] as int],
      status: RoutineTemplateStatus.values[map['status'] as int],
      tags: List<String>.from(map['tags'] as List<dynamic>),
      sourceLabel: map['sourceLabel'] as String,
      disclaimer: map['disclaimer'] as String,
      isPremium: map['isPremium'] as bool,
      blocks: (map['blocks'] as List<dynamic>)
          .map(
            (block) => SharedRoutineBlockTemplate(
              templateId: (block as Map)['templateId'] as String,
              durationMinutes: block['durationMinutes'] as int,
              note: block['note'] as String?,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> _encodeCreator(CreatorProfile creator) {
    return {
      'id': creator.id,
      'displayName': creator.displayName,
      'slug': creator.slug,
      'avatarEmoji': creator.avatarEmoji,
      'bioShort': creator.bioShort,
      'domains': creator.domains,
      'verificationStatus': creator.verificationStatus.index,
    };
  }

  CreatorProfile _decodeCreator(Map<String, dynamic> map) {
    return CreatorProfile(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      slug: map['slug'] as String,
      avatarEmoji: map['avatarEmoji'] as String,
      bioShort: map['bioShort'] as String,
      domains: List<String>.from(map['domains'] as List<dynamic>),
      verificationStatus:
          CreatorVerificationStatus.values[map['verificationStatus'] as int],
    );
  }
}

final sharedRoutinesLocalSourceProvider =
    Provider<SharedRoutinesLocalSource>((ref) {
  return SharedRoutinesLocalSource();
});
