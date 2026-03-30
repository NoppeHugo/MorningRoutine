import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
 
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
    this.titleColor,
  });
 
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
 
  @override
  Widget build(BuildContext context) {
    return AppGlassContainer(
      padding: EdgeInsets.zero,
      radius: AppSpacing.radiusLarge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      color: titleColor ?? const Color(0xFFF2F4F7),
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
                if (onTap != null && trailing == null)
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xCBE4EAF1),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
