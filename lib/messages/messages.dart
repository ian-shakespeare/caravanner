import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/components/list.dart";
import "package:caravanner/components/screen.dart";
import "package:caravanner/messages/chat.dart";
import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class Message {
  Message({
    required this.messageBody,
    required this.senderFirstName,
    required this.createdAt,
    this.groupId,
  });

  final String messageBody;
  final String senderFirstName;
  final DateTime createdAt;
  final String? groupId;
}

class Chat {
  const Chat({required this.title, required this.id, required this.subtitle, this.isGroupChat = false});

  final String title;
  final String subtitle;
  final String id;
  final bool isGroupChat;
}

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return Consumer<ProfileModel>(
      builder: (_, profile, __) => _MessageScreen(profile: profile)
    );
  }
}

class _MessageScreen extends StatefulWidget {
  const _MessageScreen({required this.profile});

  final ProfileModel profile;

  @override
  State<_MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<_MessageScreen> {
  final supabase = Supabase.instance.client;

  List<Chat> chats = [];

  @override
  void initState() {
    Future.wait([
      supabase
        .from("profiles")
        .select("""
          id,
          group_members (
            group:group_id (
              id,
              group_name,
              group_messages (
                created_at,
                message_body,
                sender:sender_id (
                  first_name
                )
              )
            )
          )
        """)
        .eq("id", widget.profile.id)
        .limit(1),
      supabase
        .from("direct_messages")
        .select("""
          created_at,
          message_body,
          recipient_id,
          sender_id,
          sender:sender_id (
            first_name
          ),
          recipient:recipient_id (
            first_name
          )
        """)
        .or("recipient_id.eq.${widget.profile.id},sender_id.eq.${widget.profile.id}")
        .order("created_at", ascending: false)
    ]).then((c) {
      setState(() {
        final groups = c[0][0]["group_members"];
        chats.addAll(List.from(groups).map((g) {
          final group = g["group"];
          final lastMessage = List.from(group["group_messages"]).fold(group["group_messages"][0], (prev, curr) {
            final prevTime = DateTime.parse(prev["created_at"]);
            final currTime = DateTime.parse(curr["created_at"]);
            return currTime.isAfter(prevTime) ? curr : prev;
          });
          return Chat(
            id: group["id"],
            title: group["group_name"],
            subtitle: "${lastMessage["sender"]["first_name"]}: ${lastMessage["message_body"]}",
            isGroupChat: true,
          );
        }));
        List<Chat> directMessages = [];
        List.from(c[1]).forEach((dm) {
          final id = dm["recipient_id"] != widget.profile.id ? dm["recipient_id"] : dm["sender_id"];
          final friendName = dm["recipient_id"] != widget.profile.id
            ? dm["recipient"]["first_name"]
            : dm["sender"]["first_name"];
          final idInList = directMessages.map((dm) => id == dm.id).isNotEmpty;
          if (!idInList) {
            directMessages.add(
              Chat(
                id: id,
                title: "${friendName[0].toUpperCase()}${friendName.substring(1)}",
                subtitle: dm["message_body"]
              )
            );
          }
        });
        chats.addAll(directMessages);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Screen(
      headerCenter: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CText.subheading("Messages"),
      ),
      body: Expanded(
        child: ListView(children: List<Widget>.from(
            chats.map((c) => GestureDetector(
              onTap: () {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      chatName: c.title,
                      id: c.id,
                      isGroupChat: c.isGroupChat,
                    ),
                  ),
                );
              },
              child: CListTile(
                label: c.title,
                sublabel: c.subtitle,
                trailing: const Icon(
                  Icons.arrow_right_rounded,
                  color: CColors.white, size: 32
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
