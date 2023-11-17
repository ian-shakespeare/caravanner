import "package:flutter/material.dart";
import "navigation/tab_bar.dart";
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
      home: CTabBar(
        tabs: [
          CTab(
            icon: Icons.home_rounded,
            screen: HomeScreen(),
            showHeader: false,
          ),
        ],
      ),
    );
  }
}
