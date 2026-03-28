import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsTile extends StatefulWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.isLast = false,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool isLast;

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isNavigable = widget.onTap != null && widget.trailing == null;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            }
          : null,
      onTapCancel: widget.onTap != null
          ? () => setState(() => _pressed = false)
          : null,
      child: AnimatedOpacity(
        opacity: _pressed ? 0.7 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: widget.isLast
                ? null
                : const Border(
                    bottom: BorderSide(
                      color: AppColors.surfaceLight,
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: AppTypography.bodyLarge.copyWith(
                  color: widget.titleColor ?? AppColors.textPrimary,
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
              if (isNavigable)
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: AppColors.textTertiary,
                  size: AppSpacing.iconSm,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
