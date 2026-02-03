import 'package:flutter/material.dart';

/// A customizable scaffold widget with consistent app structure.
///
/// Provides a standardized app layout with optional app bar,
/// bottom navigation, FAB, and drawer support.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.title,
    this.leading,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.semanticLabel,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    PreferredSizeWidget? effectiveAppBar = appBar;

    // Build default app bar if title is provided but no custom app bar
    if (effectiveAppBar == null && title != null) {
      effectiveAppBar = AppBar(
        title: Text(title!),
        leading: leading,
        actions: actions,
        backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      );
    }

    return Semantics(
      container: true,
      label: semanticLabel ?? (title != null ? 'Screen: $title' : null),
      child: Scaffold(
        appBar: effectiveAppBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        drawer: drawer,
        endDrawer: endDrawer,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
      ),
    );
  }
}
