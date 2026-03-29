import 'package:flutter/foundation.dart';

@immutable
class Expert {
  final String id;
  final String name;
  final String bio;
  final String specialty;
  final String photoUrl;
  final double rating;
  final int packCount;

  const Expert({
    required this.id,
    required this.name,
    required this.bio,
    required this.specialty,
    required this.photoUrl,
    required this.rating,
    required this.packCount,
  });

  factory Expert.fromFirestore(Map<String, dynamic> data, String id) {
    return Expert(
      id: id,
      name: data['name'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      specialty: data['specialty'] as String? ?? '',
      photoUrl: data['photoUrl'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      packCount: data['packCount'] as int? ?? 0,
    );
  }

  Expert copyWith({
    String? id,
    String? name,
    String? bio,
    String? specialty,
    String? photoUrl,
    double? rating,
    int? packCount,
  }) {
    return Expert(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      specialty: specialty ?? this.specialty,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
      packCount: packCount ?? this.packCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expert && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
