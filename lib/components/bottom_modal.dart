import "package:flutter/material.dart";
import "../theme/colors.dart";

class BottomModal extends StatelessWidget {
  BottomModal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CColors.surface,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: child,
      ),
    );
  }
}
