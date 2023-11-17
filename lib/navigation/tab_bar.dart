import "package:flutter/material.dart";
import "../theme/colors.dart";

class CTab {
  CTab({
    required this.icon,
    required this.screen,
    required this.showHeader,
    this.headerCenter,
    this.headerLeft,
    this.headerRight,
  });

  final IconData icon;
  final Widget screen;
  final bool showHeader;
  final Widget? headerCenter;
  final Widget? headerLeft;
  final Widget? headerRight;
}

class CTabBar extends StatefulWidget {
  const CTabBar({super.key, required this.tabs});

  final List<CTab> tabs;

  @override
  State<CTabBar> createState() => _CTabBarState();
}

class _CTabBarState extends State<CTabBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      bottomNavigationBar: Container(
        alignment: AlignmentDirectional.center,
        height: 60,
        padding: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: CColors.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.from(widget.tabs.asMap().entries.map((entry) {
            int index = entry.key;
            CTab tab = entry.value;
            final isSelected = index == currentIndex;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                },
                child: Icon(
                  tab.icon,
                  color: isSelected ? CColors.primary : CColors.faded,
                  size: 40, 
                ),
              ),
            );
          })),
        ),
      ),
      body: SafeArea(
        child: List<Widget>.from(widget.tabs.map((tab) => tab.screen))[currentIndex],
      ),
    );
  }
}
