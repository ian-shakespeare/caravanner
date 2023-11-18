import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class MessageBar extends StatefulWidget {
  const MessageBar({super.key, required this.chatId, required this.scrollCtrl, this.isGroupChat = false});

  final String chatId;
  final ScrollController scrollCtrl;
  final bool isGroupChat;

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final supabase = Supabase.instance.client;
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(
      builder: (_, profile, __) => Material(
        color: CColors.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    keyboardAppearance: Brightness.dark,
                    maxLines: null,
                    autofocus: true,
                    controller: _textController,
                    style: const TextStyle(color: CColors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Color(0x80FFFFFF)),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    supabase
                      .from(widget.isGroupChat ? "group_messages" : "direct_messages")
                      .insert(widget.isGroupChat
                        ? {"group_id": widget.chatId, "sender_id": profile.id, "message_body": _textController.text}
                        : {"recipient_id": widget.chatId, "sender_id": profile.id, "message_body": _textController.text}
                      )
                      .then((_) => Future.delayed(const Duration(milliseconds: 300)));
                      _textController.clear();
                  },
                  child: CText.button('Send'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}