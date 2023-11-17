import 'package:flutter/material.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? headerCenter;
  final Widget? headerLeft;
  final Widget? headerRight;

  @override
  final Size preferredSize;

  CAppBar({
    super.key,
    this.headerCenter,
    this.headerLeft,
    this.headerRight
  }) : preferredSize = Size.fromHeight(80);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      boxDecoration: null,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: <Widget>[
              SizedBox.square(
                dimension: sideButtonSize,
                child: headerLeft ?? SizedBox.shrink()
              ),
              Expanded(
                child: Container(
                  child: headerCenter ?? const Text(""),
                ),
              ),
              SizedBox.square(
                dimension: sideButtonSize,
                child: headerRight ?? SizedBox.shrink()
              ),
            ]
          ),
        ),
      ),
    ),
  }
}
