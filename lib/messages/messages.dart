import "package:caravanner/components/list.dart";
import "package:caravanner/components/screen.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Screen(
      headerCenter: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CText.subheading("Messages"),
      ),
      body: CList(
        items: [],
      ),
    );
  }
}