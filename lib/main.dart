import "package:caravanner/navigation/tab_bar.dart";
import "package:flutter/material.dart";
import "home/home.dart";
import "theme/colors.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CApp());
}

class CApp extends StatelessWidget {
  const CApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Caravanner",
      theme: ThemeData(
        canvasColor: CColors.background,
        scaffoldBackgroundColor: CColors.background,
        useMaterial3: true,
      ),
      home: CTabBar(tabs: [
        CTab(icon: Icons.home_rounded, screen: HomeScreen(), showHeader: true),
        CTab(
            icon: Icons.calendar_today_outlined,
            screen: HomeScreen(),
            showHeader: true),
        CTab(icon: Icons.groups, screen: HomeScreen(), showHeader: true),
        CTab(icon: Icons.message, screen: HomeScreen(), showHeader: true),
        CTab(icon: Icons.person, screen: HomeScreen(), showHeader: true)
      ]),
    );
  }
}
