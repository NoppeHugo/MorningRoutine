import 'package:flutter/material.dart';

import 'app_atmosphere.dart';
 
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
      borderRadius: BorderRadius.circular(28),
      child: AppGlassContainer(
        padding: padding ?? const EdgeInsets.all(24),
        radius: 28,
        color: color ?? const Color(0x26F8FAFF),
        borderColor: const Color(0x66F2F5FA),
        child: child,
      ),
    );
 
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          splashColor: const Color(0x24F7FAFF),
          child: content,
        ),
      );
    }
 
    return content;
  }
}
