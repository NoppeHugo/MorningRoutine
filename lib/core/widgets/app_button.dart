import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, text }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _scaleController.forward(),
      onTapUp: isDisabled
          ? null
          : (_) {
              _scaleController.reverse();
              HapticFeedback.lightImpact();
              widget.onPressed?.call();
            },
      onTapCancel: isDisabled ? null : () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: _buildButton(isDisabled),
      ),
    );
  }

  Widget _buildButton(bool isDisabled) {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return _buildPrimaryButton(isDisabled);
      case AppButtonVariant.secondary:
        return _buildSecondaryButton(isDisabled);
      case AppButtonVariant.text:
        return _buildTextButton(isDisabled);
    }
  }

  Widget _buildPrimaryButton(bool isDisabled) {
    return SizedBox(
      width: widget.isExpanded ? double.infinity : null,
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.surfaceLight : AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          child: _buildContent(
            isDisabled
                ? AppColors.textTertiary
                : AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(bool isDisabled) {
    return SizedBox(
      width: widget.isExpanded ? double.infinity : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDisabled ? AppColors.surfaceLight : AppColors.primary,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          child: _buildContent(
            isDisabled ? AppColors.textTertiary : AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton(bool isDisabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: _buildContent(
        isDisabled ? AppColors.textTertiary : AppColors.primary,
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (widget.isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CupertinoActivityIndicator(),
      );
    }

    final text = Text(
      widget.label,
      style: AppTypography.labelLarge.copyWith(color: color),
      textAlign: TextAlign.center,
    );

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.sm),
          text,
        ],
      );
    }

    return text;
  }
}
