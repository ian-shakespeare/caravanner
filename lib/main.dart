import "package:caravanner/auth/auth.dart";
import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/auth/register.dart";
import 'package:caravanner/calendar/calendar.dart';
import "package:caravanner/messages/messages.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "navigation/tab_bar.dart";
import "home/home.dart";
import "theme/colors.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://jwvwflixycnmbzxgbcqb.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3dndmbGl4eWNubWJ6eGdiY3FiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDAyNDE4MTMsImV4cCI6MjAxNTgxNzgxM30.cR4Pn44efjW4GFVkz6eJQQWL-NkwvNAIbALy1TBeor0",
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProfileModel()),
    ],
    child: const CApp(),
  ));
}

class CApp extends StatefulWidget {
  const CApp({super.key});

  @override
  State<CApp> createState() => _CAppState();
}

class _CAppState extends State<CApp> {
  final supabase = Supabase.instance.client;
  User? user;

  @override
  void initState() {
    super.initState();
    user = supabase.auth.currentUser;
    supabase.auth.onAuthStateChange.listen((data) {
      if ([AuthChangeEvent.signedIn, AuthChangeEvent.signedOut]
          .contains(data.event)) {
        setState(() {
          user = supabase.auth.currentUser;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = supabase.auth.currentUser;
    final hasSignedIn = user != null;
    return Consumer<ProfileModel>(
      builder: (_, profile, __) {
        final needsProfileDetails = profile.id == null;
        if (hasSignedIn && needsProfileDetails) {
          supabase.from("profiles").select().eq("user_id", user.id).then((res) {
            if (res.length <= 0) return;
            final p = res[0];
            profile.set(p ?? {});
          });
        }
        return MaterialApp(
          title: "Caravanner",
          theme: ThemeData(
            canvasColor: CColors.background,
            scaffoldBackgroundColor: CColors.background,
            useMaterial3: true,
          ),
          home: !hasSignedIn
              ? const AuthScreen()
              : needsProfileDetails
                  ? const RegisterScreen()
                  : CTabBar(
                      tabs: [
                        CTab(
                          icon: Icons.home_rounded,
                          screen: const HomeScreen(),
                          showHeader: false,
                        ),
                        CTab(
                            icon: Icons.calendar_month_rounded,
                            screen: const CalendarScreen(),
                            showHeader: true),
                        CTab(
                          icon: Icons.message_rounded,
                          screen: const MessageScreen(),
                          showHeader: true,
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
