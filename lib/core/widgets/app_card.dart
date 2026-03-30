import 'package:flutter/material.dart';
import 'dart:ui';
 
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
 
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
  });
 
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
 
  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: (color ?? AppColors.surfaceElevated).withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            border: Border.all(color: AppColors.separator.withValues(alpha: 0.8)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                offset: Offset(0, 6),
                blurRadius: 18,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
 
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          splashColor: AppColors.surfaceHighlight,
          child: content,
        ),
      );
    }
 
    return content;
  }
}
