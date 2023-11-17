import "package:flutter/material.dart";
import "../theme/text.dart";
import "../components/screen.dart";

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Screen(
      headerCenter: CText.subheading("Home"),
      body: Center(
        child: Column(
          children: <Widget>[
            CText.paragraph("Home page!"),
          ],
        ),
      )
    );
  }
}
