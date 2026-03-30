import 'package:flutter/foundation.dart';

enum CreatorVerificationStatus {
  inspired,
  verified,
  official,
}

@immutable
class CreatorProfile {
  const CreatorProfile({
    required this.id,
    required this.displayName,
    required this.slug,
    required this.avatarEmoji,
    required this.bioShort,
    required this.domains,
    required this.verificationStatus,
  });

  final String id;
  final String displayName;
  final String slug;
  final String avatarEmoji;
  final String bioShort;
  final List<String> domains;
  final CreatorVerificationStatus verificationStatus;
}
