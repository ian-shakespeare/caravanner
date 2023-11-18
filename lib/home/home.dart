import "package:caravanner/auth/profile_model.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "../theme/text.dart";
import "../components/bottom_modal.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final supabase = Supabase.instance.client;
    return Consumer<ProfileModel>(
      builder: (_, profile, __) => Center(
        child: Column(
          children: <Widget>[
            CText.paragraph("Home page!"),
            ElevatedButton(
              onPressed: () {
                supabase.auth.signOut();
                profile.clear();
              },
              child: const Text("Sign Out")
            ),
            ElevatedButton(
              child: const Text("Show Modal"),
              onPressed: () {
                showModalBottomSheet(
                  context: ctx,
                  builder: (modalCtx) {
                    return BottomModal(
                      child: Column(
                        children: <Widget>[
                          CText.subheading("my modal"),
                        ],
                      ),
                    );
                  },
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
