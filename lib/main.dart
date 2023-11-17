import "package:caravanner/auth/auth.dart";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "navigation/tab_bar.dart";
import "home/home.dart";
import "theme/colors.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://jwvwflixycnmbzxgbcqb.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3dndmbGl4eWNubWJ6eGdiY3FiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDAyNDE4MTMsImV4cCI6MjAxNTgxNzgxM30.cR4Pn44efjW4GFVkz6eJQQWL-NkwvNAIbALy1TBeor0",
  );

  runApp(const CApp());
}

class CApp extends StatelessWidget {
  const CApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final Session? session = supabase.auth.currentSession;
    return MaterialApp(
      title: "Caravanner",
      theme: ThemeData(
        canvasColor: CColors.background,
        scaffoldBackgroundColor: CColors.background,
        useMaterial3: true,
      ),
      home: session == null ? const AuthScreen() : CTabBar(
        tabs: [
          CTab(
            icon: Icons.home_rounded,
            screen:const HomeScreen(),
            showHeader: false,
          ),
        ],
      ),
    );
  }
}
