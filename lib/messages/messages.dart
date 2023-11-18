import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/components/button.dart";
import "package:caravanner/components/list.dart";
import "package:caravanner/components/screen.dart";
import "package:caravanner/messages/types.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class Chat {
  const Chat({required this.name, required this.recentMessage, required this.recentMessageDate});

  final String name;
  final String recentMessage;
  final String recentMessageDate;
}

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return Consumer<ProfileModel>(builder: (_, profile, __) => _MessageScreen(profile: profile));
  }
}

class _MessageScreen extends StatefulWidget {
  _MessageScreen({required this.profile});

  final ProfileModel profile;

  @override
  State<_MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<_MessageScreen> {
  final supabase = Supabase.instance.client;
  List<Chat> chats = [];

  @override
  void initState() {
    supabase
      .from("profiles")
      .select("""
        id,
        group_members!inner (
          groups (
            group_name,
            group_messages (
              created_at,
              message_body
            )
          )
        )
      """)
      .eq("id", widget.profile.id)
      .then((res) => print(res));
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Screen(
      headerCenter: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CText.subheading("Messages"),
      ),
      body: CButtonPrimary(text: "Log chats", onPressed: () => print(chats),),
    );
  }
}