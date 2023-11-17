import "package:caravanner/components/text_input.dart";
import "package:flutter/material.dart";
import "../theme/text.dart";
import "../components/screen.dart";

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Column(
        children: <Widget>[
          CText.paragraph("Home page!"),
        ],
      ),
    );
  }
}
