import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/expert_model.dart';

class ExpertHeader extends StatelessWidget {
  const ExpertHeader({
    super.key,
    required this.expert,
    this.showBio = false,
  });

  final Expert expert;
  final bool showBio;

  String get _initials {
    final parts = expert.name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return expert.name.isNotEmpty ? expert.name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expert.name,
                    style: AppTypography.headingSmall,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    expert.specialty,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildRatingRow(),
                ],
              ),
            ),
          ],
        ),
        if (showBio && expert.bio.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            expert.bio,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar() {
    final hasPhoto = expert.photoUrl.isNotEmpty;

    if (hasPhoto) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: CachedNetworkImage(
          imageUrl: expert.photoUrl,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _buildInitialsAvatar(),
          placeholder: (context, url) => _buildInitialsAvatar(),
        ),
      );
    }

    return _buildInitialsAvatar();
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Center(
        child: Text(
          _initials,
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
        const SizedBox(width: 2),
        Text(
          expert.rating.toStringAsFixed(1),
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '•',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '${expert.packCount} pack${expert.packCount > 1 ? 's' : ''}',
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }
}
