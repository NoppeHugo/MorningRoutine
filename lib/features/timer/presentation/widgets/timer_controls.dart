import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/timer_state.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.status,
    required this.onPlayPause,
    required this.onSkip,
    required this.onDone,
  });

  final TimerStatus status;
  final VoidCallback onPlayPause;
  final VoidCallback onSkip;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip button
        _CircleButton(
          icon: CupertinoIcons.forward_end_fill,
          size: 48,
          iconSize: AppSpacing.iconMd,
          backgroundColor: AppColors.surfaceLight,
          iconColor: AppColors.textPrimary,
          onTap: onSkip,
        ),

        const SizedBox(width: 24),

        // Play/Pause button
        _CircleButton(
          icon: status == TimerStatus.running
              ? CupertinoIcons.pause_fill
              : CupertinoIcons.play_fill,
          size: 72,
          iconSize: AppSpacing.iconLg,
          backgroundColor: AppColors.primary,
          iconColor: AppColors.textOnPrimary,
          onTap: onPlayPause,
        ),

        const SizedBox(width: 24),

        // Done button
        _CircleButton(
          icon: CupertinoIcons.checkmark_circle,
          size: 48,
          iconSize: AppSpacing.iconMd,
          backgroundColor: AppColors.surfaceLight,
          iconColor: AppColors.secondary,
          onTap: onDone,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: backgroundColor == AppColors.primary
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 16,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
