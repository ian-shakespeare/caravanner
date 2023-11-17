import "package:flutter/material.dart";
import "../navigation/app_bar.dart";

class Screen extends StatelessWidget {
  final Widget body;
  final Widget? headerCenter;
  final Widget? headerLeft;
  final Widget? headerRight;
  final Widget? bottomNavigationBar;

  const Screen({
    super.key,
    required this.body,
    this.headerCenter,
    this.bottomNavigationBar,
    this.headerLeft,
    this.headerRight
  });

  @override
  Widget build(BuildContext ctx) {
    final isHeaderEmpty = headerCenter == null && headerLeft == null && headerRight == null;
    return Scaffold(
      appBar: isHeaderEmpty ? null : CAppBar(
        headerCenter: headerCenter,
        headerLeft: headerLeft,
        headerRight: headerRight,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
