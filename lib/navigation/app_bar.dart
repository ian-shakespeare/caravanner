import "package:flutter/material.dart";
import "../theme/colors.dart";

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? headerCenter;
  final Widget? headerLeft;
  final Widget? headerRight;

  @override
  final Size preferredSize;

  const CAppBar({
    super.key,
    this.headerCenter,
    this.headerLeft,
    this.headerRight
  }) : preferredSize = const Size.fromHeight(72);

  @override
  Widget build(BuildContext _) {
    const sideButtonSize = 60.0;
    return Container(
      decoration: const BoxDecoration(
        color: CColors.surface,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: <Widget>[
              if (headerLeft != null) SizedBox.square(
                dimension: sideButtonSize,
                child: headerLeft!
              ),
              Expanded(
                child: Container(
                  child: headerCenter ?? const Text(""),
                ),
              ),
              if (headerRight != null) SizedBox.square(
                dimension: sideButtonSize,
                child: headerRight!
              ),
            ]
          ),
        ),
      ),
    );
  }
}
