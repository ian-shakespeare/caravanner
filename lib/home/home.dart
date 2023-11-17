import "package:flutter/material.dart";
import "../components/screen.dart";

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Screen(
      headerCenter: const Text("Home"),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text("Home page!"),
          ],
        ),
      )
    );
  }
}
