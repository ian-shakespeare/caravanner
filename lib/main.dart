import "package:flutter/material.dart";
import "navigation/tab_bar.dart";
import "home/home.dart";

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
