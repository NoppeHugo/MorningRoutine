import 'package:flutter/material.dart';
 
import 'app_atmosphere.dart';
import '../theme/app_typography.dart';
 
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.showBackButton = false,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });
 
  final Widget body;
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: title != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              leadingWidth: showBackButton ? 64 : null,
              leading: showBackButton
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _AppBarIconOrb(
                        icon: Icons.arrow_back_ios_new_rounded,
                        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    )
                  : null,
              title: AppGlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                radius: 24,
                child: Text(
                  title!,
                  style: AppTypography.labelLarge.copyWith(
                    color: const Color(0xFFF4F6F8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              actions: actions
                  ?.map(
                    (action) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _AppBarActionWrapper(child: action),
                    ),
                  )
                  .toList(),
            )
          : null,
      body: Stack(
        children: [
          const Positioned.fill(child: AppAtmosphericBackground()),
          SafeArea(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class _AppBarIconOrb extends StatelessWidget {
  const _AppBarIconOrb({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return AppGlassContainer(
      padding: EdgeInsets.zero,
      radius: 22,
      child: Material(
        color: Colors.transparent,
        child: Tooltip(
          message: tooltip ?? '',
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon, size: 18, color: const Color(0xFFF1F4F7)),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarActionWrapper extends StatelessWidget {
  const _AppBarActionWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (child is IconButton) {
      final iconButton = child as IconButton;
      return AppGlassContainer(
        padding: EdgeInsets.zero,
        radius: 22,
        child: SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            onPressed: iconButton.onPressed,
            icon: iconButton.icon,
            tooltip: iconButton.tooltip,
            color: const Color(0xFFF1F4F7),
            splashRadius: 20,
          ),
        ),
      );
    }
    return child;
  }
}
