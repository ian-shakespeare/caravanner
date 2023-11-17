import "package:caravanner/components/screen.dart";
import "package:caravanner/components/text_input.dart";
import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _controller = TextEditingController();
  String email = "";

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        email = _controller.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final screenHeight = MediaQuery.of(ctx).size.height;
    return Screen(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: screenHeight / 3,
                child: Text(
                  "Caravanner",
                  style: GoogleFonts.rubik(
                    color: CColors.primary,
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              CTextInput(hintText: "Email", controller: _controller),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CText.superlabel("or"),
              ),
              CText.title(email),
            ],
          ),
        )
      ),
    );
  }
}