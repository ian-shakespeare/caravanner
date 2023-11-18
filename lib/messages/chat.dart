import "package:caravanner/components/screen.dart";
import "package:caravanner/messages/chat_bubble.dart";
import "package:caravanner/messages/message_bar.dart";
import "package:caravanner/messages/messages.dart";
import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatName,
    required this.id,
    this.isGroupChat = false
  });

  final String chatName;
  final String id;
  final bool isGroupChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final supabase = Supabase.instance.client;
  List<Message> messages = [];
  late final Stream<List<dynamic>> _messageStream;
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _messageStream = supabase
      .from(widget.isGroupChat ? "group_messages" : "direct_messages")
      .stream(primaryKey: ["id"])
      .order("created_at", ascending: false);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final navigator = Navigator.of(ctx);
    return Screen(
      headerCenter: CText.subheading(widget.chatName, textAlign: TextAlign.center),
      headerLeft: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          size: 32,
          color: CColors.white
        ),
        onPressed: () {
          navigator.pop();
        },
      ),
      headerRight: IconButton(
        icon: const Icon(
          Icons.more_vert_rounded,
          size: 32,
          color: CColors.white
        ),
        onPressed: () {
          navigator.pop();
        },
      ),
      body: SafeArea(
        child: StreamBuilder(stream: _messageStream, builder: (streamCtx, streamSnapshot) {
          if (!streamSnapshot.hasData) return const SizedBox.shrink();
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  addAutomaticKeepAlives: true,
                  controller: _scrollController,
                  itemCount: streamSnapshot.data!.length,
                  itemBuilder: (_, i) {
                    final c = streamSnapshot.data![i];
                    return ChatBubble(senderId: c["sender_id"], messageBody: c["message_body"], createdAt: DateTime.parse(c["created_at"]));
                  },
                ),
              ),
              MessageBar(chatId: widget.id, scrollCtrl: _scrollController, isGroupChat: widget.isGroupChat),
            ],
          );
        }),
      ),
    );
  }
}