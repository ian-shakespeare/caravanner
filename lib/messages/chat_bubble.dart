import 'package:caravanner/auth/profile_model.dart';
import 'package:caravanner/theme/colors.dart';
import 'package:caravanner/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    super.key,
    required this.senderId,
    required this.messageBody,
    required this.createdAt,
    this.isGroupChat = false,
  });

  final String senderId;
  final String messageBody;
  final DateTime createdAt;
  final bool isGroupChat;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with AutomaticKeepAliveClientMixin {
  final supabase = Supabase.instance.client;
  late final Future<dynamic>? _sender;

  @override
  void initState() {
    _sender = supabase
      .from("profiles")
      .select("id, first_name")
      .eq("id", widget.senderId)
      .then((res) => res[0]);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext ctx) {
    super.build(ctx);
    return Consumer<ProfileModel>(
     builder: (_, profile, __) =>
      FutureBuilder(future: _sender, builder: (futureCtx, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        } else {
          final isLocalMessage = profile.id == snapshot.data["id"];
          return Align(
            alignment: isLocalMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: isLocalMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: CText.superlabel(
                  "${snapshot.data["first_name"][0].toUpperCase()}${snapshot.data["first_name"].substring(1).toLowerCase()}"
                )),
                Container(
                  decoration: BoxDecoration(
                    color: isLocalMessage
                      ? CColors.primary
                      : CColors.onSurface,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CText.paragraph(widget.messageBody),
                  ),
                )
              ],
            ),
          );
        }
      })
    );
  }
}