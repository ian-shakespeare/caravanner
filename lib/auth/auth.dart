import "dart:io";

import "package:caravanner/components/button.dart";
import "package:caravanner/components/screen.dart";
import "package:caravanner/theme/colors.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:google_sign_in/google_sign_in.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    _emailInputController.addListener(() {
      setState(() {
        email = _emailInputController.text.toLowerCase();
      });
    });
    _passwordInputController.addListener(() {
      setState(() {
        password = _passwordInputController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  Future<AuthResponse> _googleSignIn() async {
    const webClientId =
        '632718505438-3aask847dq07b6s7en1460jhav7isitn.apps.googleusercontent.com';
    final clientId = Platform.isIOS
        ? "632718505438-t6b4041r4ff2fvu2hsolopj8pjcvgm9t.apps.googleusercontent.com"
        : "632718505438-1g5ibt63tbsm140f8rf5k0g6fk2qdfnq.apps.googleusercontent.com";

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: clientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<bool> _emailPasswordSignIn(BuildContext ctx) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return false;
    } on AuthException {
      try {
        await supabase.auth.signUp(email: email, password: password);
        return true;
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final isSignedIn = supabase.auth.currentUser != null;
    final screenHeight = MediaQuery.of(ctx).size.height;
    return Screen(
      body: SafeArea(
        child: SingleChildScrollView(
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
                CButtonSecondary(
                    text: "Continue with Google",
                    leader: const SizedBox(
                      height: 24,
                      width: 24,
                      child: Image(image: AssetImage("images/google_logo.png")),
                    ),
                    onPressed: isSignedIn
                        ? null
                        : () {
                            _googleSignIn();
                          }),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 16),
                //   child: CText.superlabel("or"),
                // ),
                // CTextInput(hintText: "Email", controller: _emailInputController),
                // const SizedBox(height: 8),
                // CTextInput(hintText: "Password", controller: _passwordInputController, obscureText: true),
                // const SizedBox(height: 8),
                // CButtonPrimary(
                //   text: "Continue",
                //   onPressed: isSignedIn ? null : () {
                //     _emailPasswordSignIn(ctx)
                //     .then((showEmailAlert) => showDialog(
                //         context: ctx,
                //         builder: (BuildContext dialogCtx) => AlertDialog(
                //           title: const Text("Verify Your Email"),
                //           content: const SingleChildScrollView(
                //             child: ListBody(
                //               children: <Widget>[
                //                 Text("Check your email and click the link."),
                //               ],
                //             ),
                //           ),
                //           actions: <Widget>[
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(dialogCtx).pop();
                //               },
                //               child: const Text('OK'),
                //             ),
                //           ],
                //         ),
                //     ))
                //     .catchError((e) {
                //       showDialog(
                //         context: ctx,
                //         builder: (BuildContext dialogCtx) => AlertDialog(
                //           title: const Text("Problem Signing In"),
                //           content: SingleChildScrollView(
                //             child: ListBody(
                //               children: <Widget>[
                //                 Text(e.message),
                //               ],
                //             ),
                //           ),
                //           actions: <Widget>[
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(dialogCtx).pop();
                //               },
                //               child: const Text('OK'),
                //             ),
                //           ],
                //         ),
                //       );
                //       return AuthResponse(session: null, user: null);
                //     });
                //   }
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
