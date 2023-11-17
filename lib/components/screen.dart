import "package:flutter/material.dart";
import "../navigation/app_bar.dart";

class Screen extends StatelessWidget {
  final Widget? headerCenter;
  final Widget? headerLeft;
  final Widget? headerRight;
  final Widget body;

  Screen({
    super.key,
    required this.headerTitle,
    required this.body,
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
