import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/components/button.dart";
import "package:caravanner/components/screen.dart";
import "package:caravanner/components/text_input.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _handleInputController = TextEditingController();
  final TextEditingController _firstNameInputController = TextEditingController();
  final TextEditingController _lastNameInputController = TextEditingController();

  String? handle;
  String? firstName;
  String? lastName;

  @override
  void initState() {
    super.initState();
    _handleInputController.addListener(() {
      setState(() {
        handle = _handleInputController.text.toLowerCase();
      });
    });
    _firstNameInputController.addListener(() {
      setState(() {
        firstName = _firstNameInputController.text.toLowerCase();
      });
    });
    _lastNameInputController.addListener(() {
      setState(() {
        lastName = _lastNameInputController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _handleInputController.dispose();
    _firstNameInputController.dispose();
    _lastNameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final supabase = Supabase.instance.client;
    final User user = supabase.auth.currentUser!;
    return Consumer<ProfileModel>(
      builder: (_, profile, __) => Screen(
        body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CText.superlabel("Finish registration"),
                ),
                const SizedBox(height: 8),
                CTextInput(hintText: "Handle e.g. j_doe", controller: _handleInputController),
                const SizedBox(height: 16),
                CTextInput(hintText: "First name", controller: _firstNameInputController),
                const SizedBox(height: 8),
                CTextInput(hintText: "Last name", controller: _lastNameInputController),
                const SizedBox(height: 16),
                CButtonPrimary(text: "Continue", onPressed: () {
                  void showAlertAndClearFields({required String title, required String description, List<TextEditingController>? relevantControllers}) {
                    showDialog(
                      context: ctx,
                      builder: (BuildContext dialogCtx) {
                        return AlertDialog(
                          title: Text(title),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(description),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogCtx).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    if (relevantControllers == null) return;
                    for (final controller in relevantControllers) {
                      controller.text = "";
                    }
                  }
                  
                  final isHandleInputFilled = handle != null && handle != "";
                  if (!isHandleInputFilled) {
                    showAlertAndClearFields(title: "Invalid Handle", description: "Handle cannot be empty.");
                    return;
                  }
                  final isFirstNameInputFilled = firstName != null && firstName != "";
                  if (!isFirstNameInputFilled) {
                    showAlertAndClearFields(title: "Invalid First Name", description: "First name cannot be empty.");
                    return;
                  }
                  final isLastNameInputFilled =  lastName != null && lastName != "";
                  if (!isLastNameInputFilled) {
                    showAlertAndClearFields(title: "Invalid Last Name", description: "Last name cannot be empty.");
                    return;
                  }

                  final handleContainsValidCharacters = RegExp(r"^[a-z0-9_-]+$").hasMatch(handle!);
                  if (!handleContainsValidCharacters) {
                    showAlertAndClearFields(
                      title: "Invalid Handle",
                      description: "Handle may only contain letters, numbers, underscores, and dashes.",
                      relevantControllers: [_handleInputController],
                    );
                    return;
                  }
                  final isHandleLongEnough = handle!.length >= 3;
                  if (!isHandleLongEnough) {
                    showAlertAndClearFields(
                      title: "Invalid Handle",
                      description: "Handle must be at least 3 characters.",
                      relevantControllers: [_handleInputController],
                    );
                    return;
                  }
                  final isHandleTooLong = handle!.length > 20;
                  if (isHandleTooLong) {
                    showAlertAndClearFields(
                      title: "Invalid Handle",
                      description: "Handle must not be more than 20 characters.",
                      relevantControllers: [_handleInputController],
                    );
                    return;
                  }

                  final firstNameContainsValidCharacters =  RegExp(r"^[a-z\']+$").hasMatch(firstName!);
                  if (!firstNameContainsValidCharacters) {
                    showAlertAndClearFields(
                      title: "Invalid First Name",
                      description: "Name may only contain letters and apostraphes.",
                      relevantControllers: [_firstNameInputController],
                    );
                    return;
                  }
                  final isFirstNameTooLong = firstName!.length > 20;
                  if (isFirstNameTooLong) {
                    showAlertAndClearFields(
                      title: "Invalid First Name",
                      description: "Name must not be more than 20 characters.",
                      relevantControllers: [_firstNameInputController],
                    );
                    return;
                  }

                  final lastNameContainsValidCharacters =  RegExp(r"^[a-z\']+$").hasMatch(lastName!);
                  if (!lastNameContainsValidCharacters) {
                    showAlertAndClearFields(
                      title: "Invalid Last Name",
                      description: "Name may only contain letters and apostraphes.",
                      relevantControllers: [_lastNameInputController],
                    );
                    return;
                  }
                  final isLastNameTooLong = lastName!.length > 30;
                  if (isLastNameTooLong) {
                    showAlertAndClearFields(
                      title: "Invalid Last Name",
                      description: "Name must not be more than 30 characters.",
                      relevantControllers: [_lastNameInputController],
                    );
                    return;
                  }
                  try {
                    supabase
                      .from("profiles")
                      .insert({
                        "handle": "@$handle",
                        "first_name": firstName,
                        "last_name": lastName,
                        "user_id": user.id
                      })
                      .select()
                      .then((res) {
                        final p = res[0];
                        profile.set(p);
                      });
                  } on PostgrestException {
                    showAlertAndClearFields(title: "Handle Is Taken", description: "Choose a different handle.", relevantControllers: [_handleInputController]);
                  } catch (e) {
                    showAlertAndClearFields(title: "Internal Server Error", description: "Try again later.");
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}