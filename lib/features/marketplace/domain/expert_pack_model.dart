import 'package:flutter/foundation.dart';

@immutable
class PackBlock {
  final String id;
  final String name;
  final String emoji;
  final int durationMinutes;
  final String? tip;

  const PackBlock({
    required this.id,
    required this.name,
    required this.emoji,
    required this.durationMinutes,
    this.tip,
  });

  factory PackBlock.fromMap(Map<String, dynamic> map) {
    return PackBlock(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      emoji: map['emoji'] as String? ?? '⭐',
      durationMinutes: map['durationMinutes'] as int? ?? 1,
      tip: map['tip'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'durationMinutes': durationMinutes,
        if (tip != null) 'tip': tip,
      };

  PackBlock copyWith({
    String? id,
    String? name,
    String? emoji,
    int? durationMinutes,
    String? tip,
  }) {
    return PackBlock(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      tip: tip ?? this.tip,
    );
  }
}

const Map<String, String> _categoryLabels = {
  'energy': 'Énergie',
  'focus': 'Focus',
  'calm': 'Calme',
  'fitness': 'Forme',
  'productivity': 'Productivité',
};

const Map<String, String> _categoryEmojis = {
  'energy': '⚡',
  'focus': '🎯',
  'calm': '🧘',
  'fitness': '💪',
  'productivity': '🚀',
};

@immutable
class ExpertPack {
  final String id;
  final String expertId;
  final String title;
  final String description;
  final String category;
  final bool isFeatured;
  final bool isFree;
  final String? storeKitProductId;
  final double price;
  final double rating;
  final int reviewCount;
  final int previewBlockCount;
  final List<PackBlock> blocks;
  final bool isUnlocked;

  const ExpertPack({
    required this.id,
    required this.expertId,
    required this.title,
    required this.description,
    required this.category,
    required this.isFeatured,
    required this.isFree,
    this.storeKitProductId,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.previewBlockCount,
    required this.blocks,
    this.isUnlocked = false,
  });

  factory ExpertPack.fromFirestore(Map<String, dynamic> data, String id) {
    final rawBlocks = data['blocks'] as List<dynamic>? ?? [];
    final blocks = rawBlocks
        .map((b) => PackBlock.fromMap(b as Map<String, dynamic>))
        .toList();

    return ExpertPack(
      id: id,
      expertId: data['expertId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'energy',
      isFeatured: data['isFeatured'] as bool? ?? false,
      isFree: data['isFree'] as bool? ?? false,
      storeKitProductId: data['storeKitProductId'] as String?,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] as int? ?? 0,
      previewBlockCount: data['previewBlockCount'] as int? ?? 1,
      blocks: blocks,
      isUnlocked: data['isUnlocked'] as bool? ?? false,
    );
  }

  ExpertPack copyWith({
    String? id,
    String? expertId,
    String? title,
    String? description,
    String? category,
    bool? isFeatured,
    bool? isFree,
    String? storeKitProductId,
    double? price,
    double? rating,
    int? reviewCount,
    int? previewBlockCount,
    List<PackBlock>? blocks,
    bool? isUnlocked,
  }) {
    return ExpertPack(
      id: id ?? this.id,
      expertId: expertId ?? this.expertId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      isFree: isFree ?? this.isFree,
      storeKitProductId: storeKitProductId ?? this.storeKitProductId,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      previewBlockCount: previewBlockCount ?? this.previewBlockCount,
      blocks: blocks ?? this.blocks,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  int get durationMinutes =>
      blocks.fold(0, (sum, b) => sum + b.durationMinutes);

  String get categoryLabel => _categoryLabels[category] ?? category;
  String get categoryEmoji => _categoryEmojis[category] ?? '⭐';

  String get formattedPrice => isFree ? 'Gratuit' : '€${price.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpertPack && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
