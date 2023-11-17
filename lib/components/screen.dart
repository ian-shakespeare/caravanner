import "package:flutter/material.dart";
import "../navigation/app_bar.dart";

class Screen extends StatelessWidget {
  final Widget body;
  final Widget? headerCenter;
  final Widget? headerLeft;
  final Widget? headerRight;
  final Widget? bottomNavigationBar;

  Screen({
    super.key,
    required this.body,
    this.headerCenter,
    this.bottomNavigationBar,
    this.headerLeft,
    this.headerRight
  });

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    return Scaffold(
      appBar: CAppBar(
        headerCenter: headerCenter,
        headerLeft: headerLeft,
        headerRight: headerRight,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
