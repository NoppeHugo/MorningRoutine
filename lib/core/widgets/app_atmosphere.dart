import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppAtmosphericBackground extends StatelessWidget {
  const AppAtmosphericBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8A949F),
            Color(0xFF929AA2),
            Color(0xFF8C8483),
            Color(0xFF746563),
          ],
          stops: [0, 0.30, 0.66, 1],
        ),
      ),
      child: Stack(
        children: const [
          Positioned(
            top: -120,
            left: -90,
            child: _GlowBlob(size: 300, color: Color(0xB8FFFFFF)),
          ),
          Positioned(
            top: 210,
            right: -80,
            child: _GlowBlob(size: 240, color: Color(0x70CFE5F4)),
          ),
          Positioned(
            bottom: 130,
            left: -70,
            child: _GlowBlob(size: 260, color: Color(0x66F6DFC1)),
          ),
          Positioned.fill(child: _AtmosphereBlur()),
          Positioned.fill(child: _AtmosphereShade()),
        ],
      ),
    );
  }
}

class AppGlassContainer extends StatelessWidget {
  const AppGlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = 28,
    this.color = const Color(0x26F8FAFF),
    this.borderColor = const Color(0x66F2F5FA),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _AtmosphereBlur extends StatelessWidget {
  const _AtmosphereBlur();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Container(color: const Color(0x1FFFFFFF)),
    );
  }
}

class _AtmosphereShade extends StatelessWidget {
  const _AtmosphereShade();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0x24000000),
              Colors.transparent,
              const Color(0x18000000),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}