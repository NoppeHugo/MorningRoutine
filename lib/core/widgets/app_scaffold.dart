import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text(title!),
              automaticallyImplyLeading: false,
              leading: showBackButton
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : null,
              actions: actions,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.5),
                child: Container(
                  height: 0.5,
                  color: AppColors.surfaceLight,
                ),
              ),
            )
          : null,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
