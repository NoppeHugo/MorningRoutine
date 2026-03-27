import 'package:flutter/material.dart';
 
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Skip button
        _ControlButton(
          icon: Icons.skip_next_rounded,
          label: 'Skip',
          color: AppColors.textSecondary,
          onTap: onSkip,
        ),
 
        // Play/Pause button
        _PlayPauseButton(
          isPlaying: status == TimerStatus.running,
          onTap: onPlayPause,
        ),
 
        // Done button
        _ControlButton(
          icon: Icons.check_rounded,
          label: 'Done',
          color: AppColors.secondary,
          onTap: onDone,
        ),
      ],
    );
  }
}
 
class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.isPlaying,
    required this.onTap,
  });
 
  final bool isPlaying;
  final VoidCallback onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: AppColors.textOnPrimary,
          size: AppSpacing.iconLg,
        ),
      ),
    );
  }
}
 
class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
 
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: AppSpacing.iconMd),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
