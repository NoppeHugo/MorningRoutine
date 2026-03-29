import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/expert_pack_model.dart';

const Map<String, Color> _categoryColors = {
  'energy': Color(0xFFFF9F43),
  'focus': Color(0xFF54A0FF),
  'calm': Color(0xFF5F27CD),
  'fitness': Color(0xFF00D9A5),
  'productivity': Color(0xFF6C5CE7),
};

class PackCard extends StatefulWidget {
  const PackCard({
    super.key,
    required this.pack,
    required this.expertName,
    required this.onTap,
  });

  final ExpertPack pack;
  final String expertName;
  final VoidCallback onTap;

  @override
  State<PackCard> createState() => _PackCardState();
}

class _PackCardState extends State<PackCard> {
  bool _pressed = false;

  Color get _categoryColor =>
      _categoryColors[widget.pack.category] ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _categoryColor.withValues(alpha: 0.8),
            _categoryColor.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Large emoji background
          Positioned(
            right: -8,
            bottom: -8,
            child: Text(
              widget.pack.categoryEmoji,
              style: const TextStyle(fontSize: 72),
            ),
          ),
          // Featured badge
          if (widget.pack.isFeatured)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '⭐ Featured',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.background,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          // Category label
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                widget.pack.categoryLabel,
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.pack.title,
            style: AppTypography.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          // Expert name
          Text(
            widget.expertName,
            style: AppTypography.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Rating
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
              const SizedBox(width: 2),
              Text(
                widget.pack.rating.toStringAsFixed(1),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              // Price badge
              _buildPriceBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge() {
    if (widget.pack.isFree) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          'Gratuit',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.secondary,
            fontSize: 10,
          ),
        ),
      );
    }

    if (widget.pack.isUnlocked) {
      return const Icon(
        Icons.check_circle_rounded,
        color: AppColors.success,
        size: 16,
      );
    }

    return Text(
      '€${widget.pack.price.toStringAsFixed(2)}',
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.textSecondary,
        fontSize: 11,
      ),
    );
  }
}
