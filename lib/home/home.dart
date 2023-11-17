import "package:caravanner/components/text_input.dart";
import "package:flutter/material.dart";
import "../theme/text.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Column(
        children: <Widget>[
          CText.paragraph("Home page!"),
          const TextInput(
            hintText: "Handle (i.e. @Greg)",
          )
        ],
      ),
    );
  }
}
