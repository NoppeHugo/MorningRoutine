import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/expert_pack_model.dart';
import '../../domain/purchase_state.dart';

class PurchaseButton extends StatelessWidget {
  const PurchaseButton({
    super.key,
    required this.pack,
    required this.purchaseStatus,
    required this.isPremiumSubscriber,
    required this.onPressed,
  });

  final ExpertPack pack;
  final PurchaseStatus purchaseStatus;
  final bool isPremiumSubscriber;
  final VoidCallback onPressed;

  bool get _isOwned =>
      pack.isUnlocked ||
      purchaseStatus == PurchaseStatus.owned ||
      pack.isFree;

  @override
  Widget build(BuildContext context) {
    if (isPremiumSubscriber) {
      return _buildSubscribedButton();
    }

    if (_isOwned) {
      return _buildOwnedButton();
    }

    if (purchaseStatus == PurchaseStatus.loading) {
      return _buildLoadingButton();
    }

    if (pack.isFree) {
      return _buildFreeButton();
    }

    return _buildPaidButton();
  }

  Widget _buildLoadingButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  Widget _buildOwnedButton() {
    return _PressableButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Text(
          'Utiliser cette routine',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textOnSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSubscribedButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Text(
        'Inclus dans Premium ✓',
        style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFreeButton() {
    return _PressableButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Text(
          'Ajouter gratuitement',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textOnPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPaidButton() {
    return _PressableButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Text(
          'Débloquer — €${pack.price.toStringAsFixed(2)}',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textOnPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ── Pressable wrapper ─────────────────────────────────────────────────────

class _PressableButton extends StatefulWidget {
  const _PressableButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
