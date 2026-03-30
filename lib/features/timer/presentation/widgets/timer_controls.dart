import 'package:flutter/material.dart';
 
import '../../../../core/localization/app_i18n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_atmosphere.dart';
import '../../domain/timer_state.dart';
 
class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.status,
    required this.onPlayPause,
    required this.onSkip,
    required this.onDone,
    required this.langCode,
  });
 
  final TimerStatus status;
  final VoidCallback onPlayPause;
  final VoidCallback onSkip;
  final VoidCallback onDone;
  final String langCode;
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Skip button
        _ControlButton(
          icon: Icons.skip_next_rounded,
          label: AppI18n.t('timer.skip', langCode),
          color: const Color(0xDCE3EAF5),
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
          label: AppI18n.t('timer.done', langCode),
          color: const Color(0xFFF2F6FB),
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
      child: SizedBox(
        width: 72,
        height: 72,
        child: AppGlassContainer(
          padding: EdgeInsets.zero,
          radius: 36,
          color: const Color(0x40F6F8FF),
          borderColor: const Color(0xAFF2F5FA),
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: const Color(0xFFF3F6FB),
            size: AppSpacing.iconLg,
          ),
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
          SizedBox(
            width: 52,
            height: 52,
            child: AppGlassContainer(
              padding: EdgeInsets.zero,
              radius: 26,
              color: const Color(0x26F8FAFF),
              borderColor: const Color(0x66F2F5FA),
              child: Icon(icon, color: color, size: AppSpacing.iconMd),
            ),
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
