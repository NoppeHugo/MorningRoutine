import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_utils.dart';

class CircularTimer extends StatelessWidget {
  const CircularTimer({
    super.key,
    required this.secondsRemaining,
    required this.totalSeconds,
    required this.emoji,
    this.size = 240,
  });

  final int secondsRemaining;
  final int totalSeconds;
  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0
        ? 1.0 - (secondsRemaining / totalSeconds)
        : 0.0;

    final isUrgent = secondsRemaining < 10;
    final progressColor = isUrgent ? AppColors.error : AppColors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _TimerPainter(
              progress: progress,
              backgroundColor: AppColors.surfaceLight,
              progressColor: progressColor,
              strokeWidth: 6.0,
            ),
          ),
          // Timer text and emoji
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DurationUtils.formatTimer(secondsRemaining),
                style: AppTypography.timer,
              ),
              const SizedBox(height: 8),
              Text(
                emoji,
                style: const TextStyle(fontSize: 48),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  _TimerPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
